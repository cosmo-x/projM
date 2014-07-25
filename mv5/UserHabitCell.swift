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
    
    var HabitID : Int!
    
    @IBOutlet var imgHabit: UIImageView!
    @IBOutlet var imgCheck: UIImageView!
    @IBOutlet var lbHabit: UILabel!
    @IBOutlet var lbCellTip: UILabel!
    
    init(style: UITableViewCellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
