//
//  HabitListCell.swift
//  mv5
//
//  Created by cosmo on 14-7-7.
//  Copyright (c) 2014年 cosmo  studio. All rights reserved.
//

import UIKit
import CoreData

class HabitListCell: UITableViewCell {
    
    var HabitID: Int?
    
    @IBOutlet var imgHabit: UIImageView!
    @IBOutlet var lbHabit: UILabel!
    @IBOutlet var lbCellTip: UILabel!
    @IBOutlet var swHabitIsChosen: UISwitch!
        
    @IBAction func valueChosenChange(sender: AnyObject) {
        let appDel:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let eNChosenHabit = NSEntityDescription.entityForName("UserChosenHabit",inManagedObjectContext:context)
        let fRChosenHabit = NSFetchRequest(entityName: "UserChosenHabit")
        
        let eNDisplayHabit = NSEntityDescription.entityForName("UserDisplayHabit",inManagedObjectContext:context)
        let fRDisplayHabit = NSFetchRequest(entityName: "UserDisplayHabit")
        
        let eNUserHistory = NSEntityDescription.entityForName("UserHistory",inManagedObjectContext:context)
        let fRUserHistory = NSFetchRequest(entityName: "UserHistory")
        if let hID = HabitID {
            if swHabitIsChosen.on == true {
                // Insert the new habit
                println("Habit \(hID) set to true")
                
                lbCellTip.text = "Tap to unchoose"
                
                var newChosenHabit = Habit(entity: eNChosenHabit, insertIntoManagedObjectContext: context)
                newChosenHabit.setValue(hID, forKey: "habitID")
                newChosenHabit.setValue(lbHabit.text, forKey: "habitName")
                newChosenHabit.setValue(false, forKey: "isCompleted")
                newChosenHabit.setValue(getCurrentDate(),forKey: "noteTime")
                
                var newDisplayHabit = Habit(entity: eNDisplayHabit, insertIntoManagedObjectContext: context)
                newDisplayHabit.setValue(hID, forKey: "habitID")
                newDisplayHabit.setValue(lbHabit.text, forKey: "habitName")
                newDisplayHabit.setValue(false, forKey: "isCompleted")
                context.save(nil)
                
                addNotification(hID)
                updateUserHistory(true)

            } else {
                // Delete the select habit
                println("Habit \(hID) set to false")
                self.lbCellTip.text = "Tap to choose"
                var ChosenHabits = context.executeFetchRequest(fRChosenHabit, error:nil)
                
                for (var i = 0 as Int; i < ChosenHabits.count; ++i) {
                    var selectedHabit: NSManagedObject = ChosenHabits[i] as NSManagedObject
                    var tempID = selectedHabit.valueForKeyPath("habitID") as Int
                    if (tempID == hID) {
                        println("Habit \(tempID) in ChosenHabit set to false")
                        context.deleteObject(selectedHabit)
                        context.save(nil)
                    }
                }
                
                var DisplayHabits  = context.executeFetchRequest(fRDisplayHabit, error:nil)
                for (var i = 0 as Int; i < DisplayHabits.count; ++i) {
                    var selectedHabit: NSManagedObject = DisplayHabits[i] as NSManagedObject
                    var tempID = selectedHabit.valueForKeyPath("habitID") as Int
                    if (tempID == HabitID!) {
                        println("Habit \(tempID) in DisplayHabit set to false")
                        context.deleteObject(selectedHabit)
                        context.save(nil)
                    }
                }
                deleteNotification(hID)
                updateUserHistory(false)
            }
        }
    }
    
