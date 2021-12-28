//
//  TripRequestRepository.swift
//  RoadStar Customer
//
//  Created by Usman Nisar on 12/08/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import UIKit
import Alamofire

class TripRequestRepository {
    
    
    func sendRequestForTrip(request:SendRequestModel, attachemnts:[String], block: @escaping (SendRequestResponse?, Error?) -> Void) {
        let url = "https://myroadstar.org/api/user/send/request1"
        let token = UserDefaults.standard.value(forKey: "loginToken") as? String ?? ""
        
        
        
        
        if attachemnts.count == 0
        {
            let headers: HTTPHeaders = ["Content-Type": "application/json",
                                        "X-Requested-With": "XMLHttpRequest",
                                        "Authorization":"Bearer \(token)"]
            

            AF.request(url, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: headers).validate(statusCode: 200..<300).validate(contentType: ["application/json"]).responseDecodable(of: SendRequestResponse.self){ (response) in

                switch response.result{
                case .success:

                    guard let apiResponse = response.value else{
                        block(nil, nil)
                        return
                    }
                    block(apiResponse, nil)
                case let .failure(error):
                    let response = SendRequestResponse(message: String(bytes: response.data!, encoding: .utf8) ?? "Error occured", request_id: -1)
                    block(response, error)
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
                    multipartFormData.append(imageData.jpegData(compressionQuality: 0.7)!, withName: "attachment\(index+1)", fileName: imageName, mimeType: "image/png")
                }
                
                var params = [String:Any]()
                params = try! request.asDictionary()

                for (key, value) in params {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
            },
            to: url, method: .post , headers: headers)
            .responseDecodable(of: SendRequestResponse.self){ (response) in

                switch response.result{
                case .success:

                    guard let apiResponse = response.value else{
                        block(nil, nil)
                        return
                    }
                    block(apiResponse, nil)
                case let .failure(error):
                    let response = SendRequestResponse(message: String(bytes: response.data!, encoding: .utf8) ?? "Error occured", request_id: -1)
                    block(response, error)
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
    
   
//    func getRequestStatusForTrip(block: @escaping (RequestStatus?, Error?) -> Void) {
//        
//        let token = UserDefaults.standard.value(forKey: "loginToken") as? String ?? ""
//        
//        let url = "https://myroadstar.org/api/user/request/check"
//        let headers: HTTPHeaders = ["Content-Type": "application/json",
//                                    "X-Requested-With": "XMLHttpRequest",
//                                    "Authorization":"Bearer \(token)"]
//
//        
//        AF.request(url, method: .get, headers: headers).validate(statusCode: 200..<300).validate(contentType: ["application/json"]).responseDecodable(of: RequestStatus.self) { (response) in
////
//            switch response.result{
//            case .success:
//
//                guard let responseV = response.value else{
//                    block(nil, nil)
//                    return
//                }
//                block(responseV, nil)
//            case let .failure(error):
//                block(nil, error)
//            }
//        }
//    }
    
    func getRequestStatus(block: @escaping (GetRequestStatusResponse?, Error?) -> Void) {
        //
        let token = UserDefaults.standard.value(forKey: "loginToken") as? String ?? ""
        //
        let url = "https://myroadstar.org/api/user/request/check"
        let headers: HTTPHeaders = ["Content-Type": "application/json",
                                    "X-Requested-With": "XMLHttpRequest",
                                    "Authorization":"Bearer \(token)"]

        let params : Parameters = ["test":"test"]

        AF.request(url,method: .get,parameters: params, headers: headers)
            .validate()
            .responseDecodable(of: GetRequestStatusResponse.self) { (response) in

                switch response.result {
                case .success:
                    guard let apiResponse = response.value else{
                        block(nil, nil)
                        return
                    }
                    block(apiResponse, nil)

                case let .failure(error):
                    block(nil, error)
                }
            }
    }
    
    func cancelRequest(request:CancelBookingModel, block: @escaping (Bool, Error?) -> Void) {
        //
        let token = UserDefaults.standard.value(forKey: "loginToken") as? String ?? ""
        //End point /api/user/cancel/request
        //Params: request_id, cancel_reason
        let url = "https://myroadstar.org/api/user/cancel/request"
        let headers: HTTPHeaders = ["Content-Type": "application/json",
                                    "X-Requested-With": "XMLHttpRequest",
                                    "Authorization":"Bearer \(token)"]

        AF.request(url, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: headers).validate(statusCode: 200..<300).validate(contentType: ["application/json"])
            .response { (response) in

                switch response.result {
                case .success:
                    guard response.value != nil else{
                        block(false, nil)
                        return
                    }
                    block(true, nil)

                case let .failure(error):
                    block(false, error)
                }
            }
    }
}
