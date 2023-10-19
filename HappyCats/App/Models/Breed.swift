//
//  Breed.swift
//  HappyCats
//
//  Created by Яна Преображенская on 17.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import Foundation

struct Breed: Codable {
    let id: Int?
    let name: String?
    let description: String?
    let photo: String?
    let diseases: [Disease]?
}
