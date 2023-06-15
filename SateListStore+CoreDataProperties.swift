//
//  SateListStore+CoreDataProperties.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 10/05/23.
//
//

import Foundation
import CoreData


extension SateListStore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SateListStore> {
        return NSFetchRequest<SateListStore>(entityName: "SateListStore")
    }

    @NSManaged public var state_id: Int64
    @NSManaged public var state_name: String?
    @NSManaged public var state_abbr: String?

}

extension SateListStore : Identifiable {

}