    init(style: UITableViewCellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func getCurrentDate() -> NSDate {
        let currentCalendar = NSCalendar.currentCalendar()
        let components: NSDateComponents = currentCalendar.components (.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay , fromDate: NSDate())
        return currentCalendar.dateFromComponents(components)
    }
    
    func getRandomNotificationTime() -> NSDate {
        // Setting the time range for the notifications
        let startNotificationHour: Float = 9
        let endNotificationHour: Float = 22
        let gapBetweenTimeNode: Float = 0.5 // In the units of hour
        
        var totalIndex: Int = Int(((endNotificationHour - startNotificationHour) / gapBetweenTimeNode) + 1)
        var index: Int = Int( Float(rand()) / Float(RAND_MAX) * Float(totalIndex) )
        var time: Float = startNotificationHour + gapBetweenTimeNode * Float(index)
        
        // Get current calendar
        let currentCalendar = NSCalendar.currentCalendar()
        var components: NSDateComponents = currentCalendar.components (.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay , fromDate: NSDate())
        
        components.hour = Int(time)
        components.minute = Int((time - Float(Int(time))) * 60)
        components.timeZone = NSTimeZone.systemTimeZone()
        
        var calender:NSCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        var date:NSDate = calender.dateFromComponents(components)
        
        println("Notification time = \(date)")
        return date
    }
    
    func updateUserHistory(Insert: Bool) {
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context: NSManagedObjectContext = appDel.managedObjectContext
        let eNUserHistory = NSEntityDescription.entityForName("UserHistory", inManagedObjectContext:context)
        let searchText = [(getCurrentDate())]
        println("SearchText: \(searchText)")
        
        var pred: NSPredicate = NSPredicate(format: "date = %@", argumentArray: searchText)
        println("Predicate: \(pred)")
        
        var fRUserHistory = NSFetchRequest(entityName: "UserHistory")
        fRUserHistory.predicate = pred
        println("Fetch request: \(fRUserHistory)")
        
        var UserHistory = context.executeFetchRequest(fRUserHistory, error:nil)
        
        if (UserHistory.count != 0) {
            // There is already an entry in the entity UserHistory
            var historyEntry = HistoryEntry(entity: eNUserHistory, insertIntoManagedObjectContext: context)
            historyEntry = UserHistory[0] as HistoryEntry
            if (true == Insert) {
                // A new habit is chosen by user
                historyEntry.increaseTotal()
            } else {
                // A habit is deleted by user
                historyEntry.decreaseTotal()
            }
        } else {
            // There is not yet an entry in the entity UserHistory
            var historyEntry = HistoryEntry(entity: eNUserHistory, insertIntoManagedObjectContext: context)
            historyEntry.reset()
            if (true == Insert) {
                // A new habit is chosen by user
                historyEntry.increaseTotal()
                println("This is it")
            }
        }
        context.save(nil)
        UserHistory = context.executeFetchRequest(fRUserHistory, error:nil)
        println(UserHistory)
    }
    
    func addNotification(habitID: Int) {
        println("addNotification for habit \(habitID)")
//        NSNotificationCenter.defaultCenter().addObserver(self, selector:"actionComplete:", name: "completePressed", object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector:"actionLater:", name: "laterPressed", object: nil)
        
        let alertText = self.lbHabit.text
        var notification:UILocalNotification = UILocalNotification()
        notification.category = "FIRST_CATEGORY"
        notification.userInfo = ["habitID": Int(self.HabitID!)]
        notification.alertBody = "Have you \(alertText) today?"
        notification.alertLaunchImage = "iconHabit\(self.HabitID).png"
        notification.applicationIconBadgeNumber = 1
        notification.fireDate = getRandomNotificationTime()
        notification.repeatInterval = NSCalendarUnit.DayCalendarUnit
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        println("-----> Notification: \(UIApplication.sharedApplication().scheduledLocalNotifications)")
    }
    
    func deleteNotification(hID: Int) {
        var notification: UILocalNotification?
        var notify: UILocalNotification
        for (var i = 0; i < UIApplication.sharedApplication().scheduledLocalNotifications.count; ++i) {
            notify = UIApplication.sharedApplication().scheduledLocalNotifications[i] as UILocalNotification
            let notifyID: Int = notify.userInfo["habitID"]! as Int
            if(notifyID == hID) {
                notification = notify as UILocalNotification
                println("Deleting notification for habit \(notification!.userInfo)")
                break
            }
        }
        if notification {
            println("$$$ Successfully find corresponding notification")
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        } else {
            println("!!!Cannot find corresponding notification")
        }
        println("-----> Notification: \(UIApplication.sharedApplication().scheduledLocalNotifications)")
    }
    
//    func actionComplete(notification:NSNotification) {
//        println("actionComplete: Do nothing")
//        println(notification.userInfo)
//       
//    }
    
//    func actionLater(notification:NSNotification) {
//        println("actionLater: Do nothing")
////        // Delete the current notification
////        var notification: UILocalNotification?
////        var notify: UILocalNotification
////        for (var i = 0; i < UIApplication.sharedApplication().scheduledLocalNotifications.count; ++i) {
////            notify = UIApplication.sharedApplication().scheduledLocalNotifications[i] as UILocalNotification
////            let notifyID: Int = notify.userInfo["habitID"]! as Int
////            if(notifyID == hID) {
////                notification = notify as UILocalNotification
////                println("Deleting notification for habit \(notification!.userInfo)")
////                break
////            }
////        }
////        if notification {
////            println("$$$ Successfully find corresponding notification")
////            UIApplication.sharedApplication().cancelLocalNotification(notification)
////        } else {
////            println("!!!Cannot find corresponding notification")
////        }
////        println("-----> Notification: \(UIApplication.sharedApplication().scheduledLocalNotifications)")
////        
////        // Add notification
////        println("addNotification for habit \(habitID)")
////        NSNotificationCenter.defaultCenter().addObserver(self, selector:"actionComplete:", name: "completePressed", object: nil)
////        NSNotificationCenter.defaultCenter().addObserver(self, selector:"actionLater:", name: "laterPressed", object: nil)
////        
////        let alertText = self.lbHabit.text
////        var notification:UILocalNotification = UILocalNotification()
////        notification.category = "FIRST_CATEGORY"
////        notification.userInfo = ["habitID": Int(self.HabitID!)]
////        notification.alertBody = "Have you \(alertText) today?"
////        notification.alertLaunchImage = "iconHabit\(self.HabitID).png"
////        notification.applicationIconBadgeNumber++
////        notification.fireDate = getRandomNotificationTime()
////        notification.repeatInterval = NSCalendarUnit.DayCalendarUnit
////        
////        UIApplication.sharedApplication().scheduleLocalNotification(notification)
////        println("-----> Notification: \(UIApplication.sharedApplication().scheduledLocalNotifications)")
//    }
    
}
