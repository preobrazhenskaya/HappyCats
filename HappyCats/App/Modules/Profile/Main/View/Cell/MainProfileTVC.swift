//
//  MainProfileTVC.swift
//  HappyCats
//
//  Created by Яна Преображенская on 14.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import UIKit

class MainProfileTVC: UITableViewCell {
    
    @IBOutlet private weak var cellIcon: UIImageView!
    @IBOutlet private weak var cellLabel: UILabel!
    @IBOutlet private weak var nextIcon: UIImageView!
    
    func config(type: Constants.Cells.MainProfileCellType) {
        cellLabel.font = Constants.UI.Main.mainFont
        switch type {
        case .myProfile:
            cellIcon.image = R.image.userIcon()
            cellLabel.text = R.string.localizable.profileMyProfileTitle()
            nextIcon.image = R.image.nextIcon()
        case .myCats:
            cellIcon.image = R.image.catIcon()
            cellLabel.text = R.string.localizable.profileMyCatsTitle()
            nextIcon.image = R.image.nextIcon()
        }
    }
}
