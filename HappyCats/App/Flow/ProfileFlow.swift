//
//  ProfileFlow.swift
//  HappyCats
//
//  Created by Яна Преображенская on 14.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import Foundation
import RxFlow

final class ProfileFlow: Flow {
    
    private let rootViewController = UINavigationController()
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
        case .mainProfile:
            return navigationToMainProfile()
        case .myProfile:
            return navigationToMyProfile()
        case .myCats:
            return navigationToMyCatsScreen()
        case .cat(let id):
            return navigationToCatScreen(withId: id)
        case .addCat:
            return navigationToAddCatScreen()
        case .loggedOut:
            return .end(forwardToParentFlowWithStep: AppStep.loggedOut)
        default:
            return .none
        }
    }
    
    private func navigationToMainProfile() -> FlowContributors {
        let model = MainProfileVM(userService: services.userService)
        let vc = MainProfileVC()
        vc.title = R.string.localizable.profileMainProfileTitle()
        vc.setModel(model: model)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: FlowContributor.contribute(withNextPresentable: vc, withNextStepper: model))
    }
    
    private func navigationToMyProfile() -> FlowContributors {
        let model = MyProfileVM(userService: services.userService)
        let vc = MyProfileVC()
        vc.title = R.string.localizable.profileMyProfileTitle()
        vc.setModel(model: model)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: FlowContributor.contribute(withNextPresentable: vc, withNextStepper: model))
    }
    
    private func navigationToMyCatsScreen() -> FlowContributors {
        let model = CatsListVM(userService: services.userService)
        let vc = CatsListVC()
        vc.title = R.string.localizable.profileMyCatsTitle()
        vc.setModel(model: model)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: model))
    }
    
    private func navigationToCatScreen(withId id: Int) -> FlowContributors {
        let model = CatProfileVM(withId: id, userService: services.userService)
        let vc = CatProfileVC()
        vc.setModel(model: model)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: model))
    }
    
    private func navigationToAddCatScreen() -> FlowContributors {
        let model = AddCatVM(userService: services.userService)
        let vc = AddCatVC()
        vc.title = R.string.localizable.profileAddCatTitle()
        vc.setModel(model: model)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: model))
    }
}
