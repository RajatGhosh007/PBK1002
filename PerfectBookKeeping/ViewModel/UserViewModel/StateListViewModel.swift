//
//  StateListViewModel.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 10/05/23.
//

import UIKit
import CoreData


class StateListViewModel: BaseViewModel {
    
    
    
    var stateResponse: StateResponse?
    var stateList: [StateDetails]  = []
    var stateListStore = Constant.ContryList.stateListStore
    
    override init() {
        super.init()
        
    }
    
    
    
    func getStateList(ParamsDict:[String:String],Url:String, methodType:String,success:@escaping ((StateResponse?,Bool) -> Void)){
    
       ApiManager.shared.getStateListAPI(paramsInput: ParamsDict, urlName: Url, methodType: methodType) { [weak self] (response,_,_)  in
            self?.stateResponse = response
          self?.stateList = self?.stateResponse?.data?.states ?? [StateDetails]()
           
           print( "self?.stateResponse   :",self?.stateResponse ?? [StateResponse]())
           
         
           DispatchQueue.main.async {
              // self?.saveDataIntoCoreData()
               self?.removePreviousData()
          }
           
        } fail: { _,_,_  in
            success(nil,false)
        }

     
    }
    
    
    
    func removePreviousData(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
              let managedContext = appDelegate.persistentContainer.viewContext
              let  fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SateListStore")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest:fetchRequest)
              do {
                  try managedContext.execute(deleteRequest)
                
                  
                  do{
                      try managedContext.save()
                      self.saveDataIntoCoreData()
                  }
                  catch
                  {
                      print(error)
                  }
                  
                  
              } catch let error as NSError {
                  debugPrint(error)
              }
        
        
        
      }
    
    func saveDataIntoCoreData(){
       
        
        let arrLength =  stateList.count

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
               let managedContext = appDelegate.persistentContainer.viewContext
               guard let userEntity = NSEntityDescription.entity(forEntityName: "SateListStore", in: managedContext) else { return }
             for i in 0 ... (arrLength - 1) {
                  // let user =  NSManagedObject(entity: userEntity, insertInto: managedContext)
                   
                 let stateInfo  =   SateListStore(context: managedContext)
                
                 let dict =    self.stateList[i]
                   
                 stateInfo.state_id = dict.state_id ?? 0
                 stateInfo.state_name = dict.state_name ?? ""
                 stateInfo.state_abbr = dict.state_abbr ?? ""
                 
                   
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
              let  fetchRequest = NSFetchRequest<SateListStore>(entityName: "SateListStore")
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "state_id", ascending:true)]
             
        fetchRequest.returnsObjectsAsFaults = false
              do {
                   let product = try managedContext.fetch(fetchRequest)
                  debugPrint("load values")
                 print(product)
                  stateListStore = product
                  Constant.ContryList.stateListStore =  stateListStore
                 // handleResponse(response: arrProductList, success: true)
                 
              } catch let error as NSError {
                  debugPrint(error)
                 // handleResponse(response: nil, success: false)
              }
       
   }
    
    
    
    
    func filterDataWithTxtInput(inputTxt:String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
              let managedContext = appDelegate.persistentContainer.viewContext
              let  fetchRequest = NSFetchRequest<SateListStore>(entityName: "SateListStore")
     
        fetchRequest.predicate = NSPredicate(format: "state_name BEGINSWITH[c] %@", inputTxt )
        fetchRequest.returnsObjectsAsFaults = false
              do {
                   let product = try managedContext.fetch(fetchRequest)
                  debugPrint("load values",product)
                  stateListStore = product
             } catch let error as NSError {
                  debugPrint(error)
                
              }
        
        
    }
        
    func setInitialVal() {
        stateListStore =  Constant.ContryList.stateListStore ;
        
    }
    
    
    func numberOrRows() -> Int {
       return self.stateListStore.count
    }

    func getState(index: Int) -> SateListStore? {
         return self.stateListStore[index]
    }
    

}
