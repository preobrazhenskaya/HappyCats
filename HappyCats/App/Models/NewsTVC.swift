//
//  NewsTVC.swift
//  HappyCats
//
//  Created by Яна Преображенская on 07.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import UIKit
import Kingfisher
import Reusable

final class NewsTVC: UITableViewCell, NibReusable {

    @IBOutlet private weak var newsImage: UIImageView!
    @IBOutlet private weak var newsTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func config(data: News) {
        if let img = data.image, let imgUrl = URL(string: img) {
            newsImage.kf.setImage(with: imgUrl)
        } else {
            newsImage.image = R.image.emptyPhoto()
        }
        if let title = data.label {
            newsTitle.text = title
        } else {
            newsTitle.text = R.string.localizable.emptyTitle()
        }
    }
}
