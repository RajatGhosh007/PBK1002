//
//  UserProfileViewModel.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 11/05/23.
//

import UIKit

protocol UserProfileDataDelegate : AnyObject {
    func didRecieveDataUpdate(name:String,companyName:String,phone:String,base64Encode:String,cardModel:CardModel?,addressModel:AddressModel?)
}

class UserProfileViewModel: BaseViewModel {
    
    var userResponse: UserProfileResponse?
    
   weak var delegate: UserProfileDataDelegate?
    
    
    func getUserProfileDetailWithToken(token: String,urlName: String,methodType:String, success: @escaping ((UserProfileResponse,String,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
        
        ApiManager.shared.getUserProfileDetailWithToken(token: token, urlName: urlName, methodType: methodType) { [weak self](response, message, status) in
            self?.updateProfileInfo(profileResponse: response)
           
            success(response,message,status)
        } fail: { error, message, status in
            fail(error,message,status)
        }
  
    }
    
    func updateProfileInfo(profileResponse:UserProfileResponse?){
        print("self?.userResponse  ",self.userResponse ?? Data())
        self.userResponse = profileResponse
        
        let cardModel = self.userResponse?.data?.user?.CardModel
        let addressModel = self.userResponse?.data?.user?.AddressModel
        
        
        let name = self.userResponse?.data?.user?.name ?? ""
        let companyName = self.userResponse?.data?.user?.company_name ?? ""
        let phoneNumber = self.userResponse?.data?.user?.phone ?? ""
        let base64Encode = self.userResponse?.data?.user?.image ?? ""
        
        self.delegate?.didRecieveDataUpdate(name: name, companyName: companyName, phone: phoneNumber,base64Encode:base64Encode,cardModel:cardModel,addressModel:addressModel)
        
    }

}
