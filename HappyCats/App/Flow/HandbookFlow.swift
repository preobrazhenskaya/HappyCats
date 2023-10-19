//
//  HandbookFlow.swift
//  HappyCats
//
//  Created by Яна Преображенская on 08.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import Foundation
import RxFlow

final class HandbookFlow: Flow {
    
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
        case .handbook:
            return navigationToHandbookScreen()
        case .breed(let id):
            return navigationToBreedScreen(withId: id)
        case .disease(let id):
            return navigationToDiseaseScreen(withId: id)
        default:
            return .none
        }
    }
    
    private func navigationToHandbookScreen() -> FlowContributors {
        let model = HandbookVM(userService: services.userService)
        let vc = HandbookVC()
        vc.title = R.string.localizable.handbookTitle()
        vc.setModel(model: model)
        rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: model))
    }
    
    private func navigationToBreedScreen(withId id: Int) -> FlowContributors {
        let model = BreedVM(withId: id, userService: services.userService)
        let vc = BreedVC()
        vc.setModel(model: model)
        rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: model))
    }
    
    private func navigationToDiseaseScreen(withId id: Int) -> FlowContributors {
        let model = DiseaseVM(withId: id, userService: services.userService)
        let vc = DiseaseVC()
        vc.setModel(model: model)
        rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: model))
    }
}
