//
//  ServiceManager.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 20/04/23.
//

import Foundation


import Alamofire

import SwiftyJSON


class ServiceManager {
    public static let shared = ServiceManager()
    
    
    
    func callGetServiceWithToken<T:Decodable>(params  : [String:Any] ,token : String,Url : String ,success:@escaping ((T) -> Void),fail: @escaping ((HTTPError) -> Void)){
        
        
        let url = Url
        let authKey = String(format:"Authorization=%@",token)
        print(authKey)
        
        
        
        
        
        /*
        let urlVal = URL(string: url)!
        
        
        let jar = HTTPCookieStorage.shared
        let cookieHeaderField = ["Set-Cookie": "Authorization=value"] // Or ["Set-Cookie": "key=value, key2=value2"] for multiple cookies
        let cookies = HTTPCookie.cookies(withResponseHeaderFields: cookieHeaderField, for: urlVal)
        jar.setCookies(cookies, for: urlVal, mainDocumentURL: urlVal)
        */
        
        
    
       
       
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json",
                    "Cookie":authKey
        ]
       // let params : [String:Any]  = ["email":emailidStr,"password":passwordStr]
      //  let url = baseUrl + LOGIN
       
       
        print("============HEADERS=================")
        print(headers)
        print("============PARAMS=================")
        print(params)
        print("============URL=================")
        print(url)
        // guard let data = response.data else { return }
        
        
        AF.request(url, method: .get, parameters: nil, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            print(response)
            
            
            
            switch response.result{
            case .success(_):
                
                guard let data = response.data else {
                    fail(.noData)
                    return
                }
                
                let object = try? JSONSerialization.jsonObject(
                    with: data,
                    options: []
                )
              print("  Normal JSON   is  ",object ?? "")
                
                let decoder = JSONDecoder()
                do{
                if let json = try? decoder.decode(T.self, from: data) {
                    success(json)
                    print("  JSON DECODE   ",json)
                } else {
                    fail(.parsingFailed)
                }
               
            }catch let err {
                    print(err.localizedDescription)
     //               DataManager.shared.showLoader(text: "Please try again")
                    fail(.parsingFailed)
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                fail(.requestError)
            }
               
            
        }
        
       
    }
    
    
    // MARK: Get Company List
    
