//
//  TripStatusModel.swift
//  RoadStar Customer
//
//  Created by Apple on 22/12/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation
import UIKit

struct TripStatusModel: Encodable{
    
    let trip_id: Int?
    
    
}

struct TripStatusResponse: Decodable{
    
    let message: String?
    
    
}
