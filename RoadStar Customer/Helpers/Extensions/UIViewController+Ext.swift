//
//  UIViewController+Ext.swift
//  RoadStar Customer
//
//  Created by Roamer on 12/07/2020.
//  Copyright © 2020 Osama Azmat Khan. All rights reserved.
//

import Foundation
import UIKit

/// UIViewController extension
/// Extension for adding **Identifiers** to UIViewController.
extension UIViewController {
    /**
     
     All UIViewControllers which are used across the app have their **Identifiers** defined here
     
     */
    enum Identifiers {
        
        // MARK: Based on StoryBoards
        
        enum PreLogin {
            static let SignInViewController         = "SigninViewController"
            static let SignUpViewController         = "SignUpViewController"
            static let VerifyOTPViewController      = "VerifyOTPViewController"
            static let SignupDetailsViewController  = "SignupDetailsViewController"
            static let ForgetPasswordViewController = "ForgetPasswordViewController"
        }
        
        enum Main {
            static let ChangePassVC = "ChangePassVC"
            static let SettingsVC = "SettingsVC"
            static let ProfileVC                    = "ProfileVC"
            static let LaunchScreenViewController   = "LaunchScreenViewController"
            static let MainViewController           = "MainViewController"
            static let LeftMenuViewController       = "LeftMenuViewController"
        }
        
        enum Home {
            static let HomeViewController = "HomeViewController"
        }
        
        enum Booking {
            static let RatingViewController                 = "RatingViewController"
            static let BookingViewController                = "BookingViewController"
            static let PackageDetailsViewController         = "PackageDetailsViewController"
            static let DistancePopOverViewController        = "DistancePopOverViewController"
            static let RecieverDetailsViewController        = "RecieverDetailsViewController"
            static let BookingPaymentOptionsViewController  = "BookingPaymentOptionsViewController"
            static let RequestStatusViewController  = "RequestStatusViewController"
            static let InternationalBookingViewController = "InternationalBookingViewController"
            static let InternationalReceiverViewController = "InternationalReceiverViewController"
            static let AvailableTripDetailViewController = "AvailableTripDetailViewController"
            static let InternationalBookingBidViewController = "InternationalBookingBidViewController"
            static let AcceptRejectCounterViewController = "AcceptRejectCounterViewController"
        }
        
        enum Dialog {
            static let CustomForgotPasswordViewController = "CustomForgotPasswordViewController"
        }
        
        enum Menu {
            static let BaseViewController               = "BaseViewController"
            static let ClaimViewController              = "ClaimViewController"
            static let SupportViewController            = "SupportViewController"
            static let TrackPackageViewController       = "TrackPackageViewController"
            static let BookingHistoryViewController     = "BookingHistoryViewController"
            static let PaymentMethodsViewController     = "PaymentMethodsViewController"
            static let AllAvailableBidsViewController   = "AllAvailableBidsViewController"
            static let OfferCounterViewController = "OfferCounterViewController"
        }
    }
    
    enum Titles {
        static let Home = ""
    }
}
