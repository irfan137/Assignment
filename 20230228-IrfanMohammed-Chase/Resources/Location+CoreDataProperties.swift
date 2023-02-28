//
//  Location+CoreDataProperties.swift
//  20230228-IrfanMohammed-Chase
//
//  Created by Irfan Mohammed on 2/28/23.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var tempType: String?
    @NSManaged public var temp: Double
    @NSManaged public var name: String?
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var id: Int32
    @NSManaged public var currentDate: Double
    @NSManaged public var country: String?

}

extension Location : Identifiable {

}
