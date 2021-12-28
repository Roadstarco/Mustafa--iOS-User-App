//
//  LogInRepository.swift
//  RoadStar Customer
//
//  Created by Faizan Ali  on 2020/10/4.
//  Copyright © 2020 Faizan.Technology. All rights reserved.
//

import Foundation
import Alamofire

class LogInRepository {
    
    func logIn(with logIn: LogIn, block: @escaping (LogInResponse?, Error?) -> Void) {
        
//        let url = "https://myroadstar.org/api/user/signup"
        let url = "https://myroadstar.org/oauth/token"
        let headers: HTTPHeaders = ["Content-Type": "application/json", "X-Requested-With": "XMLHttpRequest"]
        
        AF.request(url, method: .post, parameters: logIn, encoder: JSONParameterEncoder.default, headers: headers).validate(statusCode: 200..<402).validate(contentType: ["application/json"]).responseDecodable(of: LogInResponse.self) { (response) in
            
            switch response.result{
            case .success:
                
                guard let logInResponse = response.value else{
                    block(nil, nil)
                    return
                }
                block(logInResponse, nil)
            case let .failure(error):
                block(nil, error)
            }
        }
    }
    
}
