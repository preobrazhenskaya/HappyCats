//
//  LoginVM.swift
//  HappyCats
//
//  Created by Яна Преображенская on 11.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa

final class LoginVM: Stepper {
    let steps = PublishRelay<Step>()
    
    private let disposeBag = DisposeBag()
    private let userService: UserService
    private let preferencesService: PreferencesService
    
    struct Input {
        let loginField: Observable<String?>
        let passwordField: Observable<String?>
        let loginButtonClick: Observable<Void>
        let registrationButtonClick: Observable<Void>
    }
    
    struct Output {
        
    }
    
    init(userService: UserService, preferencesService: PreferencesService) {
        self.userService = userService
        self.preferencesService = preferencesService
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        let loginData = Observable.combineLatest(input.loginField, input.passwordField)
        
        input.loginButtonClick
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(loginData)
            .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
            .flatMap { (loginField, passwordField) -> Observable<AuthResponse> in
                return AuthAPI.login(login: loginField!, password: passwordField!)
            }
            .subscribe(onNext: { authResponse in
                self.userService.setToken(authResponse.token ?? "")
                self.preferencesService.setOnboarded()
                self.steps.accept(AppStep.loginIsComplete)
            }).disposed(by: disposeBag)
        
        input.registrationButtonClick
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                self.steps.accept(AppStep.registration)
            }).disposed(by: disposeBag)
        
        return output
    }
}
