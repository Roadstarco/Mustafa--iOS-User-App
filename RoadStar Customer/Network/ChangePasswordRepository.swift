//
//  ChangePassRepository.swift
//  RoadStar Customer
//
//  Created by Apple on 01/11/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ChangePasswordRepository{
    
//    func ChangePass( with request: ChangePasswordRequest, block: @escaping (ChangePasswordResponse?, Error?) -> Void){
//
//        let token = UserDefaults.standard.value(forKey: "loginToken") as? String ?? ""
//
//        let url = "https://myroadstar.org/api/user/rate_trip_provider"
//
//        let headers: HTTPHeaders = ["Content-Type": "application/json",
//                                    "X-Requested-With": "XMLHttpRequest",
//                                    "Authorization":"Bearer \(token)"]
//        AF.request(url, method: .post, headers: headers).validate(statusCode: 200..<300).validate(contentType: ["application/json"]).responseDecodable(of: ChangePasswordResponse.self) { (response) in
//
//            switch response.result{
//            case .success:
//
//                guard let profileResponse = response.value else{
//                    block(nil, nil)
//                    return
//                }
//                block(profileResponse, nil)
//            case let .failure(error):
//                block(nil, error)
//            }
//        }
//
//    }
    
    func changePass(request: ChangePasswordRequest, block: @escaping (Bool, Error?) -> Void) {
        
        let url = "https://myroadstar.org/api/user/change/password"
        let token = UserDefaults.standard.value(forKey: "loginToken") as? String ?? ""
        let headers: HTTPHeaders = ["Content-Type": "application/json",
                                    "X-Requested-With": "XMLHttpRequest",
                                    "Authorization":"Bearer \(token)"]

//        let headers: HTTPHeaders = ["Content-Type": "application/json", "X-Requested-With": "XMLHttpRequest"]
        
        AF.request(url, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: headers).validate(statusCode: 200..<600).validate(contentType: ["application/json"]).response { (response) in
            
            switch response.result{
            case .success:
                
                guard response.value != nil else{
                    block(false, nil)
                    return
                }
                block(true, nil)
            case let .failure(error):
                block(false, error)
            }
        }
    }
    
    
}
//Decodable(of: ChangePasswordResponse.self)
//ChangePasswordResponse?
