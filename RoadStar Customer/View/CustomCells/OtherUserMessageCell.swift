//
//  OtherUserMessageCell.swift
//  RoadStar Customer
//
//  Created by Faizan Ali  on 2020/9/7.
//  Copyright © 2020 Faizan.Technology. All rights reserved.
//

import UIKit

class OtherUserMessageCell: UITableViewCell {

    static let nibName: String = "OtherUserMessageCell"
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwMain: RoundShadowView!
    
    func setUI(text: String) {
        
        lblTitle.text = text
        setTheme()
    }
    
    func setTheme() {
        lblTitle.textColor = UIColor.white
        vwMain.containerView.backgroundColor = Theme.secondaryFontColor
    }
    
}
