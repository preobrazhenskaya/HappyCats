//
//  UserAPI.swift
//  HappyCats
//
//  Created by Яна Преображенская on 14.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

struct UserAPI {
    static func getUser(token: String) -> Observable<User> {
        return Observable.create { observer -> Disposable in
            let headers = [Constants.API.Headers.auth: token]
            Alamofire.request("\(Constants.API.URL.mainURL)\(Constants.API.URL.user)",
                              method: .get,
                              encoding: JSONEncoding.default,
                              headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        if response.response?.statusCode == 200 {
                            guard let data = response.data else { return }
                            do {
                                let user = try JSONDecoder().decode(User.self, from: data)
                                observer.onNext(user)
                            }
                            catch {
                                print("Can't fetch data")
                            }
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
            }
            return Disposables.create()
        }
    }
    
    static func updateUser(token: String, name: String, login: String, email: String, phone: String, birthday: String, note: String, photo: String) -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            let headers = [Constants.API.Headers.auth: token]
            let param = ["name": name, "login": login, "email": email, "phone": phone, "birthday": birthday, "note": note, "photo": photo]
            Alamofire.request("\(Constants.API.URL.mainURL)\(Constants.API.URL.user)",
                              method: .put,
                              parameters: param,
                              encoding: JSONEncoding.default,
                              headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        if response.response?.statusCode == 200 {
                            observer.onNext(Void())
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
            }
            return Disposables.create()
        }
    }
}
