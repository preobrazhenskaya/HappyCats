//
//  NewsFlow.swift
//  HappyCats
//
//  Created by Яна Преображенская on 07.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import Foundation
import RxFlow

final class NewsFlow: Flow {
    
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
        case .newsList:
            return navigationToNewsScreen()
        case .newsDetail(let newsId):
            return navigationToNewsDetailScreen(withId: newsId)
        default:
            return .none
        }
    }
    
    private func navigationToNewsScreen() -> FlowContributors {
        let model = NewsListVM(userService: services.userService)
        let vc = NewsListVC()
        vc.title = R.string.localizable.newsTitle()
        vc.setModel(model: model)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: FlowContributor.contribute(withNextPresentable: vc, withNextStepper: model))
    }
    
    private func navigationToNewsDetailScreen(withId id: Int) -> FlowContributors {
        let model = NewsDetailVM(withId: id, userService: services.userService)
        let vc = NewsDetailVC()
        vc.setModel(model: model)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: model))
    }
}
