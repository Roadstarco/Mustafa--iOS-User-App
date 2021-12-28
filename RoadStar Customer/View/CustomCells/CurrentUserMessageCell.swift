//
//  CurrentUserMessageCell.swift
//  RoadStar Customer
//
//  Created by Faizan Ali  on 2020/9/7.
//  Copyright © 2020 Faizan.Technology. All rights reserved.
//

import UIKit

class CurrentUserMessageCell: UITableViewCell {

    static let nibName: String = "CurrentUserMessageCell"
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwMain: RoundShadowView!

    func setUI(text: String) {
        
        lblTitle.text = text
        setTheme()
    }
    
    func setTheme() {
        vwMain.containerView.backgroundColor = Theme.dropDownColor
    }
    
}
