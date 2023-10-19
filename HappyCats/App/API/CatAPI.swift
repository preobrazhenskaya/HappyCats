//
//  CatAPI.swift
//  HappyCats
//
//  Created by Яна Преображенская on 18.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

struct CatAPI {
    static func getAllCats(token: String) -> Observable<[Cat]> {
        return Observable.create { observer -> Disposable in
            let headers = [Constants.API.Headers.auth: token]
            Alamofire.request("\(Constants.API.URL.mainURL)\(Constants.API.URL.myCats)",
                              method: .get,
                              encoding: JSONEncoding.default,
                              headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        if response.response?.statusCode == 200 {
                            guard let data = response.data else { return }
                            do {
                                let cats = try JSONDecoder().decode([Cat].self, from: data)
                                observer.onNext(cats)
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
    
    static func getCat(withId id: Int, token: String) -> Observable<Cat> {
        return Observable.create { observer -> Disposable in
            let headers = [Constants.API.Headers.auth: token]
            Alamofire.request("\(Constants.API.URL.mainURL)\(Constants.API.URL.catById)/\(id)",
                              method: .get,
                              encoding: JSONEncoding.default,
                              headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        if response.response?.statusCode == 200 {
                            guard let data = response.data else { return }
                            do {
                                let cat = try JSONDecoder().decode(Cat.self, from: data)
                                observer.onNext(cat)
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
    
    static func updateCat(token: String, id: Int, name: String, breed: String, birthday: String, note: String, photo: String) -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            let headers = [Constants.API.Headers.auth: token]
            let param = ["name": name, "breed": breed, "birthday": birthday, "note": note, "photo": photo]
            Alamofire.request("\(Constants.API.URL.mainURL)\(Constants.API.URL.updateCat)/\(id)",
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
    
    static func addCat(token: String, name: String, breed: String, birthday: String, note: String, photo: String) -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            let headers = [Constants.API.Headers.auth: token]
            let param = ["name": name, "breed": breed, "birthday": birthday, "note": note, "photo": photo]
            Alamofire.request("\(Constants.API.URL.mainURL)\(Constants.API.URL.addCat)",
                              method: .post,
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

