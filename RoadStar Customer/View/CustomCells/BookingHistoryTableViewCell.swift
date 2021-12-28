//
//  BookingHistoryTableViewCell.swift
//  RoadStar Customer
//
//  Created by Roamer on 21/07/2020.
//  Copyright © 2020 Osama Azmat Khan. All rights reserved.
//

import UIKit

class BookingHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var vwMain: RoundShadowView!
    @IBOutlet weak var lblCreatedAt: UILabel!
    @IBOutlet weak var lblId_Servicetype: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblfrom: UILabel!
    @IBOutlet weak var lblTripTo: UILabel!
    
    
    
    static let nibName: String              = "BookingHistoryTableViewCell"
    static let cellReuseIdentifier: String  = "BookingHistoryTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        vwMain.containerView.backgroundColor = Theme.dropDownColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
