//
//  Cat.swift
//  HappyCats
//
//  Created by Яна Преображенская on 08.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import Foundation

struct Cat: Codable {
    let id: Int?
    let name: String?
    let photo: String?
    let breed: Breed?
    let birthday: String?
    let note: String?
}
