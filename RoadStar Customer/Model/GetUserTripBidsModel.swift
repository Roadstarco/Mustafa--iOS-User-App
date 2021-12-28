//
//  GetUserTripBidsModel.swift
//  RoadStar Customer
//
//  Created by Apple on 06/12/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation
import UIKit

struct GetUserTripBidsRequest: Encodable{
    
    let trip_id: Int?
    
    
}

struct GetUserTripBidsResponse: Decodable{
    
    
    let id: Int?
    let user_id: Int?
    let provider_id: Int?
    let trip_id: Int?
    let item: String?
    let send_from: Int?
    let send_to: String?
    let item_type: String?
    let item_size: String?
    let picture1: String?
    let picture2: String?
    let picture3: String?
    let description: String?
    let amount: Int?
    let traveller_response: String?
    let service_type: String?
    let created_by: String?
    let status: String?
    let receiver_name: String?
    let receiver_phone: String?
    let updated_at: String?
    let created_at: String?
    let counter_amount: Int?
    let is_counter: Int?
    let first_name: String?
    let last_name: String?
    let avatar: String?
    let error: String?
    
    
    
}
