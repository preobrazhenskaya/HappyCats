//
//  PhotoAPI.swift
//  HappyCats
//
//  Created by Яна Преображенская on 19.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import Cloudinary

struct PhotoAPI {
    static func uploadPhoto(photo: UIImage?) -> Observable<String> {
        let config = CLDConfiguration(cloudName: Constants.API.Cloudinary.cloudName, secure: false)
        let cloudinary = CLDCloudinary(configuration: config)
        let params = CLDUploadRequestParams().setFolder(Constants.API.Cloudinary.folder)
        return Observable.create { observer -> Disposable in
            if let imageData = photo?.pngData() {
                cloudinary.createUploader().upload(data: imageData,
                                                   uploadPreset: Constants.API.Cloudinary.preset,
                                                   params: params) { (response, error) in
                    observer.onNext((response?.secureUrl).orEmpty)
                }
            }
            return Disposables.create()
        }
    }
}
