//
//  RateTripsRepository.swift
//  RoadStar Customer
//
//  Created by Apple on 28/10/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation
import Alamofire

class RateTripsRepository {
    
    func rateTrip( with request: RatingTripsRequest, block: @escaping (RatingTripsResponse?, Error?) -> Void){
        
        let token = UserDefaults.standard.value(forKey: "loginToken") as? String ?? ""
        
        let url = "https://myroadstar.org/api/user/rate/provider"
        
        let headers: HTTPHeaders = ["Content-Type": "application/json",
                                    "X-Requested-With": "XMLHttpRequest",
                                    "Authorization":"Bearer \(token)"]
        AF.request(url, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: headers).validate(statusCode: 200..<600).validate(contentType: ["application/json"]).responseDecodable(of: RatingTripsResponse.self) { (response) in
            
            switch response.result{
            case .success:
                
                guard let ratingResponse = response.value else{
                    block(nil, nil)
                    return
                }
                block(ratingResponse, nil)
            case let .failure(error):
                block(nil, error)
            }
        }
        
    }
    func rateTrip2( with request: RatingTripsRequest2, block: @escaping (RatingTripsResponse?, Error?) -> Void){
        
        let token = UserDefaults.standard.value(forKey: "loginToken") as? String ?? ""
        
        let url = "https://myroadstar.org/api/user/rate-trip-provider"
        
        let headers: HTTPHeaders = ["Content-Type": "application/json",
                                    "X-Requested-With": "XMLHttpRequest",
                                    "Authorization":"Bearer \(token)"]
        AF.request(url, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: headers).validate(statusCode: 200..<600).validate(contentType: ["application/json"]).responseDecodable(of: RatingTripsResponse.self) { (response) in
            
            switch response.result{
            case .success:
                
                guard let ratingResponse = response.value else{
                    block(nil, nil)
                    return
                }
                block(ratingResponse, nil)
            case let .failure(error):
                block(nil, error)
            }
        }
        
    }
    
}
