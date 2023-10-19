//
//  UserService.swift
//  HappyCats
//
//  Created by Яна Преображенская on 12.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import Foundation

enum UserDefaultsKeys: String {
    case token = "token"
}

struct UserService {

    private let defaults = UserDefaults.standard
    
    func setToken(_ token: String) {
        defaults.setValue(token, forKey: UserDefaultsKeys.token.rawValue)
    }
    
    func getToken() -> String? {
        let token = defaults.string(forKey: UserDefaultsKeys.token.rawValue)
        return token
    }
    
    func deleteToken() {
        defaults.removeObject(forKey: UserDefaultsKeys.token.rawValue)
    }
}
