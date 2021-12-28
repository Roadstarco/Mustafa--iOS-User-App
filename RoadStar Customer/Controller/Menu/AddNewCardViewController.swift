//
//  AddNewCardViewController.swift
//  RoadStar Customer
//
//  Created by Apple on 05/11/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation
import UIKit
import ATGValidator

class AddNewCardViewController: BaseViewController{
    
    
    @IBOutlet weak var txtCardNmbr: UITextField!
    @IBOutlet weak var txtExprDate: UITextField!
    @IBOutlet weak var txtCVVNmbr: UITextField!
    @IBOutlet weak var btnAddCard: UIButton!
    @IBOutlet weak var lblIndicator: UILabel!
    
    
    override func setupUI() {
        if let t: String = self.txtCVVNmbr.text {
       
            self.txtCVVNmbr.text = String(t.prefix(3))
        }
        txtCardNmbr.validationRules = [ PaymentCardRule(acceptedTypes: [.visa, .mastercard, .amex, .maestro , .visaElectron, .discover])]
        txtCardNmbr.validateOnInputChange(true)
        txtCardNmbr.validationHandler = { [weak self] result in
            if self?.txtCardNmbr.text?.isEmpty ?? true {
                self?.lblIndicator.text = nil
            } else {
                var statusString = (result.status == .success ? "✅" : "❌")
                if let t: String = self?.txtCardNmbr.text {
                    self?.txtCardNmbr.text = String(t.prefix(19))
                }
                if (self?.txtCardNmbr.text?.count == 4) ||
                    (self?.txtCardNmbr.text?.count == 9) ||
                    (self?.txtCardNmbr.text?.count == 14)
                {
                    self?.txtCardNmbr.text?.insert(" ", at: (self?.txtCardNmbr.text!.endIndex)!)
                    
                }
                if let type = result.value as? PaymentCardType {
                    statusString = type.rawValue + " " + statusString
                }
                self?.lblIndicator.text = statusString
            }
            self?.lblIndicator.isHidden = self?.lblIndicator.text?.isEmpty ?? true
            self?.btnAddCard.isEnabled = result.status == .success
            self?.btnAddCard.alpha = result.status == .success ? 1.0 : 0.5
        }
    }
    
    override func setupTheme() {
        super.setupTheme()
    }
    
    
    
    
    
}
