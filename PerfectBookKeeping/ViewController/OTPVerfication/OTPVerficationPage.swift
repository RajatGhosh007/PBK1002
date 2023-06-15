//
//  OTPVerficationPage.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 25/04/23.
//

import UIKit
import SVPinView

class OTPVerficationPage: UIViewController {
    
    @IBOutlet weak var pinView: SVPinView!
    
    
    enum SVPinViewStyle : Int {
        case none = 0
        case underline
        case box
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configurePinView()
        
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
          
        
        
        
    }

}
