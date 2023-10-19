//
//  RegistrationVM.swift
//  HappyCats
//
//  Created by Яна Преображенская on 12.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa

final class RegistrationVM: Stepper {
    let steps = PublishRelay<Step>()
    
    private let disposeBag = DisposeBag()
    private let userService: UserService
    private let preferencesService: PreferencesService
    
    struct Input {
        let nameField: Observable<String?>
        let emailField: Observable<String?>
        let loginField: Observable<String?>
        let passwordField: Observable<String?>
        let registrationButtonClick: Observable<Void>
        let loginButtonClick: Observable<Void>
    }
    
    struct Output {
        
    }
    
    init(userService: UserService, preferencesService: PreferencesService) {
        self.userService = userService
        self.preferencesService = preferencesService
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        let registrationData = Observable.combineLatest(input.nameField, input.emailField, input.loginField, input.passwordField)
        input.registrationButtonClick
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(registrationData)
            .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
            .flatMap { (nameField, emailField, loginField, passwordField) -> Observable<AuthResponse> in
                return AuthAPI.registration(email: emailField!, name: nameField!, password: passwordField!, userName: loginField!)
            }
            .subscribe(onNext: { authResponse in
                self.userService.setToken(authResponse.token ?? "")
                self.preferencesService.setOnboarded()
                self.steps.accept(AppStep.registrationIsComplete)
            }).disposed(by: disposeBag)
        
        input.loginButtonClick
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                self.steps.accept(AppStep.login)
            }).disposed(by: disposeBag)
        
        return output
    }
}
