//
//  GalleryListViewModel.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 19/05/23.
//

import UIKit

class GalleryListViewModel: BaseViewModel {
    
    var galleryListResponse: GalleryListResponse?
    var galleryList: [ReceiptInfo]?
    
    
  var arrDateShow: [GalleryDate] = [GalleryDate]()
    
    var arrGalleryInfoShow : [[String:[GallaryInfo]]] =  [[String:[GallaryInfo]]]()
    
    var arrGalleryInfoDisplay : [GalleryImageDisplay] =  [GalleryImageDisplay]()
    
    func getGalleryListWithAccessToken(ParamsInput:[String: Any],token:String,urlName : String,methodType:String,success: @escaping ((GalleryListResponse?,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
        ApiManager.shared.getGalleryListWithAccessToken(paramsInput: ParamsInput, token: token, urlName: urlName, methodType: methodType) { [weak self] response  in
            
            self?.arrGalleryInfoDisplay.removeAll()
            self?.galleryListResponse = response
          //  print("self?.receiptList   ",response )
            
           
            
           let dictData =  self?.galleryListResponse?.data
            guard let dictYear = dictData?.dictYear  else{return}
            print("dictYear  ",dictYear)
            for key in Array(dictYear.keys) {
               print("\(key)")
                
                guard let dictMonth  = dictYear[String(key)] else{return}
                print("dictMonth  ",dictMonth)
                for key in Array(dictMonth.dictMonth.keys) {
                   print("\(key)")
                    
                    guard let dictDate  = dictMonth.dictMonth[String(key)] else{return}
                    print("dictDate    ",dictDate)
                    
                    for key in Array(dictDate.dictDate.keys) {
                        print("\(key)")
                        
                        guard let arrImgInfo  = dictDate.dictDate[String(key)] else{return}
                        print("arrImgInfo    ",arrImgInfo)
                        
                        self?.arrDateShow.append(dictDate)
                        
                        var galleryObj = GalleryImageDisplay(keyName:String(key), arrGalleryList:arrImgInfo)
                        
                        self?.arrGalleryInfoShow.append([String(key):arrImgInfo])
                        
                        self?.arrGalleryInfoDisplay.append(galleryObj)
                        
                      
                        
                        print("arrDateShow count    ",self?.arrGalleryInfoDisplay.count ?? 0)
                        
                    }
                  
                   
                  
                    
                }
               
                
               
                
            }
            
            
            success(response,true)
            
            
           // for(all)
                    
        //    print("allYearKey    ",allYearKey ?? "")
            
            
            
            
        //   print("date ",self?.galleryListResponsee.data )
            
          //  self?.receiptList = self?.receiptResponse?.data  ?? []
            
           // print("self?.receiptList   ",self?.receiptList ?? [])
            
            /*
            if(self?.receiptList?.isEmpty == true){
                success(nil,false)
            }else{
                success(response,true)
            }
           */
           
        } fail: { error, message, Bool in
            fail(error,message,false)
        }
        
        
    }
    
    
    func getFilterListWithAccessToken(paramsInput:[String:String],token:String,urlName: String,methodType:String, success: @escaping ((GalleryListResponse?,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
        
        
        ApiManager.shared.getFilterListWithAccessToken(paramsInput: paramsInput, token: token, urlName: urlName, methodType: methodType) { [weak self] response  in
            self?.arrGalleryInfoDisplay.removeAll()
            self?.galleryListResponse = response
          //  print("self?.receiptList   ",response )
            
           
            
           let dictData =  self?.galleryListResponse?.data
            guard let dictYear = dictData?.dictYear  else{return}
            print("dictYear  ",dictYear)
            for key in Array(dictYear.keys) {
               print("\(key)")
                
                guard let dictMonth  = dictYear[String(key)] else{return}
                print("dictMonth  ",dictMonth)
                for key in Array(dictMonth.dictMonth.keys) {
                   print("\(key)")
                    
                    guard let dictDate  = dictMonth.dictMonth[String(key)] else{return}
                    print("dictDate    ",dictDate)
                    
                    for key in Array(dictDate.dictDate.keys) {
                        print("\(key)")
                        
                        guard let arrImgInfo  = dictDate.dictDate[String(key)] else{return}
                        print("arrImgInfo    ",arrImgInfo)
                        
                        self?.arrDateShow.append(dictDate)
                        
                        var galleryObj = GalleryImageDisplay(keyName:String(key), arrGalleryList:arrImgInfo)
                        
                        self?.arrGalleryInfoShow.append([String(key):arrImgInfo])
                        
                        self?.arrGalleryInfoDisplay.append(galleryObj)
                        
                      
                        
                        print("arrDateShow count    ",self?.arrGalleryInfoDisplay.count ?? 0)
                        
                    }
                   
                }
               
              
            }
            
            
            success(response,true)
          
           
        } fail: { error, message, Bool in
            fail(error,message,false)
        }
        
        
        
        
        
    }
    
    
    
    func numberOrRows() -> Int {
        
        return self.arrGalleryInfoDisplay.count
     //   return self.arrDateShow.count
     
    }
   /*
    func getGalleryListInfo(index: Int) -> GalleryDate? {
        return self.arrDateShow[index]
    }*/
    
    func getGalleryListInfo(index: Int) -> GalleryImageDisplay? {
        return self.arrGalleryInfoDisplay[index]
    }

}
