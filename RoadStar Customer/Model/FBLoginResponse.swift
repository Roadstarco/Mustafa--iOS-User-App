//
//  FBLoginResponse.swift
//  RoadStar Customer
//
//  Created by Apple on 24/11/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation
class FBLoginResponse: Codable {
    

struct FBLoginResponse: Encodable {
    
    var email : String
    var id : Int?
    var name: String?
}
}
