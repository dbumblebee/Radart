//
//  Weather+CoreDataProperties.swift
//  
//
//  Created by Brian Bresen on 11/18/16.
//
//

import Foundation
import CoreData


extension Weather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weather> {
        return NSFetchRequest<Weather>(entityName: "Weather");
    }

    @NSManaged public var currentDesc: String?
    @NSManaged public var currentIcon: String?
    @NSManaged public var currentTemp: Double
    @NSManaged public var windSpeed: Double
    @NSManaged public var windDirection: Double
    @NSManaged public var sunrise: Double
    @NSManaged public var sunset: Double
    @NSManaged public var locationId: String?
    @NSManaged public var locationName: String?
    @NSManaged public var currentTimestamp: Double
    @NSManaged public var radarTimestamp: Double

}
