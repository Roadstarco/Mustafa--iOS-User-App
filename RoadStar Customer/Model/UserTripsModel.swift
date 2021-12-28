//
//  UserTripsModel.swift
//  RoadStar Customer
//
//  Created by Apple on 06/12/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation
import UIKit

struct UserTripsModel: Decodable{
    
    
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
    let vessel_id: Int?
   let vessel_imo: String?
   let vessel_name: String?
    let source_port_id: Int?
    let destination_port_id: Int?
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
   let avatar: String?
   let sea_trip_estimated_arrival: String?
   let air_trip_flight_info: AirTripInfo?
    let first_name: String?
   let last_name: String?
    let email: String?
    
    struct AirTripInfo: Decodable{
        
        let id: Int?
        let trip_id: Int?
        let ident: String?
        let aircraft_type: String?
        let filed_departure_time: String?
        let estimated_arrival_time: String?
        let origin: String?
        let destination: String?
        let origin_name: String?
        let origin_city: String?
        let destination_name: String?
        let destination_city: String?
        let api_json_response: String?
        let created_at: String?
        let updated_at: String?
        
    }
    
    
    
}
