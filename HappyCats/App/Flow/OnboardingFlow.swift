//
//  OnboardingFlow.swift
//  HappyCats
//
//  Created by Яна Преображенская on 11.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import Foundation
import RxFlow

final class OnboardingFlow: Flow {
    
    private var rootViewController = UINavigationController()
    private let services: ServicesContainer
    
    var root: Presentable {
        return self.rootViewController
    }
    
    init(withServices services: ServicesContainer) {
        self.services = services
    }

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }

        switch step {
        case .login:
            return navigationToLoginScreen()
        case .registration:
            return navigationToRegistration()
        case .loginIsComplete, .registrationIsComplete:
            return .end(forwardToParentFlowWithStep: AppStep.dashboard)
        default:
            return .none
        }
    }
    
    private func navigationToLoginScreen() -> FlowContributors {
        let model = LoginVM(userService: services.userService,
                            preferencesService: services.preferencesService)
        let vc = LoginVC()
        vc.setModel(model: model)
        rootViewController.pushViewController(vc, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: model))
    }
    
    private func navigationToRegistration() -> FlowContributors {
        let model = RegistrationVM(userService: services.userService,
                                   preferencesService: services.preferencesService)
        let vc = RegistrationVC()
        vc.setModel(model: model)
        rootViewController.pushViewController(vc, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: model))
    }
}
