//
//  ProfileDetailsVC.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 20/04/23.
//

import UIKit




class ProfileDetailsVC: BaseViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate ,SelectCountryDelegate {
    
    var imageData = Data()
    var startUploadImg = false
    
    private var profileViewModel = ProfileDetailViewModel()
    
    private var allCountryViewModel = AllCountryListViewModel()
    private var stateListViewModel = StateListViewModel()
    
    private var userProfileViewModel = UserProfileViewModel()
    
    
    private var usertViewModel = UserViewModel()
    
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var viewPhotoIcon: UIView!
    
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var viewProfile: UIView!
    
    @IBOutlet weak var txtCountryName: UITextField!
    @IBOutlet weak var txtStateName: UITextField!
    
    
    @IBOutlet weak var imgDropDownState: UIImageView!
    @IBOutlet weak var btnDropDownState: UIButton!
    
    
    var selCountryPopUp =  SelectCountryPopUp()
    
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCompany: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    
   
    @IBOutlet weak var txtCardNumber: UITextField!
    @IBOutlet weak var txtNameOnCard: UITextField!
    @IBOutlet weak var txtExipryDate: UITextField!
    @IBOutlet weak var txtCVVCard: UITextField!
    
    
    @IBOutlet weak var txtAddress1: UITextField!
    @IBOutlet weak var txtAddress2: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtZipCode: UITextField!
    
    
    
    let cryptLib = CryptLib()
    let key = Constant.SECRET_KEY
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
        btnDropDownState.isHidden  = true
        imgDropDownState.isHidden  = true
        
        self.addSlideMenuButton()
        
        
      
        if (NetworkState().isInternetAvailable) {
            getProfileDetail()
            getCountryList()
        }else{
           self.displayAlert(title:Constant.AlertInfo.TITLE, message:Constant.AlertInfo.NO_NETWORK)
        }
  
