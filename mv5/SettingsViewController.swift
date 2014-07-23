//
//  SettingsViewController.swift
//  mv5
//
//  Created by cosmo on 14-7-11.
//  Copyright (c) 2014年 cosmo  studio. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {
    
    let BarImageCornerRadius: CGFloat = 6.0
    
    // For top bar
    @IBOutlet var lbTimePeriod: UILabel!
    @IBOutlet var lbPeriodPercentage: UILabel!
    
    // For bar graph
    @IBOutlet var imgBarSunday: UIImageView!
    @IBOutlet var imgBarMonday: UIImageView!
    @IBOutlet var imgBarTuesday: UIImageView!
    @IBOutlet var imgBarWednesday: UIImageView!
    @IBOutlet var imgBarThursday: UIImageView!
    @IBOutlet var imgBarFriday: UIImageView!
    @IBOutlet var imgBarSaturday: UIImageView!
    
    // For circle graph
    @IBOutlet var imgAllTImeImage: UIImageView!
    @IBOutlet var imgThisMonthImage: UIImageView!
    @IBOutlet var imgThisWeekImage: UIImageView!
    @IBOutlet var lbAllTimePercentage: UILabel!
    @IBOutlet var lbThisMonthPercentage: UILabel!
    @IBOutlet var lbThisWeekPercentage: UILabel!

    @IBOutlet weak var adsfasf: UIImageView!
    // For cell
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func getCurrentDate() -> NSDate {
        let currentCalendar = NSCalendar.currentCalendar()
        let components: NSDateComponents = currentCalendar.components (.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay , fromDate: NSDate())
        return currentCalendar.dateFromComponents(components)
    }
    
    func setBarImage(imageView: UIImageView, percentage: Float) {
        var percent: Int = Int(percentage * 100)
        percent = percent / 2
        percent = percent * 2
        imageView.layer.cornerRadius = BarImageCornerRadius
        imageView.image = UIImage(named: "stBar\(percent)")
        imageView.clipsToBounds = true
    }
    
    func setCircleImage(imageView: UIImageView, percentage: Float) {
        var percent: Int = Int(percentage * 100)
        percent = percent / 2
        percent = percent * 2
        imageView.image = UIImage(named: "stCircle\(percent)")
    }
    
    func setThisWeek() {
        var arrayOfCurrentWeek: Array <NSDate> = []
        let currentDate = getCurrentDate()
        let currentCalendar = NSCalendar.currentCalendar()
        let flags: NSCalendarUnit = .MonthCalendarUnit | .DayCalendarUnit | .WeekOfYearCalendarUnit | .WeekdayCalendarUnit
        let dayOfWeek: Int = currentCalendar.components (flags, fromDate: currentDate).weekday
        let weekofYear: Int = currentCalendar.components (flags, fromDate: currentDate).weekOfYear
        
        // Getting the start day and the end day of the current week
        var gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        var comp: NSDateComponents = gregorian.components(.YearCalendarUnit, fromDate: currentDate)
        
        comp.setValue(weekofYear, forComponent: .WeekOfYearCalendarUnit)
        comp.setValue(1, forComponent: .WeekdayCalendarUnit)
        let startDateOfWeek: NSDate = gregorian.dateFromComponents(comp)
        
        comp.setValue(7, forComponent: .WeekdayCalendarUnit)
        let endDateOfWeek: NSDate = gregorian.dateFromComponents(comp)
        
        // Setting the label for the bar
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        let strStartDateOfWeek = formatter.stringFromDate(startDateOfWeek)
        let strEndDateOfWeek = formatter.stringFromDate(endDateOfWeek)
        lbTimePeriod.text = "\(strStartDateOfWeek) - \(strEndDateOfWeek)"
        
        // Setting the array for current week
        for (var i = 1; i <= dayOfWeek; ++i) {
            comp.setValue(weekofYear, forComponent: .WeekOfYearCalendarUnit)
            comp.setValue(i, forComponent: .WeekdayCalendarUnit)
            var tempDayOfWeek: NSDate = gregorian.dateFromComponents(comp)
            arrayOfCurrentWeek.append(tempDayOfWeek)
        }
        println(arrayOfCurrentWeek)
        
        // Setting the label of the week and bar image of every day in the week
        var weekPercentage: Float = 0
        var dayCount: Int = dayOfWeek
        var entryCount: Float = 0
        for (var i = 0; i < 7; ++i) {
            var currentDatePercentage: Float = 0
            if (i < dayCount) {
                let fetchResults = fetchPercentageByDate(arrayOfCurrentWeek[i])
                if (true == fetchResults.found) {
                    currentDatePercentage = fetchResults.percentage
                    weekPercentage += currentDatePercentage
                    ++entryCount
                }
            }
            // Setting the bar images
            switch i {
            case 0:
                setBarImage(imgBarSunday!,percentage: currentDatePercentage)
                continue
            case 1:
                setBarImage(imgBarMonday!,percentage: currentDatePercentage)
                continue
            case 2:
                setBarImage(imgBarTuesday!,percentage: currentDatePercentage)
                continue
            case 3:
                setBarImage(imgBarWednesday!,percentage: currentDatePercentage)
                continue
            case 4:
                setBarImage(imgBarThursday!,percentage: currentDatePercentage)
                continue
            case 5:
                setBarImage(imgBarFriday!,percentage: currentDatePercentage)
                continue
            case 6:
                setBarImage(imgBarSaturday!,percentage: currentDatePercentage)
                continue
            default:
                continue
            }
        }
        if (0 != weekPercentage) {
            weekPercentage = weekPercentage / entryCount
        }
        lbPeriodPercentage.text = "\(Int((weekPercentage) * 100))%"
        lbThisWeekPercentage.text = "\(Int((weekPercentage) * 100))%"
        
        // Setting the circle image
        setCircleImage(imgThisWeekImage!,percentage: 0.00)
    }
    
    func setThisMonth() {
        // Getting the month
        let currentDate = getCurrentDate()
        let currentCalendar = NSCalendar.currentCalendar()
        let flags: NSCalendarUnit = .YearCalendarUnit | .MonthCalendarUnit | .DayCalendarUnit
       
        let currentYear: Int = currentCalendar.components (flags, fromDate: currentDate).year
        let currentMonth: Int = currentCalendar.components (flags, fromDate: currentDate).month
        let monthIndex: Int = currentYear * 12 + currentMonth
        
        var monthPercentage: Float = 0
        let fetchResults = fetchPercentageByMonthIndex(monthIndex)
        if (true == fetchResults.found) {
            monthPercentage = fetchResults.percentage
        } else {
            monthPercentage = 0
        }
        
        // Setting the circle
        lbThisMonthPercentage.text = "\(Int((monthPercentage) * 100))%"
        setCircleImage(imgThisMonthImage!,percentage: 0.46)
    }
    
    func setAllTime() {
        
        var allPercentage: Float = 0
        let fetchResults = fetchPercentageAll()
        if (true == fetchResults.found) {
            allPercentage = fetchResults.percentage
        } else {
            allPercentage = 0
        }
        // Setting the circle
        lbAllTimePercentage.text = "\(Int((allPercentage) * 100))%"
        setCircleImage(imgAllTImeImage!,percentage: 1.00)
    }
    
    func setView() {
        setThisWeek()
        setThisMonth()
        setAllTime()
    }
    
    func fetchPercentageByDate(date: NSDate) -> (percentage: Float, found: Bool) {
        var percentage: Float = 0
        var found: Bool = false
        
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context: NSManagedObjectContext = appDel.managedObjectContext
        let eNUserHistory = NSEntityDescription.entityForName("UserHistory", inManagedObjectContext:context)
        let searchText = [date]
        
        let pred: NSPredicate = NSPredicate(format: "date = %@", argumentArray: searchText)
        let fRUserHistory = NSFetchRequest(entityName: "UserHistory")
        fRUserHistory.predicate = pred
        
        let userHistory = context.executeFetchRequest(fRUserHistory, error:nil)
        
        if (userHistory.count != 0) {
            found = true
            var historyEntry = HistoryEntry(entity: eNUserHistory, insertIntoManagedObjectContext: context)
            historyEntry = userHistory[0] as HistoryEntry
            var totalCount: Float = Float(historyEntry.totalCount)
            var completedCount: Float = Float(historyEntry.completedCount)
            if (0 == totalCount) {
                percentage = 0
            } else {
                percentage = completedCount / totalCount
            }
        }
        return (percentage, found)
    }
    
    func fetchPercentageByMonthIndex(monthIndex: Int) -> (percentage: Float, found: Bool) {
        var percentage: Float = 0
        var found: Bool = false
        var count: Float = 0
        
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context: NSManagedObjectContext = appDel.managedObjectContext
        let eNUserHistory = NSEntityDescription.entityForName("UserHistory", inManagedObjectContext:context)
        let pred: NSPredicate = NSPredicate(format: "monthIndex == %@", "\(monthIndex)")
        let fRUserHistory = NSFetchRequest(entityName: "UserHistory")
        fRUserHistory.predicate = pred
        let userHistory = context.executeFetchRequest(fRUserHistory, error:nil)
        println("countInMonth = \(userHistory.count)")
        if (userHistory.count != 0) {
            found = true
            var historyEntry = HistoryEntry(entity: eNUserHistory, insertIntoManagedObjectContext: context)
            for (var i = 0; i < userHistory.count; ++i) {
                historyEntry = userHistory[i] as HistoryEntry
                if (0 != historyEntry.totalCount) {
                    percentage += Float(historyEntry.completedCount) / Float(historyEntry.totalCount)
                    ++count
                }
            }
            percentage /= count
        } else {
            percentage = 0
        }
        return (percentage, found)
    }
    
    func fetchPercentageAll() -> (percentage: Float, found: Bool) {
        var percentage: Float = 0
        var found: Bool = false
        var count: Float = 0
        
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context: NSManagedObjectContext = appDel.managedObjectContext
        let eNUserHistory = NSEntityDescription.entityForName("UserHistory", inManagedObjectContext:context)
        let fRUserHistory = NSFetchRequest(entityName: "UserHistory")
        let userHistory = context.executeFetchRequest(fRUserHistory, error:nil)
        println(userHistory)
        if (userHistory.count != 0) {
            found = true
            var historyEntry = HistoryEntry(entity: eNUserHistory, insertIntoManagedObjectContext: context)
            for (var i = 0; i < userHistory.count; ++i) {
                historyEntry = userHistory[i] as HistoryEntry
                if (0 != historyEntry.totalCount) {
                    percentage += Float(historyEntry.completedCount) / Float(historyEntry.totalCount)
                    ++count
                }
            }
            percentage /= count
        } else {
            percentage = 0
        }
        println(percentage)
        return (percentage, found)
    }
    
}
