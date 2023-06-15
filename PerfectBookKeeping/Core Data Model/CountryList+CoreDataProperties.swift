//
//  CountryList+CoreDataProperties.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 09/05/23.
//
//

import Foundation
import CoreData


extension CountryList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CountryList> {
        return NSFetchRequest<CountryList>(entityName: "CountryList")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var nicename: String?
    @NSManaged public var iso: String?
    @NSManaged public var phonecode: Int64
    @NSManaged public var numcode: Int64

}

extension CountryList : Identifiable {

}
