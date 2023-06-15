//
//  CustCellGalleryList.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 24/05/23.
//

import UIKit
import SDWebImage

class CustCellGalleryList: UITableViewCell {
    
    @IBOutlet weak var consHeightImgList: NSLayoutConstraint!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var collVwGalleryImg: UICollectionView!
    
   // var arrImgList = [[String:Any]]()
    
    var arrGalleryImageDisplay = [GallaryInfo]()
    
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupUI()
    }
    
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.async {
        
            self.consHeightImgList.constant = self.collVwGalleryImg.contentSize.height
        }
        
        
    }
    
    private func setupUI() {
        
        self.consHeightImgList.constant = 200
        self.collVwGalleryImg.register(UINib(nibName:"CustCellGalleryImg", bundle: nil), forCellWithReuseIdentifier:"CustCellGalleryImg")
        self.collVwGalleryImg.delegate = self
        self.collVwGalleryImg.dataSource = self
        
        
        
        /*
             //or if you use class:
              self.collectionView.register(CustCellGalleryList.self, forCellWithReuseIdentifier: cellIdentifier)
        */

        
     
    }
    
    
    
    func setGallerytInfo(galleryInfo:GalleryImageDisplay , atIndex:IndexPath ) {
        
        print("galleryInfo   : ",galleryInfo)
        
        let date = galleryInfo.keyName
        
        print("date   : ",date)
        
        
        let createDateFormatted =  date.getFormattedDateFromString(inputFormatter: "yyyy-MM-dd", outputFormatter: "d MMM yyyy")
        
        
        lblDate.text =   String(createDateFormatted)
        
        
        arrGalleryImageDisplay = galleryInfo.arrGalleryList
        
        print("date   : ",arrGalleryImageDisplay)
        
        
         
    }
  

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension CustCellGalleryList: UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout  {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrGalleryImageDisplay.count
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       guard let cell = collVwGalleryImg.dequeueReusableCell(withReuseIdentifier:"CustCellGalleryImg", for: indexPath) as? CustCellGalleryImg else { return UICollectionViewCell() }
        
        
      //  cell.imgGallery.image = UIImage(named:"receiptCellBG")
        
        let thumbnailURL = self.arrGalleryImageDisplay[indexPath.row].thumbnail ?? ""
        cell.imgGallery.sd_setImage(with: URL(string: thumbnailURL), placeholderImage: UIImage(named: "receiptCellBG"))
        
        /*
        
         let thumbnail = self.arrGalleryImageDisplay[indexPath.row].thumbnail ?? ""
         let imageData = Data(base64Encoded: thumbnail, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
         
         if let newImageData = imageData {
             cell.imgGallery.image = UIImage(data: newImageData)
         }else {
             print("Oops, invalid input format!")
             cell.imgGallery.image = UIImage(named:"receiptCellBG")
         }*/
        
       
        
        return cell
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
     //   let contentSize = (UIScreen.main.bounds.size.width - 40 - 20  ) * 0.5 - 5
        
        let contentSize = (self.collVwGalleryImg.frame.size.width - 20)/3
        
        
        return  CGSize(width: contentSize , height:contentSize)
  //      return  CGSize(width: 80 , height:80)
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        
        /*
         let receiptInfo = self.paymentReceiptViewModel.getReceiptInfo(index: indexPath.row)
         
         self.paymentReceiptViewModel.downloadImageFromURL(reciptInfo:receiptInfo)
         */
        
    }
    
}
