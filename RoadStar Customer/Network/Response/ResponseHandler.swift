//
//  NetworkRepository.swift
//  RoadStar Customer
//
//  Created by Faizan Ali  on 2020/10/4.
//  Copyright © 2020 Faizan.Technology. All rights reserved.
//


import Foundation
import Alamofire

// MARK: - APIErrors
struct APIErrors: Codable, CodableInit {
    let message: String
    let errors: [String: [String]]
}

struct CustomError: APIErrorProtocol {

    var title: String?
    var code: Int
    var errorDescription: String? { return _description }
    var failureReason: String? { return _description }

    private var _description: String

    init(title: String?, description: String, code: Int) {
        self.title = title ?? "Error"
        self._description = description
        self.code = code
    }
}

protocol APIErrorProtocol: LocalizedError {
    var title: String? { get }
    var code: Int { get }
}

protocol HandleAlamoResponse {
    /// Handles request response, never called anywhere but APIRequestHandler
    ///
    /// - Parameters:
    ///   - response: response from network request, for now alamofire Data response
    ///   - completion: completing processing the json response, and delivering it in the completion handler
    func handleResponse<T: CodableInit>(_ response: AFDataResponse<Data>, completion: CallResponse<T>)
}

extension HandleAlamoResponse {
    
    func handleResponse<T: CodableInit>(_ response: AFDataResponse<Data>, completion: CallResponse<T>) {
        if let error = response.error {
            print(error)
            if let data = response.data {
                do {
                    let tempData = try JSONDecoder().decode(APIErrors.self, from: data)
                    print(tempData.errors)
                    var errorString = ""
                    tempData.errors.forEach { (err) in
                        let colors = Array(err.value)
                        print(colors)
                        colors.forEach { (finalErrorString) in
                            errorString += "\(finalErrorString)\n"
                        }
                    }
                    
                    let customError = CustomError(title: "User error", description: errorString, code: error.responseCode ?? 401)
                    completion?(.failure(customError))
                    
                }catch let err{
                    completion?(.failure(err))
                }
            }
            
            return
        }
        
        switch response.result {
        case .failure(let error):
            completion?(.failure(error))
        case .success(let value):
            do {
                let modules = try T(data: value)
                completion?(.success(modules))
            } catch {
                completion?(.failure(error))
            }
        }
    }
    
}
