//
//  CatProfileVM.swift
//  HappyCats
//
//  Created by Яна Преображенская on 18.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa
import Kingfisher

final class CatProfileVM: Stepper {
    let steps = PublishRelay<Step>()
    
    private let id: Int
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
        let name: Driver<String>
        let breed: Driver<String>
        let birthday: Driver<String>
        let note: Driver<String>
        let catImage: Driver<UIImage>
        let allBreeds: Driver<[Breed]>
    }
    
    init(withId id: Int, userService: UserService) {
        self.id = id
        self.userService = userService
    }
    
    func transform(input: Input) -> Output {
        let name = BehaviorRelay<String>(value: "")
        let breed = BehaviorRelay<String>(value: "")
        let birthday = BehaviorRelay<String>(value: "")
        let note = BehaviorRelay<String>(value: "")
        let catImage = BehaviorRelay<UIImage>(value: R.image.emptyPhoto() ?? UIImage())
        let allBreeds = BehaviorRelay<[Breed]>(value: [])
        
        CatAPI.getCat(withId: id, token: userService.getToken().orEmpty)
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { cat in
                name.accept(cat.name.orEmpty)
                breed.accept((cat.breed?.name).orEmpty)
                birthday.accept(cat.birthday.orEmpty)
                note.accept(cat.note.orEmpty)
                if let img = cat.photo, let imgUrl = URL(string: img) {
                    KingfisherManager.shared
                        .retrieveImage(with: ImageResource(downloadURL: imgUrl, cacheKey: nil)) { result in
                            switch result {
                            case .success(let image):
                                catImage.accept(image.image)
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                    }
                }
            })
            .disposed(by: disposeBag)
        
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
                        return CatAPI.updateCat(token: self.userService.getToken().orEmpty,
                                                id: self.id,
                                                name: name.orEmpty,
                                                breed: breed.orEmpty,
                                                birthday: birthday.orEmpty,
                                                note: note.orEmpty,
                                                photo: photo)
                }
            }
            .subscribe(onNext: { })
            .disposed(by: disposeBag)
        
        return Output(name: name.asDriver(onErrorDriveWith: .never()),
                      breed: breed.asDriver(onErrorDriveWith: .never()),
                      birthday: birthday.asDriver(onErrorDriveWith: .never()),
                      note: note.asDriver(onErrorDriveWith: .never()),
                      catImage: catImage.asDriver(onErrorDriveWith: .never()),
                      allBreeds: allBreeds.asDriver(onErrorJustReturn: []))
    }
}
