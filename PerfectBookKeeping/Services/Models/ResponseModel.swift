//
//  ResponseModel.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 20/04/23.
//

import Foundation



struct UserResponse: Codable {
  // let flag: Bool?
  //  let isExisting: Bool?
    let message: String?
    let data : UserInfo?
  
}


struct UserInfo: Codable {
    
    let id: Int?
    let email: String?
    let name: String?
    let company_name: String?
    let phone: String?
  
}


struct LogInResponse: Codable {
 //   let flag: Bool?
    let message: String?
    let data: LoginData?
  
}

struct LoginData: Codable {
    
    let access_token: String?
    let refresh_token: String?
   
  
}

struct CommonResponse: Codable {
    
    let message: String?
  
}
//   access_token    refresh_token

struct CompanyListRes: Codable {
   
    let message: String?
    let data: [Company]?
    
   
}


struct Company: Codable {
    let name: String?
    let logo: String?
    let date_format: String?
    let id: Int?
    let user_id: Int?
   
}


struct CountryList: Codable {
    let data: Countries?
    let message:String?
   
}

struct Countries: Codable {
    let countries: [CountryInfo]?
 
}

struct CountryInfo: Codable {
    let id: Int64?
    let numcode: Int64?
    let phonecode: Int64?
    
    let name: String?
    let nicename: String?
    let iso: String?
 
   
}

struct StateResponse: Codable {
    let data: StateList?
    let message:String?
   
}

struct StateList: Codable {
    let states: [StateDetails]?
 
}

struct StateDetails: Codable {
    
    let state_id: Int64?
    let state_name: String?
    let state_abbr: String?
   
}

struct UserProfileResponse: Codable {
    let data: UserProfileInfo?
    let message:String?
   
}

struct UserProfileInfo: Codable {
    let user: UserDetail?
    
 
}
struct UserDetail: Codable {
    let id: Int?
    let name:String?
    let email:String?
    let company_name:String?
    let phone:String?
    let image:String?
    let CardModel: CardModel?
    let AddressModel: AddressModel?
}

struct CardModel: Codable {
    
    let id : Int?
    let user_id : Int?
    let card_number : String?
    let expiry : String?
    let cvv : String?
    let first_name : String?
    let last_name : String?
   
}
struct AddressModel: Codable {
    let address1 : String?
    let address2 : String?
    let city : String?
    let country : String?
    let state : String?
    let zipcode : String?
    
    
}



struct AccessCodeResponse: Codable {
    
    let message : String?
    let data : AccessCode?
   
}

struct AccessCode: Codable {
    let access_code : String?
}



struct AccessTokenResponse: Codable {
    
    let message : String?
    let data :  AccessToken?
   
}

struct AccessToken: Codable {
    let access_token : String?
}


struct ReceiptResponse: Codable {
    
    let message : String?
    let data :  [ReceiptInfo]?
   
}

struct ReceiptInfo: Codable {
    let id : Int?
    let user_id : Int?
    let amount : Int?
    
    let transaction_id : String?
    let createdAt : String?
    
}


struct GalleryListResponse: Codable {
    
 //  let data : GalleryData?
    let data : GalleryYear?
    
}

struct GalleryData: Codable {
    
   // typealias DecodedMonthType = [String:GalleryMonth]
//    typealias DecodedMonthType = GalleryMonth?
    
    typealias DecodedYearType = GalleryYear
    
   // private var dictYear: DecodedYearType
    var dictYear: [String:GalleryYear]
    
    private struct DynamicYearKeys: CodingKey {

            // Use for string-keyed dictionary
            var stringValue: String
            init?(stringValue: String) {
                self.stringValue = stringValue
            }

