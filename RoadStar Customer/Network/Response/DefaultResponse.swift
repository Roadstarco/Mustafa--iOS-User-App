//
//  NetworkRepository.swift
//  RoadStar Customer
//
//  Created by Faizan Ali  on 2020/10/4.
//  Copyright © 2020 Faizan.Technology. All rights reserved.
//

import Foundation

/// Default response to check for every request since this's how this api works.
struct DefaultResponse: Codable, CodableInit {
    var status: Int
}

