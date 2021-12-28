//
//  AcceptRejectCounterRepository.swift
//  RoadStar Customer
//
//  Created by Apple on 05/12/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class AcceptRejectCounterRepository{
    
    
    
    func acceptCounter(with param: AcceptRejectModel, block: @escaping (AcceptRejectResponse?, Error?) -> Void) {
        
        let url = "https://myroadstar.org/api/user/bid/counter-accept"
        
        
        let token = UserDefaults.standard.value(forKey: "loginToken") as? String ?? ""
        print(token)
        let headers: HTTPHeaders = ["Content-Type": "application/json",
                                    "X-Requested-With": "XMLHttpRequest",
                                    "Authorization":"Bearer \(token)"]
        
        AF.request(url, method: .post, parameters: param, encoder: JSONParameterEncoder.default, headers: headers).validate(statusCode: 200..<600).validate(contentType: ["application/json"]).responseDecodable(of: AcceptRejectResponse.self) { (response) in
            
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
    
    func rejectCounter(with param: AcceptRejectModel, block: @escaping (AcceptRejectResponse?, Error?) -> Void) {
        
        let url = "https://myroadstar.org/api/user/bid/counter-reject"
        
        
        let token = UserDefaults.standard.value(forKey: "loginToken") as? String ?? ""
        print(token)
        let headers: HTTPHeaders = ["Content-Type": "application/json",
                                    "X-Requested-With": "XMLHttpRequest",
                                    "Authorization":"Bearer \(token)"]
        
        AF.request(url, method: .post, parameters: param, encoder: JSONParameterEncoder.default, headers: headers).validate(statusCode: 200..<600).validate(contentType: ["application/json"]).responseDecodable(of: AcceptRejectResponse.self) { (response) in
            
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
