//
//  HabitListController.swift
//  mv5
//
//  Created by cosmo on 14-7-7.
//  Copyright (c) 2014年 cosmo  studio. All rights reserved.
//

import UIKit
import CoreData

let DictionaryHaibitList = [
    0: "Break a bad habit",
    1: "Contact a close friend",
    2: "Enjoy a hobby",
    3: "Do your work",
    4: "Stay hydrated",
    5: "Eat healty",
    6: "Get active",
    7: "Get enough sleep",
    8: "Go green",
    9: "Go outside",
    10: "Maintain good Hygene",
    11: "Learn something new",
    12: "Love your family",
    13: "Maintain good posture",
    14: "Meditate",
    15: "Read",
    16: "Relax",
    17: "Save up some money",
    18: "Stay positive",
    19: "Stay sober",
    20: "Strech",
    21: "Try something new",
    22: "Walk/Bike/Run",
    23: "Write",
    24: "Pursue your dreams"
]

class HabitListController: UITableViewController {
    
    let txtCellIsChosen = "Tap to unchoose"
    let txtCellNotChosen = "Tap to choose"
    
    var HabitListArrary : Array <Int> = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]
    var HabitChosenArray : Array <Bool>= [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
     
    override func viewWillAppear(animated: Bool) {
        let appDel:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let eNChosenHabit = NSEntityDescription.entityForName("UserChosenHabit",inManagedObjectContext:context)
        let eNUserHistory = NSEntityDescription.entityForName("UserHistory",inManagedObjectContext:context)
        let fRChosenHabit = NSFetchRequest(entityName: "UserChosenHabit")
        let fRUserHistory = NSFetchRequest(entityName: "UserHistory")
        
        var Habits  = context.executeFetchRequest(fRChosenHabit, error:nil)
        for (var i = 0 as Int; i < Habits.count; ++i) {
            var selectedHabits: NSManagedObject = Habits[i] as NSManagedObject
            var tempID = selectedHabits.valueForKeyPath("habitID") as Int
            HabitChosenArray[tempID] = true
        }
        tableView.reloadData()
    }
    
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
        return HabitListArrary.count
        
    }

    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
//        let CellID: NSString = "HabitListCell"
//        var cell: HabitListCell = tableView?.dequeueReusableCellWithIdentifier(CellID) as HabitListCell
        
        var cell:HabitListCell = tableView.dequeueReusableCellWithIdentifier("HabitListCell", forIndexPath: indexPath) as HabitListCell
        
        if let ip = indexPath {
            cell.HabitID = ip.row as Int
            cell.lbHabit.text = DictionaryHaibitList[ip.row]! as String
            cell.swHabitIsChosen.on = HabitChosenArray[ip.row]
            if (true == cell.swHabitIsChosen.on) {
                cell.lbCellTip.text = txtCellIsChosen
            } else {
                cell.lbCellTip.text = txtCellNotChosen
            }
            cell.imgHabit.image = UIImage(named: "iconHabit\(cell.HabitID!)")
        }
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView?, canEditRowAtIndexPath indexPath: NSIndexPath?) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView?, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath?) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

}
