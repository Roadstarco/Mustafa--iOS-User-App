//
//  PrimaryTextView.swift
//  RoadStar Customer
//
//  Created by Roamer on 19/07/2020.
//  Copyright © 2020 Osama Azmat Khan. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class PrimaryTextView: UITextView {
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
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
    
    func setupView() {
        self.layer.cornerRadius = cornerRadius
    }
    
    
    // MARK: - Properties
    
    @IBInspectable
    var color: UIColor = UIColor.AppColors.TextViewBackGround {
        didSet {
            self.backgroundColor = color
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat = 5 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}
