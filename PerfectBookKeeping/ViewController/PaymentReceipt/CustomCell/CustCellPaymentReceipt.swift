//
//  CustCellPaymentReceipt.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 16/05/23.
//

import UIKit

class CustCellPaymentReceipt: UICollectionViewCell {
    
    @IBOutlet weak var lblTransID: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    @IBOutlet weak var viewContainer: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewContainer.roundCorners(radius: 5)
    }
    
    
    
    func setReceiptInfo(receiptInfo: ReceiptInfo , atIndex:IndexPath ) {
       
        
        let transID = receiptInfo.transaction_id ?? ""
       // lblName.text = companyaData.name
        lblTransID.text =   String(transID)
        
        let createDate = receiptInfo.createdAt ?? ""
        let amtVal = receiptInfo.amount ?? 0
        
        let createDateFormatted =  createDate.getFormattedDateFromString(inputFormatter: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z", outputFormatter: "d MMM yyyy")
        
        lblDate.text =   String(createDateFormatted)
        
        lblAmount.text =   String(format:"Amount : %d ", amtVal)
        
         
    }
    
    

}



/*
 
 
 May 16, 10:39 AM          MMM d, h:mm a
 
 
 */
