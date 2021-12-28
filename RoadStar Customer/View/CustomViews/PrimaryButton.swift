//
//  PrimaryButton.swift
//  RoadStar Customer
//
//  Created by Roamer on 12/07/2020.
//  Copyright © 2020 Osama Azmat Khan. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class PrimaryButton: UIButton {
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - UI Setup
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    override public var isEnabled: Bool {
        didSet {
            if self.isEnabled {
                self.backgroundColor = self.backgroundColor?.withAlphaComponent(1.0)
            } else {
                self.backgroundColor = self.backgroundColor?.withAlphaComponent(0.5)
            }
        }
    }

    func setupView() {
        self.backgroundColor    = color
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth  = borderWidth
        self.layer.borderColor  = borderColor.cgColor
    }
    
    // MARK: - Properties
    @IBInspectable
    var color: UIColor = UIColor.AppColors.PrimaryColor {
        didSet {
            self.backgroundColor = color
        }
    }

    @IBInspectable
    var borderWidth: CGFloat = 1 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }

    @IBInspectable
    var borderColor: UIColor = UIColor.AppColors.PrimaryColor {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat = 5 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
}
