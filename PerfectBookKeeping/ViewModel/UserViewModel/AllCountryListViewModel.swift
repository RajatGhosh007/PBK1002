//
//  AllCountryListViewModel.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 09/05/23.
//

import UIKit
import CoreData

class AllCountryListViewModel: BaseViewModel {
    
    var countryResponse: CountryList?
    var countryList: [CountryInfo]  = []
    
    var countryAllList  = Constant.ContryList.arrAllCountryList
    
    func getCountryList(ParamsDict:[String:String],Url:String, methodType:String,success:@escaping ((CountryList?,Bool) -> Void)){
    
       ApiManager.shared.getCountryListAPI(paramsInput: ParamsDict, urlName: Url, methodType: methodType) { [weak self] (response,_,_)  in
            self?.countryResponse = response
           self?.countryList = self?.countryResponse?.data?.countries ?? [CountryInfo]()
           Constant.ContryList.arrCountryList =  self?.countryList ?? [CountryInfo]()
           print( "self?.countryList   :",self?.countryList ?? [CountryInfo]())
           
         
           DispatchQueue.main.async {
              // self?.saveDataIntoCoreData()
               self?.removePreviousData()
          }
           success(self?.countryResponse,true)
        } fail: { _,_,_  in
            success(nil,false)
        }

     
    }
    
    
    func removePreviousData(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
              let managedContext = appDelegate.persistentContainer.viewContext
              let  fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AllCountryList")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest:fetchRequest)
              do {
                  try managedContext.execute(deleteRequest)
                
                  
                  do{
                      try managedContext.save()
                  }
                  catch
                  {
                      print(error)
                  }
                  
                  
              } catch let error as NSError {
                  debugPrint(error)
              }
        
        
        self.saveDataIntoCoreData()
      }
    
    
    
    
    func saveDataIntoCoreData(){
       
        
        let arrLength =  countryList.count

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
               let managedContext = appDelegate.persistentContainer.viewContext
               guard let userEntity = NSEntityDescription.entity(forEntityName: "AllCountryList", in: managedContext) else { return }
             for i in 0 ... (arrLength - 1) {
                  // let user =  NSManagedObject(entity: userEntity, insertInto: managedContext)
                   
                 let country  =   AllCountryList(context: managedContext)
                 
                 
                //   let dict =    self.countryList[i] ?? CountryInfo(id: 0, numcode: 0, phonecode: 0, name: "", nicename: "", iso: "")
                 
                 let dict =    self.countryList[i]
                   
                 country.id = dict.id ?? 0
                 country.name = dict.name ?? ""
                 country.nicename = dict.nicename ?? ""
                 country.numcode = dict.numcode ?? 0
                 country.phonecode = dict.phonecode ?? 0
                 country.iso = dict.iso ?? ""
                 
                  
                   
               }
               do {
                   try managedContext.save()
                   self.loadDataFun()
                   debugPrint("Data saved")
               } catch let error as NSError {
                   debugPrint(error)
               }
     
    }
    
    
    func loadDataFun() {
       
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
              let managedContext = appDelegate.persistentContainer.viewContext
              let  fetchRequest = NSFetchRequest<AllCountryList>(entityName: "AllCountryList")
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "id", ascending:true)]
             
        fetchRequest.returnsObjectsAsFaults = false
              do {
                   let product = try managedContext.fetch(fetchRequest)
                  debugPrint("load values")
                  countryAllList = product
                  Constant.ContryList.arrAllCountryList =  countryAllList
                  
                 // handleResponse(response: arrProductList, success: true)
                 
              } catch let error as NSError {
                  debugPrint(error)
                 // handleResponse(response: nil, success: false)
              }
       
   }
    
    func filterDataWithTxtInput(inputTxt:String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
              let managedContext = appDelegate.persistentContainer.viewContext
              let  fetchRequest = NSFetchRequest<AllCountryList>(entityName: "AllCountryList")
    //    fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "id", ascending:true)]
      //  fetchRequest.predicate = NSPredicate(format: "name LIKE %@", textField.text ?? "")
     //   fetchRequest.predicate = NSPredicate(format: "nicename BEGINSWITH %@", textField.text ?? "")
      //  fetchRequest.predicate = NSPredicate(format: "nicename MATCHES %@", textField.text ?? "")
        
        fetchRequest.predicate = NSPredicate(format: "nicename BEGINSWITH[c] %@", inputTxt )
        
        
        // request.predicate = NSPredicate(format: "name LIKE %@", query)
        
        
        fetchRequest.returnsObjectsAsFaults = false
              do {
                   let product = try managedContext.fetch(fetchRequest)
                  debugPrint("load values",product)
                  countryAllList = product
                  
                
                 
              } catch let error as NSError {
                  debugPrint(error)
                
              }
        
        
    }
        
    func setInitialVal() {
        countryAllList =  Constant.ContryList.arrAllCountryList ;
        
    }
    
    
    
    func numberOrRows() -> Int {
      //  return self.countryList?.count ?? 0
       return self.countryAllList.count
    }

    func getCountry(index: Int) -> AllCountryList? {
       
       print("getCountry  : ",self.countryAllList[index])
      
       return self.countryAllList[index]
    }
    

}
