//
//  SignUpRepository.swift
//  RoadStar Customer
//
//  Created by Faizan Ali  on 2020/10/4.
//  Copyright © 2020 Faizan.Technology. All rights reserved.
//

import Foundation
import Alamofire

class SignUpRepository {
    
    func signUp(with signUp: SignUp, block: @escaping (SignUpResponse?, Error?) -> Void) {
        
        let url = "https://myroadstar.org/api/user/signup"
        
        let headers: HTTPHeaders = ["Content-Type": "application/json", "X-Requested-With": "XMLHttpRequest"]
        
        AF.request(url, method: .post, parameters: signUp, encoder: JSONParameterEncoder.default, headers: headers).validate(statusCode: 200..<600).validate(contentType: ["application/json"]).responseDecodable(of: SignUpResponse.self) { (response) in
            
            switch response.result{
            case .success:
                
                guard let signUpResponse = response.value else{
                    block(nil, nil)
                    return
                }
                block(signUpResponse, nil)
            case let .failure(error):
                block(nil, error)
            }
        }
    }
    
}
