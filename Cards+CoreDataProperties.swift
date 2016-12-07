//
//  Cards+CoreDataProperties.swift
//  MatchIQ
//
//  Created by arash parnia on 07/12/2016.
//  Copyright © 2016 arash parnia. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Cards {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cards> {
        return NSFetchRequest<Cards>(entityName: "Cards");
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var shrt_description: String?
    @NSManaged public var image: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var address: String?

}
