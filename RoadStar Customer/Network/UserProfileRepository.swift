//
//  UserProfileRepository.swift
//  RoadStar Customer
//
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import UIKit
import Alamofire


class UserProfileRepository {
    
    func getUserProfile(with profile: ProfileRequest, block: @escaping (ProfileModel?, Error?) -> Void) {
        
//        let url = "https://myroadstar.org/api/user/signup"
        let url = "https://myroadstar.org/api/user/details?device_type=ios&device_id=d7efe9cadf4f483e&device_token="
        let headers: HTTPHeaders = ["Content-Type": "application/json",
                                    "X-Requested-With": "XMLHttpRequest",
                                    "Authorization":"Bearer \(profile.token)"]
        

        AF.request(url, method: .get, headers: headers).validate(statusCode: 200..<300).validate(contentType: ["application/json"]).responseDecodable(of: ProfileModel.self) { (response) in
            
            switch response.result{
            case .success:
                
                guard let profileResponse = response.value else{
                    block(nil, nil)
                    return
                }
                block(profileResponse, nil)
            case let .failure(error):
                block(nil, error)
            }
        }
    }
    
}

