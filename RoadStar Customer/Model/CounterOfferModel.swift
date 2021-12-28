//
//  CounterOfferModel.swift
//  RoadStar Customer
//
//  Created by Apple on 06/12/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation
import UIKit

struct CounterOfferModel: Encodable{
    
    let bid_id: Int?
    let counter_amount: String?
    
    
    
}

struct CounterOfferResponse: Decodable{
    
    let message: String?
    let error: String?
    
}
