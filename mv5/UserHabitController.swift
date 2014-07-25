//
//  UserHabitController.swift
//  mv5
//
//  Created by cosmo on 14-7-7.
//  Copyright (c) 2014年 cosmo  studio. All rights reserved.
//

import UIKit
import CoreData

class UserHabitController: UITableViewController {
    
    @IBOutlet strong var StartPageView: UITableView!
    
    let txtCellIsChosen = " Completed !"
    let txtCellNotChosen = "Tap to complete"
    
    var userChosenHabitList : Array<AnyObject> = []
    var userDisplayHabitList : Array<AnyObject> = []
    
    init(coder aDecoder: NSCoder!) {
        StartPageView = UITableView ()
        
        super.init(coder: aDecoder)
        super.clearsSelectionOnViewWillAppear = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(animated: Bool) {
        let appDel:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let eNDisplayHabit = NSEntityDescription.entityForName("UserDisplayHabit",inManagedObjectContext:context)
        let fRChosenHabit = NSFetchRequest(entityName: "UserChosenHabit")
        let fRDisplayHabit = NSFetchRequest(entityName: "UserDisplayHabit")
        
        userChosenHabitList = context.executeFetchRequest(fRChosenHabit, error:nil)
        userDisplayHabitList = context.executeFetchRequest(fRDisplayHabit, error:nil)
        
        println("userChosenHabitList.count = \(userChosenHabitList.count)")
        println("userDisplayHabitList.count = \(userDisplayHabitList.count)")
        
        var userChosenHabitListCount: Int = userChosenHabitList.count
        var userDisplayHabitListCount: Int = userDisplayHabitList.count
        var allDisplayHabitDone: Bool = true
        
        if (userChosenHabitListCount == 0) {
            // No habit is chosen by user
            StartPageView.backgroundView = UIImageView(image: UIImage(named: "imgStart"))
        } else if (isTodayNew()) {
            // It is a new day today
            // Update userDisplayHabitList
            userDisplayHabitList.removeAll(keepCapacity: false)
            for (var i = 0; i < userChosenHabitListCount; ++i) {
                var selectedHabit: NSManagedObject = userChosenHabitList[i] as NSManagedObject
                var hID = selectedHabit.valueForKeyPath("habitID") as Int
                var hName = selectedHabit.valueForKeyPath("habitName") as String
                var newDisplayHabit = Habit(entity: eNDisplayHabit, insertIntoManagedObjectContext: context)
                newDisplayHabit.setValue(hID, forKey: "habitID")
                newDisplayHabit.setValue(hName, forKey: "habitName")
                newDisplayHabit.setValue(false, forKey: "isCompleted")
                userDisplayHabitList.append(newDisplayHabit)
            }
            context.save(nil)
            // Create new historyEntry
            insertUserHistory(userChosenHabitListCount)
            StartPageView.backgroundView = UIImageView(image: UIImage(named: "imgEmpty"))
        } else {
            // It is not a new day today
            for (var i = 0; i < userDisplayHabitListCount; ++i) {
                var data: NSManagedObject = userDisplayHabitList[i] as NSManagedObject
                if ((data.valueForKeyPath("isCompleted") as Bool?) == false) {
                    allDisplayHabitDone = false
                    break
                }
            }
            if (true == allDisplayHabitDone) {
                StartPageView.backgroundView = UIImageView(image: UIImage(named: "imgCompleted"))
            }
            else {
                StartPageView.backgroundView = UIImageView(image: UIImage(named: "imgEmpty"))
            }
        }
        self.tableView.reloadData()
    }
    
        
        
//        } else if (userDisplayHabitListCount == 0) {
//            StartPageView.backgroundView = UIImageView(image: UIImage(named: "imgCompleted"))
//        } else {
//            for (var i = 0; i < userDisplayHabitListCount; ++i) {
//                var data: NSManagedObject = userDisplayHabitList[i] as NSManagedObject
//                if ((data.valueForKeyPath("isCompleted") as Bool?) == false) {
//                    allDisplayHabitDone = false
//                    break
//                }
//            }
//            if (true == allDisplayHabitDone) {
//                StartPageView.backgroundView = UIImageView(image: UIImage(named: "imgCompleted"))
//            }
//            else {
//                StartPageView.backgroundView = UIImageView(image: UIImage(named: "imgEmpty"))
//            }
//        }
//        self.tableView.reloadData()
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // #pragma mark - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        var allCompleted: Bool = true
        if (userDisplayHabitList.count == 0) {
            return 0
        }
        for (var i = 0; i < userDisplayHabitList.count; ++i) {
            var data: NSManagedObject = userDisplayHabitList[i] as NSManagedObject
            if ((data.valueForKeyPath("isCompleted") as Bool?) == false) {
                allCompleted = false
                break
            }
        }
        if (true == allCompleted) {
            return 0            
        } else {
            return userDisplayHabitList.count
        }
    }

    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        // Configure the cell...
        var cell: UserHabitCell = tableView.dequeueReusableCellWithIdentifier("UserHabitCell", forIndexPath: indexPath) as UserHabitCell
        
