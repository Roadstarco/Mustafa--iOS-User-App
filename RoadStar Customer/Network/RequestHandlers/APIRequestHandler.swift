//
//  NetworkRepository.swift
//  RoadStar Customer
//
//  Created by Faizan Ali  on 2020/10/4.
//  Copyright © 2020 Faizan.Technology. All rights reserved.
//

import Foundation
import Alamofire

private let AFManager: Session = {
//    let manager = ServerTrustManager(evaluators: [
//
//    ])case reloadIgnoringLocalAndRemoteCacheData
    let configuration = URLSessionConfiguration.af.default
    configuration.timeoutIntervalForRequest = 15
    configuration.timeoutIntervalForResource = 15
    configuration.sessionSendsLaunchEvents = false
    configuration.httpCookieAcceptPolicy = .never
    configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    configuration.shouldUseExtendedBackgroundIdleMode = true
    
    return Session(configuration: configuration, serverTrustManager: nil)
}()

/// Response completion handler beautified.
typealias CallResponse<T> = ((Result<T, Error>) -> Void)?


/// API protocol, The alamofire wrapper
protocol APIRequestHandler: HandleAlamoResponse { }

extension APIRequestHandler where Self: URLRequestBuilder {

    func send<T: CodableInit>(_ decoder: T.Type, data: UploadData? = nil, progress: ((Progress) -> Void)? = nil, then: CallResponse<T>) {
        if let data = data {
            uploadToServerWith(decoder, data: data, request: self, parameters: self.parameters, progress: progress, then: then)
        }else{
            print(self)
            AFManager.request(self).validate().responseData { (response) in
             
                
                switch response.result {
                case .success: //
                    if let data = response.data {
                        print(data)
                    }
                    self.handleResponse(response, completion: then)
                case .failure(let error):
                    print(error)
                    if let data = response.data {
                        print(data)
                    }
                    
                    self.handleResponse(response, completion: then)
                    print(error.localizedDescription)
                }
                
            }.responseJSON { (response) in
                // handle debug
                print(response.value as Any)
            }
        }
    }
    
   
}


extension APIRequestHandler {
    
    private func uploadToServerWith<T: CodableInit>(_ decoder: T.Type, data: UploadData, request: URLRequestConvertible, parameters: Parameters?, progress: ((Progress) -> Void)?, then: CallResponse<T>) {
        
        AF.upload(multipartFormData: { mul in
            mul.append(data.data, withName: data.name, fileName: data.fileName, mimeType: data.mimeType)
            guard let parameters = parameters else { return }
            for (key, value) in parameters {
                mul.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
        }, with: request).responseData { results in
            self.handleResponse(results, completion: then)
        }.responseString { string in
            debugPrint(string.value as Any)
        }
    }
}
