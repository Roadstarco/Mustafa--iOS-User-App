//
//  FCMUpdate.swift
//  RoadStar Customer
//
//  Created by Apple on 29/11/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation
import UIKit

struct FCMUpdate: Encodable {
    let fcm: String
    
}
struct FCMUpdateResponse: Decodable {
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case message
        
    }
}
