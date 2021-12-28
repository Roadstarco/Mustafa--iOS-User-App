//
//  NetworkRepository.swift
//  RoadStar Customer
//
//  Created by Faizan Ali  on 2020/10/4.
//  Copyright © 2020 Faizan.Technology. All rights reserved.
//

import Foundation

class NetworkRepository{
    
    static let shared: NetworkRepository = NetworkRepository()
    
    var signUpRepository: SignUpRepository = SignUpRepository()
    var logInRepository: LogInRepository = LogInRepository()
    var userProfileRepository: UserProfileRepository = UserProfileRepository()
    var servicesRepository: ServicesRepository = ServicesRepository()
    var fareRepository: FareEstimateRepository = FareEstimateRepository()
    var cardRepository: CardsRepository = CardsRepository()
    var sendRequestRepository: TripRequestRepository = TripRequestRepository()
    var rateTripRepository: RateTripsRepository = RateTripsRepository()
    var updateProfileRepository: UpdateProfileRepository = UpdateProfileRepository()
    var changePasswordRepository: ChangePasswordRepository = ChangePasswordRepository()
    var updateFcmRepository: FcmUpdateRepository = FcmUpdateRepository()
    var internationalTripRepository: InternationalTripRepository = InternationalTripRepository()
    var getAvailableTripsRepository: GetAvailableTripsRepository = GetAvailableTripsRepository()
    var addBidAvailableRequestRepository: AddBidAvailableRequestRepository = AddBidAvailableRequestRepository()
    var acceptRejectCounterRepository: AcceptRejectCounterRepository = AcceptRejectCounterRepository()
    var bookingHistoryTripsRepository: BookingHistoryTripsRepository = BookingHistoryTripsRepository()
    var getUserTripsRepository: GetUserTripsRepository = GetUserTripsRepository()
    var getUserTripBidsRepository: GetUserTripBidsRepository = GetUserTripBidsRepository()
    var addCounterUserTripRepository: AddCounterUserTripRepository = AddCounterUserTripRepository()
    var acceptBidUserTripRepository: AcceptBidUserTripRepository = AcceptBidUserTripRepository()
    var tripUpdateRepository: TripUpdateRepository = TripUpdateRepository()
}
