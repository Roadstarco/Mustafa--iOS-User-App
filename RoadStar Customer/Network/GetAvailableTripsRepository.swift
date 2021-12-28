//
//  GetAvailableTripsRepository.swift
//  RoadStar Customer
//
//  Created by Apple on 03/12/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class GetAvailableTripsRepository{
    
    func getAvailableTrips(block: @escaping ([AvailableTripsResponse]?, Error?) -> Void) {
        
        let token = UserDefaults.standard.value(forKey: "loginToken") as? String ?? ""
        
        let url = "https://myroadstar.org/api/user/travels"
        let headers: HTTPHeaders = ["Content-Type": "application/json",
                                    "X-Requested-With": "XMLHttpRequest",
                                    "Authorization":"Bearer \(token)"]
        

        AF.request(url, method: .post, headers: headers).validate(statusCode: 200..<600).validate(contentType: ["application/json"]).responseDecodable(of: [AvailableTripsResponse].self) { (response) in
            
            switch response.result{
            case .success:
                
                guard let responseV = response.value else{
                    block(nil, nil)
                    return
                }
                block(responseV, nil)
            case let .failure(error):
                block(nil, error)
            }
        }
    }
    
    
}
