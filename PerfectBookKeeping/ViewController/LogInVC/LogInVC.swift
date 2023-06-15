//
//  LogInVC.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 17/04/23.
//

import UIKit
import Alamofire
//import Loader


import CommonCrypto

class LogInVC: UIViewController ,ForgotPasswordDelegate ,OTPVerifyDelegate,UpadtePasswordDelegate {
    
    
    
    //   rajat.ghosh@seniordevtech.com
    var galleryListViewModel = GalleryListViewModel()
    
    @IBOutlet weak var firstView: UIView!
    
    @IBOutlet weak var secondView: UIView!
    
    
    var iconClick = true
    var userEmailID = ""
    var accessCodeForReqPassword = ""
    var accessCodeAfterOTPVerified = ""
    
    private var loginViewModel = LogInViewModel()
    
    @IBOutlet weak var btnRefLogin1: UIButton!
    @IBOutlet weak var btnRefLogin2: UIButton!
    
    @IBOutlet weak var txtEmailFirst: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet  weak var txtPassword: UITextField!
    
    @IBOutlet weak var imgHideUnhide: UIImageView!
    
    
    
    
    var customViewForgetPassword =  ForgotPassword()
    var customViewOTP =  OTPVerifyPopUp()
    var customViewUpdatePassword =  UpdatePassword()
    
    var accessCode =  ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let key = Constant.SECRET_KEY
        
        let otpTxt = " 747103"
        let cryptLib = CryptLib()
        
      var  otpCipherText = cryptLib.encryptPlainTextRandomIV(withPlainText: otpTxt, key: key) ?? ""
       print("cipherText \(otpCipherText as String)")

       let decryptedStringOTP = cryptLib.decryptCipherTextRandomIV(withCipherText: otpCipherText, key: key)
       print("decryptedStringOTP \(decryptedStringOTP! as String)")
        
        let identifier = UIDevice.current.identifierForVendor?.uuidString ?? ""

