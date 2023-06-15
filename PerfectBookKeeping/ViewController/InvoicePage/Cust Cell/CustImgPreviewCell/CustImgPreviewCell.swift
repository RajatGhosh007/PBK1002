//
//  CustImgPreviewCell.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 09/06/23.
//

import UIKit

class CustImgPreviewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgPreview: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
   // self.contentView
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                //This block will be executed whenever the cell’s selection state is set to true (i.e For the selected cell)
                self.containerView.layer.borderColor = UIColor.black.cgColor
                self.containerView.layer.borderWidth = 2
            }
            else
            {
                //This block will be executed whenever the cell’s selection state is set to false (i.e For the rest of the cells)
                self.containerView.layer.borderColor = UIColor.clear.cgColor
                self.containerView.layer.borderWidth = 0
            }
         }
        
      }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func setCropImageInfoData(backGroundImgInfo: CropUploadImageList , atIndex:IndexPath ) {
       
     //   print("countryInfo.name    is    \(String(describing: backGroundImgInfo.snap_image)) ")
        
       let base64EncodeImg = backGroundImgInfo.snap_image ?? ""
        
        let imageData = Data(base64Encoded: base64EncodeImg, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
        
        if let newImageData = imageData {
            self.imgPreview.image = UIImage(data: newImageData)
        }else {
            print("Oops, invalid input format!")
        }
       
      
      //  imgDisplay.image = UIImage(named: strImgNmae)
     
    }

}
