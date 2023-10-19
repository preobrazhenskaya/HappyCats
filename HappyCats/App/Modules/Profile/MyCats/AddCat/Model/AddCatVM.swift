//
//  AddCatVM.swift
//  HappyCats
//
//  Created by Яна Преображенская on 19.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa
import Kingfisher

final class AddCatVM: Stepper {
    let steps = PublishRelay<Step>()
    
    private let disposeBag = DisposeBag()
    private let userService: UserService
    
    struct Input {
        let name: Observable<String?>
        let breed: Observable<String?>
        let birthday: Observable<String?>
        let note: Observable<String?>
        let catPhoto: Observable<UIImage?>
        let saveButton: Observable<Void>
    }
    
    struct Output {
        let allBreeds: Driver<[Breed]>
    }
    
    init(userService: UserService) {
        self.userService = userService
    }
    
    func transform(input: Input) -> Output {
        let allBreeds = BehaviorRelay<[Breed]>(value: [])

        BreedAPI.getAllBreeds(token: userService.getToken().orEmpty)
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { data in
                allBreeds.accept(data)
            })
            .disposed(by: self.disposeBag)

        let data = Observable.combineLatest(input.name, input.breed, input.birthday, input.note, input.catPhoto)
        
        input.saveButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(data)
            .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
            .flatMap { (name, breed, birthday, note, photo) -> Observable<Void> in
                return PhotoAPI.uploadPhoto(photo: photo)
                    .flatMap { photo in
                        return CatAPI.addCat(token: self.userService.getToken().orEmpty,
                                             name: name.orEmpty,
                                             breed: breed.orEmpty,
                                             birthday: birthday.orEmpty,
                                             note: note.orEmpty,
                                             photo: photo)
                }
            }
            .subscribe(onNext: { })
            .disposed(by: disposeBag)

        return Output(allBreeds: allBreeds.asDriver(onErrorJustReturn: []))
    }
}

