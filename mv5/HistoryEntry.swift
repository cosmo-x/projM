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
    
    func decreaseCompleted() {
        let cCount: Int = completedCount as Int
        if (cCount > 0) {
            self.completedCount = cCount - 1
        }
    }
    
    func decreaseTotal() {
        let tCount: Int = totalCount as Int
        if (tCount > 0) {
            self.totalCount = tCount - 1
        }
    }
    
    func increaseCompleted() {
        let cCount: Int = completedCount as Int
        self.completedCount = cCount + 1
    }
    
    func increaseTotal() {
        let tCount: Int = totalCount as Int
        self.totalCount = tCount + 1
    }
    
}
