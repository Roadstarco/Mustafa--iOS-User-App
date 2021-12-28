//
//  AddBidAvailableTripsModel.swift
//  RoadStar Customer
//
//  Created by Apple on 04/12/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation
import UIKit

struct AddBidAvailableTripsModel: Encodable {

    let receiver_name: String
    let receiver_phone: String
    let item: String
    let item_type: String
    let item_size: String
    let description: String
    let amount: String
    let trip_id: Int
    
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
          throw NSError()
        }
        return dictionary
      }
    
}
struct AddBidAvailableTripResponse: Decodable{
    
    let user_id: Int?
    let trip_id: Int?
    let item: String?
    let item_type: String?
    let item_size: String?
    let description: String?
    let amount: String?
    let receiver_name: String?
    let receiver_phone: String?
    let picture1: String?
    let picture2: String?
    let picture3: String?
    let updated_at: String?
    let created_at: String?
    let id: Int?
    
    
    
}