    func getCompanyList<T:Decodable>(dictionary:[String: Any],token: String,urlName: String,methodType:String,success:@escaping ((T) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
    //    let method = "http://192.168.1.16:3000/login"
        
        let authKey = String(format:"Bearer %@",token)
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(url: URL(string: urlName)!)
        request.httpMethod = methodType
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
       request.addValue(authKey, forHTTPHeaderField: "Authorization")
        print("Dict-----\(dictionary)")
        
        
        if(methodType != "GET"){
            let postData: Data? = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            request.httpBody = postData
        }
        
        
        
        let dataTask = session.dataTask(with: request as URLRequest) { (data,response,error) in
          //  print(response)
            
          

            if error != nil{
                print(error!.localizedDescription)
             //   let tempData : Data = Data()
 
                let msgStr =   "Unknown Error"
                fail(.requestError,msgStr,false)
            }
            else {
               
                guard let data = data else { return }
                
                
                let object = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                print("  Normal JSON   is  ",object ?? "")
                let genMsg =  object?["message"]  as? String ?? ""
                
                let responseCode = response as? HTTPURLResponse
                
                switch responseCode?.statusCode ?? 0 {
                    
                    
                case 200:
                    
                    let decoder = JSONDecoder()
                    do{
                        let resObj = try decoder.decode(T.self, from: data)
        
                        success(resObj)
                       
                    }
                    catch let err {
                        print(err.localizedDescription)
         //               DataManager.shared.showLoader(text: "Please try again")
                        fail(.requestError,"parsing error",false)
                    }
                    
                    
                    
                    
                case 400...499:
                    
                    fail(.requestError,genMsg,false)
                    
                case 500...599:
                    
                    fail(.requestError,genMsg,false)
                    
                default:
                    
                    fail(.requestError,genMsg,false)
                    
                }
                
                
                
            }
        }
        
        dataTask.resume()
     
        
    }
    // MARK: Get General List
    
    func getListWithAccessToken<T:Decodable>(dictionary:[String: Any],token: String,urlName: String,methodType:String,success:@escaping ((T) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
    //    let method = "http://192.168.1.16:3000/login"
        
        let authKey = String(format:"Bearer %@",token)
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(url: URL(string: urlName)!)
        request.httpMethod = methodType
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
       request.addValue(authKey, forHTTPHeaderField: "Authorization")
        print("Dict-----\(dictionary)")
        
        
        if(methodType != "GET"){
            let postData: Data? = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            request.httpBody = postData
        }
        
        
        
        let dataTask = session.dataTask(with: request as URLRequest) { (data,response,error) in
          //  print(response)
            
          

            if error != nil{
                print(error!.localizedDescription)
             //   let tempData : Data = Data()
 
                let msgStr =   "Unknown Error"
                fail(.requestError,msgStr,false)
            }
            else {
               
                guard let data = data else { return }
                
                
                let object = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                print("  Normal JSON   is  ",object ?? "")
                let genMsg =  object?["message"]  as? String ?? ""
                
                let responseCode = response as? HTTPURLResponse
                
                switch responseCode?.statusCode ?? 0 {
                    
                    
                case 200:
                    
                    let decoder = JSONDecoder()
                    do{
                        let resObj = try decoder.decode(T.self, from: data)
        
                        success(resObj)
                       
                    }
                    catch let err {
                        print(err.localizedDescription)
         //               DataManager.shared.showLoader(text: "Please try again")
                        fail(.requestError,"parsing error",false)
                    }
                    
                    
                    
                    
                case 400...499:
                    
                    fail(.requestError,genMsg,false)
                    
                case 500...599:
                    
                    fail(.requestError,genMsg,false)
                    
                default:
                    
                    fail(.requestError,genMsg,false)
                    
                }
                
                
                
            }
        }
        
        dataTask.resume()
     
        
    }
    
    func getGalleryListWithAccessToken(dictionary:[String: Any],token: String,urlName: String,methodType:String,success:@escaping ((GalleryListResponse) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
    //    let method = "http://192.168.1.16:3000/login"
        
        let authKey = String(format:"Bearer %@",token)
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(url: URL(string: urlName)!)
        request.httpMethod = methodType
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
       request.addValue(authKey, forHTTPHeaderField: "Authorization")
        print("Dict-----\(dictionary)")
        
        
        if(methodType != "GET"){
            let postData: Data? = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            request.httpBody = postData
        }
        
        
        
        let dataTask = session.dataTask(with: request as URLRequest) { (data,response,error) in
          //  print(response)
            
          

            if error != nil{
                print(error!.localizedDescription)
             //   let tempData : Data = Data()
 
                let msgStr =   "Unknown Error"
                fail(.requestError,msgStr,false)
            }
            else {
               
                guard let data = data else { return }
                
                
                let object = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                print("  Normal JSON   is  ",object ?? "")
                let genMsg =  object?["message"]  as? String ?? ""
                
                guard  let  key = object?.keys else { return }
                
                
                
                print("  key     ",key)
                
            
                
                if let allData = object?["data"] as? [String:Any] {
                    print(allData)
                    
                    var keys = allData.keys.first ?? ""
                    
                    if let dateSel =  allData[keys]  {
                        print(dateSel)
                    }
                    
                }
                
                let responseCode = response as? HTTPURLResponse
                
                switch responseCode?.statusCode ?? 0 {
                    
                    
                case 200:
                    
                    let decoder = JSONDecoder()
                    do{
                        let resObj = try decoder.decode(GalleryListResponse.self, from: data)
        
                        success(resObj)
                       
                    }
                    catch let err {
                        print(err.localizedDescription)
         //               DataManager.shared.showLoader(text: "Please try again")
                        fail(.requestError,"parsing error",false)
                    }
                    
                    
                    
                    
                case 400...499:
                    
                    fail(.requestError,genMsg,false)
                    
                case 500...599:
                    
                    fail(.requestError,genMsg,false)
                    
                default:
                    
                    fail(.requestError,genMsg,false)
                    
                }
                
                
                
            }
        }
        
        dataTask.resume()
     
        
    }
    
    
    // MARK:  Requst For Filter List
    
    func getFilterListWithAccessToken(dictionary:[String:String],token: String,urlName: String,methodType:String,success:@escaping ((GalleryListResponse) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
        
        let authKey = String(format:"Bearer %@",token)
   
        var components = URLComponents(string: urlName)!
        components.queryItems = dictionary.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        
        guard let url = components.url else {
                    fail(.requestError,"Fail to Load Data",false)
                    return
        }
        
       
        
        
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(url: URL(string: urlName)!)
        request.httpMethod = methodType
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
       request.addValue(authKey, forHTTPHeaderField: "Authorization")
        print("Dict-----\(dictionary)")
        
        
        if(methodType != "GET"){
            let postData: Data? = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            request.httpBody = postData
        }
        
        
        
        let dataTask = session.dataTask(with: request as URLRequest) { (data,response,error) in
          //  print(response)
            
          

            if error != nil{
                print(error!.localizedDescription)
             //   let tempData : Data = Data()
 
                let msgStr =   "Unknown Error"
                fail(.requestError,msgStr,false)
            }
            else {
               
                guard let data = data else { return }
                
                
                let object = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                print("  Normal JSON   is  ",object ?? "")
                let genMsg =  object?["message"]  as? String ?? ""
                
                guard  let  key = object?.keys else { return }
                
                
                
                print("  key     ",key)
                
            
                
                if let allData = object?["data"] as? [String:Any] {
                    print(allData)
                    
                    var keys = allData.keys.first ?? ""
                    
                    if let dateSel =  allData[keys]  {
                        print(dateSel)
                    }
                    
                }
                
                let responseCode = response as? HTTPURLResponse
                
                switch responseCode?.statusCode ?? 0 {
                    
                    
                case 200:
                    
                    let decoder = JSONDecoder()
                    do{
                        let resObj = try decoder.decode(GalleryListResponse.self, from: data)
        
                        success(resObj)
                       
                    }
                    catch let err {
                        print(err.localizedDescription)
         //               DataManager.shared.showLoader(text: "Please try again")
                        fail(.requestError,"parsing error",false)
                    }
                    
                    
                    
                    
                case 400...499:
                    
                    fail(.requestError,genMsg,false)
                    
                case 500...599:
                    
                    fail(.requestError,genMsg,false)
                    
                default:
                    
                    fail(.requestError,genMsg,false)
                    
                }
                
                
                
            }
        }
        
        dataTask.resume()
        
        
        
        
        
        
        
        
    }
    
    
    func getGalleryListWithAccessTokenDemo(dictionary:[String: Any],token: String,urlName: String,methodType:String,success:@escaping ((GalleryListResponse) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
        let jsonString = """
        
        {
                    "data": {
                        "2023": {
                            "May": {
                                "2023-05-12": [
                                    {
                                        "id": 102,
                                        "file_name": "1684236295636.jpg",
                                       
                                        "mimetype": "image/jpg",
                                        "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236295636.jpg",
                                        "title": "Dummy Image",
                                        "company_id": 1
                                    },
                                    {
                                        "id": 103,
                                        "file_name": "1684236371353.jpg",
                                       
                                        "mimetype": "image/jpg",
                                        "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236371353.jpg",
                                        "title": "Dummy Image",
                                        "company_id": 1
                                    },
                                    {
                                        "id": 104,
                                        "file_name": "1684236371353.jpg",
                                       
                                        "mimetype": "image/jpg",
                                        "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236371353.jpg",
                                        "title": "Dummy Image",
                                        "company_id": 1
                                    },
                                    {
                                        "id": 105,
                                        "file_name": "1684236371353.jpg",
                                       
                                        "mimetype": "image/jpg",
                                        "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236371353.jpg",
                                        "title": "Dummy Image",
                                        "company_id": 1
                                    },
                                    {
                                        "id": 106,
                                        "file_name": "1684236437383.jpg",
                                       
                                        "mimetype": "image/jpg",
                                        "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236437383.jpg",
                                        "title": "Dummy Image",
                                        "company_id": 1
                                    },
                                    {
                                        "id": 107,
                                        "file_name": "1684256697030.jpg",
                                       
                                        "mimetype": "image/jpg",
                                        "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684256697030.jpg",
                                        "title": "Dummy Image",
                                        "company_id": 1
                                    }
                                            
                                ],
                                "2023-05-25": [
                                    {
                                        "id": 1402,
                                        "file_name": "1684236295636.jpg",
                                       
                                        "mimetype": "image/jpg",
                                        "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236295636.jpg",
                                        "title": "Dummy Image",
                                        "company_id": 1
                                    },
                                    {
                                        "id": 1403,
                                        "file_name": "1684236371353.jpg",
                                       
                                        "mimetype": "image/jpg",
                                        "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236371353.jpg",
                                        "title": "Dummy Image",
                                        "company_id": 1
                                    },
                                    {
                                        "id": 1404,
                                        "file_name": "1684236371353.jpg",
                                       
                                        "mimetype": "image/jpg",
                                        "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236371353.jpg",
                                        "title": "Dummy Image",
                                        "company_id": 1
                                    },
                                    {
                                        "id": 1405,
                                        "file_name": "1684236371353.jpg",
                                       
                                        "mimetype": "image/jpg",
                                        "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236371353.jpg",
                                        "title": "Dummy Image",
                                        "company_id": 1
                                    },
                                    {
                                        "id": 1406,
                                        "file_name": "1684236437383.jpg",
                                       
                                        "mimetype": "image/jpg",
                                        "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236437383.jpg",
                                        "title": "Dummy Image",
                                        "company_id": 1
                                    },
                                    {
                                        "id": 1407,
                                        "file_name": "1684256697030.jpg",
                                       
                                        "mimetype": "image/jpg",
                                        "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684256697030.jpg",
                                        "title": "Dummy Image",
                                        "company_id": 1
                                    },
        {
                                        "id": 1404,
                                        "file_name": "1684236371353.jpg",
                                       
                                        "mimetype": "image/jpg",
                                        "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236371353.jpg",
                                        "title": "Dummy Image",
                                        "company_id": 1
                                    },
                                    {
                                        "id": 1405,
                                        "file_name": "1684236371353.jpg",
                                       
                                        "mimetype": "image/jpg",
                                        "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236371353.jpg",
                                        "title": "Dummy Image",
                                        "company_id": 1
                                    },
                                    {
                                        "id": 1406,
                                        "file_name": "1684236437383.jpg",
                                       
                                        "mimetype": "image/jpg",
                                        "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236437383.jpg",
                                        "title": "Dummy Image",
                                        "company_id": 1
                                    },
                                    {
                                        "id": 1407,
                                        "file_name": "1684256697030.jpg",
                                       
                                        "mimetype": "image/jpg",
                                        "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684256697030.jpg",
                                        "title": "Dummy Image",
                                        "company_id": 1
                                    }
                                ]

                            },
                           "JUN": {
                                "2023-06-22": [
                                    {
                                        "id": 102,
                                        "file_name": "1684236295636.jpg",
                                       
                                        "mimetype": "image/jpg",
                                        "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236295636.jpg",
                                        "title": "Dummy Image",
                                        "company_id": 1
                                    },
                                    {
                                        "id": 103,
                                        "file_name": "1684236371353.jpg",
                                       
                                        "mimetype": "image/jpg",
                                        "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236371353.jpg",
                                        "title": "Dummy Image",
                                        "company_id": 1
                                    },
                                    {
                                        "id": 104,
                                        "file_name": "1684236371353.jpg",
                                       
                                        "mimetype": "image/jpg",
                                        "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236371353.jpg",
                                        "title": "Dummy Image",
                                        "company_id": 1
                                    },
                                    {
                                        "id": 105,
                                        "file_name": "1684236371353.jpg",
                                       
                                        "mimetype": "image/jpg",
                                        "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236371353.jpg",
                                        "title": "Dummy Image",
                                        "company_id": 1
                                    },
                                    {
                                        "id": 106,
                                        "file_name": "1684236437383.jpg",
                                       
                                        "mimetype": "image/jpg",
                                        "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236437383.jpg",
                                        "title": "Dummy Image",
                                        "company_id": 1
                                    },
                                    {
                                        "id": 107,
                                        "file_name": "1684256697030.jpg",
                                       
                                        "mimetype": "image/jpg",
                                        "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684256697030.jpg",
                                        "title": "Dummy Image",
                                        "company_id": 1
                                    },
                                    {
                                        "id": 106,
                                        "file_name": "1684236437383.jpg",
                                       
                                        "mimetype": "image/jpg",
                                        "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236437383.jpg",
                                        "title": "Dummy Image",
                                        "company_id": 1
                                    },
                                    {
                                        "id": 107,
                                        "file_name": "1684256697030.jpg",
                                       
                                        "mimetype": "image/jpg",
                                        "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684256697030.jpg",
                                        "title": "Dummy Image",
                                        "company_id": 1
                                    }
        
                                ],
                                "2023-06-14": [
                                    {
                                        "id": 1402,
                                        "file_name": "1684236295636.jpg",
                                       
                                        "mimetype": "image/jpg",
                                        "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236295636.jpg",
                                        "title": "Dummy Image",
                                        "company_id": 1
                                    },
                                    {
                                        "id": 1403,
                                        "file_name": "1684236371353.jpg",
                                       
                                        "mimetype": "image/jpg",
                                        "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236371353.jpg",
                                        "title": "Dummy Image",
                                        "company_id": 1
                                    },
                                    {
                                        "id": 1404,
                                        "file_name": "1684236371353.jpg",
                                       
                                        "mimetype": "image/jpg",
                                        "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236371353.jpg",
                                        "title": "Dummy Image",
                                        "company_id": 1
                                    },
                                    {
                                        "id": 1405,
                                        "file_name": "1684236371353.jpg",
                                       
                                        "mimetype": "image/jpg",
                                        "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236371353.jpg",
                                        "title": "Dummy Image",
                                        "company_id": 1
                                    },
                                    {
                                        "id": 1406,
                                        "file_name": "1684236437383.jpg",
                                       
                                        "mimetype": "image/jpg",
                                        "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236437383.jpg",
                                        "title": "Dummy Image",
                                        "company_id": 1
                                    }
                                    
                                ],
                                    "2023-06-25": [
                                    {
                                        "id": 1402,
                                        "file_name": "1684236295636.jpg",
                                       
                                        "mimetype": "image/jpg",
                                        "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236295636.jpg",
                                        "title": "Dummy Image",
                                        "company_id": 1
                                    },
                                    {
                                        "id": 1403,
                                        "file_name": "1684236371353.jpg",
                                       
                                        "mimetype": "image/jpg",
                                        "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236371353.jpg",
                                        "title": "Dummy Image",
                                        "company_id": 1
                                    }
                                    
                                    
                                    
                                ]

                            }
                           
                      
                        },
                         "2022": {
                             "JAN": {
                                 "2022-01-08": [
                                     {
                                         "id": 102,
                                         "file_name": "1684236295636.jpg",
                                        
                                         "mimetype": "image/jpg",
                                         "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236295636.jpg",
                                         "title": "Dummy Image",
                                         "company_id": 1
                                     },
                                     {
                                         "id": 103,
                                         "file_name": "1684236371353.jpg",
                                        
                                         "mimetype": "image/jpg",
                                         "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236371353.jpg",
                                         "title": "Dummy Image",
                                         "company_id": 1
                                     },
                                     {
                                         "id": 104,
                                         "file_name": "1684236371353.jpg",
                                        
                                         "mimetype": "image/jpg",
                                         "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236371353.jpg",
                                         "title": "Dummy Image",
                                         "company_id": 1
                                     },
                                     {
                                         "id": 105,
                                         "file_name": "1684236371353.jpg",
                                        
                                         "mimetype": "image/jpg",
                                         "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236371353.jpg",
                                         "title": "Dummy Image",
                                         "company_id": 1
                                     },
                                     {
                                         "id": 106,
                                         "file_name": "1684236437383.jpg",
                                        
                                         "mimetype": "image/jpg",
                                         "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236437383.jpg",
                                         "title": "Dummy Image",
                                         "company_id": 1
                                     },
                                     {
                                         "id": 107,
                                         "file_name": "1684256697030.jpg",
                                        
                                         "mimetype": "image/jpg",
                                         "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684256697030.jpg",
                                         "title": "Dummy Image",
                                         "company_id": 1
                                     },{
                                         "id": 107,
                                         "file_name": "1684256697030.jpg",
                                        
                                         "mimetype": "image/jpg",
                                         "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684256697030.jpg",
                                         "title": "Dummy Image",
                                         "company_id": 1
                                     }
                                 ],
                                 "2022-01-25": [
                                     {
                                         "id": 1402,
                                         "file_name": "1684236295636.jpg",
                                        
                                         "mimetype": "image/jpg",
                                         "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236295636.jpg",
                                         "title": "Dummy Image",
                                         "company_id": 1
                                     },
                                     {
                                         "id": 1403,
                                         "file_name": "1684236371353.jpg",
                                        
                                         "mimetype": "image/jpg",
                                         "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236371353.jpg",
                                         "title": "Dummy Image",
                                         "company_id": 1
                                     },
                                     {
                                         "id": 1404,
                                         "file_name": "1684236371353.jpg",
                                        
                                         "mimetype": "image/jpg",
                                         "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236371353.jpg",
                                         "title": "Dummy Image",
                                         "company_id": 1
                                     },
                                     {
                                         "id": 1405,
                                         "file_name": "1684236371353.jpg",
                                        
                                         "mimetype": "image/jpg",
                                         "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236371353.jpg",
                                         "title": "Dummy Image",
                                         "company_id": 1
                                     },
                                     {
                                         "id": 1406,
                                         "file_name": "1684236437383.jpg",
                                        
                                         "mimetype": "image/jpg",
                                         "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236437383.jpg",
                                         "title": "Dummy Image",
                                         "company_id": 1
                                     }
                                     
                                 ]

                             },
                            "FEB": {
                                 "2022-02-09": [
                                     {
                                         "id": 102,
                                         "file_name": "1684236295636.jpg",
                                        
                                         "mimetype": "image/jpg",
                                         "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236295636.jpg",
                                         "title": "Dummy Image",
                                         "company_id": 1
                                     },
                                     {
                                         "id": 103,
                                         "file_name": "1684236371353.jpg",
                                        
                                         "mimetype": "image/jpg",
                                         "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236371353.jpg",
                                         "title": "Dummy Image",
                                         "company_id": 1
                                     },
                                     {
                                         "id": 104,
                                         "file_name": "1684236371353.jpg",
                                        
                                         "mimetype": "image/jpg",
                                         "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236371353.jpg",
                                         "title": "Dummy Image",
                                         "company_id": 1
                                     },
                                     {
                                         "id": 105,
                                         "file_name": "1684236371353.jpg",
                                        
                                         "mimetype": "image/jpg",
                                         "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236371353.jpg",
                                         "title": "Dummy Image",
                                         "company_id": 1
                                     },
                                     {
                                         "id": 106,
                                         "file_name": "1684236437383.jpg",
                                        
                                         "mimetype": "image/jpg",
                                         "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236437383.jpg",
                                         "title": "Dummy Image",
                                         "company_id": 1
                                     },
                                     {
                                         "id": 107,
                                         "file_name": "1684256697030.jpg",
                                        
                                         "mimetype": "image/jpg",
                                         "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684256697030.jpg",
                                         "title": "Dummy Image",
                                         "company_id": 1
                                     }
                                 ],
                                 "2022-02-14": [
                                     {
                                         "id": 1402,
                                         "file_name": "1684236295636.jpg",
                                        
                                         "mimetype": "image/jpg",
                                         "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236295636.jpg",
                                         "title": "Dummy Image",
                                         "company_id": 1
                                     },
                                     {
                                         "id": 1403,
                                         "file_name": "1684236371353.jpg",
                                        
                                         "mimetype": "image/jpg",
                                         "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236371353.jpg",
                                         "title": "Dummy Image",
                                         "company_id": 1
                                     },
                                     {
                                         "id": 1404,
                                         "file_name": "1684236371353.jpg",
                                        
                                         "mimetype": "image/jpg",
                                         "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236371353.jpg",
                                         "title": "Dummy Image",
                                         "company_id": 1
                                     },
                                     {
                                         "id": 1405,
                                         "file_name": "1684236371353.jpg",
                                        
                                         "mimetype": "image/jpg",
                                         "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236371353.jpg",
                                         "title": "Dummy Image",
                                         "company_id": 1
                                     },
                                     {
                                         "id": 1406,
                                         "file_name": "1684236437383.jpg",
                                        
                                         "mimetype": "image/jpg",
                                         "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236437383.jpg",
                                         "title": "Dummy Image",
                                         "company_id": 1
                                     },
                                     {
                                         "id": 1407,
                                         "file_name": "1684256697030.jpg",
                                        
                                         "mimetype": "image/jpg",
                                         "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684256697030.jpg",
                                         "title": "Dummy Image",
                                         "company_id": 1
                                     },
                                             {
                                                 "id": 1405,
                                                 "file_name": "1684236371353.jpg",
                                                
                                                 "mimetype": "image/jpg",
                                                 "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236371353.jpg",
                                                 "title": "Dummy Image",
                                                 "company_id": 1
                                             },
                                             {
                                                 "id": 1406,
                                                 "file_name": "1684236437383.jpg",
                                                
                                                 "mimetype": "image/jpg",
                                                 "path": "/storage/emulated/0/Android/data/perfect.book.keeping/files/Pictures/1684236437383.jpg",
                                                 "title": "Dummy Image",
                                                 "company_id": 1
                                             }
                                             
                                 ]
                                     

                             }
                            
                       
                         }
                         
                    },
                    "message": "findAll"
                }
        
        
        
        """
        
        
        let data = Data(jsonString.utf8)
        
        
        let decoder = JSONDecoder()
        do{
            let resObj = try decoder.decode(GalleryListResponse.self, from: data)

            success(resObj)
           
        }
        catch let err {
            print(err.localizedDescription)
//               DataManager.shared.showLoader(text: "Please try again")
            fail(.requestError,"parsing error",false)
        }
        
        
    }
    
    
    
    // MARK: Upload Profile API
    
    func uploadprofileAccessToken<T:Decodable>(dictionary:[String: Any],token: String,urlName: String,methodType:String,success:@escaping ((T) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
    //    let method = "http://192.168.1.16:3000/login"
        
        let authKey = String(format:"Bearer %@",token)
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(url: URL(string: urlName)!)
        request.httpMethod = methodType
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
       request.addValue(authKey, forHTTPHeaderField: "Authorization")
        print("Dict-----\(dictionary)")
        
        
        if(methodType != "GET"){
            let postData: Data? = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            request.httpBody = postData
        }
        
        /*
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(dictionary)
            let jsonString = String(data: jsonData, encoding: .utf8)
            print("JSON String : " + jsonString!)
            request.httpBody = postData
        }
        catch {
        }
        */
        
        
        
        let dataTask = session.dataTask(with: request as URLRequest) { (data,response,error) in
          //  print(response)
            
          

            if error != nil{
                print(error!.localizedDescription)
             //   let tempData : Data = Data()
 
                let msgStr =   "Unknown Error"
                fail(.requestError,msgStr,false)
            }
            else {
               
                guard let data = data else { return }
                
                
                let object = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                print("  Normal JSON   is  ",object ?? "")
                let genMsg =  object?["message"]  as? String ?? ""
                
                let responseCode = response as? HTTPURLResponse
                
                switch responseCode?.statusCode ?? 0 {
                    
                    
                case 200:
                    
                    let decoder = JSONDecoder()
                    do{
                        let resObj = try decoder.decode(T.self, from: data)
        
                        success(resObj)
                       
                    }
                    catch let err {
                        print(err.localizedDescription)
         //               DataManager.shared.showLoader(text: "Please try again")
                        fail(.requestError,"parsing error",false)
                    }
                    
                    
                    
                    
                case 400...499:
                    
                    fail(.requestError,genMsg,false)
                    
                case 500...599:
                    
                    fail(.requestError,genMsg,false)
                    
                default:
                    
                    fail(.requestError,genMsg,false)
                    
                }
                
                
                
            }
        }
        
        dataTask.resume()
     
        
    }
    
    
    func uploadImageWithAccessToken<T:Decodable>(dictionary:[String: Any],token: String,urlName: String,methodType:String,success:@escaping ((T) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
    //    let method = "http://192.168.1.16:3000/login"
        
        let authKey = String(format:"Bearer %@",token)
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(url: URL(string: urlName)!)
        request.httpMethod = methodType
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
       request.addValue(authKey, forHTTPHeaderField: "Authorization")
        print("Dict-----\(dictionary)")
        
        
        if(methodType != "GET"){
            let postData: Data? = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            request.httpBody = postData
        }
        
        
        
        
        
        let dataTask = session.dataTask(with: request as URLRequest) { (data,response,error) in
          //  print(response)
            
          

            if error != nil{
                print(error!.localizedDescription)
             //   let tempData : Data = Data()
 
                let msgStr =   "Unknown Error"
                fail(.requestError,msgStr,false)
            }
            else {
               
                guard let data = data else { return }
                
                
                let object = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                print("  Normal JSON   is  ",object ?? "")
                let genMsg =  object?["message"]  as? String ?? ""
                
                let responseCode = response as? HTTPURLResponse
                
                switch responseCode?.statusCode ?? 0 {
                    
                    
                case 200:
                    
                    let decoder = JSONDecoder()
                    do{
                        let resObj = try decoder.decode(T.self, from: data)
        
                        success(resObj)
                       
                    }
                    catch let err {
                        print(err.localizedDescription)
         //               DataManager.shared.showLoader(text: "Please try again")
                        fail(.requestError,"parsing error",false)
                    }
                    
                    
                    
                    
                case 400...499:
                    
                    fail(.requestError,genMsg,false)
                    
                case 500...599:
                    
                    fail(.requestError,genMsg,false)
                    
                default:
                    
                    fail(.requestError,genMsg,false)
                    
                }
                
                
                
            }
        }
        
        dataTask.resume()
     
        
    }
    
    
    
    // MARK: Get Access Token With Refresh Token
    
    func getAccessTokenWithRefreshToken<T:Decodable>(dictionary:[String: Any],token:String,urlName: String,methodType:String,success:@escaping ((T) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
     //   let authKey = String(format:"Bearer %@",token)
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(url: URL(string: urlName)!)
        request.httpMethod = methodType
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
      //  request.addValue(authKey, forHTTPHeaderField: "Authorization")
        print("Dict-----\(dictionary)")
        
        
       
            let postData: Data? = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            request.httpBody = postData
       
        
        
        
        let dataTask = session.dataTask(with: request as URLRequest) { (data,response,error) in
          //  print(response)
            
          

            if error != nil{
                print(error!.localizedDescription)
             //   let tempData : Data = Data()
 
                let msgStr =   "Unknown Error"
                fail(.requestError,msgStr,false)
            }
            else {
               
                guard let data = data else { return }
                
                
                let object = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                print("  Normal JSON   is  ",object ?? "")
                let genMsg =  object?["message"]  as? String ?? ""
                
                let responseCode = response as? HTTPURLResponse
                
                switch responseCode?.statusCode ?? 0 {
                    
                    
                case 200:
                    
                    let decoder = JSONDecoder()
                    do{
                        let resObj = try decoder.decode(T.self, from: data)
        
                        success(resObj)
                       
                    }
                    catch let err {
                        print(err.localizedDescription)
         //               DataManager.shared.showLoader(text: "Please try again")
                        fail(.requestError,"parsing error",false)
                    }
                    
                case 400...499:
                    
                    fail(.requestError,genMsg,false)
                    
                case 500...599:
                    
                    fail(.requestError,genMsg,false)
                    
                default:
                    
                    fail(.requestError,genMsg,false)
                    
                }
                
                
                
            }
        }
        
        dataTask.resume()
     
        
    }
    
    
    // MARK: First API LogIn Access Code
    
    func getAccessCodeWithEmail<T:Decodable>(dictionary:[String: Any],urlName: String,methodType:String,success:@escaping ((T,String,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
    //    let method = "http://192.168.1.16:3000/login"
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(url: URL(string: urlName)!)
        request.httpMethod = methodType
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
    //    request.addValue(accessToken, forHTTPHeaderField: "x-access-token")
        print("Dict-----\(dictionary)")
        let postData: Data? = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        request.httpBody = postData
        
        
        
        
        let dataTask = session.dataTask(with: request as URLRequest) { (data,response,error) in
          //  print(response)
            
          

            if error != nil{
                print(error!.localizedDescription)
             //   let tempData : Data = Data()
 
                let msgStr =   "Unknown Error"
                fail(.requestError,msgStr,false)
            }
            else {
               
                guard let data = data else { return }
                
                
                let object = try? JSONSerialization.jsonObject(
                    with: data,
                    options: []
                )
                print("  Normal JSON   is  ",object ?? "")
                
                
                let responseCode = response as? HTTPURLResponse
                
                switch responseCode?.statusCode ?? 0 {
                    
                    
                case 200:
                    
                    let decoder = JSONDecoder()
                    do{
                        let resObj = try decoder.decode(AccessCodeResponse.self, from: data)
                        let msgStr =   resObj.message ?? ""
                       
                        success(resObj as! T,msgStr,true)
                       
                    }
                    catch let err {
                        print(err.localizedDescription)
         //               DataManager.shared.showLoader(text: "Please try again")
                        fail(.requestError,"parsing error",false)
                    }
                    
                    
                    
                    
                case 400...499:
                    
                    fail(.requestError,"parsing error",false)
                    
                case 500...599:
                    
                    fail(.requestError,"parsing error",false)
                    
                default:
                    
                    fail(.requestError,"parsing error",false)
                    
                }
                
                
                
            }
        }
        
        dataTask.resume()
     
        
    }
    
    
    
    
    func callGeneralSubmitAPIWithToken1<T:Decodable>(dictionary:[String: Any],token: String,urlName: String,methodType:String,success:@escaping ((T,String,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
     //   let token = UserDefaults.standard.string(forKey: "strCookieValOTPonly")  ?? ""
        
        
        let authKey = String(format:"Authorization=%@",token)
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(url: URL(string: urlName)!)
        request.httpMethod = methodType
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(authKey, forHTTPHeaderField: "Cookie")
        print("Dict-----\(dictionary)")
        let postData: Data? = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        request.httpBody = postData
        
        
        
        
        let dataTask = session.dataTask(with: request as URLRequest) { (data,response,error) in
          //  print(response)
            
          

            if error != nil{
                print(error!.localizedDescription)
             //   let tempData : Data = Data()
 
                let msgStr =   "Unknown Error"
                fail(.requestError,msgStr,false)
            }
            else {
               
                guard let data = data else { return }
                
                
                let object = try? JSONSerialization.jsonObject(
                    with: data,
                    options: []
                )
                print("  Normal JSON   is  ",object ?? "")
                
                
                let responseCode = response as? HTTPURLResponse
                
                switch responseCode?.statusCode ?? 0 {
                    
                    
                case 200:
                    
                    let decoder = JSONDecoder()
                    do{
                        let resObj = try decoder.decode(CommonResponse.self, from: data)
                        let msgStr =   resObj.message ?? ""
                       
                        success(resObj as! T,msgStr,true)
                       
                    }
                    catch let err {
                        print(err.localizedDescription)
         //               DataManager.shared.showLoader(text: "Please try again")
                        fail(.requestError,"parsing error",false)
                    }
                    
                    
                    
                    
                case 400...499:
                    
                    fail(.requestError,"parsing error",false)
                    
                case 500...599:
                    
                    fail(.requestError,"parsing error",false)
                    
                default:
                    
                    fail(.requestError,"parsing error",false)
                    
                }
                
                
                
            }
        }
        
        dataTask.resume()
     
        
    }
    
    
    
    func callLoginServiceSubmit<T:Decodable>(dictionary:[String: Any],urlName:String,methodType:String, success:@escaping ((T,String,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
    //    let method = "http://192.168.1.16:3000/login"
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(url: URL(string: urlName)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
    //    request.addValue(accessToken, forHTTPHeaderField: "x-access-token")
        print("Dict-----\(dictionary)")
        let postData: Data? = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        request.httpBody = postData
        
        
        
        
        let dataTask = session.dataTask(with: request as URLRequest) { (data,response,error) in
          //  print(response)
            
          

            if error != nil{
                print(error!.localizedDescription)
             //   let tempData : Data = Data()
 
                let msgStr =   "Unknown Error"
                fail(.requestError,msgStr,false)
            }
            else {
                
             
                guard let data = data else { return }
                
                let object = try? JSONSerialization.jsonObject(
                    with: data,
                    options: []
                )  as? [String: Any]
                print("  Normal JSON   is  ",object ?? "")
                
              //  let nsDict = object as? NSDictionary
               // let genMsg =  nsDict?["message"]  as! String
                
                let genMsg =  object?["message"]  as? String ?? ""
                
                let responseCode = response as? HTTPURLResponse
                switch responseCode?.statusCode ?? 0 {
                case 200:
                    
                    let decoder = JSONDecoder()
                    do{
                        let resObj = try decoder.decode(LogInResponse.self, from: data)
                        let msgStr =   resObj.message ?? ""
                     //  let flag = resObj.flag ?? false
                        
                  /*
                         
                    guard  let url = response?.url,
                    let httpResponse = response as? HTTPURLResponse,
                    let fields = httpResponse.allHeaderFields as? [String: String]
                    else { return }
         
         
         let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: url)
            HTTPCookieStorage.shared.setCookies(cookies, for: url, mainDocumentURL: nil)
            for cookie in cookies {
                var cookieProperties = [HTTPCookiePropertyKey: Any]()
                cookieProperties[.name] = cookie.name
                cookieProperties[.value] = cookie.value
                cookieProperties[.domain] = cookie.domain
                cookieProperties[.path] = cookie.path
                cookieProperties[.version] = cookie.version
                cookieProperties[.expires] = Date().addingTimeInterval(31536000)

                let newCookie = HTTPCookie(properties: cookieProperties)
                HTTPCookieStorage.shared.setCookie(newCookie!)
                
                UserDefaults.standard.setValue(cookie.value, forKey: "strCookieVal")

                print("name: \(cookie.name) value: \(cookie.value)")
                
                
                
            }*/
         
                success(resObj as! T,msgStr,true)
                   
                        
                    }
                    catch let err {
                        print(err.localizedDescription)
         //               DataManager.shared.showLoader(text: "Please try again")
                        fail(.requestError,"Parsing Error" ,false)
                    }
                    
                    
                case 400...499:
                    
                    fail(.requestError,genMsg,false)
                    
                default:
                    
                    fail(.requestError,genMsg,false)
                    
                    
                    
                }
              
               
            }
        }
        
        dataTask.resume()
     
        
    }
    
    func callGeneralSubmitAPI<T:Decodable>(dictionary:[String: Any],urlName: String,methodType:String,success:@escaping ((T,String,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
    //    let method = "http://192.168.1.16:3000/login"
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(url: URL(string: urlName)!)
        request.httpMethod = methodType
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
    //    request.addValue(accessToken, forHTTPHeaderField: "x-access-token")
        print("Dict-----\(dictionary)")
        let postData: Data? = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        request.httpBody = postData
        
        
        
        
        let dataTask = session.dataTask(with: request as URLRequest) { (data,response,error) in
          //  print(response)
            
          

            if error != nil{
                print(error!.localizedDescription)
             //   let tempData : Data = Data()
 
                let msgStr =   "Unknown Error"
                fail(.requestError,msgStr,false)
            }
            else {
               
                guard let data = data else { return }
                
                
                let object = try? JSONSerialization.jsonObject(
                    with: data,
                    options: []
                )
                print("  Normal JSON   is  ",object ?? "")
                
                
                let responseCode = response as? HTTPURLResponse
                
                switch responseCode?.statusCode ?? 0 {
                    
                    
                case 200:
                    
                    let decoder = JSONDecoder()
                    do{
                        let resObj = try decoder.decode(CommonResponse.self, from: data)
                        let msgStr =   resObj.message ?? ""
                       
                        success(resObj as! T,msgStr,true)
                       
                    }
                    catch let err {
                        print(err.localizedDescription)
         //               DataManager.shared.showLoader(text: "Please try again")
                        fail(.requestError,"parsing error",false)
                    }
                    
                    
                    
                    
                case 400...499:
                    
                    fail(.requestError,"parsing error",false)
                    
                case 500...599:
                    
                    fail(.requestError,"parsing error",false)
                    
                default:
                    
                    fail(.requestError,"parsing error",false)
                    
                }
                
                
                
            }
        }
        
        dataTask.resume()
     
        
    }
    
    // MARK: Request Password
    
    func callGeneralSubmitAPIRequestPassword<T:Decodable>(dictionary:[String: Any],urlName: String,methodType:String,success:@escaping ((T,String,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
    //    let method = "http://192.168.1.16:3000/login"
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(url: URL(string: urlName)!)
        request.httpMethod = methodType
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
    //    request.addValue(accessToken, forHTTPHeaderField: "x-access-token")
        print("Dict-----\(dictionary)")
        let postData: Data? = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        request.httpBody = postData
        
        
        
        
        let dataTask = session.dataTask(with: request as URLRequest) { (data,response,error) in
          //  print(response)
            
          

            if error != nil{
                print(error!.localizedDescription)
             //   let tempData : Data = Data()
 
                let msgStr =   "Unknown Error"
                fail(.requestError,msgStr,false)
            }
            else {
               
                guard let data = data else { return }
                
                
                let object = try? JSONSerialization.jsonObject(
                    with: data,
                    options: []
                )
                print("  Normal JSON   is  ",object ?? "")
                
                
                let responseCode = response as? HTTPURLResponse
                
                switch responseCode?.statusCode ?? 0 {
                    
                    
                case 200:
                    
                    let decoder = JSONDecoder()
                    do{
                        let resObj = try decoder.decode(AccessCodeResponse.self, from: data)
                     //   let accessCode =   resObj.data?.access_code ?? ""
                        let message =   resObj.message ?? ""
                        success(resObj as! T,message,true)
                       
                    }
                    catch let err {
                        print(err.localizedDescription)
         //               DataManager.shared.showLoader(text: "Please try again")
                        fail(.requestError,"parsing error",false)
                    }
                    
                    
                    
                    
                case 400...499:
                    
                    fail(.requestError,"parsing error",false)
                    
                case 500...599:
                    
                    fail(.requestError,"parsing error",false)
                    
                default:
                    
                    fail(.requestError,"parsing error",false)
                    
                }
                
                
                
            }
        }
        
        dataTask.resume()
     
        
    }
    
    
    
    
    func callGeneralSubmitAPIWithToken<T:Decodable>(dictionary:[String: Any],token: String,urlName: String,methodType:String,success:@escaping ((T,String,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
     //   let token = UserDefaults.standard.string(forKey: "strCookieValOTPonly")  ?? ""
        
        
        let authKey = String(format:"Authorization=%@",token)
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(url: URL(string: urlName)!)
        request.httpMethod = methodType
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(authKey, forHTTPHeaderField: "Cookie")
        print("Dict-----\(dictionary)")
        let postData: Data? = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        request.httpBody = postData
        
        
        
        
        let dataTask = session.dataTask(with: request as URLRequest) { (data,response,error) in
          //  print(response)
            
          

            if error != nil{
                print(error!.localizedDescription)
             //   let tempData : Data = Data()
 
                let msgStr =   "Unknown Error"
                fail(.requestError,msgStr,false)
            }
            else {
               
                guard let data = data else { return }
                
                
                let object = try? JSONSerialization.jsonObject(
                    with: data,
                    options: []
                )
                print("  Normal JSON   is  ",object ?? "")
                
                
                let responseCode = response as? HTTPURLResponse
                
                switch responseCode?.statusCode ?? 0 {
                    
                    
                case 200:
                    
                    let decoder = JSONDecoder()
                    do{
                        let resObj = try decoder.decode(CommonResponse.self, from: data)
                        let msgStr =   resObj.message ?? ""
                       
                        success(resObj as! T,msgStr,true)
                       
                    }
                    catch let err {
                        print(err.localizedDescription)
         //               DataManager.shared.showLoader(text: "Please try again")
                        fail(.requestError,"parsing error",false)
                    }
                    
                    
                    
                    
                case 400...499:
                    
                    fail(.requestError,"parsing error",false)
                    
                case 500...599:
                    
                    fail(.requestError,"parsing error",false)
                    
                default:
                    
                    fail(.requestError,"parsing error",false)
                    
                }
                
                
                
            }
        }
        
        dataTask.resume()
     
        
    }
    
    
    
    func submitUserVerifyAPI<T:Decodable>(dictionary:[String: Any],urlName: String,methodType:String,success:@escaping ((T,String,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
    //    let method = "http://192.168.1.16:3000/login"
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(url: URL(string: urlName)!)
        request.httpMethod = methodType
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
   //    request.addValue(accessToken, forHTTPHeaderField: "x-access-token")
        print("Dict-----\(dictionary)")
        let postData: Data? = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        request.httpBody = postData
        
        
        
        
        let dataTask = session.dataTask(with: request as URLRequest) { (data,response,error) in
          //  print(response)
            
          

            if error != nil{
                print(error!.localizedDescription)
             //   let tempData : Data = Data()
 
                let msgStr =   "Unknown Error"
                fail(.requestError,msgStr,false)
            }
            else {
                
               
              
                
                guard let data = data else { return }
                
                
                let object = try? JSONSerialization.jsonObject(
                    with: data,
                    options: []
                )
                print("  Normal JSON   is  ",object ?? "")
                
                
                let responseCode = response as? HTTPURLResponse
                
                switch responseCode?.statusCode ?? 0 {
                    
                    
                case 200:
                    
                    let decoder = JSONDecoder()
                    do{
                        let resObj = try decoder.decode(UserResponse.self, from: data)
                        let msgStr =   resObj.message ?? ""
                       
                        success(resObj as! T,msgStr,true)
                       
                    }
                    catch let err {
                        print(err.localizedDescription)
         //               DataManager.shared.showLoader(text: "Please try again")
                        fail(.requestError,"parsing error",false)
                    }
                    
                    
                    
                    
                case 400...499:
                    
                    fail(.requestError,"parsing error",false)
                    
                case 500...599:
                    
                    fail(.requestError,"parsing error",false)
                    
                default:
                    
                    fail(.requestError,"parsing error",false)
                    
                }
                
                
                
            }
        }
        
        dataTask.resume()
     
        
    }
    
    
    
    
    func callLoginServiceSubmitOTPRequestPassword<T:Decodable>(dictionary:[String: Any],urlName:String,methodType:String, success:@escaping ((T,String,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
   
        
        let token = UserDefaults.standard.string(forKey: "strCookieVal")  ?? ""
        let authKey = String(format:"Authorization=%@",token)
        
        
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(url: URL(string: urlName)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
    //   request.addValue(authKey, forHTTPHeaderField: "Cookie")
        print("Dict-----\(dictionary)")
        let postData: Data? = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        request.httpBody = postData
        
        
        
        
        let dataTask = session.dataTask(with: request as URLRequest) { (data,response,error) in
          //  print(response)
            
          

            if error != nil{
                print(error!.localizedDescription)
           
 
                let msgStr =   "Unknown Error"
                fail(.requestError,msgStr,false)
            }
            else {
                
              
                guard let data = data else { return }
                
                let object = try? JSONSerialization.jsonObject(
                    with: data,
                    options: []
                )   as? [String: Any]
                print("  Normal JSON   is  ",object ?? "")
                let genMsg =  object?["message"]  as? String ?? ""
                
                let responseCode = response as? HTTPURLResponse
                switch responseCode?.statusCode ?? 0 {
                case 200:
                    
                    let decoder = JSONDecoder()
                    do{
                        let resObj = try decoder.decode(AccessCodeResponse.self, from: data)
                        let msgStr =   resObj.message ?? ""
                       
                        success(resObj as! T,msgStr,true)
                        
                    }catch let err {
                        print(err.localizedDescription)
                        fail(.requestError,"parsing error",false)
                    }
                    
                   
                case 400...499:
                    
                    fail(.requestError,genMsg,false)
                    
                case 500...599:
                    
                    fail(.requestError,genMsg,false)
                    
                default:
                    
                    fail(.requestError,genMsg,false)
                    
                    
                    
                }
              
            }
        }
        
        dataTask.resume()
        
       
        
    }
    
    
    
    
    func callLoginServiceSubmitOTP<T:Decodable>(dictionary:[String: Any],urlName:String,methodType:String, success:@escaping ((T,String,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
    //    let method = "http://192.168.1.16:3000/login"
        
        let token = UserDefaults.standard.string(forKey: "strCookieVal")  ?? ""
        let authKey = String(format:"Authorization=%@",token)
        
        
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(url: URL(string: urlName)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
       request.addValue(authKey, forHTTPHeaderField: "Cookie")
        print("Dict-----\(dictionary)")
        let postData: Data? = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        request.httpBody = postData
        
        
        
        
        let dataTask = session.dataTask(with: request as URLRequest) { (data,response,error) in
          //  print(response)
            
          

            if error != nil{
                print(error!.localizedDescription)
             //   let tempData : Data = Data()
 
                let msgStr =   "Unknown Error"
                fail(.requestError,msgStr,false)
            }
            else {
                
              
                guard let data = data else { return }
                
                let object = try? JSONSerialization.jsonObject(
                    with: data,
                    options: []
                )
                print("  Normal JSON   is  ",object ?? "")
                
                
                let responseCode = response as? HTTPURLResponse
                switch responseCode?.statusCode ?? 0 {
                case 200:
                    
                    let decoder = JSONDecoder()
                    do{
                        let resObj = try decoder.decode(UserResponse.self, from: data)
                        let msgStr =   resObj.message ?? ""
                     //   let flag = resObj.flag ?? false
                        
                        
                        guard  let url = response?.url,
                        let httpResponse = response as? HTTPURLResponse,
                        let fields = httpResponse.allHeaderFields as? [String: String]
                           else { return }
                        
                        
                        
                        let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: url)
                           HTTPCookieStorage.shared.setCookies(cookies, for: url, mainDocumentURL: nil)
                           for cookie in cookies {
                               var cookieProperties = [HTTPCookiePropertyKey: Any]()
                               cookieProperties[.name] = cookie.name
                               cookieProperties[.value] = cookie.value
                               cookieProperties[.domain] = cookie.domain
                               cookieProperties[.path] = cookie.path
                               cookieProperties[.version] = cookie.version
                               cookieProperties[.expires] = Date().addingTimeInterval(31536000)

                               let newCookie = HTTPCookie(properties: cookieProperties)
                               HTTPCookieStorage.shared.setCookie(newCookie!)
                               
                               //   In case of OTP   cookies will not save
                             
                             UserDefaults.standard.setValue(cookie.value, forKey: "strCookieValOTPonly")

                               print("name: \(cookie.name) value: \(cookie.value)")
                           }
                        
                     
                        
                        success(resObj as! T,msgStr,true)
                        
                    }catch let err {
                        print(err.localizedDescription)
         //               DataManager.shared.showLoader(text: "Please try again")
                        fail(.requestError,"parsing error",false)
                    }
                    
                   
                case 400...499:
                    
                    fail(.requestError,"parsing error",false)
                    
                case 500...599:
                    
                    fail(.requestError,"parsing error",false)
                    
                default:
                    
                    fail(.requestError,"parsing error",false)
                    
                    
                    
                }
              
            }
        }
        
        dataTask.resume()
        
        
        
        
        
        
    }
    
   
    
    func callLoginServiceNormal<T:Decodable>(emailidStr: String,passwordStr: String, success:@escaping ((T,String,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
        let method = "http://192.168.1.16:3000/login"
        
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json"]
        let dictionary : [String:Any]  = ["email":emailidStr,"password":passwordStr]
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(url: URL(string: method)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
      //  request.addValue(accessToken, forHTTPHeaderField: "x-access-token")
        print("Dict-----\(dictionary)")
        let postData: Data? = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        request.httpBody = postData
        
        
    }
    
    
    
    // MARK:  Requst For CountryList
    
    func requstForCountryList<T:Decodable>(dictionary:[String: String],urlName: String,methodType:String,success:@escaping ((T,String,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
   
        var components = URLComponents(string: urlName)!
        components.queryItems = dictionary.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil{
                print(error!.localizedDescription)
             //   let tempData : Data = Data()
 
                let msgStr =   "Unknown Error"
                fail(.requestError,msgStr,false)
            }else {
                guard let data = data else { return }
                
                let responseObject = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
                
                print("responseObject   is   ",responseObject ?? [:])
                
                let responseCode = response as? HTTPURLResponse
                
                switch responseCode?.statusCode ?? 0 {
                case 200...299:
                    
                    let decoder = JSONDecoder()
                    do{
                        let resObj = try decoder.decode(CountryList.self, from: data)
                        let msgStr =   resObj.message ?? ""
                        
                        success(resObj as! T,msgStr,true)
                    }catch let err {
                        print(err.localizedDescription)
         //               DataManager.shared.showLoader(text: "Please try again")
                        fail(.requestError,"parsing error",false)
                    }
                        
                    
                case 400...499:
                    
                    fail(.requestError,"Fail to Load Data",false)
                case 500...599:
                    
                    fail(.requestError,"Fail to Load Data",false)
                    
                default:
                    
                    fail(.requestError,"Fail to Load Data",false)
                    
                    
                    
                    
                }
                
                
                
            }
            
            
            
            
        }
        task.resume()
        
        
        
    }
    
    
    func requstForStateList<T:Decodable>(dictionary:[String: String],urlName: String,methodType:String,success:@escaping ((T,String,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
   
        var components = URLComponents(string: urlName)!
        components.queryItems = dictionary.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil{
                print(error!.localizedDescription)
             //   let tempData : Data = Data()
 
                let msgStr =   "Unknown Error"
                fail(.requestError,msgStr,false)
            }else {
                guard let data = data else { return }
                
                let responseObject = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
                
                print("responseObject   is   ",responseObject ?? [:])
                
                let responseCode = response as? HTTPURLResponse
                
                switch responseCode?.statusCode ?? 0 {
                case 200...299:
                    
                    let decoder = JSONDecoder()
                    do{
                        let resObj = try decoder.decode(StateResponse.self, from: data)
                        let msgStr =   resObj.message ?? ""
                        
                        success(resObj as! T,msgStr,true)
                    }catch let err {
                        print(err.localizedDescription)
         //               DataManager.shared.showLoader(text: "Please try again")
                        fail(.requestError,"parsing error",false)
                    }
                        
                    
                case 400...499:
                    
                    fail(.requestError,"Fail to Load Data",false)
                case 500...599:
                    
                    fail(.requestError,"Fail to Load Data",false)
                    
                default:
                    
                    fail(.requestError,"Fail to Load Data",false)
                    
                    
                    
                    
                }
                
                
                
            }
            
            
            
            
        }
        task.resume()
        
        
        
    }
    
    
    
    
    
    
    
    func requstForCountryList2<T:Decodable>(dictionary:[String: String],urlName: String,methodType:String,success:@escaping ((T,String,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
   
        var components = URLComponents(string: urlName)!
        components.queryItems = dictionary.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,                              // is there data
                let response = response as? HTTPURLResponse,  // is there HTTP response
                200 ..< 300 ~= response.statusCode,           // is statusCode 2XX
                error == nil                                  // was there no error
            else {
                fail(.requestError,"Fail to load data" ,false)
                return
            }
            
            let responseObject = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
            success(responseObject as! T,"",true)
        }
        task.resume()
        
        
        
    }
    
    
    
    
    
    // MARK: GET  Requst For User Profile
    
    func getUserProfileDetailWithToken<T:Decodable>(token: String,urlName: String,methodType:String,success:@escaping ((T,String,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
     
        
        let authKey = String(format:"Bearer %@",token)
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(url: URL(string: urlName)!)
        request.httpMethod = methodType
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(authKey, forHTTPHeaderField: "Authorization")
        
        
     //   request.addValue(authKey, forHTTPHeaderField: "Cookie")
        
      
        
        let dataTask = session.dataTask(with: request as URLRequest) { (data,response,error) in
          //  print(response)
            
          

            if error != nil{
                print(error!.localizedDescription)
             //   let tempData : Data = Data()
 
                let msgStr =   "Unknown Error"
                fail(.requestError,msgStr,false)
            }
            else {
               
                guard let data = data else { return }
                
                
                let object = try? JSONSerialization.jsonObject(
                    with: data,
                    options: []
                )
                print("  Normal JSON   is  ",object ?? "")
                
                
                let responseCode = response as? HTTPURLResponse
                
                switch responseCode?.statusCode ?? 0 {
                    
                    
                case 200:
                    
                    let decoder = JSONDecoder()
                    do{
                        let resObj = try decoder.decode(UserProfileResponse.self, from: data)
                        let msgStr =   resObj.message ?? ""
                       
                        success(resObj as! T,msgStr,true)
                       
                    }
                    catch let err {
                        print(err.localizedDescription)
        
                        fail(.requestError,"parsing error",false)
                    }
                  
                    
                case 400...499:
                    
                    fail(.requestError,"parsing error",false)
                    
                case 500...599:
                    
                    fail(.requestError,"parsing error",false)
                    
                default:
                    
                    fail(.requestError,"parsing error",false)
                    
                }
                
                
                
            }
        }
        
        dataTask.resume()
     
        
    }
    
    /*
     
     let url = URL(string: "http://www.stackoverflow.com")!

     let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
         guard let data = data else { return }
         print(String(data: data, encoding: .utf8)!)
     }

     task.resume()
     */
    
    
    func getUserProfileDetailDemoWithToken<T:Decodable>(dictionary:[String: Any],token: String,urlName: String,methodType:String,success:@escaping ((T,String,Bool) -> Void),fail: @escaping ((HTTPError,String,Bool) -> Void)){
        
     //   let token = UserDefaults.standard.string(forKey: "strCookieValOTPonly")  ?? ""
        
        
        let authKey = String(format:"Authorization=%@",token)
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(url: URL(string: urlName)!)
        request.httpMethod = methodType
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(authKey, forHTTPHeaderField: "Cookie")
        print("Dict-----\(dictionary)")
        let postData: Data? = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        request.httpBody = postData
        
        
        
        
        let dataTask = session.dataTask(with: request as URLRequest) { (data,response,error) in
          //  print(response)
            
          

            if error != nil{
                print(error!.localizedDescription)
             //   let tempData : Data = Data()
 
                let msgStr =   "Unknown Error"
                fail(.requestError,msgStr,false)
            }
            else {
               
                guard let data = data else { return }
                
                
                let object = try? JSONSerialization.jsonObject(
                    with: data,
                    options: []
                )
                print("  Normal JSON   is  ",object ?? "")
                
                
                let responseCode = response as? HTTPURLResponse
                
                switch responseCode?.statusCode ?? 0 {
                    
                    
                case 200:
                    
                    let decoder = JSONDecoder()
                    do{
                        let resObj = try decoder.decode(UserProfileResponse.self, from: data)
                        let msgStr =   resObj.message ?? ""
                       
                        success(resObj as! T,msgStr,true)
                       
                    }
                    catch let err {
                        print(err.localizedDescription)
         //               DataManager.shared.showLoader(text: "Please try again")
                        fail(.requestError,"parsing error",false)
                    }
                    
                    
                    
                    
                case 400...499:
                    
                    fail(.requestError,"parsing error",false)
                    
                case 500...599:
                    
                    fail(.requestError,"parsing error",false)
                    
                default:
                    
                    fail(.requestError,"parsing error",false)
                    
                }
                
                
                
            }
        }
        
        dataTask.resume()
     
        
    }
    
}
