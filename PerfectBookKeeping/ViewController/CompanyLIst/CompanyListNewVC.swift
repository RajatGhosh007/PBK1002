//
//  CompanyListNewVC.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 12/06/23.
//

import UIKit
import iOSDropDown

class CompanyListNewVC: BaseViewController {

    @IBOutlet weak var viewSettings: UIView!
    @IBOutlet weak var scrollViewMain: UIScrollView!
    @IBOutlet weak var txtDropDown: DropDown!
    var arrCommanyList = [[String: Any]]()
    @IBOutlet weak var lblNoDataText: UILabel!
    private var usertViewModel = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.viewSettings.layer.masksToBounds = true
        self.viewSettings.layer.cornerRadius = 15
        
        let userType = UserDefaults.standard.string(forKey: "USERTYPE")
        print(userType as Any)
        
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
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileDetailsNewVC") as! ProfileDetailsNewVC
                self.navigationController?.pushViewController(vc, animated: true)
            }else if selectedText == "Log Out"{
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        if (NetworkState().isInternetAvailable) {
           pageLoadFun()
        }else{
            Alert.showAlert(on: self, with: Constant.AlertInfo.TITLE, message: Constant.AlertInfo.NO_NETWORK)
        }
    }
    
    func pageLoadFun(){
        let accessToken = UserDefaults.standard.string(forKey: "accessTokenKey")  ?? ""
        
        let paramsForHome = [String:Any]()
        self.showLoader()
        
        usertViewModel.getCompanyListWithAccessToken(ParamsInput: paramsForHome, token: accessToken, urlName:Constant.API_NAME.COMPANIES, methodType: "GET") { [weak self] _, success in
            
            if success {
                print("Succes  success ")
               DispatchQueue.main.async {
                   self?.hideLoader()
                   self?.lblNoDataText.isHidden = true
                   self?.scrollViewMain.isHidden = false
                   
                   self?.loadScrollView()
                }
            }
            else{
                DispatchQueue.main.async {
                    self?.hideLoader()
                    self?.lblNoDataText.isHidden = false
                    self?.scrollViewMain.isHidden = true
                 }
            }
        } fail: {[weak self] _,_,_ in
            self?.refreshAccessTokenAPI()
        }
    }
    
    func loadScrollView() {
        var viewHeight = 20
        var viewWidth = 20
        print(screenWidth)
        let subviewHeightWidth = (screenWidth - 60)/3
        
        let rowCount = self.usertViewModel.numberOrRows()
        for i in 0 ..< rowCount {
            let companyData = self.usertViewModel.getCompany(index: i)
            print(companyData?.name ?? "")
            
            let viewSubModule = UIView()
            viewSubModule.frame = CGRect(x: viewWidth, y: viewHeight, width: Int(subviewHeightWidth), height: Int(subviewHeightWidth))
            viewSubModule.backgroundColor = UIColor.clear
            viewSubModule.layer.masksToBounds = false
            viewSubModule.layer.borderWidth = 5
            viewSubModule.layer.borderColor = UIColor.lightGray.cgColor
            viewSubModule.layer.cornerRadius = 5.0
            viewSubModule.layer.shadowOffset = CGSize(width: -1, height: 2)
            viewSubModule.layer.shadowRadius = 2
            viewSubModule.layer.shadowOpacity = 0.2
            scrollViewMain.addSubview(viewSubModule)
            
            let strBase64 = companyData?.logo ?? ""
            let fullImageBase64String = strBase64.components(separatedBy: "base64,")
            let imageBase64: String = fullImageBase64String[1]
            
            let dataDecoded : Data = Data(base64Encoded: imageBase64, options: .ignoreUnknownCharacters)!
            let decodedimage = UIImage(data: dataDecoded)
            
            let imageCompIcon = UIImageView()
            imageCompIcon.frame = CGRect(x: 20, y: 10, width: Int(viewSubModule.bounds.size.width-40), height: Int(viewSubModule.bounds.size.width-40))
            imageCompIcon.image = decodedimage
            viewSubModule.addSubview(imageCompIcon)
            
            let lblCompanyName = UILabel()
            lblCompanyName.frame = CGRect(x: 5, y: Int(viewSubModule.bounds.size.width-40)+15, width: Int(viewSubModule.bounds.size.width-10), height: 15)
            lblCompanyName.text = companyData?.name ?? ""
            lblCompanyName.textAlignment = .center
            lblCompanyName.textColor = UIColor.black
            lblCompanyName.font = UIFont(name: "Poppins-Regular", size: 9.0)
            viewSubModule.addSubview(lblCompanyName)
            
            let btnCompanyDetails = UIButton(type: .custom)
            btnCompanyDetails.frame = CGRect(x: 0, y: 0, width: viewSubModule.bounds.size.width, height: viewSubModule.bounds.size.height)
            btnCompanyDetails.addTarget(self, action: #selector(clickCompanyDetails(_:)), for: .touchUpInside)
            btnCompanyDetails.tag = i
            viewSubModule.addSubview(btnCompanyDetails)
            
            viewWidth = viewWidth + Int(subviewHeightWidth) + 10
            
            if (Int(viewWidth) + Int(subviewHeightWidth))>Int(screenWidth) {
                viewWidth = 20
                viewHeight = viewHeight + 120
            }
        }
        
        scrollViewMain.contentSize = CGSize(width: 0, height: viewHeight)
    }
    
    @objc func clickCompanyDetails(_ sender: UIButton) {
        let companyData = self.usertViewModel.getCompany(index: sender.tag)
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompanyDetailsVC") as! CompanyDetailsVC
        vc.strCompanyName = companyData?.name ?? ""
        vc.strCompanyLogo = companyData?.logo ?? ""
        Constant.APPStaticData.selectCompanyID =  companyData?.id ?? 0
       
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func refreshAccessTokenAPI(){
        let refreshToken = UserDefaults.standard.string(forKey: "refreshTokenKey")  ?? ""
        let paramsForHome = [String:Any]()
        
        usertViewModel.getAccessTokenWithRefreshToken(ParamsInput: paramsForHome, token: refreshToken, urlName: Constant.API_NAME.REFRESH, methodType:"POST") { [weak self] _, success  in
            self?.pageLoadFun()
        }fail: { [weak self] _,_,_ in
            self?.hideLoader()
            self?.forwrdTOLogINPage()
        }
    }
    
    func forwrdTOLogINPage(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
