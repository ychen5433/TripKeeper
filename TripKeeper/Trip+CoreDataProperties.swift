//
//  Trip+CoreDataProperties.swift
//  TripKeeper
//
//  Created by PYC on 12/23/17.
//  Copyright © 2017 PYC. All rights reserved.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var date: NSDate
    @NSManaged public var destination: String
    @NSManaged public var mileage: Double
    @NSManaged public var note: String?
    @NSManaged public var origin: String

}
