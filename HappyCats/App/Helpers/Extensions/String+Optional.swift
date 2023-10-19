//
//  String+Optional.swift
//  HappyCats
//
//  Created by Яна Преображенская on 15.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import Foundation

extension Optional {
    var orEmpty: String {
        switch self {
        case .some(let value):
            return String(describing: value)
        case _:
            return ""
        }
    }
}
