//
//  UserProfile.swift
//  RoadStar Customer
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let profileModel = try? newJSONDecoder().decode(ProfileModel.self, from: jsonData)

import Foundation

struct ProfileRequest: Encodable {
    
    let token: String
    
    
}

// MARK: - ProfileModel
struct ProfileModel: Codable {
    let id: Int?
    let firstName, lastName, paymentMode, email: String?
    let gender, mobile: String?
    let picture: String?
    let points: Int?
    let deviceToken, deviceID, deviceType, loginBy: String?
    let socialUniqueID: String?
    let latitude, longitude: Double?
    let stripeCustID: String?
    let walletBalance: Int?
    let rating: String?
    let otp: Int?
    let updatedAt, referralCode: String?
    let isReferralUsed: Int?
    let countryName, address, currency, sos: String?
    let marineTrafficAPIKey: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case paymentMode = "payment_mode"
        case email, gender, mobile, picture, points
        case deviceToken = "device_token"
        case deviceID = "device_id"
        case deviceType = "device_type"
        case loginBy = "login_by"
        case socialUniqueID = "social_unique_id"
        case latitude, longitude
        case stripeCustID = "stripe_cust_id"
        case walletBalance = "wallet_balance"
        case rating, otp
        case updatedAt = "updated_at"
        case referralCode = "referral_code"
        case isReferralUsed = "is_referral_used"
        case countryName = "country_name"
        case address, currency, sos
        case marineTrafficAPIKey = "marine_traffic_api_key"
    }
}

