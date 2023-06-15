//
//  PaymentReceiptViewModel.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 16/05/23.
//

import UIKit

class PaymentReceiptViewModel: BaseViewModel {
   
    var receiptResponse: ReceiptResponse?
    var receiptList: [ReceiptInfo]?
    
    func getPaymentReceiptListWithAccessToken(ParamsInput:[String: Any],token:String,urlName : String,methodType:String,success: @escaping ((ReceiptResponse?,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
        ApiManager.shared.getPaymentReceiptListWithAccessToken(paramsInput: ParamsInput, token: token, urlName: urlName, methodType: methodType) { [weak self] response  in
            self?.receiptResponse = response
            
            self?.receiptList = self?.receiptResponse?.data  ?? []
            
            print("self?.receiptList   ",self?.receiptList ?? [])
            
            if(self?.receiptList?.isEmpty == true){
                success(nil,false)
            }else{
                success(response,true)
            }
           
           
        } fail: { error, message, Bool in
            fail(error,message,false)
        }
        
        
    }
    
    func numberOrRows() -> Int {
        return self.receiptList?.count ?? 0
      //  return 1
    }

    func getReceiptInfo(index: Int) -> ReceiptInfo? {
        return self.receiptList?[index]
    }
    
    
    func downloadImageFromURL(reciptInfo:ReceiptInfo?)  {
        guard let reciptInfo = reciptInfo else{return}
        
        print("reciptInfo for download %@  ",reciptInfo)
        
    }
    
    // MARK: Download and Save 
    
    
    
    func demoData(){
        
        receiptList  =  [
        
        
        
         ReceiptInfo(id: 90, user_id: 2, amount: 600, transaction_id: "40116532730", createdAt: "2023-03-13T07:09:51.000Z"),
         ReceiptInfo(id: 91, user_id: 2, amount: 960, transaction_id: "AAVT67893STEN", createdAt: "2022-07-25T07:03:22.000Z"),
         ReceiptInfo(id: 92, user_id: 2, amount: 265, transaction_id: "AECHJU450N", createdAt: "2023-01-13T07:06:42.000Z"),
         ReceiptInfo(id: 93, user_id: 2, amount: 560, transaction_id: "HGHHJKJ964CRTEAT", createdAt: "2022-08-19T06:14:51.000Z"),
         ReceiptInfo(id: 94, user_id: 2, amount: 458, transaction_id: "BBB9985673421", createdAt: "2022-03-22T07:15:51.000Z"),
         ReceiptInfo(id: 95, user_id: 2, amount: 670, transaction_id: "40116532730", createdAt: "2022-11-22T07:05:15.000Z"),
         ReceiptInfo(id: 96, user_id: 2, amount: 430, transaction_id: "40116532730", createdAt: "2022-05-21T07:10:47.000Z"),
         ReceiptInfo(id: 97, user_id: 2, amount: 540, transaction_id: "AMVY53980PO", createdAt: "2021-03-18T07:08:30.000Z"),
         ReceiptInfo(id: 98, user_id: 2, amount: 6790, transaction_id: "8740DGJTSD56", createdAt: "2023-02-10T07:04:20.000Z"),
         ReceiptInfo(id: 99, user_id: 2, amount: 400, transaction_id: "CGKVBHB2458", createdAt: "2023-03-04T07:11:35.000Z"),
         ReceiptInfo(id: 100, user_id: 2, amount: 320, transaction_id: "760FGHHJJMNFGH", createdAt: "2022-10-22T07:07:20.000Z"),
         
         
         
         
         ReceiptInfo(id: 90, user_id: 2, amount: 600, transaction_id: "40116532730", createdAt: "2023-03-13T07:09:51.000Z"),
         ReceiptInfo(id: 91, user_id: 2, amount: 960, transaction_id: "AAVT67893STEN", createdAt: "2022-07-25T07:03:22.000Z"),
         ReceiptInfo(id: 92, user_id: 2, amount: 265, transaction_id: "AECHJU450N", createdAt: "2023-01-13T07:06:42.000Z"),
         ReceiptInfo(id: 93, user_id: 2, amount: 560, transaction_id: "HGHHJKJ964CRTEAT", createdAt: "2022-08-19T06:14:51.000Z"),
         ReceiptInfo(id: 94, user_id: 2, amount: 458, transaction_id: "BBB9985673421", createdAt: "2022-03-22T07:15:51.000Z"),
         ReceiptInfo(id: 95, user_id: 2, amount: 670, transaction_id: "40116532730", createdAt: "2022-11-22T07:05:15.000Z"),
         ReceiptInfo(id: 96, user_id: 2, amount: 430, transaction_id: "40116532730", createdAt: "2022-05-21T07:10:47.000Z"),
         ReceiptInfo(id: 97, user_id: 2, amount: 540, transaction_id: "AMVY53980PO", createdAt: "2021-03-18T07:08:30.000Z"),
         ReceiptInfo(id: 98, user_id: 2, amount: 6790, transaction_id: "8740DGJTSD56", createdAt: "2023-02-10T07:04:20.000Z"),
         ReceiptInfo(id: 99, user_id: 2, amount: 400, transaction_id: "CGKVBHB2458", createdAt: "2023-03-04T07:11:35.000Z"),
         ReceiptInfo(id: 100, user_id: 2, amount: 320, transaction_id: "760FGHHJJMNFGH", createdAt: "2022-10-22T07:07:20.000Z"),
         
         
        
        
        
        ]
        
        
        
    }
    

}




/*
 
 
 {
     "data": [
         {
             "id": 90,
             "user_id": 2,
             "transaction_id": "40116532730",
             "amount": 600,
             "payment_status": 1,
             "transaction_type": 0,
             "response": "[\"1\",\"1\",\"1\",\"This transaction has been approved.\",\"MW4CKF\",\"Y\",\"40116532730\",\"\",\"\",\"600.00\",\"CC\",\"auth_capture\",\"\",\"dsgg gsd\",\"\",\"\",\"dsg1 gsdjj\",\"\",\"g\",\"1234\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"P\",\"2\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"XXXX1111\",\"Visa\",\"\",\"\",\"\",\"\",\"\",\"\",\"DQ4BY73KJW8CFU7BV5GSGBB\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\"]",
             "deleted": 0,
             "createdAt": "2023-03-13T07:09:51.000Z",
             "updatedAt": null
         },
         {
             "id": 91,
             "user_id": 2,
             "transaction_id": "40116532738",
             "amount": 500,
             "payment_status": 1,
             "transaction_type": 0,
             "response": "[\"1\",\"1\",\"1\",\"This transaction has been approved.\",\"TKFISH\",\"Y\",\"40116532738\",\"\",\"\",\"500.00\",\"CC\",\"auth_capture\",\"\",\"sdg gsd\",\"\",\"\",\"dsg1 gsdjj\",\"\",\"g\",\"1234\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"P\",\"2\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"XXXX1111\",\"Visa\",\"\",\"\",\"\",\"\",\"\",\"\",\"2CM0JKQHHUNIJ11Z1ISBNRR\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\"]",
             "deleted": 0,
             "createdAt": "2023-03-13T07:10:01.000Z",
             "updatedAt": null
         },
         {
             "id": 92,
             "user_id": 2,
             "transaction_id": "40116532738",
             "amount": 500,
             "payment_status": 1,
             "transaction_type": 0,
             "response": "[\"1\",\"1\",\"1\",\"This transaction has been approved.\",\"TKFISH\",\"Y\",\"40116532738\",\"\",\"\",\"500.00\",\"CC\",\"auth_capture\",\"\",\"sdg gsd\",\"\",\"\",\"dsg1 gsdjj\",\"\",\"g\",\"1234\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"P\",\"2\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"XXXX1111\",\"Visa\",\"\",\"\",\"\",\"\",\"\",\"\",\"2CM0JKQHHUNIJ11Z1ISBNRR\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\"]",
             "deleted": 0,
             "createdAt": "2023-03-13T07:10:01.000Z",
             "updatedAt": null
         },
         {
             "id": 93,
             "user_id": 2,
             "transaction_id": "40116532738",
             "amount": 500,
             "payment_status": 1,
             "transaction_type": 0,
             "response": "[\"1\",\"1\",\"1\",\"This transaction has been approved.\",\"TKFISH\",\"Y\",\"40116532738\",\"\",\"\",\"500.00\",\"CC\",\"auth_capture\",\"\",\"sdg gsd\",\"\",\"\",\"dsg1 gsdjj\",\"\",\"g\",\"1234\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"P\",\"2\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"XXXX1111\",\"Visa\",\"\",\"\",\"\",\"\",\"\",\"\",\"2CM0JKQHHUNIJ11Z1ISBNRR\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\"]",
             "deleted": 0,
             "createdAt": "2023-03-13T07:10:01.000Z",
             "updatedAt": null
         },
         {
             "id": 94,
             "user_id": 2,
             "transaction_id": "40116532738",
             "amount": 500,
             "payment_status": 1,
             "transaction_type": 0,
             "response": "[\"1\",\"1\",\"1\",\"This transaction has been approved.\",\"TKFISH\",\"Y\",\"40116532738\",\"\",\"\",\"500.00\",\"CC\",\"auth_capture\",\"\",\"sdg gsd\",\"\",\"\",\"dsg1 gsdjj\",\"\",\"g\",\"1234\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"P\",\"2\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"XXXX1111\",\"Visa\",\"\",\"\",\"\",\"\",\"\",\"\",\"2CM0JKQHHUNIJ11Z1ISBNRR\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\"]",
             "deleted": 0,
             "createdAt": "2023-03-13T07:10:01.000Z",
             "updatedAt": null
         },
         {
             "id": 95,
             "user_id": 2,
             "transaction_id": "40116532738",
             "amount": 500,
             "payment_status": 1,
             "transaction_type": 0,
             "response": "[\"1\",\"1\",\"1\",\"This transaction has been approved.\",\"TKFISH\",\"Y\",\"40116532738\",\"\",\"\",\"500.00\",\"CC\",\"auth_capture\",\"\",\"sdg gsd\",\"\",\"\",\"dsg1 gsdjj\",\"\",\"g\",\"1234\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"P\",\"2\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"XXXX1111\",\"Visa\",\"\",\"\",\"\",\"\",\"\",\"\",\"2CM0JKQHHUNIJ11Z1ISBNRR\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\"]",
             "deleted": 0,
             "createdAt": "2023-03-13T07:10:01.000Z",
             "updatedAt": null
         },
         {
             "id": 96,
             "user_id": 2,
             "transaction_id": "40116532738",
             "amount": 500,
             "payment_status": 1,
             "transaction_type": 0,
             "response": "[\"1\",\"1\",\"1\",\"This transaction has been approved.\",\"TKFISH\",\"Y\",\"40116532738\",\"\",\"\",\"500.00\",\"CC\",\"auth_capture\",\"\",\"sdg gsd\",\"\",\"\",\"dsg1 gsdjj\",\"\",\"g\",\"1234\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"P\",\"2\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"XXXX1111\",\"Visa\",\"\",\"\",\"\",\"\",\"\",\"\",\"2CM0JKQHHUNIJ11Z1ISBNRR\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\"]",
             "deleted": 0,
             "createdAt": "2023-03-13T07:10:01.000Z",
             "updatedAt": null
         },
         {
             "id": 97,
             "user_id": 2,
             "transaction_id": "40116532738",
             "amount": 500,
             "payment_status": 1,
             "transaction_type": 0,
             "response": "[\"1\",\"1\",\"1\",\"This transaction has been approved.\",\"TKFISH\",\"Y\",\"40116532738\",\"\",\"\",\"500.00\",\"CC\",\"auth_capture\",\"\",\"sdg gsd\",\"\",\"\",\"dsg1 gsdjj\",\"\",\"g\",\"1234\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"P\",\"2\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"XXXX1111\",\"Visa\",\"\",\"\",\"\",\"\",\"\",\"\",\"2CM0JKQHHUNIJ11Z1ISBNRR\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\"]",
             "deleted": 0,
             "createdAt": "2023-03-13T07:10:01.000Z",
             "updatedAt": null
         },
         {
             "id": 98,
             "user_id": 2,
             "transaction_id": "40116532738",
             "amount": 500,
             "payment_status": 1,
             "transaction_type": 0,
             "response": "[\"1\",\"1\",\"1\",\"This transaction has been approved.\",\"TKFISH\",\"Y\",\"40116532738\",\"\",\"\",\"500.00\",\"CC\",\"auth_capture\",\"\",\"sdg gsd\",\"\",\"\",\"dsg1 gsdjj\",\"\",\"g\",\"1234\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"P\",\"2\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"XXXX1111\",\"Visa\",\"\",\"\",\"\",\"\",\"\",\"\",\"2CM0JKQHHUNIJ11Z1ISBNRR\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\"]",
             "deleted": 0,
             "createdAt": "2023-03-13T07:10:01.000Z",
             "updatedAt": null
         }
     ],
     "message": "findAll"
 }
 */
