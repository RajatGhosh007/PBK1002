//
//  InvoicePageVC.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 07/06/23.
//

import UIKit

import CoreData

import CropViewController
import Photos



import CoreImage
import AVKit

class InvoicePageVC: BaseViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
 
    var isImageAdded = false
    var isImageRetake  = false
    var isModifyCrop  = false
    var isBlackWhite  = false
    
    @IBOutlet weak var contentView: UIView!

    
    @IBOutlet weak var collImgSlider: UICollectionView!
    @IBOutlet weak var collImgPreview: UICollectionView!
    
    var selIndex = 0
    
    var imagePicked: UIImage?
    
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    
    var invoiceViewModel = InvoiceViewModel()
    
    
    @IBOutlet weak var imgBlackWhite: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        fetchImageListFromCoreData()
        /*
        imageDisplayView.image = imagePicked
        let tapRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(didTapImageView))
        imageDisplayView.addGestureRecognizer(tapRecognizer)
         
         */
    }
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutImageView()
    }
    
    public func layoutImageView() {
        
       /*
        self.imageDisplayView.contentMode = .scaleAspectFit
        self.imageDisplayView.layer.masksToBounds = true
        self.imageDisplayView.clipsToBounds = true
      */
    }
    
    private func setupUI() {
        
        
        self.collImgSlider.register(UINib(nibName:"CustCropImgCell", bundle: nil), forCellWithReuseIdentifier:"CustCropImgCell")
        self.collImgSlider.delegate = self
        self.collImgSlider.dataSource = self
        
        
   //     collImgPreview
        
        self.collImgPreview.register(UINib(nibName:"CustImgPreviewCell", bundle: nil), forCellWithReuseIdentifier:"CustImgPreviewCell")
        self.collImgPreview.delegate = self
        self.collImgPreview.dataSource = self
        
        
        
        /*
             //or if you use class:
              self.collectionView.register(CustCellGalleryList.self, forCellWithReuseIdentifier: cellIdentifier)
        */

        
     
    }
    
    func fetchImageListFromCoreData(){
       
        invoiceViewModel.fetchCropImageList(success: {[weak self] reloadData in
            
            if(reloadData){
               DispatchQueue.main.async {
                  self?.collImgSlider.reloadData()
                   self?.collImgPreview.reloadData()
                   
                   //  In Case New Image Addition Scroll to First Index
                   if(self?.isImageAdded == true){
                       self?.isImageAdded = false
                       
                       self?.collImgSlider.scrollToItem(at:IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
                       self?.collImgPreview.scrollToItem(at:IndexPath(item:0, section: 0), at: .centeredHorizontally, animated: false)
                   }
               }
            }
            
        })
      
    }
    
    func fetchImageListFromCoreData1002(){
       
        invoiceViewModel.fetchCropImageList(success: {[weak self] reloadData in
            
            if(reloadData){
               DispatchQueue.main.async {
                  self?.collImgSlider.reloadData()
                   let indexNumber =  self?.invoiceViewModel.numberOrRows()
                   guard var indexNumber = indexNumber else { return }
                   if(indexNumber > 1){
                       indexNumber = indexNumber - 1
                       self?.collImgSlider.scrollToItem(at:IndexPath(item: indexNumber, section: 0), at: .centeredHorizontally, animated: false)
                       self?.collImgPreview.scrollToItem(at:IndexPath(item: indexNumber, section: 0), at: .centeredHorizontally, animated: false)
                   }
                }
            }
            
        })
      
    }
    
    
    
    func updateImageSliderSeletedCell(indexNumber:Int){
        
        DispatchQueue.main.async {
        self.collImgPreview.scrollToItem(at:IndexPath(item: indexNumber, section: 0), at: .centeredHorizontally, animated: true)
      self.collImgPreview.selectItem(at: IndexPath(row: indexNumber, section: 0), animated: true, scrollPosition: .centeredHorizontally)
         
        }
        
        
    }
    
    func displaySelectedCropImage(indexNumber:Int){
        
        DispatchQueue.main.async {
            self.collImgSlider.scrollToItem(at:IndexPath(item: indexNumber, section: 0), at:.centeredHorizontally, animated: false)
         
        }
        
        
    }
    
    
    
    func updateImageSliderSeletedCell1001(indexPath:IndexPath){
        
        DispatchQueue.main.async {
        //self?.collImgPreview.scrollToItem(at:IndexPath(item: indexNumber, section: 0), at: .right, animated: false)
         //   self.collImgPreview.scrollToItem(at:indexPath, at: .left, animated:false)
            self.collImgPreview.scrollToItem(at:indexPath, at:.centeredHorizontally,animated:false)
        }
        
        
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
    
    //
    
    // MARK: - Save Crop Image Into Core Data
    
    /**
          Save New  Crop Image To Core Data
     */
    
    func saveDataIntoCoreData(_ image:UIImage){
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let imageObj  =   CropUploadImageList(context: managedContext)
        
        
        
        //
        let uuid = UUID().uuidString
        
        imageObj.imageID = uuid
        
        imageObj.file_name = ""
        imageObj.file_path = ""
        imageObj.mime_type = ""
        imageObj.title = "Perfiect BookKeeping"
        imageObj.file_date = Constant.APPStaticData.selectDateUploadReceipt
        
        imageObj.company_id = String(format:"%d",Constant.APPStaticData.selectCompanyID)
        
        
        imageObj.bw_status = false
        imageObj.upload_status = false
        imageObj.for_upload = false
        
        
        let imageData = image.jpegData(compressionQuality: 0.5) ?? Data()
        let strBase64SnapImg = imageData.base64EncodedString(options:.lineLength64Characters)
        
        
        imageObj.snap_image = strBase64SnapImg
        imageObj.temp_snap_image = strBase64SnapImg
        
        do {
            try managedContext.save()
            debugPrint("Data saved")
            self.fetchImageListFromCoreData()
            
        } catch let error as NSError {
            debugPrint(error)
        }
        
        
    }
    
    /**
               Update Crop Image Into Core Data When Retake And Modify Crop
     */
    
    
    func updateCropImageIntoCoreData(image:UIImage) {
        
        guard  let cropImgInfo = self.invoiceViewModel.getCropImg(index:selIndex) else{return}
        
         let imageID = cropImgInfo.imageID ?? ""
        
      
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
              let managedContext = appDelegate.persistentContainer.viewContext
              let  fetchRequest = NSFetchRequest<CropUploadImageList>(entityName: "CropUploadImageList")
                   fetchRequest.predicate = NSPredicate(format: "imageID = %@", imageID)
                   fetchRequest.returnsObjectsAsFaults = false
              do {
                   let product = try managedContext.fetch(fetchRequest)
                  debugPrint("load values")
                 // cropImgList = product
                  if(product.count > 0){
                      let productObj  =   product[0]
                      
                      let imageData = image.jpegData(compressionQuality: 0.5) ?? Data()
                      let strBase64SnapImg = imageData.base64EncodedString(options:.lineLength64Characters)
                      
                      productObj.setValue(strBase64SnapImg, forKey:"snap_image")
                      productObj.setValue(strBase64SnapImg, forKey:"temp_snap_image")
                      
                      
                      do {
                          try managedContext.save()
                          debugPrint("Data saved")
                          self.fetchImageListFromCoreData()
                          
                      } catch let error as NSError {
                          debugPrint(error)
                      }
                    
                  }
                 
                  
                  
              } catch let error as NSError {
                  debugPrint(error)
                  
                  
              }
       
        
    }
    /**
          Save  Black White Image Into Core Data
     */
    
    func updateIntoCoreDataWithBlackWhiteImg(image:UIImage,imageID:String) {
       guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
              let managedContext = appDelegate.persistentContainer.viewContext
              let  fetchRequest = NSFetchRequest<CropUploadImageList>(entityName: "CropUploadImageList")
                   fetchRequest.predicate = NSPredicate(format: "imageID = %@", imageID)
                   fetchRequest.returnsObjectsAsFaults = false
              do {
                   let product = try managedContext.fetch(fetchRequest)
                  debugPrint("load values")
                 // cropImgList = product
                  if(product.count > 0){
                      let productObj  =   product[0]
                      
                      let imageData = image.jpegData(compressionQuality: 0.5) ?? Data()
                      let strBase64SnapImg = imageData.base64EncodedString(options:.lineLength64Characters)
                      
                      productObj.setValue(strBase64SnapImg, forKey:"snap_image")
                      productObj.setValue(true, forKey:"bw_status")
                      
                      
                      do {
                          try managedContext.save()
                          debugPrint("Data saved")
                          self.fetchImageListFromCoreData()
                          
                      } catch let error as NSError {
                          debugPrint(error)
                      }
                    
                  }
                 
                  
                  
              } catch let error as NSError {
                  debugPrint(error)
                  
                  
              }
       
        
    }
    
    
    /**
          Revert Back Black White Image To Original Image And Save Into Core Data
     */
    
    func updateIntoCoreDataRevertBlackWhiteToOriginalImg(snapImgBase64:String,imageID:String) {
        
      
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
              let managedContext = appDelegate.persistentContainer.viewContext
              let  fetchRequest = NSFetchRequest<CropUploadImageList>(entityName: "CropUploadImageList")
                   fetchRequest.predicate = NSPredicate(format: "imageID = %@", imageID)
                   fetchRequest.returnsObjectsAsFaults = false
              do {
                   let product = try managedContext.fetch(fetchRequest)
                  debugPrint("load values")
                 // cropImgList = product
                  if(product.count > 0){
                      let productObj  =   product[0]
                      
                      productObj.setValue(snapImgBase64, forKey:"snap_image")
                      productObj.setValue(false, forKey:"bw_status")
                      
                      
                      do {
                          try managedContext.save()
                          debugPrint("Data saved")
                          self.fetchImageListFromCoreData()
                          
                      } catch let error as NSError {
                          debugPrint(error)
                      }
                    
                  }
                 
                  
                  
              } catch let error as NSError {
                  debugPrint(error)
                  
                  
              }
       
        
        
    }
    
   
    
    
    @IBAction func addNewImageFun(_ sender: Any) {
        isImageAdded = true
        openCamera()
    }
    
    
    @IBAction func retakeImageFun(_ sender: Any) {
       isImageRetake = true
        openCamera()
    }
    
    @IBAction func modifyCropImage(_ sender: Any) {
        isModifyCrop = true
        modifyCropImage()
    }
    
    @IBAction func transferBlackWhiteImg(_ sender: Any) {
        isBlackWhite = true
        transIntolBackWhiteImg()
    }
    
    @IBAction func uploadAPIFiles(_ sender: Any) {
        showLoader()
        let accessToken = UserDefaults.standard.string(forKey: "accessTokenKey")  ?? ""
        let urlName = Constant.API_NAME.FILES_UPLOADS
        
        invoiceViewModel.uploadFileAPI(token: accessToken, urlName: urlName, methodType:"POST") {( _,message, success) in
            self.hideLoader()
            if(success){
                
            }else{
                
            }
            
        } fail: { (_, message, fail) in
            print("Error")
            self.hideLoader()
        }

    
    }

    // MARK: Camera Functionality
   
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
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let imagePicked = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        
        let cropController = CropViewController(croppingStyle: croppingStyle, image:imagePicked)
        cropController.delegate = self
        
        cropController.rotateButtonsHidden = true
        cropController.rotateClockwiseButtonHidden = true
        cropController.doneButtonColor =  UIColor.white
        cropController.cancelButtonColor =  UIColor.white
        cropController.resetButtonHidden = true
       
        cropController.toolbar.clampButton.isHidden = false
        
        
        
        DispatchQueue.main.async {
            picker.dismiss(animated: true, completion:{
               
                self.present(cropController, animated: true, completion:{
                    //self.hideSpinnerAnother()
                })
            })
            
        }
        
    }
    
    
    func modifyCropImage(){
        
        guard let imagePicked = self.invoiceViewModel.fetchSelectedCropImg(index:selIndex) else{return}
        
        let cropController = CropViewController(croppingStyle: croppingStyle, image:imagePicked)
        cropController.delegate = self
        
        cropController.rotateButtonsHidden = true
        cropController.rotateClockwiseButtonHidden = true
        cropController.doneButtonColor =  UIColor.white
        cropController.cancelButtonColor =  UIColor.white
        cropController.resetButtonHidden = true
       
        cropController.toolbar.clampButton.isHidden = false
        
        
        
        DispatchQueue.main.async {
            self.present(cropController, animated: true, completion:{
                //self.hideSpinnerAnother()
            })
            
           
            
        }
        
      
    }
    
    
    func transIntolBackWhiteImg(){
        
        guard  let cropImgInfo = self.invoiceViewModel.getCropImg(index:selIndex) else{return}
        
         let imageID = cropImgInfo.imageID ?? ""
        
        let bwStatus = cropImgInfo.bw_status
        
        if(bwStatus == true){
           let base64EncodeImg = cropImgInfo.temp_snap_image ?? ""
            updateIntoCoreDataRevertBlackWhiteToOriginalImg(snapImgBase64:base64EncodeImg,imageID:imageID)
            
        }else{
            
            guard let imagePicked = self.invoiceViewModel.fetchSelectedCropImg(index:selIndex) else{return}
            
            
            guard let currentCGImage = imagePicked.cgImage else { return }
            let currentCIImage = CIImage(cgImage: currentCGImage)
            /*
            let corrected = currentCIImage.colorMatrix(
                                      column0: CIVector(x:0.0, y: 0.0, z: 1, w: 0),
                                      column1: CIVector(x: 0.0, y: 0.0, z: 1, w: 0),
                                      column2: CIVector(x:  0.0, y:  0.0, z:1, w: 0),
                                      column3: CIVector(x: 0, y: 0, z: 0, w: 1)
                                      )
            */
           // let ratio = (85.0/255.0)
           // let bRatio = -(140.0/255.0)
            let ratio = (85.0)
            let bRatio = -(50.0)
            
            let corrected = currentCIImage.colorMatrix(
                                      column0: CIVector(x:ratio, y: ratio, z: ratio, w: 0),
                                      column1: CIVector(x:ratio, y: ratio, z: ratio, w: 0),
                                      column2: CIVector(x:ratio, y: ratio, z: ratio, w: 0),
                                      column3: CIVector(x: 0, y: 0, z: 0, w: 1),
                                      biasVec: CIVector(x: bRatio, y: bRatio, z: bRatio, w: 0)
                                      )
            
            let imageBlackWhite = UIImage(ciImage: corrected)
            updateIntoCoreDataWithBlackWhiteImg(image: imageBlackWhite,imageID: imageID)
            
        }
    
        
    }
    
   
    
    
    @IBAction func clickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}


