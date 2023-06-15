//
//  ProfileDetailViewModel.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 08/05/23.
//

import UIKit

class ProfileDetailViewModel: BaseViewModel {
    
  //  public static let shared = ProfileDetailViewModel()
    
    var countryResponse: CountryList?
    var commonResponse: CommonResponse?
  //  var countryList: [CountryInfo]?
    
    
    var countryList  = Constant.ContryList.arrCountryList
    /*
    var   countryList = [
        
        CountryInfo(id: 1, name: "AFGHANISTAN"),
        CountryInfo(id: 2, name: "ALBANIA"),
        CountryInfo(id: 3, name: "ALGERIA"),
        CountryInfo(id: 10, name: "ARGENTINA"),
        CountryInfo(id: 11, name: "ARMENIA"),
        CountryInfo(id: 12, name: "ARUBA"),
        CountryInfo(id: 18, name: "BANGLADESH"),
        CountryInfo(id: 19, name: "BARBADOS"),
        CountryInfo(id: 21, name: "BELGIUM"),
        CountryInfo(id: 25, name: "BHUTAN"),
        CountryInfo(id: 26, name: "BOLIVIA"),
        CountryInfo(id: 27, name: "BOSNIA AND HERZEGOVINA"),
        CountryInfo(id: 28, name: "BOTSWANA"),
        CountryInfo(id: 29, name: "BOUVET ISLAND"),
        
        CountryInfo(id: 47, name: "COLOMBIA"),
        CountryInfo(id: 52, name: "COSTA RICA"),
        CountryInfo(id: 57, name: "CZECH REPUBLIC")
    
    
                  ]
     
     */
    
    
    func uploadImageWithAccessToken(paramsInput:[String: Any],token: String,urlName: String,methodType:String,success:@escaping ((CommonResponse?,String) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
        ApiManager.shared.uploadImageWithAccessToken(paramsInput: paramsInput, token: token, urlName: urlName, methodType: methodType) {[weak self] response in
               print(response)
               self?.commonResponse = response
               let message = self?.commonResponse?.message  ?? ""
               success(self?.commonResponse,message)
               
           } fail: { error, message, Bool in
               fail(error,message,false)
           }
        
    }
        
    
    func submitProfileDetailWithToken(paramsInput: [String: Any],token: String,urlName: String,methodType:String, success: @escaping ((CommonResponse?,String) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
     ApiManager.shared.submitProfileDetailWithToken(paramsInput: paramsInput, token: token, urlName: urlName, methodType: methodType) {[weak self] response in
            print(response)
            self?.commonResponse = response
            let message = self?.commonResponse?.message  ?? ""
            success(self?.commonResponse,message)
            
        } fail: { error, message, Bool in
            fail(error,message,false)
        }
 
    }
    
    
    func getCountryList(ParamsDict:[String:String],Url:String, methodType:String,success:@escaping ((CountryList?,Bool) -> Void)){
    
       ApiManager.shared.getCountryListAPI(paramsInput: ParamsDict, urlName: Url, methodType: methodType) { [weak self] (response,_,_)  in
            self?.countryResponse = response
           self?.countryList = self?.countryResponse?.data?.countries ?? [CountryInfo]()
           Constant.ContryList.arrCountryList =  self?.countryList ?? [CountryInfo]()
           print( "self?.countryList   :",self?.countryList ?? [CountryInfo]())
           
        } fail: { _,_,_  in
            success(nil,false)
        }

     
    }
    
    
    
    
    func sendRequest(_ url: String, parameters: [String: String], completion: @escaping ([String: Any]?, Error?) -> Void) {
        
        var components = URLComponents(string: url)!
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,                              // is there data
                let response = response as? HTTPURLResponse,  // is there HTTP response
                200 ..< 300 ~= response.statusCode,           // is statusCode 2XX
                error == nil                                  // was there no error
            else {
                completion(nil, error)
                return
            }
            
            let responseObject = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
            completion(responseObject, nil)
        }
        task.resume()
    }
    
    
  
    
    func numberOrRows() -> Int {
       // return self.countryList?.count ?? 0
        return self.countryList.count
    }

    func getCountry(index: Int) -> CountryInfo? {
       
        print("getCountry  : ",self.countryList[index])
        return self.countryList[index]
        
      //  return self.countryList?[index]
    }
    
    
    
    func getDemoDataList(){
    /*
       
     var   itemDemo = [
            
            CountryInfo(id: 1, name: "AFGHANISTAN"),
            CountryInfo(id: 2, name: "ALBANIA"),
            CountryInfo(id: 3, name: "ALGERIA"),
            CountryInfo(id: 10, name: "ARGENTINA"),
            CountryInfo(id: 11, name: "ARMENIA"),
            CountryInfo(id: 12, name: "ARUBA"),
            CountryInfo(id: 18, name: "BANGLADESH"),
            CountryInfo(id: 19, name: "BARBADOS"),
            CountryInfo(id: 21, name: "BELGIUM"),
            CountryInfo(id: 25, name: "BHUTAN"),
            CountryInfo(id: 26, name: "BOLIVIA"),
            CountryInfo(id: 27, name: "BOSNIA AND HERZEGOVINA"),
            CountryInfo(id: 28, name: "BOTSWANA"),
            CountryInfo(id: 29, name: "BOUVET ISLAND"),
            
            CountryInfo(id: 47, name: "COLOMBIA"),
            CountryInfo(id: 52, name: "COSTA RICA"),
            CountryInfo(id: 57, name: "CZECH REPUBLIC")
        
        
                    
        
                      ]
        
        
        
        countryList =   itemDemo
     
     */
    }

}
