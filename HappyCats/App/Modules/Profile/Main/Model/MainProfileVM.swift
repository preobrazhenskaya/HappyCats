//
//  MainProfileVM.swift
//  HappyCats
//
//  Created by Яна Преображенская on 14.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa
import Kingfisher

final class MainProfileVM: Stepper {
    let steps = PublishRelay<Step>()
    
    private let disposeBag = DisposeBag()
    private let userService: UserService
    
    struct Input {
        let exitButton: Observable<Void>
    }
    
    struct Output {
        let userImage: Driver<UIImage>
    }
    
    init(userService: UserService) {
        self.userService = userService
    }
    
    func transform(input: Input) -> Output {
        let userImage = BehaviorRelay<UIImage>(value: R.image.emptyPhoto() ?? UIImage())
        
        UserAPI.getUser(token: userService.getToken() ?? "")
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { user in
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
        
        input.exitButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                self.steps.accept(AppStep.loggedOut)
            }).disposed(by: disposeBag)
        
        return Output(userImage: userImage.asDriver(onErrorDriveWith: .never()))
    }
    
    func goToMyProfile() {
        steps.accept(AppStep.myProfile)
    }
    
    func goToMyCats() {
        steps.accept(AppStep.myCats)
    }
}
