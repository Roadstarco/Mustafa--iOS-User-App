//
//  OTPTextField.swift
//  RoadStar Customer
//
//  Created by Roamer on 12/07/2020.
//  Copyright © 2020 Osama Azmat Khan. All rights reserved.
//

import Foundation
import UIKit

class OTPTextField: UITextField {
    weak var previousTextField: OTPTextField?
    weak var nextTextField: OTPTextField?
    
    override public func deleteBackward() {
        text = ""
        previousTextField?.becomeFirstResponder()
    }
}
