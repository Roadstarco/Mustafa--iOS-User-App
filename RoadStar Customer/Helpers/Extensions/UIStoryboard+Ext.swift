//
//  UIStoryboard+Ext.swift
//  RoadStar Customer
//
//  Created by Roamer on 13/07/2020.
//  Copyright © 2020 Osama Azmat Khan. All rights reserved.
//

import Foundation
import UIKit

/// UIStoryboard extension
/// Extension for adding **Names** to UIStoryboard.
extension UIStoryboard {
    /**
     
     All UIStoryboard which are used across the app are defined here
     
     */
    enum AppStoryboard: String {
        
        case Main, Booking, LaunchScreen, PreLogin, Menu
        
        var instance : UIStoryboard {
            return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
        }
    }
}

