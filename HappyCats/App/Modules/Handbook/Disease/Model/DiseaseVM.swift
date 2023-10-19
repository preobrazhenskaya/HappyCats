//
//  DiseaseVM.swift
//  HappyCats
//
//  Created by Яна Преображенская on 17.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa
import Kingfisher

final class DiseaseVM: Stepper {
    let steps = PublishRelay<Step>()
    
    private let id: Int
    private let disposeBag = DisposeBag()
    private let userService: UserService
    
    struct Input { }
    
    struct Output {
        let image: Driver<UIImage>
        let title: Driver<String>
        let description: Driver<String>
    }
    
    init(withId id: Int, userService: UserService) {
        self.id = id
        self.userService = userService
    }
    
    func transform(input: Input) -> Output {
        let title = BehaviorRelay<String>(value: "")
        let description = BehaviorRelay<String>(value: "")
        let diseaseImage = BehaviorRelay<UIImage>(value: R.image.emptyPhoto() ?? UIImage())
        
        DiseaseAPI.getDisease(withId: id, token: userService.getToken().orEmpty)
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { disease in
                title.accept(disease.name.orEmpty)
                description.accept(disease.description.orEmpty)
                if let img = disease.photo, let imgUrl = URL(string: img) {
                    KingfisherManager.shared
                        .retrieveImage(with: ImageResource(downloadURL: imgUrl, cacheKey: nil)) { result in
                            switch result {
                            case .success(let image):
                                diseaseImage.accept(image.image)
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                    }
                }
            })
            .disposed(by: disposeBag)
        
        return Output(image: diseaseImage.asDriver(onErrorDriveWith: .never()),
                      title: title.asDriver(onErrorDriveWith: .never()),
                      description: description.asDriver(onErrorDriveWith: .never()))
    }
}
