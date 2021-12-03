//
//  UnitFormatter.swift
//  final
//
//  Created by John Woods on 11/13/21.
//

import Foundation

class UnitFormatter {
    
    
    // converts seconds to hours, minutes, seconds
    static func niceTime(duration: Int) -> String
    {
        let theTime:TimeInterval = TimeInterval(duration)
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [.pad ]
        
        return formatter.string(from: theTime)!
    }
    
    static func niceDate() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let date = Date()
        print(date)
        return dateFormatter.string(from: date)
    }
    
    static func niceDistance(length: Measurement<UnitLength>) -> String
    {
        let val:Double = length.value
        let distance:String = String(format: "%.2f",  val)
        return distance + " meters"
        
    }
    
    static func nicePace(length: Measurement<UnitLength>, seconds: Int) -> String
    {
        let kiloPerHourConversion:Double = 3.6
        var speed:Double = 0
        // meters per second
        if length.value != 0
        {
            speed = length.value / Double(seconds)
        }
        else
        {
            speed = 0
        }
        
        let kiloPerHour = speed * kiloPerHourConversion
        
        var out:String = String(format: "%.2f", kiloPerHour)
        out = out + " Km/Hour"
        return out
    }
    
}


