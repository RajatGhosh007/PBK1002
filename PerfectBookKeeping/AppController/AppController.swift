//
//  AppController.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 21/04/23.
//

import Foundation

import Alamofire


struct NetworkState {

    var isInternetAvailable:Bool
    {
        return NetworkReachabilityManager()!.isReachable
    }
}


class AppController {
    public static let shared = AppController()
    
    
    
    
}
    
