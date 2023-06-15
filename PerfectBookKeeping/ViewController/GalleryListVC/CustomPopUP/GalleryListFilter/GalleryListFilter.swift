//
//  GalleryListFilter.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 25/05/23.
//

import UIKit

protocol GalleryListFilterDelegate : AnyObject {
    
  //  func forwardToNextPageFromForgetPassword(inputEmailID:String)
    func dismissPopUpViewFilerVC()
    func displayDatePicker()
    func applyFilter(fromDate:String,toDate:String)
}

class GalleryListFilter: BaseViewController {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var outsideContentView: UIView!
    @IBOutlet weak var viewFromDate: UIView!
    @IBOutlet weak var viewToDate: UIView!
    
    @IBOutlet weak var btnRefSubmit: UIButton!
    
    @IBOutlet weak var txtFormDate: UITextField!
    @IBOutlet weak var txtToDate: UITextField!
    //  DatePickerPopUp   custVwGalleryListSortBy
    
    var btnSelDateTag  = 0
    
    
    
    var custVwDatePickerPopUp = DatePickerPopUp()
    
    weak var delegate: GalleryListFilterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        btnRefSubmit.applyGradient(colors: [Constant.CustomAppColour.colorLeft, Constant.CustomAppColour.colorRight],
                                   locations: [0.0, 1.0],
                                   direction: .leftToRight)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewContainer.roundCornersSpecific(corners: [.topLeft,.topRight], radius: 30.0)
        viewFromDate.roundCornerWithCornerRadius(cornerRadius: 5,colorBorder: UIColor.gray, borderWidth:1)
        viewToDate.roundCornerWithCornerRadius(cornerRadius: 5,colorBorder: UIColor.gray, borderWidth:1)
        
        btnRefSubmit.roundCornersWithHalfRadius()
        
    }
    
    
    @IBAction func showFromDate(_ sender: UIButton) {
        // delegate?.displayDatePicker()
        btnSelDateTag = sender.tag
        showDatePickerPopUP()
    }
    
    
    func showDatePickerPopUP(){
        
        custVwDatePickerPopUp = DatePickerPopUp(nibName:"DatePickerPopUp", bundle: nil)
        custVwDatePickerPopUp.delegate = self
        
        custVwDatePickerPopUp.view.frame = self.view.bounds
        self.addChild(custVwDatePickerPopUp)
        self.view.addSubview(custVwDatePickerPopUp.view)
        
    }
    
    
    func dateComparsion(strFormDate:String,strToDate:String,formatType:String) -> Bool{
          
          let formatter = DateFormatter()
          formatter.dateFormat = formatType
          let formDate = formatter.date(from:strFormDate)
          let toDate = formatter.date(from: strToDate)

          if formDate?.compare(toDate!) == .orderedDescending {
              print("First Date is greater than second date")
              return false
          }
          return true
      }
    
    
    // MARK: Submit Functionality
    
    @IBAction func forwardToNextPage(_ sender: Any) {
        
        if((txtFormDate.text != "") && (txtToDate.text != "")){
            delegate?.applyFilter(fromDate:txtFormDate.text!,toDate:txtToDate.text!)
        }else if(txtFormDate.text != ""){
            //  if todate is not provide then current date is to date
            
            let dateStr = Date().getSelectDateInString(format:"d MMM yyyy") ?? ""
            print("   txtFormDate.text  ",txtFormDate.text!)
            print("   dateStr is  ",dateStr)
            
            delegate?.applyFilter(fromDate:txtFormDate.text!,toDate:dateStr)
        }else{
            delegate?.applyFilter(fromDate:"",toDate:"")
        }
        
        
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        if let touch = touches.first {
            
            if touch.view == outsideContentView {
                
                delegate?.dismissPopUpViewFilerVC()
            }
           
               
            }
        
    }


  

}

extension GalleryListFilter: DatePickerPopUpDelegate  {
    
    
    func dismissPopUpViewDatePicker(){
        
        custVwDatePickerPopUp.view.removeFromSuperview()
        custVwDatePickerPopUp.delegate = nil
        custVwDatePickerPopUp.removeFromParent()
    }
 
      
    
    func selectDateFromDatePicker(selctDate:String?){
        
        if(btnSelDateTag == 1001){
            let formatedDate = selctDate?.getFormattedDateFromString(inputFormatter: "dd-MM-yyyy", outputFormatter: "d MMM yyyy") ?? ""
            txtFormDate.text =  formatedDate
            
            if((txtFormDate.text != "") && (txtToDate.text != "")){
                let validDate =  dateComparsion(strFormDate:txtFormDate.text!, strToDate:txtToDate.text!, formatType:"d MMM yyyy")
                if(validDate == false){
                    txtToDate.text = ""
                    self.displayAlert(title:Constant.AlertInfo.TITLE, message:Constant.AlertInfo.TO_DATE_ERROR)
                }
            }else{
                //   Checking From Date is greater than form today
                  let todayStr = Date().getSelectDateInString(format:"d MMM yyyy") ?? ""
                print("   txtFormDate.text  ",txtFormDate.text!)
                print("   dateStr is  ",todayStr)
                
                let validDate =  dateComparsion(strFormDate:txtFormDate.text!, strToDate:todayStr, formatType:"d MMM yyyy")
                if(validDate == false){
                    txtFormDate.text = ""
                    self.displayAlert(title:Constant.AlertInfo.TITLE, message:Constant.AlertInfo.FORM_DATE_ERROR)
                }
            }
           
        }else{
            let formatedDate = selctDate?.getFormattedDateFromString(inputFormatter: "dd-MM-yyyy", outputFormatter: "d MMM yyyy") ?? ""
            txtToDate.text =  formatedDate
            
            if((txtFormDate.text != "") && (txtToDate.text != "")){
                let validDate =  dateComparsion(strFormDate:txtFormDate.text!, strToDate:txtToDate.text!, formatType:"d MMM yyyy")
                if(validDate == false){
                    txtToDate.text = ""
                    self.displayAlert(title:Constant.AlertInfo.TITLE, message:Constant.AlertInfo.TO_DATE_ERROR)
                }
            }
            
        }
        
        custVwDatePickerPopUp.view.removeFromSuperview()
        custVwDatePickerPopUp.delegate = nil
        custVwDatePickerPopUp.removeFromParent()
        
    }
    
}
