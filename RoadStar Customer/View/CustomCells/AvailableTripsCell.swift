//
//  AvailableTripsCell.swift
//  RoadStar Customer
//
//  Created by Apple on 03/12/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation
import UIKit

class AvailableTripsCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAcNo: UILabel!
    @IBOutlet weak var vwMain: RoundShadowView!
    @IBOutlet weak var lblfrom: UILabel!
    @IBOutlet weak var lblTo: UILabel!
    
    
    static let nibName: String = "AvailableTripsCell"
    static let cellReuseIdentifier: String  = "AvailableTripsCell"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        vwMain.containerView.backgroundColor = Theme.backgroundColor
    }
    
    func setUp(request: AvailableTripsResponse) {
        
        
        let date = request.created_at ?? ""
        let id = request.booking_id ?? ""
        let to = request.tripto ?? ""
        let from = request.tripfrom ?? ""
        
        lblAcNo.text = id
        lblDate.text = date
        lblTo.text = to
        lblfrom.text = from
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
