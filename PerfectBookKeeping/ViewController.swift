//
//  ViewController.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 17/04/23.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var btnRefLogin: UIButton!
    
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet  weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Enter your email address here",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Enter your password here",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        btnRefLogin.roundCorners(radius:5)
        
    }
}

extension ViewController: UITextFieldDelegate {
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
       textField.resignFirstResponder()
       return true
    }

}

