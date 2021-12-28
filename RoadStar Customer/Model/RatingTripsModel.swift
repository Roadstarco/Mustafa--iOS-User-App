//
//  RatingTripsModel.swift
//  RoadStar Customer
//
//  Created by Apple on 28/10/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation
struct RatingTripsRequest: Encodable{
    
    let request_id: Int?
    let rating: Int?
    let comment: String?
    enum CodingKeys: String, CodingKey {
        case request_id
        case rating
        case comment
        
      
    }
}
struct RatingTripsResponse: Codable{
    let status: Bool?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message = "message"
        
      
    }
}
struct RatingTripsRequest2: Encodable{
    
    let trip_id: Int?
    let rating: Int?
    let comment: String?
    enum CodingKeys: String, CodingKey {
        case trip_id
        case rating
        case comment
        
      
    }
}

