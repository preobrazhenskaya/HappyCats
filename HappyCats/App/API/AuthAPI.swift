//
//  AuthAPI.swift
//  HappyCats
//
//  Created by Яна Преображенская on 12.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

struct AuthAPI {
    static func login(login: String, password: String) -> Observable<AuthResponse> {
        return Observable.create { observer -> Disposable in
            let param = ["username": login, "password": password]
            Alamofire.request("\(Constants.API.URL.mainURL)\(Constants.API.URL.loginURL)",
                              method: .post,
                              parameters: param,
                              encoding: JSONEncoding.default)
                .responseString { response in
                    switch response.result {
                    case .success:
                        if response.response?.statusCode == 200 {
                            let authData = AuthResponse(token: response.result.value)
                            observer.onNext(authData)
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
            }
            return Disposables.create()
        }
    }
    
    static func registration(email: String, name: String, password: String, userName: String) -> Observable<AuthResponse> {
        return Observable.create { observer -> Disposable in
            let param = ["email": email, "name": name, "password": password, "username": userName]
            Alamofire.request("\(Constants.API.URL.mainURL)\(Constants.API.URL.registrationURL)",
                              method: .post,
                              parameters: param,
                              encoding: JSONEncoding.default)
                .responseString { response in
                    switch response.result {
                    case .success:
                        let authData = AuthResponse(token: response.result.value)
                        observer.onNext(authData)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
            }
            return Disposables.create()
        }
    }
}
