//
//  HandbookVM.swift
//  HappyCats
//
//  Created by Яна Преображенская on 08.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa

final class HandbookVM: Stepper {
    let steps = PublishRelay<Step>()
    
    private let disposeBag = DisposeBag()
    private let userService: UserService
    
    struct Input {
        let selectedBreed: Observable<Int>
        let selectedDisease: Observable<Int>
    }
    
    struct Output {
        let breeds: Driver<[Breed]>
        let disease: Driver<[Disease]>
    }
    
    init(userService: UserService) {
        self.userService = userService
    }
    
    func transform(input: Input) -> Output {
        let breeds = BehaviorRelay<[Breed]>(value: [])
        let disease = BehaviorRelay<[Disease]>(value: [])
        
        input.selectedBreed
            .subscribe(onNext: { index in
                guard let id = breeds.value[safe: index]?.id else { return }
                self.steps.accept(AppStep.breed(withId: id))
            }).disposed(by: disposeBag)
        
        input.selectedDisease
            .subscribe(onNext: { index in
                guard let id = disease.value[safe: index]?.id else { return }
                self.steps.accept(AppStep.disease(withId: id))
            }).disposed(by: disposeBag)
        
        BreedAPI.getAllBreeds(token: self.userService.getToken().orEmpty)
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { data in
                breeds.accept(data)
            })
            .disposed(by: self.disposeBag)
        
        DiseaseAPI.getAllDisease(token: self.userService.getToken().orEmpty)
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { data in
                disease.accept(data)
            })
            .disposed(by: self.disposeBag)
        
        let output = Output(breeds: breeds.asDriver(onErrorJustReturn: []),
                            disease: disease.asDriver(onErrorJustReturn: []))
        return output
    }
}
