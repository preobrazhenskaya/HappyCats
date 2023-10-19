//
//  HandbookTVC.swift
//  HappyCats
//
//  Created by Яна Преображенская on 08.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import UIKit
import Reusable

class HandbookTVC: UITableViewCell, NibReusable {

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configCatCell(cat: Breed) {
        if let img = cat.photo, let imgUrl = URL(string: img) {
            cellImage.kf.setImage(with: imgUrl)
        } else {
            cellImage.image = R.image.emptyPhoto()
        }
        if let title = cat.name {
            cellLabel.text = title
        } else {
            cellLabel.text = R.string.localizable.emptyTitle()
        }
    }
    
    func configDiseaseCell(disease: Disease) {
        if let img = disease.photo, let imgUrl = URL(string: img) {
            cellImage.kf.setImage(with: imgUrl)
        } else {
            cellImage.image = R.image.emptyPhoto()
        }
        if let title = disease.name {
            cellLabel.text = title
        } else {
            cellLabel.text = R.string.localizable.emptyTitle()
        }
    }
}
