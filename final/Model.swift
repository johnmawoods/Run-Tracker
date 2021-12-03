//
//  Run+CoreDataProperties.swift
//  final
//
//  Created by John Woods on 11/14/21.
//
//

import Foundation
import CoreData
import UIKit

public class Model {
    let managedObjectContext:NSManagedObjectContext?
    
    var fetchResults = [Run]()
    
    init(context: NSManagedObjectContext)
    {
        managedObjectContext = context
    }
    
    func fetchRecord() -> Int {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Run")

        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "timeStamp", ascending: true),
            NSSortDescriptor(key: "duration", ascending: true)
        ]
        var x = 0
        // Execute the fetch request, and cast the results to an array of Run objects
        fetchResults = ((try? managedObjectContext?.fetch(fetchRequest)) as? [Run])!
        
        x = fetchResults.count
        print(x)
        // return how many entities in the coreData
        return x
    }
    
    func SaveContext(distance:String, duration:String, picture:NSData, timeStamp:String)
    {
        // get a handler to the Devices entity through the managed object context
        let ent = NSEntityDescription.entity(forEntityName: "Run", in: self.managedObjectContext!)
        
        // create a device object instance for insert
        let runObj = Run(entity: ent!, insertInto: managedObjectContext)
        
        // add data to each field in the entity
        runObj.distance = distance
        runObj.duration = duration
        runObj.timeStamp = timeStamp
        
        print(distance)
        print(timeStamp)
        print(duration)
        
       // if picture.isEmpty
        //{
        //    runObj.picture = nil
        //}
       // else
       // {
            runObj.picture = picture
       // }
        
        do {
            // save the updated managed object context
            try managedObjectContext?.save()
        } catch {
            
        }
        
    }
    
    func deleteElement(item:Int)
    {
        managedObjectContext?.delete(fetchResults[item])
        fetchResults.remove(at:item)
        
        do {
            // save the updated managed object context
            try managedObjectContext?.save()
        } catch {
            
        }
    }
    
    
    
}


