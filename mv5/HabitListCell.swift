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
        let eNDisplayHabit = NSEntityDescription.entityForName("UserDisplayHabit",inManagedObjectContext:context)
        let eNUserHistory = NSEntityDescription.entityForName("UserHistory",inManagedObjectContext:context)
        let fRChosenHabit = NSFetchRequest(entityName: "UserChosenHabit")
        let fRDisplayHabit = NSFetchRequest(entityName: "UserDisplayHabit")
        let fRUserHistory = NSFetchRequest(entityName: "UserHistory")
        if let hID = HabitID {
            var fRChosenHabit = NSFetchRequest(entityName: "UserChosenHabit")
            var chosenHabits: [Habit] = context.executeFetchRequest(fRChosenHabit, error:nil) as [Habit]
            var chosenHabitsCount = chosenHabits.count
            
            if (true == swHabitIsChosen.on) {
                // Insert the new habit
                println("Habit \(hID) set to true")
                self.lbCellTip.text = "Tap to unchoose"
                
                var newChosenHabit = Habit(entity: eNChosenHabit, insertIntoManagedObjectContext: context)
                newChosenHabit.setValue(hID, forKey: "habitID")
                newChosenHabit.setValue(lbHabit.text, forKey: "habitName")
                newChosenHabit.setValue(false, forKey: "isCompleted")
                // noteTime is reserved for possible future use
                newChosenHabit.setValue(getCurrentDate(),forKey: "noteTime")
                ++chosenHabitsCount
                
                var newDisplayHabit = Habit(entity: eNDisplayHabit, insertIntoManagedObjectContext: context)
                newDisplayHabit.setValue(hID, forKey: "habitID")
                newDisplayHabit.setValue(lbHabit.text, forKey: "habitName")
                newDisplayHabit.setValue(false, forKey: "isCompleted")
                context.save(nil)
                
                updateUserHistory(true, totalCount: chosenHabitsCount, habitID: hID)
                addNotification(hID)

            } else {
                // Delete the select habit
                println("Habit \(hID) set to false")
                self.lbCellTip.text = "Tap to choose"
                fRChosenHabit.predicate = NSPredicate(format: "habitID = %@", argumentArray: [hID])
                fRDisplayHabit.predicate = NSPredicate(format: "habitID = %@", argumentArray: [hID])
                let theChosenHabit: [Habit] = context.executeFetchRequest(fRChosenHabit, error:nil) as [Habit]
                let theDisplayHabit: [Habit] = context.executeFetchRequest(fRDisplayHabit, error:nil) as [Habit]
                
                if (0 != theChosenHabit.count) {
                    --chosenHabitsCount
                    updateUserHistory(false, totalCount: chosenHabitsCount, habitID: hID)
                    context.deleteObject(theChosenHabit[0])
                    if (0 != theDisplayHabit.count) {
                        context.deleteObject(theDisplayHabit[0])
                    }
                    context.save(nil)
                    deleteNotification(hID)
                } else {
                    println("The habit you want to delete is not chosen")
                }
            }
            chosenHabits = context.executeFetchRequest(fRChosenHabit, error:nil) as [Habit]
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
    
//    func updateUserHistory(totalCount: Int) {
//        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
//        let context: NSManagedObjectContext = appDel.managedObjectContext
//        let eNUserHistory = NSEntityDescription.entityForName("UserHistory", inManagedObjectContext:context)
//        
//        let pred: NSPredicate = NSPredicate(format: "date = %@", argumentArray: [getCurrentDate()])
//        let fRUserHistory = NSFetchRequest(entityName: "UserHistory")
//        fRUserHistory.predicate = pred
//        
//        var UserHistory: [HistoryEntry] = context.executeFetchRequest(fRUserHistory, error:nil) as [HistoryEntry]
//        
//        if (0 == UserHistory.count) {
//            // There is not yet an entry in the entity UserHistory
//            insertUserHistory(0, tCount: totalCount)
//        } else {
//            // There is already an entry in the entity UserHistory
//            UserHistory[0].increaseCompleted()
//        }
//        context.save(nil)
//        UserHistory = context.executeFetchRequest(fRUserHistory, error:nil) as [HistoryEntry]
//        println("Updated UserHistory \(UserHistory)")
//    }

    func insertUserHistory (tCount: Int) {
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context: NSManagedObjectContext = appDel.managedObjectContext
        let eNUserHistory = NSEntityDescription.entityForName("UserHistory", inManagedObjectContext:context)
        let historyEntry = HistoryEntry(completedCount: 0, date: getCurrentDate(), totalCount: tCount, entity: eNUserHistory, insertIntoManagedObjectContext: context)
        println("newHistoryEntry: \(historyEntry)")
        context.save(nil)
    }
    
    
    func updateUserHistory(Insert: Bool, totalCount: Int, habitID: Int) {
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context: NSManagedObjectContext = appDel.managedObjectContext
        let eNUserHistory = NSEntityDescription.entityForName("UserHistory", inManagedObjectContext:context)
        let fRUserHistory = NSFetchRequest(entityName: "UserHistory")
        fRUserHistory.predicate = NSPredicate(format: "date = %@", argumentArray: [getCurrentDate()])

        var UserHistory: [HistoryEntry] = context.executeFetchRequest(fRUserHistory, error:nil) as [HistoryEntry]
        
        if (UserHistory.count == 0) {
            // There is not yet an entry in the entity UserHistory
            insertUserHistory(totalCount)
        } else {
            // There is already an entry in the entity UserHistory
            if (true == Insert) {
                // A new habit is chosen by user
                UserHistory[0].increaseTotal()
            } else {
                // A habit is deleted by user
                UserHistory[0].decreaseTotal()
                // Decide if the completedCount needs to be decreased
                let fRChosenHabit = NSFetchRequest(entityName: "UserChosenHabit")
                fRChosenHabit.predicate = NSPredicate(format: "habitID = %@", argumentArray: [habitID])
                let userChosen: [Habit] = context.executeFetchRequest(fRChosenHabit, error:nil) as [Habit]
                if (userChosen[0].isCompleted) {
                    UserHistory[0].decreaseCompleted()
                }
            }
        }
        context.save(nil)
        UserHistory = context.executeFetchRequest(fRUserHistory, error:nil) as [HistoryEntry]
        println(UserHistory)
    }
    
    func addNotification(habitID: Int) {
        println("addNotification for habit \(habitID)")
        
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
    
}
