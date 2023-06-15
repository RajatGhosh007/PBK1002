//
//  CropUploadImageList+CoreDataProperties.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 15/06/23.
//
//

import Foundation
import CoreData


extension CropUploadImageList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CropUploadImageList> {
        return NSFetchRequest<CropUploadImageList>(entityName: "CropUploadImageList")
    }

    @NSManaged public var bw_status: Bool
    @NSManaged public var company_id: String?
    @NSManaged public var file_date: String?
    @NSManaged public var file_name: String?
    @NSManaged public var file_path: String?
    @NSManaged public var for_upload: Bool
    @NSManaged public var id: String?
    @NSManaged public var imageID: String?
    @NSManaged public var mime_type: String?
    @NSManaged public var snap_image: String?
    @NSManaged public var temp_snap_image: String?
    @NSManaged public var title: String?
    @NSManaged public var upload_status: Bool

}

extension CropUploadImageList : Identifiable {

}
