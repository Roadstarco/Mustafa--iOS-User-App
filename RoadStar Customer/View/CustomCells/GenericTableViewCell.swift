//
//  GenericTableViewCell.swift
//  RoadStar Customer
//
//  Created by Roamer on 12/07/2020.
//  Copyright © 2020 Osama Azmat Khan. All rights reserved.
//

import UIKit

class GenericTableViewCell: UITableViewCell {

      
    // MARK: Variables, Constants And Outlets
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    
    static let nibName: String              = "GenericTableViewCell"
    static let cellReuseIdentifier: String  = "GenericTableViewCell"
    
    
    // MARK: Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // MARK: Private Functions
    
    
    
    // MARK: App Flow Functions

    
}
