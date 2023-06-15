//
//  CustCellCountryName.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 09/05/23.
//

import UIKit

class CustCellCountryName: UITableViewCell {

    @IBOutlet weak var lblDisplay: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /*
    func setCountryInfoData(countryInfo: CountryInfo , atIndex:IndexPath ) {
       
        print("countryInfo.name    is    \(String(describing: countryInfo.name)) ")
        
       let name = countryInfo.name ?? ""
       
       lblDisplay.text =   String(format:"%ld.   %@ ",(atIndex.row + 1),name)
        
     
    }*/
    
    
    func setCountryInfoData(countryInfo: AllCountryList , atIndex:IndexPath ) {
       
        print("countryInfo.name    is    \(String(describing: countryInfo.name)) ")
        
       let name = countryInfo.name ?? ""
       
       lblDisplay.text =   String(format:"%ld.   %@ ",(atIndex.row + 1),name)
        
     
    }
    
    func setStateInfoData(stateInfo:SateListStore , atIndex:IndexPath ) {
       
        print("countryInfo.name    is    \(String(describing: stateInfo.state_name)) ")
        
       let name = stateInfo.state_name ?? ""
       lblDisplay.text =   String(format:"%ld.   %@ ",(atIndex.row + 1),name)
     
    }
    
}
