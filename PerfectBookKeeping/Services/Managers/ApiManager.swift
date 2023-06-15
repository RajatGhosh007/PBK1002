//
//  ApiManager.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 20/04/23.
//

import Foundation

class ApiManager {
    public static let shared = ApiManager()
    
    
    func fileUploadAPI(paramsInput: [String: Any],token:String,urlName: String,methodType:String, success: @escaping ((CommonResponse) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
      
        ServiceManager.shared.getCompanyList(dictionary: paramsInput, token: token, urlName: urlName, methodType: methodType) { (response) in
            success(response)
        } fail: { error, message, status in
            fail(error,message,status)
        }
        
      
    }
    
    
    func  HomeCallAPI(paramsAny : [String : Any],Url : String,token: String, success: @escaping ((CompanyListRes) -> Void),fail: @escaping ((HTTPError) -> Void)){
      
        ServiceManager.shared.callGetServiceWithToken(params : paramsAny, token: token , Url: Url) { (response: CompanyListRes)  in
            success(response)
        } fail: { error in
            fail(error)
        }
        
      
    }
    
    
    func getCompanyListWithAccessToken(paramsInput: [String: Any],token:String,urlName: String,methodType:String, success: @escaping ((CompanyListRes) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
        
        ServiceManager.shared.getCompanyList(dictionary: paramsInput, token: token, urlName: urlName, methodType: methodType) { (response) in
            success(response)
        } fail: { error, message, status in
            fail(error,message,status)
        }
        
        
    }
    
    func getPaymentReceiptListWithAccessToken(paramsInput: [String: Any],token:String,urlName: String,methodType:String, success: @escaping ((ReceiptResponse) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
        
        ServiceManager.shared.getListWithAccessToken(dictionary: paramsInput, token: token, urlName: urlName, methodType: methodType) { (response) in
            success(response)
        } fail: { error, message, status in
            fail(error,message,status)
        }
        
        
    }
    
    // MARK: Gallery List
    func getGalleryListWithAccessToken(paramsInput: [String: Any],token:String,urlName: String,methodType:String, success: @escaping ((GalleryListResponse) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
        //  Demo
        ServiceManager.shared.getGalleryListWithAccessToken(dictionary: paramsInput, token: token, urlName: urlName, methodType: methodType) { (response) in
            success(response)
        } fail: { error, message, status in
            fail(error,message,status)
        }
        
        
    }
   
    // MARK: Filter  List
    func getFilterListWithAccessToken(paramsInput:[String:String],token:String,urlName: String,methodType:String, success: @escaping ((GalleryListResponse) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
        //  Demo
        ServiceManager.shared.getFilterListWithAccessToken(dictionary:paramsInput, token: token, urlName: urlName, methodType: methodType) { (response) in
            success(response)
        } fail: { error, message, status in
            fail(error,message,status)
        }
        
        
    }
    
    
    func getAccessTokenWithRefreshToken(dictionary:[String: Any],token:String,urlName: String,methodType:String,success:@escaping ((AccessTokenResponse) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
        ServiceManager.shared.getAccessTokenWithRefreshToken(dictionary: dictionary, token: token, urlName:urlName , methodType: methodType) { (response) in
            success(response)
        } fail: { error, message, status in
            fail(error,message,status)
        }

        
        
        
    }
    
    
    
    func LoginAPISubmit(paramsInput: [String: Any],urlName: String,methodType:String,success: @escaping ((LogInResponse ,String,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
        ServiceManager.shared.callLoginServiceSubmit(dictionary: paramsInput, urlName: urlName,methodType: methodType) {(response, message, status) in
            success(response,message,status)
        } fail: { error, message, status in
            fail(error,message,status)
        }
  
       
    }
    
    func getAccessCodeWithEmail(paramsInput:[String: Any],urlName: String,methodType:String,success:@escaping ((AccessCodeResponse,String,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
        ServiceManager.shared.getAccessCodeWithEmail(dictionary: paramsInput, urlName: urlName,methodType: methodType) {(response, message, status) in
            success(response,message,status)
        } fail: { error, message, status in
            fail(error,message,status)
        }
       
    }
    
    
    
    
    
    
    func LoginAPISubmitOTPRequestPassword(paramsInput: [String: Any],urlName: String,methodType:String,success: @escaping ((AccessCodeResponse ,String,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
        ServiceManager.shared.callLoginServiceSubmitOTPRequestPassword(dictionary: paramsInput, urlName: urlName,methodType: methodType) {(response, message, status) in
            success(response,message,status)
        } fail: { error, message, status in
            fail(error,message,status)
        }
  
       
    }
    
    
    func LoginAPISubmitOTP(paramsInput: [String: Any],urlName: String,methodType:String,success: @escaping ((UserResponse ,String,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
        ServiceManager.shared.callLoginServiceSubmitOTP(dictionary: paramsInput, urlName: urlName,methodType: methodType) {(response, message, status) in
            success(response,message,status)
        } fail: { error, message, status in
            fail(error,message,status)
        }
  
       
    }
    
    
    
    func submitGeneralAPI(paramsInput: [String: Any],urlName: String,methodType:String, success: @escaping ((CommonResponse ,String,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
        ServiceManager.shared.callGeneralSubmitAPI(dictionary: paramsInput, urlName: urlName,methodType:methodType) { (response, message, status) in
            success(response,message,status)
        } fail: { error, message, status in
            fail(error,message,status)
        }
 
    }
    
    
    //   RequestPassword
    // MARK: Request Password
    func submitGeneralAPIRequestPassword(paramsInput: [String: Any],urlName: String,methodType:String, success: @escaping ((AccessCodeResponse ,String,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
        ServiceManager.shared.callGeneralSubmitAPIRequestPassword(dictionary: paramsInput, urlName: urlName,methodType:methodType) { (response, message, status) in
            success(response,message,status)
        } fail: { error, message, status in
            fail(error,message,status)
        }
 
    }
    
    func submitGeneralAPIWithToken(paramsInput: [String: Any],token:String,urlName: String,methodType:String, success: @escaping ((CommonResponse ,String,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
        ServiceManager.shared.callGeneralSubmitAPIWithToken(dictionary: paramsInput,token:token, urlName: urlName,methodType:methodType) { (response, message, status) in
            success(response,message,status)
        } fail: { error, message, status in
            fail(error,message,status)
        }
 
    }
    
    
    
    
    func userVerifyAPI(paramsInput: [String: Any],urlName: String,methodType:String, success: @escaping ((CommonResponse ,String,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
        ServiceManager.shared.submitUserVerifyAPI(dictionary: paramsInput, urlName: urlName,methodType:methodType) { (response, message, status) in
            success(response,message,status)
        } fail: { error, message, status in
            fail(error,message,status)
        }
 
    }
    
    
    func LoginAPINormal(emailidStr: String,passwordStr: String, success: @escaping ((LogInResponse ,String,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
        /*
        ServiceManager.shared.callLoginService(emailidStr: emailidStr, passwordStr: passwordStr) { (response, message, status) in
          success(response,message,status)
        } fail: { error, message, status in
            fail(error,message,status)
        }
       */
        
       
    }
    
    
    // MARK: GET  Requst For User Profile
    
    func getUserProfileDetailWithToken(token: String,urlName: String,methodType:String, success: @escaping ((UserProfileResponse,String,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
        ServiceManager.shared.getUserProfileDetailWithToken(token: token, urlName: urlName, methodType: methodType) { (response, message, status) in
            success(response,message,status)
        } fail: { error, message, status in
            fail(error,message,status)
        }

    }
    
    
    func submitProfileDetailWithToken(paramsInput: [String: Any],token: String,urlName: String,methodType:String, success: @escaping ((CommonResponse) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
        ServiceManager.shared.getListWithAccessToken(dictionary: paramsInput, token: token, urlName: urlName, methodType: methodType) { (response) in
            success(response)
        } fail: { error, message, status in
            fail(error,message,status)
        }

    }
    
    func uploadImageWithAccessToken(paramsInput:[String: Any],token: String,urlName: String,methodType:String,success:@escaping ((CommonResponse) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
        ServiceManager.shared.uploadImageWithAccessToken(dictionary: paramsInput, token: token, urlName: urlName, methodType: methodType) { (response) in
            success(response)
        } fail: { error, message, status in
            fail(error,message,status)
        }

        
    }
    
    
    
    func getCountryListAPI(paramsInput:[String:String],urlName: String,methodType:String, success: @escaping ((CountryList ,String,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
        ServiceManager.shared.requstForCountryList(dictionary: paramsInput, urlName: urlName, methodType: methodType) { (response, message, status) in
            success(response,message,status)
        } fail: { error, message, status in
            fail(error,message,status)
        }

 
    }
    
    
    func getStateListAPI(paramsInput:[String:String],urlName: String,methodType:String, success: @escaping ((StateResponse ,String,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
        ServiceManager.shared.requstForStateList(dictionary: paramsInput, urlName: urlName, methodType: methodType) { (response, message, status) in
            success(response,message,status)
        } fail: { error, message, status in
            fail(error,message,status)
        }

 
    }
    
    
}
