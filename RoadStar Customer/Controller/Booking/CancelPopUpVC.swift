//
//  CancelPopUpVC.swift
//  RoadStar Customer
//
//  Created by Syed on 22/08/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import UIKit

protocol CancelPopUpVCDelegate {
    func didCancelTapped(text:String?)
}

class CancelPopUpVC: BaseViewController {

    @IBOutlet var txtCancelReason : UITextView!
    @IBOutlet var btnCancel : UIButton!
    var delegate :CancelPopUpVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func setupUI() {
        
    }
    
    @IBAction func onBackClicked(_ sender:Any) {
        self.dismiss(animated: true) {
            self.delegate?.didCancelTapped(text: self.txtCancelReason.text ?? "")
        }
    }
}
