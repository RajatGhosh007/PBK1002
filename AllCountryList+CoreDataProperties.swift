//
//  AllCountryList+CoreDataProperties.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 09/05/23.
//
//

import Foundation
import CoreData


extension AllCountryList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AllCountryList> {
        return NSFetchRequest<AllCountryList>(entityName: "AllCountryList")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var nicename: String?
    @NSManaged public var iso: String?
    @NSManaged public var numcode: Int64
    @NSManaged public var phonecode: Int64

}

extension AllCountryList : Identifiable {

}
