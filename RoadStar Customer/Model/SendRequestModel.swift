//
//  SendRequestModel.swift
//  RoadStar Customer
//
//  Created by Usman Nisar on 12/08/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import UIKit



struct SendRequestModel: Encodable {
    
    let s_latitude: String
    let s_longitude: String
    let d_latitude: String
    let d_longitude: String
    let s_address: String
    let d_address: String
    let service_type: String
    let distance: String
    let use_wallet: String
    let payment_mode: String
    let card_id: String
    
    let category: String
    let product_type: String
    let product_weight: String
    let weight_unit : String
    let product_width : String
    let product_height: String
    let receiver_name: String
    let receiver_phone: String
    let instruction: String
    let product_distribution: String
    
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
          throw NSError()
        }
        return dictionary
      }
    
}

struct SendRequestResponse: Codable {
    
    let message: String
    let request_id : Int

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case request_id = "request_id"
      
    }
}




// MARK: - GetRequestStatusResponse
struct GetRequestStatusResponse: Codable {
    let data: [StatusResponse]?
}

// MARK: - Datum
struct StatusResponse: Codable {
    let id: Int
    let bookingID: String?
    let userID, providerID, currentProviderID, serviceTypeID: Int?
    let status, cancelledBy: String?
    let cancelReason: String?
    let paymentMode: String?
    let paid: Int?
    let assignedAt: String?
    let scheduleAt, startedAt, finishedAt: String?
    let userRated, providerRated, useWallet: Int?
    let createdAt, updatedAt, category, productType: String?
    let productWeight: String?
    let productWidth, productHeight, weightUnit: String?
    let attachment1,attachment2, attachment3: String?
    let productDistribution: String?
    let receiverName, receiverPhone: String?
//    let rating: String?
    let provider : Provider?
    let serviceType : ServiceType?
    let providerService : ProviderService?
    let d_latitude, d_longitude: Double

    enum CodingKeys: String, CodingKey {
        case id
        case bookingID = "booking_id"
        case userID = "user_id"
        case providerID = "provider_id"
        case currentProviderID = "current_provider_id"
        case serviceTypeID = "service_type_id"
        case status
        case cancelledBy = "cancelled_by"
        case cancelReason = "cancel_reason"
        case paymentMode = "payment_mode"
        case paid
        case assignedAt = "assigned_at"
        case scheduleAt = "schedule_at"
        case startedAt = "started_at"
        case finishedAt = "finished_at"
        case userRated = "user_rated"
        case providerRated = "provider_rated"
        case useWallet = "use_wallet"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case category
        case productType = "product_type"
        case productWeight = "product_weight"
        case productWidth = "product_width"
        case productHeight = "product_height"
        case weightUnit = "weight_unit"
        case attachment1, attachment2, attachment3
        case productDistribution = "product_distribution"
        case receiverName = "receiver_name"
        case receiverPhone = "receiver_phone"
        case provider = "provider"
        case serviceType = "service_type"
        case providerService = "provider_service"
//        case rating
        case d_latitude, d_longitude
    }
}

// MARK: - Provider
struct Provider: Codable {
    let id: Int
    let firstName, lastName, email, gender: String
    let mobile: String
    let avatar: String?
    let rating: String
//    let wallet, commissionPayable: JSONNull?
    let status: String
    let fleet: Int
    let latitude, longitude: Double
    let otp: Int
    let createdAt, updatedAt, loginBy: String
//    let socialUniqueID: JSONNull?
    let compName, compRegNo, homeAddress, numberOfVehicle: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar = "avatar"
        case email, gender, mobile, rating
//        case commissionPayable = "commission_payable"
        case status, fleet, latitude, longitude, otp
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case loginBy = "login_by"
//        case socialUniqueID = "social_unique_id"
        case compName = "comp_name"
        case compRegNo = "comp_reg_no"
        case homeAddress = "home_address"
        case numberOfVehicle = "number_of_vehicle"
    }
}

// MARK: - ProviderService
struct ProviderService: Codable {
    let id, providerID, serviceTypeID: Int
    let status, serviceNumber, serviceModel: String

    enum CodingKeys: String, CodingKey {
        case id
        case providerID = "provider_id"
        case serviceTypeID = "service_type_id"
        case status
        case serviceNumber = "service_number"
        case serviceModel = "service_model"
    }
}

// MARK: - ServiceType
struct ServiceType: Codable {
    let id: Int
    let zones, name, providerName: String
    let image: String
    let capacity: Int
    let fixed, price, minute: String
    let distance: Int
    let calculator, serviceTypeDescription: String
    let status: Int

    enum CodingKeys: String, CodingKey {
        case id, zones, name
        case providerName = "provider_name"
        case image, capacity, fixed, price, minute, distance, calculator
        case serviceTypeDescription = "description"
        case status
    }
}

// MARK: - User
struct User: Codable {
    let id: Int
    let firstName, lastName, paymentMode, email: String
    let gender, mobile: String
    let picture: JSONNull?
    let points: Int
    let deviceToken, deviceID, deviceType, loginBy: String
    let socialUniqueID: String
    let latitude, longitude, stripeCustID: JSONNull?
    let walletBalance: Int
    let rating: String
    let otp: Int
    let updatedAt, referralCode: String
    let isReferralUsed: Int
    let countryName, address: String

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
        case address
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
