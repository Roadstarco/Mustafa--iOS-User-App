//
//  ServicesRepository.swift
//  RoadStar Customer
//
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import UIKit
import Alamofire

class ServicesRepository {

    func getServicesList(block: @escaping (ServiceList?, Error?) -> Void) {
        
        let token = UserDefaults.standard.value(forKey: "loginToken") as? String ?? ""
        
        let url = "https://myroadstar.org/api/user/services"
        let headers: HTTPHeaders = ["Content-Type": "application/json",
                                    "X-Requested-With": "XMLHttpRequest",
                                    "Authorization":"Bearer \(token)"]
        

        AF.request(url, method: .get, headers: headers).validate(statusCode: 200..<300).validate(contentType: ["application/json"]).responseDecodable(of: ServiceList.self) { (response) in
            
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
