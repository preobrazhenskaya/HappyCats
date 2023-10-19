//
//  User.swift
//  HappyCats
//
//  Created by Яна Преображенская on 12.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import Foundation

struct User: Codable {
    var id: Int?
    var login: String?
    var name: String?
    var email: String?
    var phone: String?
    var birthday: String?
    var photo: String?
    var note: String?
    
    enum CodingKeys : String, CodingKey {
        case id
        case login = "username"
        case name
        case email
        case phone
        case birthday
        case photo
        case note
    }
}


