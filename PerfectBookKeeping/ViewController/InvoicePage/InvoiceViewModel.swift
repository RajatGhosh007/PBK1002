//
//  InvoiceViewModel.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 08/06/23.
//

import UIKit
import CoreData


class InvoiceViewModel : BaseViewModel {
    var commonResponse: CommonResponse?
    
    var cropImgList: [CropUploadImageList]?
    
    var arrUploadImg = [[String:Any]]()
    
    func fetchCropImageList(success:@escaping ((Bool) -> Void)){
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
              let managedContext = appDelegate.persistentContainer.viewContext
              let  fetchRequest = NSFetchRequest<CropUploadImageList>(entityName: "CropUploadImageList")
             
        fetchRequest.returnsObjectsAsFaults = false
              do {
                   let product = try managedContext.fetch(fetchRequest)
                  debugPrint("load values")
                 // cropImgList = product
                  cropImgList = [CropUploadImageList]()
                  cropImgList = product.reversed()
                  populateUploadImageList(cropImgList)
                 
                  success(true)
                 
              } catch let error as NSError {
                  debugPrint(error)
                  success(false)
                  
              }
        
        
    }
    
    
    
    func numberOrRows() -> Int {
        return self.cropImgList?.count ?? 0
      //  return self.cropImgList.count
    }

    func getCropImg(index: Int) -> CropUploadImageList? {
       
    //    print("getCountry  : ",self.cropImgList?[index])
        return self.cropImgList?[index]
        
      
    }
    
    
    func fetchSelectedCropImg(index: Int) -> UIImage? {
        let cropImgInfo = self.cropImgList?[index]
        
        let base64EncodeImg = cropImgInfo?.snap_image ?? ""
         
         let imageData = Data(base64Encoded: base64EncodeImg, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
         
         if let newImageData = imageData {
             return UIImage(data: newImageData)
         }else {
             print("Oops, invalid input format!")
             return nil
         }
        
       
      
    }
    
    
    func populateUploadImageList(_ cropImgList: [CropUploadImageList]?){
        guard  let cropImgList = cropImgList else{return}
        arrUploadImg.removeAll()
        
        for index in 0..<cropImgList.count {
            var dict = [String:Any]()
            
            
            
            dict["company_id"] =  cropImgList[index].company_id ?? ""
            dict["title"] =  cropImgList[index].title ?? ""
            dict["filedate"] =  cropImgList[index].file_date ?? ""
            dict["path"] =  cropImgList[index].company_id ?? ""
            dict["mimetype"] =  "image/jpeg"
            dict["blobdata"] =  cropImgList[index].snap_image ?? ""
            dict["file_name"] =  cropImgList[index].file_name ?? ""
            
            
            arrUploadImg.append(dict)
            
        }
         
     //  print("arrUploadImg",arrUploadImg)
      //  print("arrUploadImg  count ",arrUploadImg.count)
      //  print("cropImgList  count ",cropImgList.count)
        
        
    }
    
    
    
    
    func uploadFileAPI(token:String,urlName : String,methodType:String,success: @escaping ((CommonResponse?,String,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        let paramDict = ["files":arrUploadImg]
        
        ApiManager.shared.fileUploadAPI(paramsInput: paramDict, token:token, urlName: urlName, methodType:"POST") { [weak self] response  in
            self?.commonResponse =   response
            let messege =  self?.commonResponse?.message ?? ""
            success(self?.commonResponse,messege,true)
            print("Upload Upload ")
        } fail: { (error, message, status) in
            fail(error,message,false)
        }
        
        
    }
    
}
