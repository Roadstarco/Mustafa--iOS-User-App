//
//  LogIn.swift
//  RoadStar Customer
//
//  Created by Faizan Ali  on 2020/10/4.
//  Copyright © 2020 Faizan.Technology. All rights reserved.
//

import Foundation

struct LogIn: Encodable {
    
    let grant_type: String
    let client_id: Int
    let client_secret: String
    let username: String
    let password: String
    let scope: String
    let device_type: String
    let device_id: String
    let device_token: String
    
}


struct LogInResponse: Decodable {
   
    let expires_in: Int?
    let token_type: String?
    let access_token: String?
    let refresh_token: String?
    let error: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case expires_in
        case token_type
        case access_token
        case refresh_token
        case error
        case message
    }
}

