//
//  SelectCountryPopUp.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 08/05/23.
//

import UIKit
import CoreData


protocol SelectCountryDelegate: AnyObject {

    func selectCountry(selCountryInfo:AllCountryList)
    func selectState(selStateInfo:SateListStore)
}

class SelectCountryPopUp: UIViewController ,UITextFieldDelegate  {
    
    weak var delegate: SelectCountryDelegate?
    
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var lblHeader: UILabel!
    
    
    @IBOutlet weak var tblCountry: UITableView!
    
    @IBOutlet weak var viewContainer: UIView!
    
    
    //   var arrCountryList =  [CountryInfo]()
    var arrCountryList =  [AllCountryList]()
    
    var profileViewModel = ProfileDetailViewModel()
    var allCountryListViewModel = AllCountryListViewModel()
    var stateListViewModel = StateListViewModel()
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        txtSearch.delegate = self
        txtSearch.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        //     [txtSearch addTarget:self  action:@selector(textFieldDidChange:)  forControlEvents:UIControlEventEditingChanged];
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewContainer.roundCorners(radius:5)
     
    }
    
    private func setupUI() {
        
        //   self.tblCountry.register(CustCellCountryName.self, forCellReuseIdentifier: "CustCellCountryName")
        self.tblCountry.register(UINib(nibName: "CustCellCountryName", bundle: nil), forCellReuseIdentifier: "CustCellCountryName")
        self.tblCountry.delegate = self
        self.tblCountry.dataSource = self
        
    }
    
    
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        
        if(textField.tag == 1001)  {
             if(txtSearch.text?.isEmpty == true ){
                allCountryListViewModel.setInitialVal()
                
                DispatchQueue.main.async {
                    self.tblCountry.reloadData()
                    
                }
           }else{
                allCountryListViewModel.filterDataWithTxtInput(inputTxt: textField.text ?? "")
                DispatchQueue.main.async {
                    self.tblCountry.reloadData()
                    
                }
                
            }
            
        }else{
            if(txtSearch.text?.isEmpty == true ){
               stateListViewModel.setInitialVal()
               
               DispatchQueue.main.async {
                   self.tblCountry.reloadData()
                   
               }
          }else{
              stateListViewModel.filterDataWithTxtInput(inputTxt: textField.text ?? "")
               DispatchQueue.main.async {
                   self.tblCountry.reloadData()
                   
               }
               
           }
            
            
            
        }
        
    }
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}






extension SelectCountryPopUp: UITableViewDelegate ,UITableViewDataSource  {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(tableView.tag == 1001){
            return self.allCountryListViewModel.numberOrRows()
        }else{
            return self.stateListViewModel.numberOrRows()
        }
       
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if(tableView.tag == 1001){
            
            guard let cell = tblCountry.dequeueCell(withType: CustCellCountryName.self, for: indexPath) as? CustCellCountryName , let countryInfo = self.allCountryListViewModel.getCountry(index: indexPath.row) else {
                return UITableViewCell()
                
            }
            
         //   let countryInfo = self.arrCountryList[indexPath.row]
            
           print("countryInfo   is ",countryInfo)
        
        //   cell.setCountryInfoData(countryInfo: countryInfo, atIndex:indexPath)
            cell.setCountryInfoData(countryInfo: countryInfo, atIndex:indexPath)
           
            cell.selectionStyle = .none
            return cell
            
        }else{
            
            guard let cell = tblCountry.dequeueCell(withType: CustCellCountryName.self, for: indexPath) as? CustCellCountryName , let stateInfo = self.stateListViewModel.getState(index: indexPath.row) else {
                return UITableViewCell()
                
            }
           
           print("countryInfo   is ",stateInfo)
        
            cell.setStateInfoData(stateInfo:stateInfo , atIndex:indexPath)
            cell.selectionStyle = .none
          
            return cell
        }
        
        
        
        
        
        
    }
      
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40;//Choose your custom row height
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(tableView.tag == 1001){
            guard let selCountry = self.allCountryListViewModel.getCountry(index: indexPath.row) else { return }
            self.delegate?.selectCountry(selCountryInfo:selCountry)
        }else{
            guard let selState = self.stateListViewModel.getState(index: indexPath.row) else { return }
            self.delegate?.selectState(selStateInfo:selState)
        }
        
        //  func selectState(selStateInfo:SateListStore)
    //    dismiss(animated: false, completion: nil)
    }

}

