//
//  ForgotPassword.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 26/04/23.
//

import UIKit

protocol ForgotPasswordDelegate: AnyObject  {
    func dismissPopUpForgetPassword()
    func forwardToNextPageFromForgetPassword(inputEmailID:String)
}
    
//  func submitFromOTPVC(inputVal:String)


class ForgotPassword: UIViewController ,UITextFieldDelegate{
    
    var userEmailID = ""
    
    
    var activeTextField : UITextField? = nil
    @IBOutlet weak var txtEmail : UITextField!
    
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var outsideContentView: UIView!
    
    weak var delegate: ForgotPasswordDelegate?
    
    @IBOutlet weak var btnRefNext: UIButton!
    
    let colorLeft =  UIColor(red: 168.0/255.0, green: 214.0/255.0, blue: 170.0/255.0, alpha: 1.0).cgColor
    let colorRight = UIColor(red: 157.0/255.0, green: 220.0/255.0, blue: 243.0/255.0, alpha: 1.0).cgColor

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        btnRefNext.applyGradient(colors: [Constant.CustomAppColour.colorLeft, Constant.CustomAppColour.colorRight],
                                        locations: [0.0, 1.0],
                                        direction: .leftToRight)
        
        setupUITextField()
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        btnRefNext.roundCornersWithHalfRadius()
        viewContainer.roundCornersSpecific(corners: [.topLeft,.topRight], radius: 30.0)
     
        
    }
    
    
    func setupUITextField(){
        txtEmail.delegate = self
        
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
        NotificationCenter.default.addObserver(self, selector: #selector(ForgotPassword.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
          
        // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(ForgotPassword.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
            
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {

            // if keyboard size is not available for some reason, dont do anything
            return
          }

          var shouldMoveViewUp = false

          // if active text field is not nil
          if let activeTextField = activeTextField {

            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY;
            
            let topOfKeyboard = self.view.frame.height - keyboardSize.height

            // if the bottom of Textfield is below the top of keyboard, move up
            if bottomOfTextField > topOfKeyboard {
              shouldMoveViewUp = true
            }
          }

          if(shouldMoveViewUp) {
            self.view.frame.origin.y = 0 - keyboardSize.height
          }
    }

     @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin to zero
      self.view.frame.origin.y = 0
     }
    
    
    
    
    
    
      // when user select a textfield, this method will be called
      func textFieldDidBeginEditing(_ textField: UITextField) {
        // set the activeTextField to the selected textfield
        self.activeTextField = textField
      }
        
      // when user click 'done' or dismiss the keyboard
      func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
      }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
    
    

    @IBAction func nextPageButtonFun(_ sender: UIButton) {
        
        
        if (UITextField.validateAll(textFields: [txtEmail])) {
            
            if txtEmail.text!.isValidEmail{
                userEmailID = txtEmail.text ?? ""
                delegate?.forwardToNextPageFromForgetPassword(inputEmailID:userEmailID)
                
            }else{
            
                Alert.showAlert(on: self, with: Constant.AlertInfo.TITLE, message: "Enter a valid email address")
            }
            
            
            
        }else{
            Alert.showAlert(on: self, with: Constant.AlertInfo.TITLE, message: "Enter Email ID")
        }
        
       
        
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        if let touch = touches.first {
            
            if touch.view == outsideContentView {
                
                delegate?.dismissPopUpForgetPassword()
            }
           
               
            }
        
    }

}
