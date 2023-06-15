//
//  ProfileDetailsNewVC.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 13/06/23.
//

import UIKit
import iOSDropDown
import StripeCore
import StripePayments
import StripePaymentsUI
import StripeUICore
import StripePaymentSheet
import CreditCardForm

class ProfileDetailsNewVC: BaseViewController,STPPaymentCardTextFieldDelegate {

    @IBOutlet weak var viewSetting: UIView!
    @IBOutlet weak var txtDropDown: DropDown!
    @IBOutlet weak var btnUpdateProfile: UIButton!
    @IBOutlet weak var creditCardFormView: CreditCardFormView!
    @IBOutlet weak var viewCardMain: UIView!
    
    @IBOutlet weak var viewCamera: UIView!
    let paymentTextField = STPPaymentCardTextField()
    private var cardHolderNameTextField: UITextField!
    private var cardParams: STPPaymentMethodCardParams!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.btnUpdateProfile.layer.masksToBounds = true
        self.btnUpdateProfile.layer.cornerRadius = 25
        
        self.viewSetting.layer.masksToBounds = true
        self.viewSetting.layer.cornerRadius = 15
        
        self.viewCamera.layer.masksToBounds = true
        self.viewCamera.layer.cornerRadius = 15
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.btnUpdateProfile.applyGradient(colors: [Constant.CustomAppColour.colorLeft, Constant.CustomAppColour.colorRight],
                                            locations: [0.0, 1.0],
                                            direction: .leftToRight)
        
        let arrdropMenuText = ["Company(s)","Sub Users","Book Keeper(s)","Payment Receipt(s)","Log Out"]
        
        txtDropDown.optionArray = arrdropMenuText
        txtDropDown.checkMarkEnabled = false
        txtDropDown.arrowSize = 0
        txtDropDown.isSearchEnable = false
        txtDropDown.semanticContentAttribute = .forceRightToLeft
        txtDropDown.textColor = .white
        txtDropDown.didSelect { selectedText, index, id in
            print(selectedText)
            if selectedText == "Company(s)"{
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompanyListNewVC") as! CompanyListNewVC
                self.navigationController?.pushViewController(vc, animated: true)
            }else if selectedText == "Log Out"{
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        paymentTextField.postalCodeEntryEnabled = false
        createTextField()
    }
    
    func createTextField() {
        cardHolderNameTextField = UITextField(frame: CGRect(x: 15, y: 220, width: self.viewCardMain.frame.size.width - 30, height: 44))
        cardHolderNameTextField.placeholder = "CARD HOLDER"
        cardHolderNameTextField.delegate = self
        cardHolderNameTextField.translatesAutoresizingMaskIntoConstraints = false
        cardHolderNameTextField.setBottomBorder()
        cardHolderNameTextField.addTarget(self, action: #selector(ProfileDetailsNewVC.textFieldDidChange(_:)), for: .editingChanged)
        self.viewCardMain.addSubview(cardHolderNameTextField)
        
        paymentTextField.frame = CGRect(x: 15, y: 270, width: self.viewCardMain.frame.size.width - 30, height: 44)
        paymentTextField.delegate = self
        paymentTextField.translatesAutoresizingMaskIntoConstraints = false
        paymentTextField.borderWidth = 0
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: paymentTextField.frame.size.height - width, width:  paymentTextField.frame.size.width, height: paymentTextField.frame.size.height)
        border.borderWidth = width
        paymentTextField.layer.addSublayer(border)
        paymentTextField.layer.masksToBounds = true
        
        self.viewCardMain.addSubview(paymentTextField)
        
        NSLayoutConstraint.activate([
            cardHolderNameTextField.topAnchor.constraint(equalTo: self.creditCardFormView.bottomAnchor, constant: 20),
            cardHolderNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardHolderNameTextField.widthAnchor.constraint(equalToConstant: self.viewCardMain.frame.size.width-25),
            cardHolderNameTextField.heightAnchor.constraint(equalToConstant: 44)
        ])

        NSLayoutConstraint.activate([
            paymentTextField.topAnchor.constraint(equalTo: cardHolderNameTextField.bottomAnchor, constant: 20),
            paymentTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            paymentTextField.widthAnchor.constraint(equalToConstant: self.viewCardMain.frame.size.width-20),
            paymentTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        creditCardFormView.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: UInt(textField.expirationYear), expirationMonth: UInt(textField.expirationMonth), cvc: textField.cvc)
    }

    @objc func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
        creditCardFormView.paymentCardTextFieldDidEndEditingExpiration(expirationYear: UInt(textField.expirationYear))
    }

    @objc func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardFormView.paymentCardTextFieldDidBeginEditingCVC()
    }

    @objc func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardFormView.paymentCardTextFieldDidEndEditingCVC()
    }
}

extension ProfileDetailsNewVC: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        creditCardFormView.cardHolderString = textField.text!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == cardHolderNameTextField {
            textField.resignFirstResponder()
            paymentTextField.becomeFirstResponder()
        } else if textField == paymentTextField  {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = UITextField.BorderStyle.none
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,   width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

