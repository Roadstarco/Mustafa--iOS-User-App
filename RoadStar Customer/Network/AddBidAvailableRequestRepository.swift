//
//  AddBidAvailableRequestRepository.swift
//  RoadStar Customer
//
//  Created by Apple on 04/12/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class AddBidAvailableRequestRepository{
    
    func addBidAvailableTrips(request:AddBidAvailableTripsModel, attachemnts:[String], block: @escaping (AddBidAvailableTripResponse?, Error?) -> Void) {
        let url = "https://myroadstar.org/api/user/request-trip"
        let token = UserDefaults.standard.value(forKey: "loginToken") as? String ?? ""
        print(token)
        
        
        
        if attachemnts.count == 0
        {
            let headers: HTTPHeaders = ["Content-Type": "application/json",
                                        "X-Requested-With": "XMLHttpRequest",
                                        "Authorization":"Bearer \(token)"]
            

            AF.request(url, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: headers).validate(statusCode: 200..<600).validate(contentType: ["application/json"]).responseDecodable(of: AddBidAvailableTripResponse.self){ (response) in

                switch response.result{
                case .success:

                    guard let apiResponse = response.value else{
                        block(nil, nil)
                        return
                    }
                    block(apiResponse, nil)
                case let .failure(error):
                    let response = error
                    block(nil, error)
                }
            }
        }
        else
        {
            let headers: HTTPHeaders = ["Content-Type": "multipart/form-data",
                                        "X-Requested-With": "XMLHttpRequest",
                                        "Authorization":"Bearer \(token)"]
            
            AF.upload(multipartFormData: { multipartFormData in
                
                for (index,value) in attachemnts.enumerated()
                {
                    let imageName = (value as NSString).lastPathComponent
                    let imageData = UIImage(contentsOfFile: value)!
                    multipartFormData.append(imageData.jpegData(compressionQuality: 0.7)!, withName: "picture\(index+1)", fileName: imageName, mimeType: "image/png")
                }
                
                var params = [String:Any]()
                params = try! request.asDictionary()

                for (key, value) in params {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
            },
            to: url, method: .post , headers: headers)
            .responseDecodable(of: AddBidAvailableTripResponse.self){ (response) in

                switch response.result{
                case .success:

                    guard let apiResponse = response.value else{
                        block(nil, nil)
                        return
                    }
                    block(apiResponse, nil)
                case let .failure(error):
                    let response = error
                    block(nil, error)
                }
            }
            
//            AF.upload(multipartFormData: { multipartFormData in
//                for value in attachemnts
//                {
//                    let imageName = (value as NSString).lastPathComponent
//                    let imageData = UIImage(contentsOfFile: value)
//                    multipartFormData.append(imageData, withName: "file", fileName: imageName, mimeType: "image/png")
//                }
//
//                var params = [String:Any]()
//                params = try request.asDictionary()
//
//                for (key, value) in params {
//                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
//                }
//            }, to: URL(string: url)!, method: .post , headers: headers)
//            .response { resp in
//                print(resp)
//
//
//            }
            
            
        }
        
    }
    
    
    
}
