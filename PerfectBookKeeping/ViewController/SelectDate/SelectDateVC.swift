//
//  SelectDateVC.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 24/04/23.
//

import UIKit
import CropViewController
import Photos

class SelectDateVC: BaseViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var selDate = ""
    @IBOutlet weak var lblSelDate: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    @IBOutlet weak var viewBottom: UIView!
    
    
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        lblSelDate.text = Date().getSelectDateInString(format:"MMM d,yyyy") ?? ""
        
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
            datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        } else {
            // Fallback on earlier versions
        }
        
        datePicker.backgroundColor = .black
        datePicker.overrideUserInterfaceStyle = .dark
      
        
        
    }
    
    
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        datePicker.setValue(UIColor.green, forKeyPath: "textColor")
        datePicker.datePickerMode = .date
        datePicker.setValue(false, forKeyPath: "highlightsToday")
        datePicker.maximumDate = Date()
        
        //    datePicker.setValue(UIColor.blue ,forKeyPath: "textColor")
        //  datePicker.setValue(UIColor.yellow, forKeyPath: "backgroundColor")
        
          
        datePicker.roundCorners(radius:5)
        viewBottom.roundCorners(radius: 5)
            
      
        
    }
    
    
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "MMM dd,yyyy"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
      //  lblSelDate.text =  selectedDate
        
        lblSelDate.text = sender.date.getSelectDateInString(format:"MMM d,yyyy") ?? ""
        selDate =   sender.date.getSelectDateInString(format:"yyyy-MM-dd") ?? ""
        print("Selected value \(selectedDate)")
        print("selDate \(selDate)")
        Constant.APPStaticData.selectDateUploadReceipt =  selDate
        openCamera()
        
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
    
   
    
    @IBAction func clickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
  
   
    
    
    
}
// MARK: - Crop Image Delegate -
extension SelectDateVC: CropViewControllerDelegate  {
   
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
       
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InvoicePageVC") as! InvoicePageVC
        vc.imagePicked =  image
       self.navigationController?.pushViewController(vc, animated: true)
        
        cropViewController.dismiss(animated: true, completion: {
            
            // self.hideSpinnerAnother()
        })
        
        saveDataIntoCoreData(image)
        
       
       
    }
    
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
            
            
        } catch let error as NSError {
            debugPrint(error)
        }
        
        
    }
    
    
}

extension Date  {
    
    func getFormattedDateNew(inputFormatter: String ,outputFormatter: String,selDate:String?)-> String  {
            var strDateDis = ""
            
            guard let selDate =  selDate  else{
               return strDateDis
            }
            
            
            let dateFormatter = DateFormatter()
             dateFormatter.dateFormat = "MMM dd,yyyy"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.locale = Locale.current
            
            if let date = dateFormatter.date(from: selDate) {
                
                let dateFormteOut = DateFormatter()
                dateFormteOut.dateFormat = "yyyy-MM-dd"
                dateFormteOut.locale = Locale.current
                strDateDis =  dateFormteOut.string(from: date)
               
            }
            
          
            
            return  strDateDis
    }
    
    
    
}


