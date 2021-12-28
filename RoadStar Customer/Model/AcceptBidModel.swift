//
//  AcceptBidModel.swift
//  RoadStar Customer
//
//  Created by Apple on 07/12/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation
import UIKit

struct AcceptBidModel: Encodable{
    
    let trip_id: Int?
    let bid_id: Int?
    
    
}

struct AcceptBidResponse: Decodable{
    
    let message: String?
    
    
}
