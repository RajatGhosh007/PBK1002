//
//  UserViewModel.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 20/04/23.
//

import Foundation

class UserViewModel: BaseViewModel {
    
    var comListResponse: CompanyListRes?
    var accessTokenResponse: AccessTokenResponse?
    var companyList: [Company]?
    
    
    
    func getCompanyList(ParamsInput : [String: Any], Url : String , token : String,success: @escaping ((CompanyListRes?,Bool) -> Void)){
    
        
        ApiManager.shared.HomeCallAPI(paramsAny: ParamsInput , Url: Url, token: token) { [weak self] response  in
            self?.comListResponse = response
            self?.companyList = self?.comListResponse?.data
           // success(response,true)
            
            let data =  self?.comListResponse?.data ?? []
            if(data.count > 0){
                success(response,true)
            }else{
                success(nil,false)
            }
            
       
        } fail: { _ in
         
            success(nil,false)
        }
        
        
    }
    
    
    func getCompanyListWithAccessToken(ParamsInput:[String: Any],token:String,urlName : String,methodType:String,success: @escaping ((CompanyListRes?,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
      
        ApiManager.shared.getCompanyListWithAccessToken(paramsInput: ParamsInput, token: token, urlName: urlName, methodType: methodType) { [weak self] response  in
            self?.comListResponse = response
            self?.companyList = self?.comListResponse?.data
            let data =  self?.comListResponse?.data ?? []
            if(data.count > 0){
                success(response,true)
            }else{
                success(nil,false)
            }
        } fail: { error, message, Bool in
            fail(error,message,false)
        }

       
        
    }
    
    
    func getAccessTokenWithRefreshToken(ParamsInput:[String: Any],token:String,urlName : String,methodType:String,success: @escaping ((AccessTokenResponse?,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
       
        ApiManager.shared.getAccessTokenWithRefreshToken(dictionary: ParamsInput, token: token, urlName: urlName, methodType: methodType) { [weak self] response  in
            self?.accessTokenResponse = response
            
            let accessToken =  self?.accessTokenResponse?.data?.access_token ?? ""
            UserDefaults.standard.setValue(accessToken, forKey: "accessTokenKey")
            success(response,true)
        } fail: { error, message, Bool in
            fail(error,message,false)
        }


        
        
        
        /*
        ApiManager.shared.getCompanyListWithAccessToken(paramsInput: ParamsInput, token: token, urlName: urlName, methodType: methodType) { [weak self] response  in
            self?.comListResponse = response
            self?.companyList = self?.comListResponse?.data
            let data =  self?.comListResponse?.data ?? []
            if(data.count > 0){
                success(response,true)
            }else{
                success(nil,false)
            }
        } fail: { error, message, Bool in
            fail(error,message,false)
        }
         */
       
        
    }
    
    
    
    func numberOrRows() -> Int {
        return self.companyList?.count ?? 0
      //  return 1
    }

    func getCompany(index: Int) -> Company? {
        return self.companyList?[index]
    }
    
    
    
    
    
    
    
    /*
     func getDemoDataList(){
    
       
        companyList = [
        
                     Company(name: "Senior Devs"),
                     Company(name: "Montesino Translation"),
                     Company(name: "Technical Junk Removal"),
                     Company(name: "Comapany 4"),
                     Company(name: "Comapany 5"),
                     Company(name: "Comapany 6"),
                     Company(name: "Comapany 7"),
                     Company(name: "Comapany 8"),
                     Company(name: "Comapany 9"),
                     Company(name: "Comapany 10"),
                     Company(name: "Comapany 11"),
                     Company(name: "Comapany 12"),
        
        ]
    }*/
    
    
  
    
    
}

