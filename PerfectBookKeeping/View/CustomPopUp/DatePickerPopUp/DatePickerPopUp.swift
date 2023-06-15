//
//  DatePickerPopUp.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 25/05/23.
//

import UIKit

protocol DatePickerPopUpDelegate : AnyObject {
    
  //  func forwardToNextPageFromForgetPassword(inputEmailID:String)
    func dismissPopUpViewDatePicker()
    func selectDateFromDatePicker(selctDate:String?)
}

class DatePickerPopUp: BaseViewController {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var outsideContentView: UIView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var delegate: DatePickerPopUpDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       viewContainer.roundCornersSpecific(corners: [.topLeft,.topRight], radius: 30.0)
       
    }
    
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        
        let date = sender.date
        
        print("   date is  ",date)
        
        let dateStr = date.getSelectDateInString(format:"dd-MM-yyyy") ?? ""
        print("   dateStr is  ",dateStr)
        delegate?.selectDateFromDatePicker(selctDate: dateStr)
    }

    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        if let touch = touches.first {
            
            if touch.view == outsideContentView {
                
                delegate?.dismissPopUpViewDatePicker()
            }
           
               
            }
        
    }

    

}
