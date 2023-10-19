//
//  CatsListVM.swift
//  HappyCats
//
//  Created by Яна Преображенская on 18.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa
import Kingfisher

final class CatsListVM: Stepper {
    let steps = PublishRelay<Step>()
    
    private let disposeBag = DisposeBag()
    private let userService: UserService
    
    struct Input {
        let selectedCat: Observable<Int>
        let addCatButton: Observable<Void>
    }
    
    struct Output {
        let cats: Driver<[Cat]>
    }
    
    init(userService: UserService) {
        self.userService = userService
    }
    
    func transform(input: Input) -> Output {
        let cats = BehaviorRelay<[Cat]>(value: [])
        
        input.selectedCat
            .subscribe(onNext: { index in
                guard let id = cats.value[safe: index]?.id else { return }
                self.steps.accept(AppStep.cat(withId: id))
            }).disposed(by: disposeBag)
        
        input.addCatButton
            .subscribe(onNext: { _ in
                self.steps.accept(AppStep.addCat)
            }).disposed(by: disposeBag)
        
        CatAPI.getAllCats(token: userService.getToken().orEmpty)
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { data in
                cats.accept(data)
            })
            .disposed(by: self.disposeBag)
        
        return Output(cats: cats.asDriver(onErrorJustReturn: []))
    }
}

