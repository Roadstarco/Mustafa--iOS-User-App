//
//  ForgetPasswordViewController.swift
//  RoadStar Customer
//
//  Created by Roamer on 11/07/2020.
//  Copyright © 2020 Osama Azmat Khan. All rights reserved.
//

import UIKit

class ForgetPasswordViewController: BaseViewController {

    override func setupUI() {
        
    }
    
    override func setupTheme() {
        super.setupTheme()
        
    }
    
    @IBAction func onClickBackBtn(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
     }
     
    
}
