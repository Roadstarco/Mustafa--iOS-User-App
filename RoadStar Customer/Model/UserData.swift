//
//  UserData.swift
//  RoadStar Customer
//
//  Created by Faizan Ali  on 2020/10/4.
//  Copyright © 2020 Faizan.Technology. All rights reserved.
//

import Foundation

class UserProfile: Codable {
    
    var userId: String = UUID().uuidString
    var name: String?
    var email: String?
    var photo: String?
    var phoneNumber: String?
    var device_token: String?
    var address: String?
    var contryName: String?
    var deviceType: String?
    var paymentMode: String?
    var isLoggedIn: Bool = false
    
    var photoUrl: URL? {
        guard let p = photo else {
            return nil
        }
        
        return URL(string: p)
    }
    
    static var current: UserProfile? {
        do {
            if let data = UserDefaults.standard.data(forKey: "UserProfile") {
                let decoder = JSONDecoder()
                let user = try decoder.decode(UserProfile.self, from: data)
                return user
            }
            
            
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    func save(){
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(self) {
            UserDefaults.standard.setValue(data, forKey: "UserProfile")
        }
    }
    
    static func fromSignUp(response: SignUpResponse) -> UserProfile {
        
        let user: UserProfile = UserProfile()
        user.userId = String(response.id!)
        user.name = "\(response.first_name!) \(response.last_name!)"
        user.email = response.email
        user.photo = nil
        user.phoneNumber = response.mobile
        user.device_token = response.device_token
        user.address = response.address
        user.contryName = response.country_name
        user.deviceType = response.device_type
        user.paymentMode = response.payment_mode
        
        return user
    }
    
}