        NSLog("output is : %@", identifier as String)
        
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Enter your email address here",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Enter your password here",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        
        btnRefLogin1.applyGradient(colors: [Constant.CustomAppColour.colorLeft, Constant.CustomAppColour.colorRight],
                                  locations: [0.0, 1.0],
                                  direction: .leftToRight)
        btnRefLogin2.applyGradient(colors: [Constant.CustomAppColour.colorLeft, Constant.CustomAppColour.colorRight],
                                  locations: [0.0, 1.0],
                                  direction: .leftToRight)
     
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        btnRefLogin1.roundCornersWithHalfRadius()
        btnRefLogin2.roundCornersWithHalfRadius()
    }
    
    // MARK:  SUBMIT of Log IN PAGE 1 API
    @IBAction func getAccessCodeBeforeLogIn(_ sender: Any) {
        
        var userNameStr = ""
        
        if (UITextField.validateAll(textFields: [txtEmailFirst])) {
        if txtEmailFirst.text!.isValidEmail{
        userNameStr = txtEmailFirst.text!
        
            if (NetworkState().isInternetAvailable) {
         //   callLogInAPI(userName:userNameStr ,password:passwordStr)
                getAccessCode(userName: userNameStr)
            }else{
                showAlert(titleStr: "Perfect BookKeeping", msgStr:"No Network")
            }
        
        }else{
           showAlert(titleStr: "Perfect BookKeeping", msgStr:"Enter a valid email address")
        }
        
        
        }else{
           showAlert(titleStr: "Perfect BookKeepings", msgStr:"Email field is empty")
        }
      
        
    }
    
    func getAccessCode(userName:String) {
        
        let paramDict = ["email":userName,"mac_address":"","device_type":"ios","user_type":0] as [String : Any]
    
     
        let urlName = Constant.API_NAME.ACCESS_CODE
        
        
        loginViewModel.getAccessCodeWithEmail(paramsInput: paramDict, urlName: urlName, methodType: "POST") { (_,accessCode, message, success) in
            self.accessCode = accessCode
            
            
            DispatchQueue.main.async {
                self.firstView.isHidden = true
                self.secondView.isHidden = false
                self.txtEmail.text = self.txtEmailFirst.text
            }
        
            
        } fail: { (_, message, fail) in
            print("Error")
        }

        
        
        
    }
    
    
    
    // MARK:  SUBMIT of Log IN PAGE 2 API
    @IBAction func forwardToNextPage(_ sender: Any) {
      
      //  forwardToProfilePage()
        txtEmail.text = txtEmailFirst.text
        
         var userNameStr = ""
         var passwordStr = ""
         
         if (UITextField.validateAll(textFields: [txtEmail])) {
         if txtEmail.text!.isValidEmail{
         userNameStr = txtEmail.text!
         
         if (UITextField.validateAll(textFields: [txtPassword])) {
         
         if txtPassword.text!.count >= 6{
         passwordStr = txtPassword.text!
         
         if (NetworkState().isInternetAvailable) {
         callLogInAPI(userName:userNameStr ,password:passwordStr)
         
         }else{
             showAlert(titleStr: "Perfect BookKeeping", msgStr:"No Network")
         }
         
         }else{
         showAlert(titleStr: "Perfect BookKeeping", msgStr:"Password field should contain atleast 8 character")
         }
         
         
         
         }else{
         showAlert(titleStr: "Perfect BookKeeping", msgStr:"Password field is empty")
         }
         
         
         
         
         }else{
         showAlert(titleStr: "Perfect BookKeeping", msgStr:"Enter a valid email address")
         }
         
         
         }else{
         showAlert(titleStr: "Perfect BookKeepings", msgStr:"Email field is empty")
         }
         
       
        
        
    }
    
    
    func callLogInAPI(userName:String, password: String ) {
        var cipherText = ""
        let key = Constant.SECRET_KEY
        let cryptLib = CryptLib()

        cipherText = cryptLib.encryptPlainTextRandomIV(withPlainText: password, key: key) ?? ""
        print("cipherText \(cipherText as String)")

        let decryptedString = cryptLib.decryptCipherTextRandomIV(withCipherText: cipherText, key: key)
        print("decryptedString \(decryptedString! as String)")
            
        let paramDict = ["email":userName,"password":cipherText,"access_code":accessCode]
        let urlName = Constant.API_NAME.LOGIN
        
        showLoader()
        loginViewModel.loginServiceSubmit(paramsInput:paramDict, urlName:urlName, methodType:"POST") { (_,message, success,isExisting) in
            self.hideLoader()
            if success {
                print("Success ")
                DispatchQueue.main.async {
                    self.forwardToCompanyPage()
                }
            }else{
                print("Log In Error ")
                DispatchQueue.main.async {
                    self.showAlert(titleStr: "Perfect BookKeepings", msgStr:message)
                }
            }
        }
    }
    
    func forwardToCompanyPage() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompanyListNewVC") as! CompanyListNewVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    func showAlert(titleStr: String, msgStr: String ) {
        let alert = UIAlertController(title:titleStr, message: msgStr, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showLoader() {
        Loader.shared.show()
    }
    
    func hideLoader() {
        Loader.shared.hide()
    }
    
    // MARK: Foget Password POP UP
    @IBAction func showForgetPassord(_ sender: Any) {
        showForgotEmail()
    }
    
    func showForgotEmail(){
        customViewForgetPassword = ForgotPassword(nibName: "ForgotPassword", bundle: nil)
        customViewForgetPassword.delegate = self
        
        customViewForgetPassword.view.frame = self.view.bounds
        self.addChild(customViewForgetPassword)
        self.view.addSubview(customViewForgetPassword.view)
    }
    
    // MARK:  Request of FORGET PASSWORD PAGE
    func forwardToNextPageFromForgetPassword(inputEmailID:String){
        callForgotPasswordAPIWithEmail(emailID:inputEmailID)
    }
    
    func callForgotPasswordAPIWithEmail(emailID:String){
       //   let userEmailID = "rajat.ghosh@seniordevtech.com"
        userEmailID =  emailID
        
        let urlName = Constant.API_NAME.REQUEST_RESET_PASSWORD
        
        
    //    let paramDict = ["email":userEmailID]
        //let paramDict = ["email":userEmailID,"mac_address":"","device_type":"ios","user_type":"0"]
        let paramDict = ["email":userEmailID,"mac_address":"","device_type":"ios","user_type":0] as [String : Any]
      
        
        loginViewModel.callServiceAPISubmitRequestPassword(paramsInput: paramDict, urlName: urlName,methodType:"POST") { [weak self](_,accessCode, success) in
            
            if success {
                self?.accessCodeForReqPassword = accessCode
               DispatchQueue.main.async {
                    self?.displayOTPPageContent()
                    
               }
            }else{
                print("fail fail  ")
            }
        }
        
        
    }
    
    func dismissPopUpForgetPassword() {
        customViewForgetPassword.view.removeFromSuperview()
        customViewForgetPassword.delegate = nil
        customViewForgetPassword.removeFromParent()
        
    }
   
    
    func displayOTPPageContent(){
        
        print("New New new ")
        customViewForgetPassword.view.removeFromSuperview()
        customViewForgetPassword.delegate = nil
        customViewForgetPassword.removeFromParent()
        
         customViewOTP = OTPVerifyPopUp(nibName: "OTPVerifyPopUp", bundle: nil)
        customViewOTP.delegate = self
        
        customViewOTP.view.frame = self.view.bounds
        self.addChild(customViewOTP)
        self.view.addSubview(customViewOTP.view)
    }
    
    func dismissPopUpOtpVerify(){
        customViewOTP.view.removeFromSuperview()
        customViewOTP.delegate = nil
        customViewOTP.removeFromParent()
        
    }
    
   // dismissPopUpOtpVerify
    
    // MARK: SUBMIT of OTP Page
    
    func  submitFromOTPVC(inputVal:String) {
    
        userEmailID = txtEmailFirst.text ?? ""
        let token = inputVal
    
      //  let paramDict = ["email":userEmailID,"otp":token]
        
        let key = Constant.SECRET_KEY
        let cryptLib = CryptLib()
        
        let  otpCipherText = cryptLib.encryptPlainTextRandomIV(withPlainText: token, key: key) ?? ""
       print("cipherText \(otpCipherText as String)")

       let decryptedStringOTP = cryptLib.decryptCipherTextRandomIV(withCipherText: otpCipherText, key: key)
       print("decryptedStringOTP \(decryptedStringOTP! as String)")
        
        
        let paramDict = ["email":userEmailID,"otp":otpCipherText,"access_code":self.accessCodeForReqPassword,"mac_address":"","device_type":"ios"]
        
        let urlName = Constant.API_NAME.VARIFY_OTP
       
        //   loginServiceSubmit
        
        showLoader()
        loginViewModel.loginServiceSubmitOTPRequestPassword(paramsInput: paramDict, urlName:urlName, methodType:"POST") { (_,message, success) in
            
            self.hideLoader()
            if success {
                print("Success ")
                self.accessCodeAfterOTPVerified =  message
                print("self.accessCodeAfterOTPVerified    ",self.accessCodeAfterOTPVerified)
                DispatchQueue.main.async {
                    self.displayUpdatePasswordContent()
                    
                }
            }else{
                print("Log In Error ")
                DispatchQueue.main.async {
                    self.showAlert(titleStr: "Perfect BookKeepings", msgStr:message)
                    
                }
                
            }
        }
        
        
        
        /*
        
        loginViewModel.callServiceAPISubmit(paramsInput: paramDict, urlName: urlName) { [weak self](_,message, success) in
            
            if success {
                self?.displayUpdatePasswordContent()
            }else{
                print("fail fail  ")
            }
        }
        */
        
        
        
      
    }
    
    
    func displayUpdatePasswordContent(){
        
        customViewOTP.view.removeFromSuperview()
        customViewOTP.delegate = nil
        customViewOTP.removeFromParent()
        
        customViewUpdatePassword = UpdatePassword(nibName: "UpdatePassword", bundle: nil)
        customViewUpdatePassword.delegate = self
        customViewUpdatePassword.view.frame = self.view.bounds
        self.addChild(customViewUpdatePassword)
        self.view.addSubview(customViewUpdatePassword.view)
    }
    
    
    
    
    // MARK: Update Password Functionnality
    
    func updatePassword(emailInput:String ,passwordInput:String){
        
        updatePasswordAPI(emailInput:emailInput ,passwordInput:passwordInput)
     
    }
    
    
    func updatePasswordAPI(emailInput:String ,passwordInput:String){
        
        var  cipherText = ""
       
        
    //    let userEmailID = "rajat.ghosh@seniordevtech.com"
        
        print("passwordInput     ",passwordInput)
        
      //  let key = "secretKey"
        let key = Constant.SECRET_KEY

        let cryptLib = CryptLib()

         cipherText = cryptLib.encryptPlainTextRandomIV(withPlainText: passwordInput, key: key) ?? ""
        print("cipherText \(cipherText as String)")

        let decryptedString = cryptLib.decryptCipherTextRandomIV(withCipherText: cipherText, key: key)
        print("decryptedString \(decryptedString! as String)")
       
      //  var urlName =  Constant.API_NAME.USERS
        let urlName =  Constant.API_NAME.RESET_PASSWORD
        
       
     
        print("urlName   is ",urlName)
        
      //  let paramDict = ["email":userEmailID,"password":cipherText]
        let paramDict = ["email":userEmailID,"password":cipherText,"access_code":self.accessCodeAfterOTPVerified]
        
        
        
        let token = UserDefaults.standard.string(forKey: "strCookieValOTPonly")  ?? ""
        
        loginViewModel.callServiceAPISubmitWithToken(paramsInput: paramDict,token:token, urlName: urlName,methodType:"POST") { [weak self](_,message, success) in
            
            if success {
               DispatchQueue.main.async {
                    self?.forwardToLogInPage()
               
               }
            }else{
                print("fail fail  ")
            }
        }
        
        /*
        loginViewModel.callServiceAPISubmitWithToken(paramsInput: paramDict,token:token, urlName: urlName,methodType:"PUT") { [weak self](_,message, success) in
            
            if success {
               DispatchQueue.main.async {
                    self?.forwardToLogInPage()
               
               }
            }else{
                print("fail fail  ")
            }
        }
        */
    }
    
    func dismissPopUpUpdatePassword(){
        
        customViewUpdatePassword.view.removeFromSuperview()
        customViewUpdatePassword.delegate = nil
        customViewUpdatePassword.removeFromParent()
    }
    
    
    func forwardToLogInPage(){
        
        customViewUpdatePassword.view.removeFromSuperview()
        customViewUpdatePassword.delegate = nil
        customViewUpdatePassword.removeFromParent()
        
        customViewOTP.view.removeFromSuperview()
        customViewOTP.delegate = nil
        customViewOTP.removeFromParent()
        
        customViewForgetPassword.view.removeFromSuperview()
        customViewForgetPassword.delegate = nil
        customViewForgetPassword.removeFromParent()
        
       
        DispatchQueue.main.async {
            self.showAlert(titleStr: "Perfect BookKeeping", msgStr:"Password Update Successfully ")
        
        }
        
    }
    
    
    
    @IBAction func hideUnhidePassword(_ sender: UIButton) {
        
        
        if iconClick {
            txtPassword.isSecureTextEntry = false
            self.imgHideUnhide.image = UIImage(named:"view")
            } else {
                txtPassword.isSecureTextEntry = true
                self.imgHideUnhide.image = UIImage(named:"hide")
            }
            iconClick = !iconClick
        
        
    }
    
    
    
    
    
    func demoEncryptCheck(){
        
        
        let plainText = "123456"
       // let key = "secretKey"
        let key = Constant.SECRET_KEY

        let cryptLib = CryptLib()

        let cipherText = cryptLib.encryptPlainTextRandomIV(withPlainText: plainText, key: key)
        print("cipherText \(cipherText! as String)")

        let decryptedString = cryptLib.decryptCipherTextRandomIV(withCipherText: cipherText, key: key)
        print("decryptedString \(decryptedString! as String)")
    }
    
    
    
    
}





extension LogInVC : UITextFieldDelegate {
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
       textField.resignFirstResponder()
       return true
    }

}







/*
 
 var iconClick = true
 
 
 @IBAction func iconAction(sender: AnyObject) {
     if iconClick {
         passwordTF.secureTextEntry = false
     } else {
         passwordTF.secureTextEntry = true
     }
     iconClick = !iconClick
 }
 
 
 
 
 
 
 //http://192.168.1.16:3000/login
 {
     "email":"admin@gmail.com",
     "password":"123456"
 }
 
 
 {
     "data": {
         "id": 1,
         "email": "admin@gmail.com",
         "password": "",
         "name": "Super Admin",
         "createdAt": "2021-02-02T20:14:11.000Z",
         "updatedAt": "2023-02-14T03:22:10.000Z"
     },
     "message": "login",
     "flag": true
 }
 
 {
     "message": "Password not matching",
     "flag": false
 }
 
 
 
 */
