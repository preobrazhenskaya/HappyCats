//
//  AppearanceManager.swift
//  HappyCats
//
//  Created by Яна Преображенская on 08.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import Foundation
import UIKit

final class AppearanceManager {
    
    func setup() {
        setNavigation()
        setTabBar()
    }
    
    private func setNavigation() {
        let navigationBar = UINavigationBar.appearance()
        navigationBar.barTintColor = Constants.UI.Main.mainColor
        navigationBar.titleTextAttributes = [
            .foregroundColor: Constants.UI.Main.alternativeFontColor,
            .font: Constants.UI.Navigation.titleFont ?? Constants.UI.Navigation.systemTitleFont
        ]
        navigationBar.tintColor = Constants.UI.Main.alternativeFontColor
        
        let barButtonItem = UIBarButtonItem.appearance()
        barButtonItem.setTitleTextAttributes([.font: Constants.UI.Main.mainFont ?? Constants.UI.Navigation.systemTitleFont], for: .normal)
    }
    
    private func setTabBar() {
        let tabBar = UITabBar.appearance()
        tabBar.tintColor = Constants.UI.Main.mainColor
        
        let tabBarItem = UITabBarItem.appearance()
        tabBarItem.setTitleTextAttributes([.font: Constants.UI.Navigation.tabBarItemFont ?? Constants.UI.Navigation.systemTitleFont], for: .normal)
    }
}
