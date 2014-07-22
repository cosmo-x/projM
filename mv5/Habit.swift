//
//  Habit.swift
//  mv5
//
//  Created by cosmo on 14-7-7.
//  Copyright (c) 2014年 cosmo  studio. All rights reserved.
//

import UIKit
import CoreData
@objc(Habit)

class Habit: NSManagedObject {
    @NSManaged var habitID: NSNumber
    @NSManaged var habitName: String
    @NSManaged var isChosen: NSNumber
    @NSManaged var isCompleted: NSNumber
    @NSManaged var noteTime: NSDate
}