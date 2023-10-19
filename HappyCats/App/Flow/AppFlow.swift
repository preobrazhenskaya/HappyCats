//
//  AppFlow.swift
//  HappyCats
//
//  Created by Яна Преображенская on 07.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import Foundation
import UIKit
import RxFlow
import RxSwift
import RxCocoa

final class AppFlow: Flow {
    
    private let window: UIWindow
    private let services: ServicesContainer

    var root: Presentable {
        return self.window
    }

    init(window: UIWindow, services: ServicesContainer) {
        self.window = window
        self.services = services
    }

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }

        switch step {
        case .dashboard:
            return navigationToDashboardScreen()
        case .onboarding:
            return navigationToOnboarding()
        default:
            return .none
        }
    }
    
    private func navigationToDashboardScreen() -> FlowContributors {
        let dashboardFlow = DashboardFlow(withServices: services)
        
        Flows.whenReady(flow1: dashboardFlow) { [unowned self] (root) in
            self.window.rootViewController = root
        }
        
        return .one(flowContributor: FlowContributor.contribute(withNextPresentable: dashboardFlow, withNextStepper: OneStepper(withSingleStep: AppStep.dashboard)))
    }
    
    private func navigationToOnboarding() -> FlowContributors {
        let onboardingFlow = OnboardingFlow(withServices: services)
        
        Flows.whenReady(flow1: onboardingFlow) { [unowned self] (root) in
            self.window.rootViewController = root
        }
        
        return .one(flowContributor: FlowContributor.contribute(withNextPresentable: onboardingFlow, withNextStepper: OneStepper(withSingleStep: AppStep.login)))
    }
}

class AppStepper: Stepper {

    let steps = PublishRelay<Step>()
    private let servicesContainer: ServicesContainer
    private let disposeBag = DisposeBag()

    init(withServices services: ServicesContainer) {
        self.servicesContainer = services
    }

    var initialStep: Step {
        return AppStep.onboarding
    }
    
    func readyToEmitSteps() {
        self.servicesContainer
            .preferencesService.rx
            .isOnboarded
            .map { $0 ? AppStep.dashboard : AppStep.onboarding }
            .bind(to: self.steps)
            .disposed(by: self.disposeBag)
    }
}

