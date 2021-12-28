//
//  UpdateProfileModel.swift
//  RoadStar Customer
//
//  Created by Apple on 29/10/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation
struct UpdateProfileRequest: Encodable{
    var first_name: String = ""
    var last_name: String = ""
    var email: String = ""
    var mobile: String = ""
    var country_name: String = ""
    var address: String = ""
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
          throw NSError()
        }
        return dictionary
      }
//    var picture: String = ""
//    var token: String = ""
//    var id: Int = 0
}
struct ProfileUpdatedResponse: Codable {
    let id: Int?
    let firstName, lastName, email, gender: String?
    let mobile, avatar: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email, gender, mobile, avatar
    }
}

