//
//  FcmUpdateRepository.swift
//  RoadStar Customer
//
//  Created by Apple on 29/11/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation
import Alamofire

class FcmUpdateRepository {
    
    func updateFCM(with fcm: FCMUpdate, block: @escaping (FCMUpdateResponse?, Error?) -> Void) {
        
        let url = "https://myroadstar.org/api/user/update/profile/fcm"
        
        
        let token = UserDefaults.standard.value(forKey: "loginToken") as? String ?? ""
        print(token)
        let headers: HTTPHeaders = ["Content-Type": "application/json",
                                    "X-Requested-With": "XMLHttpRequest",
                                    "Authorization":"Bearer \(token)"]
        
        AF.request(url, method: .post, parameters: fcm, encoder: JSONParameterEncoder.default, headers: headers).validate(statusCode: 200..<300).validate(contentType: ["application/json"]).responseDecodable(of: FCMUpdateResponse.self) { (response) in
            
            switch response.result{
            case .success:
                
                guard let fcmresponse = response.value else{
                    block(nil, nil)
                    return
                }
                block(fcmresponse, nil)
            case let .failure(error):
                block(nil, error)
            }
        }
    }
}
