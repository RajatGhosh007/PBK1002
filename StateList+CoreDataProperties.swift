//
//  StateList+CoreDataProperties.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 10/05/23.
//
//

import Foundation
import CoreData


extension StateList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StateList> {
        return NSFetchRequest<StateList>(entityName: "StateList")
    }

    @NSManaged public var state_id: Int64
    @NSManaged public var state_name: String?
    @NSManaged public var state_abbr: String?

}

extension StateList : Identifiable {

}
