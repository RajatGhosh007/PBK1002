//
//  HttpError.swift
//  DemoProject
//
//  Created by Rajat Ghosh on 09/11/22.
//

import Foundation

enum HTTPError: Error {
    case urlFailed
    case noData
    case requestError
    case parsingFailed
}
