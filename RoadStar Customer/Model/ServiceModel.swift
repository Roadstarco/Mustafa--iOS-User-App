//
//  ServiceClass.swift
//  RoadStar Customer
//
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import UIKit


// MARK: - ServiceModel
struct ServiceModel: Codable {
    let id: Int
    let zones, name, providerName: String
    let image: String
    let capacity: Int
    let fixed, price, minute: String
    let distance: Int
    let calculator, serviceElementDescription: String
    let status: Int

    enum CodingKeys: String, CodingKey {
        case id, zones, name
        case providerName = "provider_name"
        case image, capacity, fixed, price, minute, distance, calculator
        case serviceElementDescription = "description"
        case status
    }
}


typealias ServiceList = [ServiceModel]
