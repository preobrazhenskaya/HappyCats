//
//  MyProfileVM.swift
//  HappyCats
//
//  Created by Яна Преображенская on 14.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa
import Kingfisher

final class MyProfileVM: Stepper {
    let steps = PublishRelay<Step>()
    
    private let disposeBag = DisposeBag()
    private let userService: UserService
    
    struct Input {
        let name: Observable<String?>
        let login: Observable<String?>
        let email: Observable<String?>
        let phone: Observable<String?>
        let birthday: Observable<String?>
        let note: Observable<String?>
        let userPhoto: Observable<UIImage?>
        let saveButton: Observable<Void>
    }
    
    struct Output {
        let name: Driver<String>
        let login: Driver<String>
        let email: Driver<String>
        let phone: Driver<String>
        let birthday: Driver<String>
        let note: Driver<String>
        let userImage: Driver<UIImage>
    }
    
    init(userService: UserService) {
        self.userService = userService
    }
    
    func transform(input: Input) -> Output {
        let name = BehaviorRelay<String>(value: "")
        let login = BehaviorRelay<String>(value: "")
        let email = BehaviorRelay<String>(value: "")
        let phone = BehaviorRelay<String>(value: "")
        let birthday = BehaviorRelay<String>(value: "")
        let note = BehaviorRelay<String>(value: "")
        let userImage = BehaviorRelay<UIImage>(value: R.image.emptyPhoto() ?? UIImage())
        
        UserAPI.getUser(token: userService.getToken() ?? "")
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { user in
                name.accept(user.name.orEmpty)
                login.accept(user.login.orEmpty)
                email.accept(user.email.orEmpty)
                phone.accept(user.phone.orEmpty)
                birthday.accept(user.birthday.orEmpty)
                note.accept(user.note.orEmpty)
                if let img = user.photo, let imgUrl = URL(string: img) {
                    KingfisherManager.shared
                        .retrieveImage(with: ImageResource(downloadURL: imgUrl, cacheKey: nil)) { result in
                            switch result {
                            case .success(let image):
                                userImage.accept(image.image)
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                    }
                }
            })
            .disposed(by: disposeBag)
        
        let data = Observable.combineLatest(input.name, input.login, input.phone, input.email, input.birthday, input.note, input.userPhoto)

        input.saveButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(data)
            .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
            .flatMap { (name, login, phone, email, birthday, note, photo) -> Observable<Void> in
                return PhotoAPI.uploadPhoto(photo: photo)
                    .flatMap { photo in
                        return UserAPI.updateUser(token: self.userService.getToken().orEmpty,
                                                  name: name.orEmpty,
                                                  login: login.orEmpty,
                                                  email: email.orEmpty,
                                                  phone: phone.orEmpty,
                                                  birthday: birthday.orEmpty,
                                                  note: note.orEmpty,
                                                  photo: photo)
                    }
            }
            .subscribe(onNext: { }).disposed(by: disposeBag)
        
        return Output(name: name.asDriver(onErrorDriveWith: .never()),
                      login: login.asDriver(onErrorDriveWith: .never()),
                      email: email.asDriver(onErrorDriveWith: .never()),
                      phone: phone.asDriver(onErrorDriveWith: .never()),
                      birthday: birthday.asDriver(onErrorDriveWith: .never()),
                      note: note.asDriver(onErrorDriveWith: .never()),
                      userImage: userImage.asDriver(onErrorDriveWith: .never()))
    }
}
