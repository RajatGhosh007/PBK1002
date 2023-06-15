//
//  CustCropImgCell.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 08/06/23.
//

import UIKit

class CustCropImgCell: UICollectionViewCell {
    
    @IBOutlet weak var imgDisplay: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func draw(_ rect: CGRect) {
        
        /*
        let tapRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(didTapImageView))
        imgDisplay.addGestureRecognizer(tapRecognizer)
        */
    }
    
    @objc public func didTapImageView() {
        /*
        // When tapping the image view, restore the image to the previous cropping state
        let cropViewController = CropViewController(croppingStyle: self.croppingStyle, image: self.imagePicked!)
       
        
        cropViewController.delegate = self
        let viewFrame = view.convert(imageDisplayView.frame, to: navigationController!.view)
        
        
        
        cropViewController.presentAnimatedFrom(self,
                                               fromImage: self.imageDisplayView.image,
                                               fromView: nil,
                                               fromFrame: viewFrame,
                                               angle: self.croppedAngle,
                                               toImageFrame: self.croppedRect,
                                               setup: { self.imageDisplayView.isHidden = true },
                                               completion: nil)
        */
      
    }
   
    
    func setCropImageInfoData(backGroundImgInfo: CropUploadImageList , atIndex:IndexPath ) {
       
    //    print("countryInfo.name    is    \(String(describing: backGroundImgInfo.snap_image)) ")
        
       let base64EncodeImg = backGroundImgInfo.snap_image ?? ""
        
        let imageData = Data(base64Encoded: base64EncodeImg, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
        
        if let newImageData = imageData {
            self.imgDisplay.image = UIImage(data: newImageData)
        }else {
            print("Oops, invalid input format!")
        }
       
      
      //  imgDisplay.image = UIImage(named: strImgNmae)
     
    }

}
