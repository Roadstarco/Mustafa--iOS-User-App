//
//  InternationalRequest.swift
//  RoadStar Customer
//
//  Created by Apple on 03/12/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation
import UIKit

struct InternationalRequest: Encodable {

    let receiver_name: String
    let receiver_phone: String
    let item: String
    let tripfrom: String
    let tripto: String
    let item_type: String
    let item_size: String
    let arrival_date: String
    let other_information: String
    let trip_amount: String
    
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
          throw NSError()
        }
        return dictionary
      }
    
}

struct InternationalRequestResponse: Codable {
    
    let booking_id: String
    let user_id: Int
    let tripfrom: String
    let tripto: String
    let item: String
    let item_type: String
    let item_size: String
    let other_information: String
    let trip_amount: String
    let trip_status: String
    let created_by: String
    let arrival_date: String
    let receiver_name: String
    let receiver_phone: String
    let picture1: String
    let picture2: String
    let picture3: String
    let updated_at: String
    let created_at: String
    let id: Int
    
}