        if let ip = indexPath{
            var data: NSManagedObject = userDisplayHabitList[ip.row] as NSManagedObject
            cell.HabitID = data.valueForKeyPath("habitID") as? Int
            cell.lbHabit.text = data.valueForKeyPath("habitName") as String
            cell.imgHabit.image = UIImage(named: "iconHabit\(cell.HabitID!)")
            if (true == (data.valueForKeyPath("isCompleted") as Bool)) {
                cell.lbCellTip.text = txtCellIsChosen
                cell.imgCheck.image = UIImage(named: "iconChecked")
            } else {
                cell.lbCellTip.text = txtCellNotChosen
                cell.imgCheck.image = UIImage(named: "iconUnchecked")
            }
        }
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView?, canEditRowAtIndexPath indexPath: NSIndexPath?) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath?) {
        let appDel:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let fRDisplayHabit = NSFetchRequest(entityName: "UserDisplayHabit")
        
        var cell: UserHabitCell = tableView.dequeueReusableCellWithIdentifier("UserHabitCell", forIndexPath: indexPath) as UserHabitCell
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            // Delete the row from the data source
            if let tV = tableView {
                // Delete the corresponding notification
                if (cell.HabitID) {
                    deleteTodayNotification(cell.HabitID!)
                }
                context.deleteObject(userDisplayHabitList[indexPath!.row] as NSManagedObject)
                userDisplayHabitList.removeAtIndex(indexPath!.row)
                context.save(nil)
                
                userDisplayHabitList = context.executeFetchRequest(fRDisplayHabit, error:nil)
                
                let updatedCount = userDisplayHabitList.count
                if (0 == updatedCount) {
                    StartPageView.backgroundView = UIImageView(image: UIImage(named: "imgCompleted"))
                } else {
                    var allCompleted = true
                    for (var i = 0; i < updatedCount; i++) {
                        var data: NSManagedObject = userDisplayHabitList[i] as NSManagedObject
                        if ((data.valueForKeyPath("isCompleted") as Bool) == false) {
                            allCompleted = false
                            break
                        }
                    }
                    if (true == allCompleted) {
                        StartPageView.backgroundView = UIImageView(image: UIImage(named: "imgCompleted"))
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let theSelectedCell: UserHabitCell = tableView.cellForRowAtIndexPath(indexPath) as UserHabitCell
        let hID = theSelectedCell.HabitID! as Int
        if (txtCellIsChosen != theSelectedCell.lbCellTip.text) {
            // Only select the cell if the cell is not yet selected
            println("cell select")
            theSelectedCell.lbCellTip.text = txtCellIsChosen
            theSelectedCell.imgCheck.image = UIImage(named: "iconChecked")
            
            // Delete the corresponding notification
            if (theSelectedCell.HabitID) {
                deleteTodayNotification(hID)
            }
            
            let appDel:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
            let context:NSManagedObjectContext = appDel.managedObjectContext
            let eNDisplayHabit = NSEntityDescription.entityForName("UserDisplayHabit",inManagedObjectContext:context)
            let fRChosenHabit = NSFetchRequest(entityName: "UserChosenHabit")
            let fRDisplayHabit = NSFetchRequest(entityName: "UserDisplayHabit")
            fRChosenHabit.predicate = NSPredicate(format: "habitID = %@", argumentArray: [hID])
            fRDisplayHabit.predicate = NSPredicate(format: "habitID = %@", argumentArray: [hID])
            
            var theChosenHabit: [Habit] = context.executeFetchRequest(fRChosenHabit, error:nil) as [Habit]
            var theDisplayHabit: [Habit] = context.executeFetchRequest(fRDisplayHabit, error:nil) as [Habit]
            
            if (0 != theChosenHabit.count) {
                theChosenHabit[0].isCompleted = true
            }
            if (0 != theDisplayHabit.count) {
                theDisplayHabit[0].isCompleted = true
            }
            context.save(nil)
//            userDisplayHabitList[indexPath!.row].setValue(true, forKey: "isCompleted")
            
            // Check if all the DisplayHabits are completed
            var allCompleted: Bool = true
            for (var i = 0; i < userDisplayHabitList.count; i++) {
                var data: NSManagedObject = userDisplayHabitList[i] as NSManagedObject
                if ((data.valueForKeyPath("isCompleted") as Bool) == false) {
                    allCompleted = false
                    break
                }
            }
            if (true == allCompleted) {
                StartPageView.backgroundView = UIImageView(image: UIImage(named: "imgCompleted"))
            }
            updateUserHistory(userDisplayHabitList.count)
        }
        self.tableView.reloadData()
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView?, moveRowAtIndexPath fromIndexPath: NSIndexPath?, toIndexPath: NSIndexPath?) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView?, canMoveRowAtIndexPath indexPath: NSIndexPath?) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    func getCurrentDate() -> NSDate {
        let currentCalendar = NSCalendar.currentCalendar()
        let components: NSDateComponents = currentCalendar.components (.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay , fromDate: NSDate())
        return currentCalendar.dateFromComponents(components)
    }
    
    func deleteTodayNotification(habitID: Int) {
        println("deleteNotification for habit \(habitID)")
        var notification: UILocalNotification?
        var notify: UILocalNotification?
        for notify in UIApplication.sharedApplication().scheduledLocalNotifications {
            if(notify.userInfo!.valueForKey("habitID") as NSObject == habitID) {
                notification = notify as? UILocalNotification
                break
            }
        }
        if notification {
            var newNotification: UILocalNotification = UILocalNotification()
            newNotification.category = notification!.category
            newNotification.userInfo = notification!.userInfo
            newNotification.alertBody = notification!.alertBody
            newNotification.applicationIconBadgeNumber = 1
            newNotification.alertLaunchImage = notification!.alertLaunchImage
            newNotification.fireDate = notification!.fireDate.dateByAddingTimeInterval(86400)
            newNotification.repeatInterval = NSCalendarUnit.DayCalendarUnit

            UIApplication.sharedApplication().cancelLocalNotification(notification)
            UIApplication.sharedApplication().scheduleLocalNotification(newNotification)
        }
        println("AFTER deleteTodayNotification: \(UIApplication.sharedApplication().scheduledLocalNotifications)")
    }
    
    func isTodayNew() -> Bool {
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context: NSManagedObjectContext = appDel.managedObjectContext
        let eNUserHistory = NSEntityDescription.entityForName("UserHistory", inManagedObjectContext:context)
        let pred: NSPredicate = NSPredicate(format: "date = %@", argumentArray: [getCurrentDate()])
        let fRUserHistory = NSFetchRequest(entityName: "UserHistory")
        fRUserHistory.predicate = pred
        
        let UserHistory = context.executeFetchRequest(fRUserHistory, error:nil)
        
        return (UserHistory.count == 0) ? true: false
    }
    
    func insertUserHistory (tCount: Int) {
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context: NSManagedObjectContext = appDel.managedObjectContext
        let eNUserHistory = NSEntityDescription.entityForName("UserHistory", inManagedObjectContext:context)
        let historyEntry = HistoryEntry(completedCount: 0, date: getCurrentDate(), totalCount: tCount, entity: eNUserHistory, insertIntoManagedObjectContext: context)
        println("newHistoryEntry: \(historyEntry)")
        context.save(nil)
    }
    
    func updateUserHistory(totalCount: Int) {
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context: NSManagedObjectContext = appDel.managedObjectContext
        let eNUserHistory = NSEntityDescription.entityForName("UserHistory", inManagedObjectContext:context)
        
        let pred: NSPredicate = NSPredicate(format: "date = %@", argumentArray: [getCurrentDate()])
        let fRUserHistory = NSFetchRequest(entityName: "UserHistory")
        fRUserHistory.predicate = pred
        
        var UserHistory: [HistoryEntry] = context.executeFetchRequest(fRUserHistory, error:nil) as [HistoryEntry]
        
        if (0 == UserHistory.count) {
            // There is not yet an entry in the entity UserHistory
            insertUserHistory(totalCount)
            UserHistory = context.executeFetchRequest(fRUserHistory, error:nil) as [HistoryEntry]
        } else {
            // There is already an entry in the entity UserHistory
            UserHistory[0].increaseCompleted()
        }
        context.save(nil)
        UserHistory = context.executeFetchRequest(fRUserHistory, error:nil) as [HistoryEntry]
        println("Updated UserHistory \(UserHistory)")
    }

}