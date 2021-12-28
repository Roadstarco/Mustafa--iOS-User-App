//
//  ChangePassModel.swift
//  RoadStar Customer
//
//  Created by Apple on 01/11/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import UIKit
import Foundation

struct ChangePasswordRequest: Encodable{
    var password: String = ""
    var old_password: String = ""
    var password_confirmation = ""
}
struct ChangePasswordResponse: Codable {
    var status: Bool
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case status
        case message = "message"
        
      
    }
}
