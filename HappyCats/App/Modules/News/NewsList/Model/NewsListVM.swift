//
//  NewsListVM.swift
//  HappyCats
//
//  Created by Яна Преображенская on 07.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa

final class NewsListVM: Stepper {
    let steps = PublishRelay<Step>()
    
    private let disposeBag = DisposeBag()
    private let userService: UserService
    
    struct Input {
        let selectedNews: Observable<Int>
    }
    
    struct Output {
        let news: Driver<[News]>
    }
    
    init(userService: UserService) {
        self.userService = userService
    }
    
    func transform(input: Input) -> Output {
        let news = BehaviorRelay<[News]>(value: [])
        
        input.selectedNews
            .subscribe(onNext: { index in
                guard let id = news.value[safe: index]?.id else { return }
                self.steps.accept(AppStep.newsDetail(withId: id))
            }).disposed(by: disposeBag)
        
        NewsAPI.getAllNews(token: userService.getToken().orEmpty)
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { data in
                news.accept(data)
            })
            .disposed(by: disposeBag)
        
        let output = Output(news: news.asDriver(onErrorJustReturn: []))
        return output
    }
}