            // Use for integer-keyed dictionary
            var intValue: Int?
            init?(intValue: Int) {
                // We are not using this, thus just return nil
                return nil
            }
        }
    
    
    init(from decoder: Decoder) throws {

            // 1
            // Create a decoding container using DynamicCodingKeys
            // The container will contain all the JSON first level key
            let container = try decoder.container(keyedBy: DynamicYearKeys.self)

      
        var tempDict = [String:GalleryYear]()

            // 2
            // Loop through each key (student ID) in container
            for key in container.allKeys {
                print("Key Key in Data ",key)
                let keyName =  (DynamicYearKeys(stringValue: key.stringValue)! )
                
                // Decode Student using key & keep decoded Student object in tempArray
                let decodedObject = try container.decode(GalleryYear.self, forKey: DynamicYearKeys(stringValue: key.stringValue)!)
                print("decodedObject in year   ",decodedObject)
              //  tempDict[key.stringValue] =  decodedObject
                
                
                tempDict[keyName.stringValue] = decodedObject
            }

            // 3
            // Finish decoding all Student objects. Thus assign tempArray to array.
        dictYear = tempDict
        }
    
}

struct GalleryYear: Codable {
    
   
    
 //   typealias DecodedMonthType =  GalleryMonth
     var dictYear : [String:GalleryMonth]
    
    private struct DynamicYearKeys: CodingKey {

            // Use for string-keyed dictionary
            var stringValue: String
            init?(stringValue: String) {
                self.stringValue = stringValue
            }
            
        // Use for integer-keyed dictionary
        var intValue: Int?
        init?(intValue: Int) {
            // We are not using this, thus just return nil
            return nil
        }
           
           
        }
    
    
    
    init(from decoder: Decoder) throws {

           
            let container = try decoder.container(keyedBy: DynamicYearKeys.self)
            // var tempArray = [GalleryDate]()
        var tempDictYear = [String:GalleryMonth]()
         
            for key in container.allKeys {
                print("Key Key in YEar ",key)
                let keyName =  DynamicYearKeys(stringValue: key.stringValue)!
              let decodedObject = try container.decode(GalleryMonth.self, forKey: DynamicYearKeys(stringValue: key.stringValue)!)
              //  let decodedObject = try container.decode(GalleryMonth.self, forKey: DynamicYearKeys(stringValue:"2023")!)
                
                print("decodedObject in month   ",decodedObject)
                tempDictYear[keyName.stringValue] =  decodedObject
                print("tempDictYear in   ",tempDictYear)
            }
        

         dictYear = tempDictYear
        }
    
}



struct GalleryMonth: Codable {
    
   // typealias DecodedDateType = GalleryDate
     var dictMonth : [String:GalleryDate]
    
    private struct DynamicMonthKeys: CodingKey {

            // Use for string-keyed dictionary
            var stringValue: String
            init?(stringValue: String) {
                self.stringValue = stringValue
            }
            
        // Use for integer-keyed dictionary
        var intValue: Int?
        init?(intValue: Int) {
            // We are not using this, thus just return nil
            return nil
        }
           
           
        }
    
    
    
    init(from decoder: Decoder) throws {

           
            let container = try decoder.container(keyedBy: DynamicMonthKeys.self)
        var tempDictDate = [String:GalleryDate]()
         
            for key in container.allKeys {
                print("Key Key in month ",key)
                let keyName =  DynamicMonthKeys(stringValue: key.stringValue)!
               let decodedObject = try container.decode(GalleryDate.self, forKey: DynamicMonthKeys(stringValue: key.stringValue)!)
                
             //   let decodedObject = try container.decode(GalleryDate.self, forKey: DynamicMonthKeys(stringValue:"May")!)
                
                print("decodedObject in month   ",decodedObject)
                tempDictDate[keyName.stringValue] = decodedObject
                print("tempArray in   ",tempDictDate)
            }
        

        dictMonth  = tempDictDate
        }
    
    
}
struct GalleryDate: Codable {
    
   // typealias DecodedGallaryInfoType = GallaryInfo
     var dictDate: [String:[GallaryInfo]]
   //  var dateGalleryDis: String
  
    private struct DynamicDateKeys: CodingKey {

