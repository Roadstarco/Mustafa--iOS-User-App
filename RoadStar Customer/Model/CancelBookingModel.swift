//
//  CancelBookingModel.swift
//  RoadStar Customer
//
//  Created by Syed on 22/08/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation

struct CancelBookingModel: Encodable {
    
    var request_id : String
    var cancel_reason: String?
}
