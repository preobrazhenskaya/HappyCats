//
//  PreferecesService.swift
//  HappyCats
//
//  Created by Яна Преображенская on 11.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import Foundation
import RxSwift

struct UserPreferences {
    static let onBoarded = "onBoarded"
}

final class PreferencesService {
    private let defaults = UserDefaults.standard

    func setOnboarded () {
        defaults.set(true, forKey: UserPreferences.onBoarded)
    }

    func setNotOnboarded () {
        defaults.removeObject(forKey: UserPreferences.onBoarded)
    }

    func isOnboarded () -> Bool {
        return defaults.bool(forKey: UserPreferences.onBoarded)
    }
}

extension PreferencesService: ReactiveCompatible {}

extension Reactive where Base: PreferencesService {
    var isOnboarded: Observable<Bool> {
        return UserDefaults.standard
            .rx
            .observe(Bool.self, UserPreferences.onBoarded)
            .map { $0 ?? false }
    }
}
