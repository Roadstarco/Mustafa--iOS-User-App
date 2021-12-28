//
//  FareEstimate.swift
//  RoadStar Customer
//

//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let fareEstimate = try? newJSONDecoder().decode(FareEstimate.self, from: jsonData)

import Foundation


struct FareEstimateRequest: Encodable {
    
    var pickup_lat = 0.0
    var pickup_long = 0.0
    var drop_lat = 0.0
    var drop_long = 0.0
    var service_id = 0
}

// MARK: - FareEstimate
struct FareEstimate: Codable {
    let estimatedFare, distance: Int
    let time: String
    let surge: Int
    let surgeValue: String
    let taxPrice: Int
    let basePrice: String
    let walletBalance: Int

    enum CodingKeys: String, CodingKey {
        case estimatedFare = "estimated_fare"
        case distance, time, surge
        case surgeValue = "surge_value"
        case taxPrice = "tax_price"
        case basePrice = "base_price"
        case walletBalance = "wallet_balance"
    }
}
