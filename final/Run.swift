//
//  Run+CoreDataClass.swift
//  final
//
//  Created by John Woods on 11/14/21.
//
//

import Foundation
import CoreData


public class Run: NSManagedObject {
    @NSManaged public var distance: String
    @NSManaged public var duration: String
    @NSManaged public var picture: NSData
    @NSManaged public var timeStamp: String
}
