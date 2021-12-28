//
//  ModeCollectionViewCell.swift
//  RoadStar Customer
//
//  Created by Roamer on 17/07/2020.
//  Copyright © 2020 Osama Azmat Khan. All rights reserved.
//

import UIKit

class ModeCollectionViewCell: UICollectionViewCell {

    static let nibName: String              = "ModeCollectionViewCell"
    static let cellReuseIdentifier: String  = "ModeCollectionViewCell"
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
