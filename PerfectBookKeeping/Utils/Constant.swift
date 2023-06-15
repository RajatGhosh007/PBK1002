//
//  Constant.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 20/04/23.
//

import UIKit

public var screenWidth : CGFloat{
    return UIScreen.main.bounds.width
}

public var screenHeight : CGFloat{
    return UIScreen.main.bounds.height
}

struct Constant {
    
    static let SECRET_KEY = "a93e82d9be0d860cdde873826fa8f37d9b83092f8fb04e138fbca1dcd0131947"
    
    
    struct APPStaticData{
        static var selectCompanyID = 0
        static var selectDateUploadReceipt = ""
        
        
    }
    
   
    struct CustomAppColour {
        
    static  let colorLeft =  UIColor(red: 121.0/255.0, green: 175.0/255.0, blue: 114.0/255.0, alpha: 1.0).cgColor
    static let colorRight = UIColor(red: 63.0/255.0, green: 92.0/255.0, blue: 99.0/255.0, alpha: 1.0).cgColor
        
    }
    
    
    struct ContryList {
        
        static var arrCountryList = [CountryInfo]()
        static var arrAllCountryList = [AllCountryList]()
        static var stateListStore = [SateListStore]()
        
    }
    
    struct API_NAME {
        
    //    static let BASE_URL = "https://api.perfectbookkeeping.com/"
        static let BASE_URL = "https://api2.rentmycargovan.com/"
                       
        static let ACCESS_CODE                    = BASE_URL + "login/access-code"
        static let LOGIN                          = BASE_URL + "login"
   
        static let REFRESH                        = BASE_URL + "refresh"
        
        static let REQUEST_RESET_PASSWORD        = BASE_URL + "request-reset-password"
        static let VARIFY_OTP                    = BASE_URL + "verify-otp"
        static let RESET_PASSWORD                = BASE_URL + "reset-password"
        
    
        
        static let USERS                          = BASE_URL + "users"
        static let USERS_PROFILE                  = BASE_URL + "users/profile"
        static let COMPANIES                      = BASE_URL + "companies"
        static let PAYMENTS                       = BASE_URL + "payments"
        static let FILES                          = BASE_URL + "files"
        static let FILES_UPLOADS                          = BASE_URL + "files/uploads"
        
        //  files
        
      //  files/uploads
        
        //   refresh    payments
        
        //    static let REQUEST_RESET_PASSWORD   = BASE_URL + "requestResetPassword"
          //  static let VARIFY_OTP                = BASE_URL + "verifyOtp"
        
    }
    
    
    struct APIResponseCode{
        
            static let success = "success"
            static let failed = "error"
            static let error = "error"
    }
    
    
    
    struct AlertInfo{
        
            static let NO_NETWORK = "Please check your internet connection "
            static let TITLE = "Perfect BookKeepings"
            static let UNKNOWN_ERROR = "UNKNOWN ERROR"
            
            static let TO_DATE_ERROR = "ToDate should be greater than FormDate "
            static let FORM_DATE_ERROR = "FromDate Cannot be greater than Today "
          // static let TITLE = "Alert"
            
    }
    
}
