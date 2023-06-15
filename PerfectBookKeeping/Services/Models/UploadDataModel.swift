//
//  UploadDataModel.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 17/05/23.
//

import Foundation



struct UploadDataUserProfile: Codable {
    let user : UploadDataUser?
    let address : UploadDataAddress?
    let card : UploadDataCard?
   
}

struct UploadDataUser: Codable {
    
    let company_name:String?
    let phone:String?
  
}

struct UploadDataAddress: Codable {
    let address1 : String?
    let address2 : String?
    let city : String?
    let country : String?
    let state : String?
    let zipcode : String?
    
    
}
struct UploadDataCard: Codable {
    let card_number : String?
    let expiry : String?
    let cvv : String?
    let first_name : String?
    let last_name : String?
   
}
