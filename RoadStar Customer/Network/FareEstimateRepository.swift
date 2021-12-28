//
//  FareEstimateRepository.swift
//  RoadStar Customer
//
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import UIKit
import Alamofire

class FareEstimateRepository {
    
    func getFareEstimation(with fareInfo: FareEstimateRequest, block: @escaping (FareEstimate?, Error?) -> Void) {
        
        let token = UserDefaults.standard.value(forKey: "loginToken") as? String ?? ""
        
        let url = "https://myroadstar.org/api/user/estimated/fare?s_latitude=\(fareInfo.pickup_lat)&s_longitude=\(fareInfo.pickup_long)&d_latitude=\(fareInfo.drop_lat)&d_longitude=\(fareInfo.drop_long)&service_type=\(fareInfo.service_id)"
        let headers: HTTPHeaders = ["Content-Type": "application/json",
                                    "X-Requested-With": "XMLHttpRequest",
                                    "Authorization":"Bearer \(token)"]
        

        AF.request(url, method: .get, headers: headers).validate(statusCode: 200..<300).validate(contentType: ["application/json"]).responseDecodable(of: FareEstimate.self) { (response) in
            
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
