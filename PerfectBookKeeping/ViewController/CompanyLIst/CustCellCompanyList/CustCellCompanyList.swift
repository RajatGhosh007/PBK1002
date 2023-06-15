//
//  CustCellCompanyList.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 20/04/23.
//

import UIKit

class CustCellCompanyList: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCompanyData(companyaData: Company , atIndex:IndexPath ) {
       
        print("companyaData.name    is    \(String(describing: companyaData.name)) ")
        
        let name = companyaData.name ?? ""
       // lblName.text = companyaData.name
        lblName.text =   String(format:"%ld.   %@ ",(atIndex.row + 1),name)
        
    }
    
    
    
}
