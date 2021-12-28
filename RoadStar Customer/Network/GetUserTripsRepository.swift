//
//  GetUserTripsRepository.swift
//  RoadStar Customer
//
//  Created by Apple on 06/12/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class GetUserTripsRepository{
    
    func getUserTrips(block: @escaping ([UserTripsModel]?, Error?) -> Void) {
        
        let token = UserDefaults.standard.value(forKey: "loginToken") as? String ?? ""
        
        let url = "https://myroadstar.org/api/user/user-trips"
        let headers: HTTPHeaders = ["Content-Type": "application/json",
                                    "X-Requested-With": "XMLHttpRequest",
                                    "Authorization":"Bearer \(token)"]
        

        AF.request(url, method: .post, headers: headers).validate(statusCode: 200..<600).validate(contentType: ["application/json"]).responseDecodable(of: [UserTripsModel].self) { (response) in
            
            switch response.result{
            case .success:
                
                guard let response = response.value else{
                    block(nil, nil)
                    return
                }
                block(response, nil)
            case let .failure(error):
                block(nil, error)
            }
        }
    }
    
    
}
