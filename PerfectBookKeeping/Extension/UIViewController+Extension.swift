//
//  UIViewController+Extension.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 16/05/23.
//

import UIKit

extension UIViewController {
    
    func displayAlert(title: String,message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}


/*
 
 let alert = UIAlertController(title:titleStr, message: msgStr, preferredStyle: UIAlertController.Style.alert)
 alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
 self.present(alert, animated: true, completion: nil)
 */