        btnSubmit.applyGradient(colors: [Constant.CustomAppColour.colorLeft, Constant.CustomAppColour.colorRight],locations: [0.0, 1.0],direction: .leftToRight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        if(startUploadImg == true ){
       //     self.callUploadImageAPI(imageData: imageData)
            self.startUploadImg = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        btnSubmit.roundCorners(radius:5)
        
        viewProfile.roundCornersWithHalfRadius(colorBorder: UIColor.darkGray, borderWidth: 2.0)
        viewPhotoIcon.roundCornersWithHalfRadius(colorBorder: UIColor.lightGray, borderWidth: 1.0)
        
        imgProfile.roundCornersWithHalfRadius()
        
    }
    
    func demoData(){
         profileViewModel.getDemoDataList()
       
    }
    
    func getProfileDetail(){
        showLoader()
 
        let accessToken = UserDefaults.standard.string(forKey: "accessTokenKey")  ?? ""
        
        userProfileViewModel.delegate = self
        userProfileViewModel.getUserProfileDetailWithToken(token: accessToken, urlName: Constant.API_NAME.USERS_PROFILE, methodType:"GET") {[weak self] _, message, success in
            self?.hideLoader()
            
        } fail: {[weak self] (_, message, status) in
           self?.refreshAccessTokenAPI()
        }

        
    }
    
    
    func refreshAccessTokenAPI(){
        
        let refreshToken = UserDefaults.standard.string(forKey: "refreshTokenKey")  ?? ""
        let paramsForHome = [String:Any]()
        
        usertViewModel.getAccessTokenWithRefreshToken(ParamsInput: paramsForHome, token: refreshToken, urlName: Constant.API_NAME.REFRESH, methodType:"POST") { [weak self] _, success  in
            self?.getProfileDetail()
        } fail: { [weak self] _,_,_ in
            self?.hideLoader()
            self?.forwrdTOLogINPage()
        }

        
    }
    
    
    func forwrdTOLogINPage(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    
   
    
    
    func getCountryList() {
        
        allCountryViewModel.getCountryList(ParamsDict: ["filter": "countries"], Url: "http://rentmycargovan.com:3000/countryState", methodType: "get") { _, success in
            print("success ")
            if(success == true){
                self.getStateList()
            }
           
        }
        
        
       
    }
    
    func getStateList() {
        stateListViewModel.getStateList(ParamsDict: ["filter": "states"], Url: "http://rentmycargovan.com:3000/countryState", methodType: "get") { _, success in
            print("success ")
        }
        
    }
    
    func getCountryList1001() {
        
        profileViewModel.getCountryList(ParamsDict: ["filter": "countries"], Url: "http://rentmycargovan.com:3000/countryState", methodType: "get") { _, success in
            print("success ")
        }
      
    }
    
    
    // MARK: Country Selection  POP UP
    
    @IBAction func showCountryPopUP(_ sender: Any) {
        showCountryPopUp()
    }
    
    func showCountryPopUp(){
        
        selCountryPopUp = SelectCountryPopUp(nibName: "SelectCountryPopUp", bundle: nil)
        selCountryPopUp.delegate = self
        selCountryPopUp.modalPresentationStyle = UIModalPresentationStyle.currentContext
        selCountryPopUp.view.frame = self.view.bounds
      
        
        self.present(selCountryPopUp, animated: true, completion: nil)
        /*
        self.view.addSubview(selCountryPopUp.view)
        self.addChild(selCountryPopUp)
        selCountryPopUp.didMove(toParent:self)
        
        //self.view.bringSubviewToFront(selCountryPopUp.view)
        */
        
    
      //  selCountryPopUp.arrCountryList = Constant.ContryList.arrAllCountryList
        allCountryViewModel.countryAllList  =  Constant.ContryList.arrAllCountryList
        
        selCountryPopUp.tblCountry.tag = 1001
        selCountryPopUp.tblCountry.reloadData()
        selCountryPopUp.txtSearch.tag = 1001
        selCountryPopUp.lblHeader.text = "Select Country"
        
        
    }
    
    // MARK:  Delegate of Select Country Name
    
    func selectCountry(selCountryInfo:AllCountryList){
        
       print(" AllCountryList   is  ",selCountryInfo)
        txtCountryName.text = selCountryInfo.name ?? ""
        if(txtCountryName.text == "UNITED STATES"){
            btnDropDownState.isHidden = false
            imgDropDownState.isHidden = false
        }else{
            btnDropDownState.isHidden = true
            imgDropDownState.isHidden = true
        }
        dismiss(animated: false, completion: nil)
        
    }
    
    func selectState(selStateInfo: SateListStore) {
        print(" selStateInfo   is  ",selStateInfo)
        
        txtStateName.text = selStateInfo.state_name ?? ""
       
        dismiss(animated: false, completion: nil)
    }
    
    
    // MARK: State Selection  POP UP
    
    @IBAction func showStatePopUP(_ sender: Any) {
        showStatePopUp()
    }
    
    func showStatePopUp(){
        
        selCountryPopUp = SelectCountryPopUp(nibName: "SelectCountryPopUp", bundle: nil)
        selCountryPopUp.delegate = self
        selCountryPopUp.modalPresentationStyle = UIModalPresentationStyle.currentContext
        selCountryPopUp.view.frame = self.view.bounds
        
        self.present(selCountryPopUp, animated: true, completion: nil)
       
        stateListViewModel.stateListStore =  Constant.ContryList.stateListStore
        selCountryPopUp.tblCountry.tag = 1002
        selCountryPopUp.tblCountry.reloadData()
        selCountryPopUp.txtSearch.tag = 1002
        selCountryPopUp.lblHeader.text = "Select State"
        
        
    }
   
    
    
    
    
    // MARK:  Camera & Gallery Option
    
    @IBAction func addProfileImageFun(_ sender: UIButton) {
        showAlart()
        
    }
    
    func showAlart(){
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
              
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                  self.openCamera()
                }))

               alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                   self.openGallery()
               }))

               alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

               self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let pickedImage = info[.originalImage] as? UIImage {
            
            
            imgProfile.image  =   pickedImage
            imageData = pickedImage.jpegData(compressionQuality: 0.5) ?? Data()
            self.startUploadImg = true
           
           /*
            imageViewBackGround.contentMode = .scaleAspectFill
            imageView.sd_setImage(with: URL(string: uiimage), placeholderImage: UIImage(named: "https://dev8.ivantechnology.in/daleart/backend/uploads/products/1669899054446_Screenshot%202022-11-25%20at%201.20.29%20PM.png"))
           
            imageViewBackGround.image =  pickedImage
           */
        }
           
           
        DispatchQueue.main.async {
            picker.dismiss(animated: true, completion: nil)
        }
      
      self.callUploadImageAPI(imageData: imageData)
    }
    
    func callUploadImageAPI(imageData:Data?){
        
        guard let imageData = imageData else { return }
        
        let strBase64 = imageData.base64EncodedString(options:.lineLength64Characters)
        let paramDict = ["image":strBase64]
        let urlName = Constant.API_NAME.USERS
        let accessToken = UserDefaults.standard.string(forKey: "accessTokenKey")  ?? ""
        
        profileViewModel.uploadImageWithAccessToken(paramsInput: paramDict, token: accessToken, urlName: urlName, methodType:"PUT") { (_,message) in
            print(message)
            
        } fail: { _, _, _ in
            
        }

        
       
        
    }
    
    
    // MARK: Update Profile Submit API
    
    
    @IBAction func updateProfile(_ sender: UIButton) {
        
      
        if(UITextField.validateAll(textFields: [txtNameOnCard])) {
            if(UITextField.validateAll(textFields: [txtCardNumber])) {
                if(UITextField.validateAll(textFields: [txtExipryDate])) {
                    if(UITextField.validateAll(textFields: [txtCVVCard])) {
                        if(UITextField.validateAll(textFields: [txtCountryName])) {
                            if(UITextField.validateAll(textFields: [txtAddress1])) {
                                if(UITextField.validateAll(textFields: [txtCity])) {
                                    if(UITextField.validateAll(textFields: [txtStateName])) {
                                        if(UITextField.validateAll(textFields: [txtZipCode])) {
                                            if(UITextField.validateAll(textFields: [txtCompany])) {
                                                if(UITextField.validateAll(textFields: [phoneNumber])) {
                                                   if(phoneNumber.text!.count >= 10) {
                                                       if (NetworkState().isInternetAvailable) {
                                                           submitProfileAPI()
                                                       }else{
                                                        self.displayAlert(title:Constant.AlertInfo.TITLE, message:Constant.AlertInfo.NO_NETWORK)
                                                       }
                                                    
                                                    }else{
                                                        self.displayAlert(title:Constant.AlertInfo.TITLE, message:"Phone Number Should Be Minimum 10 Digits")
                                                    }
                                                
                                                }else{
                                                    self.displayAlert(title:Constant.AlertInfo.TITLE, message:"Please Enter Phone Number")
                                                }
                                            
                                            
                                            }else{
                                                self.displayAlert(title:Constant.AlertInfo.TITLE, message:"Please Enter Company Name")
                                            }
                                        
                                        
                                        }else{
                                            self.displayAlert(title:Constant.AlertInfo.TITLE, message:"Please Enter Zip Code")
                                        }
                                    
                                    
                                    }else{
                                        self.displayAlert(title:Constant.AlertInfo.TITLE, message:"Please Enter Your State")
                                    }
                                
                                
                                }else{
                                    self.displayAlert(title:Constant.AlertInfo.TITLE, message:"Please Enter Your City")
                                }
                          }else{
                                self.displayAlert(title:Constant.AlertInfo.TITLE, message:"Please Enter Your Address")
                            }
                         }else{
                            self.displayAlert(title:Constant.AlertInfo.TITLE, message:"Please Select Country Name")
                        }
                    
                    
                    }else{
                        self.displayAlert(title:Constant.AlertInfo.TITLE, message:"Card CVV Should Not Be Empty")
                    }
                
                
                }else{
                    self.displayAlert(title:Constant.AlertInfo.TITLE, message:"Card Expiry Date Should Not Be Empty")
                }
            
            
            }else{
                self.displayAlert(title:Constant.AlertInfo.TITLE, message:"Card Number Should Not Be Empty")
            }
        
        
        }else{
            self.displayAlert(title:Constant.AlertInfo.TITLE, message:"Name Should Not Be Empty")
        }
       
       
    }
    
    func submitProfileAPI(){
       
        
        let strCardNo =  txtCardNumber.text ?? ""
        let strExpDate =  txtExipryDate.text ?? ""
        let strCVV =  txtCVVCard.text ?? ""
        
      //  let strLame =  txtExipryDate.text ?? ""
        var firstName = ""
        var lastName = ""
        
        let fullName = txtNameOnCard.text ?? ""
           var components = fullName.components(separatedBy: " ")
        if components.count > 0 {
            firstName = components.removeFirst()
            lastName = components.joined(separator: " ")
            debugPrint(firstName)
            debugPrint(lastName)
        }
        
   
        
        
        let  cardNoCiper = cryptLib.encryptPlainTextRandomIV(withPlainText: strCardNo, key: key) ?? ""
        let  expDateCiper = cryptLib.encryptPlainTextRandomIV(withPlainText: strExpDate, key: key) ?? ""
        let  cvvCiper = cryptLib.encryptPlainTextRandomIV(withPlainText: strCVV, key: key) ?? ""
        let  fNameCiper = cryptLib.encryptPlainTextRandomIV(withPlainText: firstName, key: key) ?? ""
        let  lNameCiper = cryptLib.encryptPlainTextRandomIV(withPlainText: lastName, key: key) ?? ""
        
       
        
        let strCompanyName =  txtCompany.text ?? ""
        let strPhoneNo =  phoneNumber.text ?? ""
        let strAddress1 =  txtAddress1.text ?? ""
        let strAddress2 =  txtAddress2.text ?? ""
        let strCity =  txtCity.text ?? ""
        let strStateName =  txtStateName.text ?? ""
        let strCountryName =  txtCountryName.text ?? ""
        let strZipCode =  txtZipCode.text ?? ""
        
        
        
        
        let paramDict = [
            "user": ["company_name": strCompanyName, "phone":strPhoneNo],
            "address": ["address1": strAddress1, "address2":strAddress2,"city": strCity, "country": strCountryName, "state":strStateName, "zipcode":strZipCode],
            "card": ["card_number":cardNoCiper, "expiry":expDateCiper, "cvv":cvvCiper, "first_name":fNameCiper, "last_name": lNameCiper]
            
            
                          ]  as [String:Any]
        
        let accessToken = UserDefaults.standard.string(forKey: "accessTokenKey")  ?? ""
        
        
        profileViewModel.submitProfileDetailWithToken(paramsInput: paramDict, token: accessToken, urlName: Constant.API_NAME.USERS_PROFILE, methodType:"PUT") { [weak self](_,message) in
            DispatchQueue.main.async {
                self?.displayAlert(title:Constant.AlertInfo.TITLE, message: message)
            }
            self?.getProfileDetail()
        } fail: {[weak self] _,message, _ in
            DispatchQueue.main.async {
                self?.displayAlert(title:Constant.AlertInfo.TITLE, message: message)
            }
        }

        
        
        
    }
    
    
    
    func checkCardNumber(input: String) -> (type: CardType, formatted: String, valid: Bool) {
        // Get only numbers from the input string
    
        
        let numberOnly = input.replacingOccurrences(of: "[^0-9]", with: "", options: .literal, range: nil)
        
        
        
        var type: CardType = .Unknown
        var formatted = ""
        var valid = false
        
        // detect card type
        for card in CardType.allCards {
            if (matchesRegex(regex: card.regex, text: numberOnly)) {
                type = card
                break
            }
        }
        
        // check validity
        valid = luhnCheck(numberOnly)
        
        // format
        var formatted4 = ""
        for character in numberOnly {
            if formatted4.count == 4 {
                formatted += formatted4 + " "
                formatted4 = ""
            }
            formatted4.append(character)
        }
        
        formatted += formatted4 // the rest
        
        // return the tuple
        return (type, formatted, valid)
    }
    
    
    
    func matchesRegex(regex: String!, text: String!) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
            let nsString = text as NSString
            let match = regex.firstMatch(in: text, options: [], range: NSMakeRange(0, nsString.length))
            return (match != nil)
        } catch {
            return false
        }
    }


    func luhnCheck(_ number: String) -> Bool {
        var sum = 0
        let digitStrings = number.reversed().map { String($0) }

        for tuple in digitStrings.enumerated() {
            if let digit = Int(tuple.element) {
                let odd = tuple.offset % 2 == 1

                switch (odd, digit) {
                case (true, 9):
                    sum += 9
                case (true, 0...8):
                    sum += (digit * 2) % 9
                default:
                    sum += digit
                }
            } else {
                return false
            }
        }
        return sum % 10 == 0
    }
  

}

