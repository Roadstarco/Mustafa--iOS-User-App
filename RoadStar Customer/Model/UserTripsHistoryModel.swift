//
//  UserTripsHistoryModel.swift
//  RoadStar Customer
//
//  Created by Apple on 06/12/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation
import UIKit
struct UserTripsHistoryModel: Decodable{
    
    let localJobs: [LocalJobs]
    let internationalJobs: [InternationalJobs]
    
}

struct LocalJobs: Decodable{
    
    
    
}

struct InternationalJobs: Decodable{
    
    let id: Int?
    let booking_id: String?
    let provider_id: Int?
    let user_id: Int?
    let tripfrom: String?
    let tripto: String?
    let arrival_date: String?
    let recurrence: String?
    let item_size: String?
    let item: String?
    let item_type: String?
    let other_information: String?
    let service_type: String?
    let vessel_id: String?
    let vessel_imo: String?
    let vessel_name: String?
    let source_port_id: String?
    let destination_port_id: String?
    let vessel_tracking_count: Int?
    let flight_no: String?
    let departure_time: String?
    let airport: String?
    let flight_tracking_count: Int?
    let tripfrom_lat: String?
    let tripfrom_lng: String?
    let tripto_lat: String?
    let tripto_lng: String?
    let trip_amount: Int?
    let receiver_name: String?
    let receiver_phone: String?
    let picture1: String?
    let picture2: String?
    let picture3: String?
    let pickedup_image: String?
    let droppedof_image: String?
    let created_by: String?
    let trip_status: String?
    let status: Int?
    let user_rated: Int?
    let provider_rated: Int?
    let updated_at: String?
    let created_at: String?
    let payment: Payment?
    let trip_request: TripRequest?
}

struct Payment: Decodable{
    
    let id: Int?
    let trip_id: Int?
    let bid_id: Int?
    let user_id: Int?
    let provider_id: Int?
    let fixed: Int?
    let commision: Int?
    let tax: Int?
    let total: Int?
    let provider_pay: Int?
    let payment_id: String?
    let payment_mode: String?
    let card_id: Int?
    let created_at: String?
    let updated_at: String?
    
}

struct TripRequest: Decodable{
    
    let id: Int?
    let user_id: Int?
    let provider_id: Int?
    let trip_id: Int?
    let item: String?
    let send_from: String?
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
    
    
    
}
