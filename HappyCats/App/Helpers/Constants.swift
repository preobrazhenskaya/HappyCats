//
//  Constants.swift
//  HappyCats
//
//  Created by Яна Преображенская on 07.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import Foundation
import UIKit

enum Constants {
    enum API {
        enum URL {
            static let mainURL = "http://localhost:8080"
            static let loginURL = "/auth/sigin"
            static let registrationURL = "/auth/signup"
            static let user = "/users/me"
            static let allNews = "/news/all"
            static let newsById = "/news/id"
            static let allBreeds = "/breeds/allbreeds"
            static let breedById = "/breeds/id"
            static let allDisease = "/diseases/all"
            static let diseaseById = "/diseases/id"
            static let myCats = "/cats/all"
            static let catById = "/cats/id"
            static let updateCat = "/cats/catid"
            static let addCat = "/cats/"
        }
        
        enum Headers {
            static let auth = "Authorization"
        }
        
        enum Cloudinary {
            static let cloudName = "dj7n6iicp"
            static let folder = "happycats_test/"
            static let preset = "HappyCatsPreset"
        }
    }
    
    enum UI {
        enum Main {
            static let mainColor = UIColor(red: 0.13, green: 0.59, blue: 0.95, alpha: 1.00)
            static let mainFont = R.font.montserratRegular(size: 17)
            static let smallFont = R.font.montserratRegular(size: 14)
            static let titleFont = R.font.montserratMedium(size: 24)
            static let sectionFont = R.font.montserratMedium(size: 20)
            static let mainFontColor = UIColor.black
            static let alternativeFontColor = UIColor.white
        }
        
        enum Navigation {
            static let titleFont = R.font.montserratRegular(size: 20)
            static let systemTitleFont = UIFont.systemFont(ofSize: 20)
            static let tabBarItemFont = R.font.montserratRegular(size: 10)
        }
        
        enum Button {
            static let cornerRadius: CGFloat = 5
            static let borderWidth: CGFloat = 1
            
            enum AddCat {
                static let cornerRadius: CGFloat = 25
            }
        }
        
        enum View {
            static let cornerRadius: CGFloat = 10
        }
    }
    
    enum Cells {
        static let news = "NewsTVC"
        static let handbook = "HandbookTVC"
        static let mainProfile = "MainProfileTVC"
        
        enum MainProfileCellType {
            case myProfile
            case myCats
        }
        
        enum CellInHandbookDetail {
            static let height: CGFloat = 60
        }
        
        enum CellOfProfileTable {
            static let height: CGFloat = 46
        }
    }
    
    enum SelectedButton {
        case cats
        case disease
    }
}
