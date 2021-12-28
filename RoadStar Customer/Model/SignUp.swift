//
//  SignUp.swift
//  RoadStar Customer
//
//  Created by Faizan Ali  on 2020/10/4.
//  Copyright © 2020 Faizan.Technology. All rights reserved.
//

import Foundation
import UIKit

struct SignUp: Encodable {
    let login_by: String
    let first_name: String
    let last_name: String
    let mobile: String
    let picture: Data? = nil
    let social_unique_id: String
    let email: String
    let grant_type: String
    let client_secret: String
    let client_id: String
    let password: String
    let device_type: String
    let device_id: String
    let device_token: String
    let country_name: String
    let address: String
}

struct SignUpResponse: Decodable {
    let id: Int?
    let email: String?
    let mobile: String?
    let first_name: String?
    let last_name: String?
    let login_by: String?
    let device_id: String?
    let device_token: String?
    let device_type: String?
    let address: String?
    let country_name: String?
    let payment_mode: String?
    let error: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case mobile
        case first_name
        case last_name
        case login_by
        case device_id
        case device_token
        case device_type
        case address
        case country_name
        case payment_mode
        case error
    }
}
