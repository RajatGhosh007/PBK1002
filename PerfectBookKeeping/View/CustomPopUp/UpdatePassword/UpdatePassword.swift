//
//  UpdatePassword.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 27/04/23.
//

import UIKit


protocol UpadtePasswordDelegate: AnyObject {

    func updatePassword(emailInput:String ,passwordInput:String)
    func dismissPopUpUpdatePassword()
}

class UpdatePassword: UIViewController {

    weak var delegate: UpadtePasswordDelegate?
    @IBOutlet weak var outsideContentView: UIView!
    
    @IBOutlet weak var btnRefNext: UIButton!
    @IBOutlet weak var viewContainer: UIView!
    
    
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmPssword: UITextField!
    
    
    var newPasswordStr = ""
    var confirmPasswordStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // txtNewPassword.text = "123456"

        // Do any additional setup after loading the view.
        btnRefNext.applyGradient(colors: [Constant.CustomAppColour.colorLeft, Constant.CustomAppColour.colorRight],
                                        locations: [0.0, 1.0],
                                        direction: .leftToRight)
        
        
        
        txtNewPassword.attributedPlaceholder = NSAttributedString(string: "Enter New Password",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        txtConfirmPssword.attributedPlaceholder = NSAttributedString(string: "Enter Confirm Password",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        btnRefNext.roundCornersWithHalfRadius()
        viewContainer.roundCornersSpecific(corners: [.topLeft,.topRight], radius: 30.0)
     
        
    }

    
    @IBAction func updatePassWord(_ sender: UIButton) {
        
    
      
        
        if (UITextField.validateAll(textFields: [txtNewPassword])) {
            
            if txtNewPassword.text!.count >= 6{
                newPasswordStr = txtNewPassword.text!
                
                if (UITextField.validateAll(textFields: [txtConfirmPssword])) {
                    confirmPasswordStr = txtConfirmPssword.text!
                    
                    if (newPasswordStr == confirmPasswordStr){
                        
                        
                        delegate?.updatePassword(emailInput: newPasswordStr, passwordInput: txtNewPassword.text!)
                        
                    }else{
                        Alert.showAlert(on: self, with: Constant.AlertInfo.TITLE, message: "New Password and Confirm Password Should Be Same")
                    }
                    
                }else{
                    Alert.showAlert(on: self, with: Constant.AlertInfo.TITLE, message: "Enter Confirm Password")
                }
                
                
            }else{
                Alert.showAlert(on: self, with: Constant.AlertInfo.TITLE, message: "Password Should be minimum 6 Charecter")
            }
            
            
        }else{
            Alert.showAlert(on: self, with: Constant.AlertInfo.TITLE, message: "Enter New Password")
        }
        
        
        
        
       
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        if let touch = touches.first {
            
            if touch.view == outsideContentView {
                
                delegate?.dismissPopUpUpdatePassword()
            }
           
               
            }
        
    }

    

}

// MARKS : Text Field Delegate
extension UpdatePassword: UITextFieldDelegate {
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
       textField.resignFirstResponder()
       return true
    }

}

