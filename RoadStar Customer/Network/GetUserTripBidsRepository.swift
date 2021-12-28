//
//  GetUserTripBidsRepository.swift
//  RoadStar Customer
//
//  Created by Apple on 06/12/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class GetUserTripBidsRepository{

func getAllBids(with param: GetUserTripBidsRequest, block: @escaping ([GetUserTripBidsResponse]?, Error?) -> Void) {
    
    let url = "https://myroadstar.org/api/user/trip-bids"
    
    
    let token = UserDefaults.standard.value(forKey: "loginToken") as? String ?? ""
    print(token)
    let headers: HTTPHeaders = ["Content-Type": "application/json",
                                "X-Requested-With": "XMLHttpRequest",
                                "Authorization":"Bearer \(token)"]
    
    AF.request(url, method: .post, parameters: param, encoder: JSONParameterEncoder.default, headers: headers).validate(statusCode: 200..<600).validate(contentType: ["application/json"]).responseDecodable(of: [GetUserTripBidsResponse].self) { (response) in
        
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
