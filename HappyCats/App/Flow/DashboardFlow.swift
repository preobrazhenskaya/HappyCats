//
//  DashboardFlow.swift
//  HappyCats
//
//  Created by Яна Преображенская on 07.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import Foundation
import RxFlow

final class DashboardFlow: Flow {
    
    private let services: ServicesContainer
    
    let rootViewController = UITabBarController()
    
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
        case .dashboard:
            return navigateToDashboard()
        case .loggedOut:
            return popToSignInScreen()
        default:
            return .none
        }
    }
    
    private func navigateToDashboard() -> FlowContributors {
        let newsFlow = NewsFlow(withServices: self.services)
        let handbookFlow = HandbookFlow(withServices: self.services)
        let profileFlow = ProfileFlow(withServices: self.services)
        
        Flows.whenReady(flow1: newsFlow, flow2: handbookFlow, flow3: profileFlow) { [unowned self] (root1: UINavigationController, root2: UINavigationController, root3: UINavigationController) in
            let tabBarItem1 = UITabBarItem(title: R.string.localizable.newsTitle(), image: R.image.newsIcon(), selectedImage: nil)
            let tabBarItem2 = UITabBarItem(title: R.string.localizable.handbookTitle(), image: R.image.catIcon(), selectedImage: nil)
            let tabBarItem3 = UITabBarItem(title: R.string.localizable.profileMainProfileTitle(), image: R.image.userIcon(), selectedImage: nil)
            
            root1.tabBarItem = tabBarItem1
            root1.title = R.string.localizable.newsTitle()
            root2.tabBarItem = tabBarItem2
            root2.title = R.string.localizable.handbookTitle()
            root3.tabBarItem = tabBarItem3
            root3.title = R.string.localizable.profileMainProfileTitle()
            
            self.rootViewController.setViewControllers([root1, root2, root3], animated: false)
        }
        
        return .multiple(flowContributors: [.contribute(withNextPresentable: newsFlow,
                                                        withNextStepper: OneStepper(withSingleStep: AppStep.newsList)),
                                            .contribute(withNextPresentable: handbookFlow,
                                                        withNextStepper: OneStepper(withSingleStep: AppStep.handbook)),
                                            .contribute(withNextPresentable: profileFlow,
                                                        withNextStepper: OneStepper(withSingleStep: AppStep.mainProfile))])
    }
    
    private func popToSignInScreen() -> FlowContributors {
        services.preferencesService.setNotOnboarded()
        services.userService.deleteToken()
        return .end(forwardToParentFlowWithStep: AppStep.onboarding)
    }
}
