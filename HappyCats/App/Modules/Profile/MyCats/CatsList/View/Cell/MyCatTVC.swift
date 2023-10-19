//
//  MyCatTVC.swift
//  HappyCats
//
//  Created by Яна Преображенская on 18.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import UIKit
import Reusable

class MyCatTVC: UITableViewCell, NibReusable {

    @IBOutlet weak var catImage: UIImageView!
    @IBOutlet weak var catName: UILabel!
    @IBOutlet weak var nextButton: UIImageView!
    
    func config(cat: Cat) {
        defaultBuild()
        if let img = cat.photo, let imgUrl = URL(string: img) {
            catImage.kf.setImage(with: imgUrl)
        } else {
            catImage.image = R.image.emptyPhoto()
        }
        if let title = cat.name {
            catName.text = title
        } else {
            catName.text = R.string.localizable.emptyTitle()
        }
    }
    
    private func defaultBuild() {
        nextButton.image = R.image.nextIcon()
        catName.font = Constants.UI.Main.mainFont
    }
}
