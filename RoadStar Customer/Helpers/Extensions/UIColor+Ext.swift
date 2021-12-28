//
//  UIColor+Ext.swift
//  RoadStar Customer
//
//  Created by Roamer on 12/07/2020.
//  Copyright © 2020 Osama Azmat Khan. All rights reserved.
//

import Foundation
import UIKit

public struct Theme {
    
    public static var primaryFontColor: UIColor = UIColor.init(red: 221, green: 49, blue: 27)
    public static var secondaryFontColor: UIColor = UIColor.rgba(28, 47, 66, 0.7)
    public static var tertiaryFontColor: UIColor = UIColor.rgba(28, 47, 66, 0.5)
    public static var placeholderFontColor: UIColor = UIColor.rgba(28, 47, 66, 0.3)
    
    public static var dropDownColor: UIColor = UIColor.rgba(243, 238, 241, 1.0)
    
    public static var backgroundColor: UIColor = UIColor.white
    
    public static var overlayBackgroundColor: UIColor = UIColor.rgba(25, 80, 120, 0.7)
    
    public static var brandColor: UIColor = UIColor.rgba(221, 49, 27, 1.0)
    
    
    public static var buttonCornerRadius: CGFloat = 4.0

}

extension UIColor {
    enum AppColors {
        static let PrimaryColor: UIColor = UIColor.init(red: 221, green: 49, blue: 27)
        static let GrayBackground: UIColor = UIColor.init(red: 242, green: 242, blue: 242)
        static let TextViewBackGround: UIColor = UIColor.init(red: 243, green: 238, blue: 241)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    // MARK: Private
    public static func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
    
    public static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
        return rgba(r, g, b, 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
