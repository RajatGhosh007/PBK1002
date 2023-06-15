//
//  LogInViewModel.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 21/04/23.
//

import Foundation
import JWTDecode

class LogInViewModel: BaseViewModel {
    
    var loginResponse: LogInResponse?
    var commonResponse: CommonResponse?
    var userResponse: UserResponse?
    var accessCodeResponse: AccessCodeResponse?
    
    
    func loginServiceCustom(emailIdStr: String,passwordStr: String, success: @escaping ((LogInResponse?,String,Bool) -> Void)){
      
        
    }
    
    
    func loginServiceSubmit(paramsInput:[String: Any],urlName:String,methodType:String, success: @escaping ((LogInResponse?,String,Bool,Bool) -> Void)){
        
        ApiManager.shared.LoginAPISubmit(paramsInput: paramsInput, urlName: urlName,methodType: methodType) { (response, message, status) in
            self.loginResponse = response
       //     let isExisting =   self.userResponse?.isExisting  ?? false
            
            let accessToken =  self.loginResponse?.data?.access_token ?? ""
            let refreshToken =  self.loginResponse?.data?.refresh_token ?? ""
            
            do{
                let jwt = try JWTDecode.decode(jwt: accessToken)
                print(jwt.body["user_type"] as Any)
                let userType = jwt.body["user_type"] as Any
                UserDefaults.standard.setValue(userType, forKey: "USERTYPE")
            }catch{
                
            }
            
            UserDefaults.standard.setValue(accessToken, forKey: "accessTokenKey")
            UserDefaults.standard.setValue(refreshToken, forKey: "refreshTokenKey")
            
            success(response,message,true,true)
        } fail: { HTTPError, message, Bool in
            success(nil,message,false,false)
        }

        
    }
    
    
    func getAccessCodeWithEmail(paramsInput:[String: Any],urlName: String,methodType:String,success:@escaping ((AccessCodeResponse?,String,String,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
         
        ApiManager.shared.getAccessCodeWithEmail(paramsInput: paramsInput, urlName: urlName, methodType: methodType) { (response, message, status) in
            self.accessCodeResponse = response
            let accessCode =  self.accessCodeResponse?.data?.access_code ?? ""
            success(response,accessCode,message,true)
        } fail: { error, message, Bool in
            fail(error,message,false)
        }

        
    }
    
    func loginServiceSubmitOTP(paramsInput:[String: Any],urlName:String,methodType:String, success: @escaping ((UserResponse?,String,Bool) -> Void)){
        
        ApiManager.shared.LoginAPISubmitOTP(paramsInput: paramsInput, urlName: urlName,methodType: methodType) { (response, message, status) in
            self.userResponse = response
            success(response,message,true)
        } fail: { HTTPError, message, Bool in
            success(nil,message,false)
        }

        
    }
    
    func loginServiceSubmitOTPRequestPassword(paramsInput:[String: Any],urlName:String,methodType:String, success: @escaping ((AccessCodeResponse?,String,Bool) -> Void)){
        
        ApiManager.shared.LoginAPISubmitOTPRequestPassword(paramsInput: paramsInput, urlName: urlName,methodType: methodType) { (response, message, status) in
            self.accessCodeResponse = response
            let accessCode = self.accessCodeResponse?.data?.access_code ?? ""
            success(response,accessCode,true)
        } fail: { HTTPError, message, Bool in
            success(nil,message,false)
        }

        
    }
    
    
    
    func callServiceAPISubmit(paramsInput:[String: Any],urlName:String, methodType:String,success: @escaping ((CommonResponse?,String,Bool) -> Void)){
        
        ApiManager.shared.submitGeneralAPI(paramsInput: paramsInput, urlName: urlName,methodType:methodType) { (response, message, status) in
            self.commonResponse = response
            success(response,message,true)
        } fail: { HTTPError, message, Bool in
            success(nil,message,false)
        }


        
    }
    
    // MARK: Request Password
    
    func callServiceAPISubmitRequestPassword(paramsInput:[String: Any],urlName:String, methodType:String,success: @escaping ((AccessCodeResponse?,String,Bool) -> Void)){
        
        ApiManager.shared.submitGeneralAPIRequestPassword(paramsInput: paramsInput, urlName: urlName,methodType:methodType) { (response, message, status) in
            self.accessCodeResponse = response
            let accessCode = self.accessCodeResponse?.data?.access_code ?? ""
            success(response,accessCode,true)
        } fail: { HTTPError, message, Bool in
            success(nil,message,false)
        }


        
    }
    
    
    func callServiceAPISubmitWithToken(paramsInput:[String: Any],token:String,urlName : String , methodType:String , success: @escaping ((CommonResponse?,String,Bool) -> Void)){
        
        ApiManager.shared.submitGeneralAPIWithToken(paramsInput: paramsInput,token:token, urlName: urlName,methodType:methodType) { (response, message, status) in
            self.commonResponse = response
            success(response,message,true)
        } fail: { HTTPError, message, Bool in
            success(nil,message,false)
        }


        
    }
    
    
    
    func submitUserVerifyAPI(paramsInput:[String: Any],urlName : String , methodType:String , success: @escaping ((CommonResponse?,String,Bool) -> Void)){
        
        ApiManager.shared.userVerifyAPI(paramsInput: paramsInput, urlName: urlName,methodType:methodType) { (response, message, status) in
            self.commonResponse = response
            success(response,message,true)
        } fail: { HTTPError, message, Bool in
            success(nil,message,false)
        }
    }
    
    
    func decode(jwtToken jwt: String) throws -> [String: Any] {
        enum DecodeErrors: Error {
            case badToken
            case other
        }

        func base64Decode(_ base64: String) throws -> Data {
            let base64 = base64
                .replacingOccurrences(of: "-", with: "+")
                .replacingOccurrences(of: "_", with: "/")
            let padded = base64.padding(toLength: ((base64.count + 3) / 4) * 4, withPad: "=", startingAt: 0)
            guard let decoded = Data(base64Encoded: padded) else {
                throw DecodeErrors.badToken
            }
            return decoded
        }

        func decodeJWTPart(_ value: String) throws -> [String: Any] {
            let bodyData = try base64Decode(value)
            let json = try JSONSerialization.jsonObject(with: bodyData, options: [])
            guard let payload = json as? [String: Any] else {
                throw DecodeErrors.other
            }
            return payload
        }

        let segments = jwt.components(separatedBy: ".")
        return try decodeJWTPart(segments[1])
    }
    
}


