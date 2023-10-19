//
//  AppStep.swift
//  HappyCats
//
//  Created by Яна Преображенская on 07.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import RxFlow

enum AppStep: Step {
    // Main
    case dashboard
    case onboarding
    
    // News
    case newsList
    case newsDetail(withId: Int)
    
    // Handbook
    case handbook
    case breed(withId: Int)
    case disease(withId: Int)
    
    // Sign In
    case login
    case loginIsComplete
    
    // Sign Up
    case registration
    case registrationIsComplete
    
    // Profile
    case mainProfile
    case myProfile
    case myCats
    case cat(withId: Int)
    case addCat
    case loggedOut
}
