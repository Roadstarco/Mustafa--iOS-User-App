//
//  AcceptRejectModel.swift
//  RoadStar Customer
//
//  Created by Apple on 05/12/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation
import UIKit

struct AcceptRejectModel: Encodable{
    
    let bid_id: Int?
    let trip_id: Int?
    
    
}

struct AcceptRejectResponse: Decodable{
    
    let message: String?
    
    
    
}
