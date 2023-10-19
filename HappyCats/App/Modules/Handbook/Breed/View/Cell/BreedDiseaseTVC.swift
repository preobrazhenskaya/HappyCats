//
//  BreedDiseaseTVC.swift
//  HappyCats
//
//  Created by Яна Преображенская on 17.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import UIKit
import Reusable

class BreedDiseaseTVC: UITableViewCell, NibReusable {
    
    @IBOutlet weak var diseaseImage: UIImageView!
    @IBOutlet weak var diseaseLabel: UILabel!
    @IBOutlet weak var nextButton: UIImageView!
    
    func config(disease: Disease) {
        nextButton.image = R.image.nextIcon()
        if let img = disease.photo, let imgUrl = URL(string: img) {
            diseaseImage.kf.setImage(with: imgUrl)
        } else {
            diseaseImage.image = R.image.emptyPhoto()
        }
        if let title = disease.name {
            diseaseLabel.text = title
        } else {
            diseaseLabel.text = R.string.localizable.emptyTitle()
        }
    }
}