            // Use for string-keyed dictionary
            var stringValue: String
            init?(stringValue: String) {
                self.stringValue = stringValue
            }

            // Use for integer-keyed dictionary
            var intValue: Int?
            init?(intValue: Int) {
                // We are not using this, thus just return nil
                return nil
            }
        }
    
    
    init(from decoder: Decoder) throws {
     //   var decodedQuotes: [GallaryInfo] = []
            // 1
            // Create a decoding container using DynamicCodingKeys
            // The container will contain all the JSON first level key
            let container = try decoder.container(keyedBy:DynamicDateKeys.self)

        
        var tempArrayDate = [String:[GallaryInfo]]()

            // 2
            // Loop through each key (student ID) in container
            for key in container.allKeys {
                print("Key Key in Date ",key)
                // Decode Student using key & keep decoded Student object in tempArray
                let keyName =  DynamicDateKeys(stringValue: key.stringValue)!
                let decodedObject = try container.decode([GallaryInfo].self, forKey: DynamicDateKeys(stringValue: key.stringValue)!)
                
                
              //  let decodedObject = try container.decode([GallaryInfo].self, forKey:DynamicDateKeys(stringValue:"2023-05-08")!)
               
               // tempArrayDate.append(decodedObject)
                tempArrayDate[keyName.stringValue] =  decodedObject
                print("decodedObject in gallery info   ",decodedObject)
                print("tempGalleryInfo  in date    ",tempArrayDate)
                
           //     dateGalleryDis =  keyName.stringValue
            }

            // 3
            // Finish decoding all Student objects. Thus assign tempArray to array.
        dictDate = tempArrayDate
       // dateGalleryDis =
        
        }
   
}


struct GalleryImageDisplay: Codable {
    
    var keyName : String
    var arrGalleryList : [GallaryInfo]
    
    
    
}




/*
struct GalleryDate: Codable {
    
    typealias DecodedArrayType = [GallaryInfo]
    private var array: DecodedArrayType
    
    
    private struct DynamicDateKeys: CodingKey {

            // Use for string-keyed dictionary
            var stringValue: String
            init?(stringValue: String) {
                self.stringValue = stringValue
            }

            // Use for integer-keyed dictionary
            var intValue: Int?
            init?(intValue: Int) {
                // We are not using this, thus just return nil
                return nil
            }
        }
    
    
    init(from decoder: Decoder) throws {

            // 1
            // Create a decoding container using DynamicCodingKeys
            // The container will contain all the JSON first level key
            let container = try decoder.container(keyedBy:DynamicDateKeys.self)

           var tempArray = [GallaryInfo]()

            // 2
            // Loop through each key (student ID) in container
            for key in container.allKeys {

                // Decode Student using key & keep decoded Student object in tempArray
                let decodedObject = try container.decode(GallaryInfo.self, forKey: DynamicDateKeys(stringValue: key.stringValue)!)
                //tempArray.append(contentsOf:[decodedObject])
                tempArray.append(decodedObject)
            }

            // 3
            // Finish decoding all Student objects. Thus assign tempArray to array.
            array = tempArray
        }
    
}
*/

struct GallaryList: Codable {
    let id : Int?
  //  let company_id : Int?
    
    
  //  let file_name : String?
  //  let title : String?
    
}


struct GallaryInfo: Codable {
    let id : Int?
    let thumbnail : String?
    
    
   //  thumbnail
    
    
  //  let file_name : String?
  //  let title : String?
    
}




//  user_id   transaction_id     createdAt   amount

/*
 
 
 
 
 {
     "data": [
         {
             "id": 1,
             "user_id": 1,
             "name": "RJ.pvt",
             "createdAt": "2023-03-17T09:50:07.000Z",
             "updatedAt": "2023-03-17T09:55:25.000Z"
         }
     ],
     "message": "findAll"
 }
 
 
 {
     "message": "Authentication token missing"
 }
 */
