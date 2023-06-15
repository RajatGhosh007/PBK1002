//
//  OTPVerifyPopUp.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 26/04/23.
//

import UIKit
import SVPinView

protocol OTPVerifyDelegate: AnyObject {
    func dismissPopUpOtpVerify()
    func submitFromOTPVC(inputVal:String)
}



class OTPVerifyPopUp: UIViewController {
    
    weak var delegate: OTPVerifyDelegate?
    
    @IBOutlet weak var pinView: SVPinView!
    @IBOutlet weak var outsideContentView: UIView!
    
    @IBOutlet weak var btnRefNext: UIButton!
    @IBOutlet weak var viewContainer: UIView!
    
    var otpVal = ""
    
    
    let colorLeft =  UIColor(red: 168.0/255.0, green: 214.0/255.0, blue: 170.0/255.0, alpha: 1.0).cgColor
    let colorRight = UIColor(red: 157.0/255.0, green: 220.0/255.0, blue: 243.0/255.0, alpha: 1.0).cgColor
    
    enum SVPinViewStyle : Int {
        case none = 0
        case underline
        case box
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        configurePinView()
     //  setUpForKeyBoardAvoiding()
        
        btnRefNext.applyGradient(colors: [colorLeft, colorRight],
                                        locations: [0.0, 1.0],
                                        direction: .leftToRight)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        btnRefNext.roundCornersWithHalfRadius()
        viewContainer.roundCornersSpecific(corners: [.topLeft,.topRight], radius: 30.0)
    
        
    }
    
    func configurePinView() {
        pinView.pinLength = 6
        pinView.secureCharacter = "\u{25CF}"
        pinView.interSpace = 15       //   10
        pinView.textColor = UIColor.black
        pinView.borderLineColor = UIColor.black
        pinView.activeBorderLineColor = UIColor.black
        pinView.borderLineThickness = 1
        pinView.shouldSecureText = true
        pinView.allowsWhitespaces = false
        pinView.style = .underline
      //  pinView.fieldBackgroundColor = UIColor.systemGreen.withAlphaComponent(0.1)
        pinView.fieldBackgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        
   //     pinView.activeFieldBackgroundColor = UIColor.systemGreen.withAlphaComponent(0.4)
        
        pinView.activeFieldBackgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        
        pinView.fieldCornerRadius = 15
        pinView.activeFieldCornerRadius = 15
       // pinView.placeholder = "******"
        pinView.deleteButtonAction = .deleteCurrentAndMoveToPrevious
        pinView.keyboardAppearance = .default
        pinView.tintColor = .black
        pinView.becomeFirstResponderAtIndex = 0
        pinView.shouldDismissKeyboardOnEmptyFirstField = false

        
        pinView.font = UIFont.systemFont(ofSize: 20)
        pinView.keyboardType = .phonePad
        pinView.pinInputAccessoryView = { () -> UIView in
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
            doneToolbar.barStyle = UIBarStyle.black
            doneToolbar.tintColor = UIColor.black
            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem  = UIBarButtonItem(title: "DONE", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard))
            done.tintColor = .white
            
            var items = [UIBarButtonItem]()
            items.append(flexSpace)
            items.append(done)
            
            doneToolbar.items = items
            doneToolbar.sizeToFit()
            return doneToolbar
        }()
        
        pinView.didFinishCallback = didFinishEnteringPin(pin:)
        
        
        pinView.didChangeCallback = { pin in
            print("The entered pin is \(pin)")
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
    }

    func didFinishEnteringPin(pin:String) {
        //showAlert(title: "Success", message: "The Pin entered is \(pin)")
       // self.submitPinAction()
        //  API   Call
          
        otpVal =  pin
        
        
    }

    
    func setUpForKeyBoardAvoiding() {
        
        //  #selector(ForgotPassword.keyboardWillShow)
        
        NotificationCenter.default.addObserver(self, selector: #selector(OTPVerifyPopUp.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(OTPVerifyPopUp.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
    
    @objc func  keyboardWillShow(notification: NSNotification) {
       self.view.frame.origin.y -= 150
        
      
    }

    @objc func  keyboardWillHide(notification: NSNotification) {
       self.view.frame.origin.y += 150
        
        
        /*
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {

            // if keyboard size is not available for some reason, dont do anything
            return
          }
        
        //   keyboardSize.height
        
        self.view.frame.origin.y += keyboardSize.height
        */
    }

    
    
    
    @IBAction func nextPageButtonFun(_ sender: UIButton) {
        
        if(otpVal.count == 6 ){
            delegate?.submitFromOTPVC(inputVal:otpVal )

        }
        
      
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        if let touch = touches.first {
            
            if touch.view == outsideContentView {
                
                delegate?.dismissPopUpOtpVerify()
            }
           
               
            }
        
    }
  

}