extension ProfileDetailsVC : UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension ProfileDetailsVC : UserProfileDataDelegate {
    func didRecieveDataUpdate(name:String,companyName:String,phone:String,base64Encode:String,cardModel:CardModel?,addressModel:AddressModel?) {
         print("Recive Data ",name)
        
        self.setCardDetailProfilePage(cardModel: cardModel)
        self.setAddressProfilePage(addressModel: addressModel)
        
          DispatchQueue.main.async {
              
           //   self.txtName.text = name
              self.txtCompany.text = companyName
              self.phoneNumber.text =  phone
              
            //  print("base64Encode  ",base64Encode)
              
              
              let imageData = Data(base64Encoded: base64Encode, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
              
              if let newImageData = imageData {
                  self.imgProfile.image = UIImage(data: newImageData)
              }else {
                  print("Oops, invalid input format!")
              }
              
            
              
          }
          
      }
    
    
    func setCardDetailProfilePage(cardModel:CardModel?){
        
        guard let cardModel = cardModel else { return }
        
        let carNumberRec =  cardModel.card_number ?? ""
        let expiryRec =  cardModel.expiry ?? ""
        let firstNameRec =  cardModel.first_name ?? ""
        let lastNameRec =  cardModel.last_name ?? ""
        let cvvRec =  cardModel.cvv ?? ""
       
       
 
        
        print("carNumberRec  \(carNumberRec)")

       let decryptedStringCardNumberRec = cryptLib.decryptCipherTextRandomIV(withCipherText: carNumberRec, key: key) ??  ""
       print("decryptedStrinCcardNumber  \(decryptedStringCardNumberRec as String)")
        
        let decryptedStringExpiryRec = cryptLib.decryptCipherTextRandomIV(withCipherText: expiryRec, key: key) ??  ""
        
        let decryptedStringFirstNameRec = cryptLib.decryptCipherTextRandomIV(withCipherText: firstNameRec, key: key) ??  ""
        
        let decryptedStringLastNameRec = cryptLib.decryptCipherTextRandomIV(withCipherText: lastNameRec, key: key) ??  ""
        let decryptedStringCVVRec = cryptLib.decryptCipherTextRandomIV(withCipherText: cvvRec, key: key) ??  ""
        
        
        
        DispatchQueue.main.async {
            
            self.txtCardNumber.text = decryptedStringCardNumberRec
            self.txtNameOnCard.text = String(format: "%@ %@", decryptedStringFirstNameRec,decryptedStringLastNameRec)
            self.txtCVVCard.text = decryptedStringCVVRec
            self.txtExipryDate.text = decryptedStringExpiryRec
           // self.txt.text = decryptedStringCardNumber
            
            
            
            
        }
     
        
    }
    
    
    func setAddressProfilePage(addressModel:AddressModel?){
        
        guard let addressModel = addressModel else { return }
        
       DispatchQueue.main.async {
            
           self.txtAddress1.text = addressModel.address1?.capitalized ?? ""
            self.txtAddress2.text = addressModel.address2 ?? ""
           self.txtCity.text = addressModel.city?.capitalized ?? ""
           self.txtStateName.text = addressModel.state?.capitalized ?? ""
           self.txtCountryName.text = addressModel.country?.capitalized ?? ""
            self.txtZipCode.text = addressModel.zipcode ?? ""
            
       }
        
    }
    
    
    
}

enum CardType: String {
    case Unknown, Amex, Visa, MasterCard, Diners, Discover, JCB, Elo, Hipercard, UnionPay

    static let allCards = [Amex, Visa, MasterCard, Diners, Discover, JCB, Elo, Hipercard, UnionPay]

    var regex : String {
        switch self {
        case .Amex:
           return "^3[47][0-9]{5,}$"
        case .Visa:
           return "^4[0-9]{6,}([0-9]{3})?$"
        case .MasterCard:
           return "^(5[1-5][0-9]{4}|677189)[0-9]{5,}$"
        case .Diners:
           return "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
        case .Discover:
           return "^6(?:011|5[0-9]{2})[0-9]{3,}$"
        case .JCB:
           return "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
        case .UnionPay:
           return "^(62|88)[0-9]{5,}$"
        case .Hipercard:
           return "^(606282|3841)[0-9]{5,}$"
        case .Elo:
           return "^((((636368)|(438935)|(504175)|(451416)|(636297))[0-9]{0,10})|((5067)|(4576)|(4011))[0-9]{0,12})$"
        default:
           return ""
        }
    }
}



