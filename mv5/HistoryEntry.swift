//
//  HistoryEntry.swift
//  mv5
//
//  Created by cosmo on 14-7-15.
//  Copyright (c) 2014年 cosmo  studio. All rights reserved.
//

import UIKit
import CoreData
@objc(HistoryEntry)

class HistoryEntry: NSManagedObject {
    @NSManaged var completedCount: NSNumber
    @NSManaged var date: NSDate
    @NSManaged var monthIndex: NSNumber
    @NSManaged var totalCount: NSNumber
    
    func reset() {
        let currentCalendar = NSCalendar.currentCalendar()
        let components: NSDateComponents = currentCalendar.components (.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay , fromDate: NSDate())
        self.date = currentCalendar.dateFromComponents(components)
        self.completedCount = 0
        self.monthIndex = components.year * 12 + components.month
        self.totalCount = 0
    }
    
    func increaseTotal() {
        var tCount: Int = totalCount as Int
        totalCount = ++tCount
    }
    
    func decreaseTotal() {
        var tCount: Int = totalCount as Int
        var cCount: Int = completedCount as Int
        if (tCount > 0) {
            --tCount
            if (cCount > 0) {
                --cCount
                completedCount = cCount
            }
            totalCount = tCount
        }
    }
    
    func increaseCompleted() {
        var cCount: Int = completedCount as Int
        completedCount = ++cCount
    }
    
    func decreaseCompleted() {
        var cCount: Int = completedCount as Int
        if (cCount > 0) {
            --cCount
            completedCount = cCount
        }
    }
}
