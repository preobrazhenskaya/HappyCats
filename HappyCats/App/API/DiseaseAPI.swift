//
//  DiseaseAPI.swift
//  HappyCats
//
//  Created by Яна Преображенская on 17.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

struct DiseaseAPI {
    static func getAllDisease(token: String) -> Observable<[Disease]> {
        return Observable.create { observer -> Disposable in
            let headers = [Constants.API.Headers.auth: token]
            Alamofire.request("\(Constants.API.URL.mainURL)\(Constants.API.URL.allDisease)",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        if response.response?.statusCode == 200 {
                            guard let data = response.data else { return }
                            do {
                                let disease = try JSONDecoder().decode([Disease].self, from: data)
                                observer.onNext(disease)
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
    
    static func getDisease(withId id: Int, token: String) -> Observable<Disease> {
        return Observable.create { observer -> Disposable in
            let headers = [Constants.API.Headers.auth: token]
            Alamofire.request("\(Constants.API.URL.mainURL)\(Constants.API.URL.diseaseById)/\(id)",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        if response.response?.statusCode == 200 {
                            guard let data = response.data else { return }
                            do {
                                let disease = try JSONDecoder().decode(Disease.self, from: data)
                                observer.onNext(disease)
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
}