extension InvoicePageVC: CropViewControllerDelegate  {
    
    // MARK: - Crop Image Delegate -
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    
    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        
        //   showSpinnerAnother()
        //  cropViewController.dismiss(animated: true, completion: nil)
        
        cropViewController.dismiss(animated: true, completion: {
            
            // self.hideSpinnerAnother()
        })
      
     
        
        if((isImageRetake)||(isModifyCrop)){
            isImageRetake = false
            isModifyCrop = false
            updateCropImageIntoCoreData(image: image)
        }
        if(isImageAdded){
          //  isImageAdded = false
            saveDataIntoCoreData(image)
        }
       
        
    }
    
  
}


extension InvoicePageVC: UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout  {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.invoiceViewModel.numberOrRows()
      //  return 6
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(collectionView.tag == 1001){
            
            guard let cell = collImgSlider.dequeueReusableCell(withReuseIdentifier:"CustCropImgCell", for: indexPath) as? CustCropImgCell ,let cropImgInfo = self.invoiceViewModel.getCropImg(index: indexPath.row) else { return UICollectionViewCell() }
            
            
            cell.setCropImageInfoData(backGroundImgInfo: cropImgInfo, atIndex: indexPath)
            
            return cell
            
        }else{
            
            guard let cell = collImgPreview.dequeueReusableCell(withReuseIdentifier:"CustImgPreviewCell", for: indexPath) as? CustImgPreviewCell ,let cropImgInfo = self.invoiceViewModel.getCropImg(index: indexPath.row) else { return UICollectionViewCell() }
            cell.setCropImageInfoData(backGroundImgInfo: cropImgInfo, atIndex: indexPath)
            
            return cell
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if(collectionView.tag == 1001){
            
           let contentSizeWidth = UIScreen.main.bounds.size.width
           let contentSizeHeight = collImgSlider.bounds.size.height
            
           return  CGSize(width:contentSizeWidth , height:contentSizeHeight)
            
        }else{
               return  CGSize(width:92,height:92)
        }
        
      
       
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        print("did select ")
        if(collectionView.tag == 1002){
            let visibleIndex = indexPath.row
            self.displaySelectedCropImage(indexNumber:visibleIndex)
            
        }
        
        if(collectionView.tag == 1001){
            
        }
        
        guard  let cropImgInfo = self.invoiceViewModel.getCropImg(index: indexPath.row) else{return}
        selIndex = indexPath.row
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if(collectionView.tag == 1002){
            
             
            
            let   CellWidth = 92
            let   CellCount =  self.invoiceViewModel.numberOrRows()
            let   CellSpacing = 10
            let   collectionViewWidth =  self.collImgPreview.frame.size.width
            
            let totalCellWidth = CellWidth * CellCount
            let totalSpacingWidth = CellSpacing * (CellCount - 1)
            
         //   let leftInset = (collectionViewWidth - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
            let leftInset = max(0, (collectionViewWidth - CGFloat(totalCellWidth + totalSpacingWidth)) / 2.0)
            let rightInset = leftInset
            
            return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
          
        }else{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
      if(collectionView.tag == 1001){
          let visibleIndex = indexPath.row
          let visibleSection = indexPath.section
         //   print("Currently visible cell is \(self.collectionView.indexPathsForVisibleItems)")
          
          print("End End cell is  visibleIndex  \(visibleIndex)")
          print("End End cell is  visibleSection \(visibleSection)")
    
        }
        
        
        
        
      }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if(collectionView.tag == 1001){
            let visibleIndex = indexPath.row
            let visibleSection = indexPath.section
            selIndex =  visibleIndex
            self.updateImageSliderSeletedCell(indexNumber:visibleIndex)
          
         
            print(" will diplay visibleIndex cell is \(visibleIndex)")
            print(" will diplay visibleSection cell is \(visibleSection)")
          }
    }
    
    
    /*
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
        if(collectionView.tag == 1002){
            guard let cell = collImgPreview.dequeueReusableCell(withReuseIdentifier:"CustImgPreviewCell", for: indexPath) as? CustImgPreviewCell else{return}
            cell.containerView.layer.borderColor = UIColor.black.cgColor
        }
       
    }


    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if(collectionView.tag == 1002){
            guard let cell = collImgPreview.dequeueReusableCell(withReuseIdentifier:"CustImgPreviewCell", for: indexPath) as? CustImgPreviewCell else{return}
            cell.containerView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    */
    
    
}


extension CIFilter {
    func colorMatrix(column0: CIVector,
                     column1: CIVector,
                     column2: CIVector,
                     column3: CIVector) -> CIFilter {
        return CIFilter(name: "CIColorMatrix", parameters: [
                              "inputRVector" : column0,
                              "inputGVector" : column1,
                              "inputBVector" : column2,
                              "inputAVector" : column3 ])!
    }
}


extension CIImage {
    
    
    func colorMatrix(column0: CIVector,
                     column1: CIVector,
                     column2: CIVector,
                     column3: CIVector,
                     biasVec: CIVector) -> CIImage {
        return applyingFilter("CIColorMatrix", parameters: [
                              "inputRVector" : column0,
                              "inputGVector" : column1,
                              "inputBVector" : column2,
                              "inputAVector" : column3,
                             "inputBiasVector" : biasVec ])
    }
    
    
    /*
    func colorMatrix(column0: CIVector,
                     column1: CIVector,
                     column2: CIVector,
                     column3: CIVector
                     ) -> CIImage {
        return applyingFilter("CIColorMatrix", parameters: [
                              "inputRVector" : column0,
                              "inputGVector" : column1,
                              "inputBVector" : column2,
                              "inputAVector" : column3
                            ])
    }*/
}
