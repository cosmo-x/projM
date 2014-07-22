//
//  UserHabitCell.swift
//  mv5
//
//  Created by cosmo on 14-7-7.
//  Copyright (c) 2014年 cosmo  studio. All rights reserved.
//

import UIKit
import CoreData

class UserHabitCell: UITableViewCell {
    
    var HabitID : Int?
    
    @IBOutlet var imgHabit: UIImageView?
    @IBOutlet var imgCheck: UIImageView?
    @IBOutlet var lbHabit: UILabel?
    @IBOutlet var lbCellTip: UILabel?
//    @IBOutlet var HabitIsCompleted: UISwitch
//    
//    @IBAction func valueCompletedChange(sender: AnyObject) {
//        let appDel:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
//        let context:NSManagedObjectContext = appDel.managedObjectContext
//        
//        let eNDisplayHabit = NSEntityDescription.entityForName("UserDisplayHabit",inManagedObjectContext:context)
//        var fRDisplayHabit = NSFetchRequest(entityName: "UserDisplayHabit")
//        
//        if HabitIsCompleted.on == true {
//            // Complete the habit
//            println("set to true")
//            var Habits  = context.executeFetchRequest(fRDisplayHabit, error:nil)
//            for (var i = 0 as Int; i < Habits.count; ++i) {
//                var selectedHabit: NSManagedObject = Habits[i] as NSManagedObject
//                var tempID = selectedHabit.valueForKeyPath("habitID") as Int
//                if (tempID == HabitID!) {
//                    selectedHabit.setValue(true, forKey: "isCompleted")
//                    context.save(nil)
//                    println("Habit \(tempID) set to true")
//                }
//            }
//        }else{
//            // Uncomplete the habit
//            println("set to false")
//            var Habits  = context.executeFetchRequest(fRDisplayHabit, error:nil)
//            for (var i = 0 as Int; i < Habits.count; ++i) {
//                var selectedHabit: NSManagedObject = Habits[i] as NSManagedObject
//                var tempID = selectedHabit.valueForKeyPath("habitID") as Int
//                if (tempID == HabitID!) {
//                    selectedHabit.setValue(false, forKey: "isCompleted")
//                    context.save(nil)
////                    var cell: UITableViewCell = self as UITableViewCell
////                    cell.HabitLabel.text = "no longer"
////                    var table: UIView = cell.superview as UIView
////                    var parentTableView: UITableView = superview as UITableView
////                    parentTableView.reloadData()                    
//                    println("Habit \(tempID) set to false")
//                }
//            }
//        }
//    }
    
    init(style: UITableViewCellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
