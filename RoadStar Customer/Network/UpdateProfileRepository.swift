//
//  UpdateProfileRepository.swift
//  RoadStar Customer
//
//  Created by Apple on 29/10/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class UpdateProfileRepository{
    
    func updateProfile(request: UpdateProfileRequest, picture: URL?, image: UIImage, block: @escaping (ProfileUpdatedResponse?, Error?) -> Void){
        
        let token = UserDefaults.standard.value(forKey: "loginToken") as? String ?? ""
        print(token)
        let url = "https://myroadstar.org/api/user/update/profile"
        
        let headers: HTTPHeaders = ["Content-Type": "application/json",
                                    "X-Requested-With": "XMLHttpRequest",
                                    "Authorization":"Bearer \(token)"]
        if picture != nil{
        AF.upload(multipartFormData: { multipartFormData in
            
           
                
            
            let imageName = picture?.lastPathComponent
            multipartFormData.append(image.jpegData(compressionQuality: 0.7)!, withName: "picture", fileName: imageName, mimeType: "image/png")

            
            var params = [String:Any]()
            params = try! request.asDictionary()

            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: url, method: .post, headers: headers).validate(statusCode: 200..<600).validate(contentType: ["application/json"]).responseDecodable(of: ProfileUpdatedResponse.self){ (response) in
            
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
        }else{
            AF.request(url, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: headers).validate(statusCode: 200..<600).validate(contentType: ["application/json"]).responseDecodable(of: ProfileUpdatedResponse.self) { (response) in

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
    }

        
        
    
    func send(){
        
        
        
    }
//    

