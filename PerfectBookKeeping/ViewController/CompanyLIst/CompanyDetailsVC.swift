//
//  CompanyDetailsVC.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 13/06/23.
//

import UIKit
import iOSDropDown

class CompanyDetailsVC: BaseViewController {

    @IBOutlet weak var imgVwCompLogo: UIImageView!
    @IBOutlet weak var viewCompLogo: UIView!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var viewSettings: UIView!
    @IBOutlet weak var txtDropDown: DropDown!
    
    @IBOutlet weak var viewUploadReceipt: UIView!
    @IBOutlet weak var viewReceipt: UIView!
    @IBOutlet weak var viewsubUser: UIView!
    @IBOutlet weak var viewSetting: UIView!
    @IBOutlet weak var viewSubUploadReceipt: UIView!
    @IBOutlet weak var btnUploadReceipt: UIButton!
    @IBOutlet weak var viewsubReceipt: UIView!
    @IBOutlet weak var btnReceipt: UIButton!
    @IBOutlet weak var viewSubsubUser: UIView!
    @IBOutlet weak var btnSubUser: UIButton!
    @IBOutlet weak var viewSubSetting: UIView!
    @IBOutlet weak var btnSetting: UIButton!
    var strCompanyName: String? = ""
    var strCompanyLogo: String? = ""
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.viewSettings.layer.masksToBounds = true
        self.viewSettings.layer.cornerRadius = 15
        
        self.viewCompLogo.layer.masksToBounds = false
        self.viewCompLogo.layer.borderWidth = 5
        self.viewCompLogo.layer.borderColor = UIColor.lightGray.cgColor
        self.viewCompLogo.layer.cornerRadius = 5.0
        self.viewCompLogo.layer.shadowOffset = CGSize(width: -1, height: 2)
        self.viewCompLogo.layer.shadowRadius = 2
        self.viewCompLogo.layer.shadowOpacity = 0.2
        
        self.viewSubUploadReceipt.layer.masksToBounds = true
        self.viewSubUploadReceipt.layer.cornerRadius = 10
        self.btnUploadReceipt.layer.masksToBounds = true
        self.btnUploadReceipt.layer.cornerRadius = 25
        
        self.viewsubReceipt.layer.masksToBounds = true
        self.viewsubReceipt.layer.cornerRadius = 10
        self.btnReceipt.layer.masksToBounds = true
        self.btnReceipt.layer.cornerRadius = 25
        
        self.viewSubsubUser.layer.masksToBounds = true
        self.viewSubsubUser.layer.cornerRadius = 10
        self.btnSubUser.layer.masksToBounds = true
        self.btnSubUser.layer.cornerRadius = 25
        
        self.viewSubSetting.layer.masksToBounds = true
        self.viewSubSetting.layer.cornerRadius = 10
        self.btnSetting.layer.masksToBounds = true
        self.btnSetting.layer.cornerRadius = 25
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.lblCompanyName.text = self.strCompanyName
        
        let fullImageBase64String = self.strCompanyLogo?.components(separatedBy: "base64,")
        let imageBase64: String = fullImageBase64String?[1] ?? ""
        let dataDecoded : Data = Data(base64Encoded: imageBase64, options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)
        self.imgVwCompLogo.image = decodedimage
        
        let arrdropMenuText = ["Profile Details","Sub Users","Book Keeper(s)","Payment Receipt(s)","Log Out"]
        
        txtDropDown.optionArray = arrdropMenuText
        txtDropDown.checkMarkEnabled = false
        txtDropDown.arrowSize = 0
        txtDropDown.isSearchEnable = false
        txtDropDown.semanticContentAttribute = .forceRightToLeft
        txtDropDown.textColor = .white
        txtDropDown.didSelect { selectedText, index, id in
            print(selectedText)
            if selectedText == "Profile Details"{
                self.navigationController?.popViewController(animated: true)
            }else if selectedText == "Log Out"{
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    @IBAction func clickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnUploadReceiptFun(_ sender: UIButton) {
        //SelectDateVC
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectDateVC") as! SelectDateVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func showGalleryList(_ sender: UIButton) {
        //SelectDateVC
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GalleryListVC") as! GalleryListVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
