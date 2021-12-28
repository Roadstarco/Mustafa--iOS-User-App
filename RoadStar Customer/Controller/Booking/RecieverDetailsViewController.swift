//
//  RecieverDetailsViewController.swift
//  RoadStar Customer
//
//  Created by Roamer on 21/07/2020.
//  Copyright © 2020 Osama Azmat Khan. All rights reserved.
//

import UIKit
import GooglePlacesSearchController
import SDWebImage

class RecieverDetailsViewController: BaseViewController {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var receiverName: UITextField!
    @IBOutlet weak var receiverPhone: UITextField!
    
    var fareEstimate : FareEstimate? = nil
    var serviceInfo : ServiceModel? = nil
    var pickUpLocation : PlaceDetails? = nil
    var destinationLocation : PlaceDetails? = nil
    
    var pkgCategory = ""
    var pkgType = ""
    var weight = ""
    var weightUnit = ""
    var pkgHeight = ""
    var pkgWidth = ""
    var instrutions = ""
    var pkdDetails = ""
    
    var attachment1Path = ""
    var attachment2Path = ""
    var attachment3Path = ""
    
    override func setupUI() {
        
        if let url = URL(string: serviceInfo!.image)
        {
            imgView.sd_setImage(with: url) { image, error, cashe, urlv in
                //
            }
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                tap.cancelsTouchesInView = false
                view.addGestureRecognizer(tap)


    }
    
    override func setupTheme() {
        super.setupTheme()
        
    }
    
@objc override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func onBackClicked(_ id:UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNextTapped(_ sender: Any) {
        
        if (receiverName.text!.count < 2)
        {
            Toast.show(message: "Please add receiver name")
            return
        }
        else if (receiverPhone.text!.count < 11)
        {
            Toast.show(message: "Please add valid number")
            return
        }
        
        let paymentOptionsVC = UIStoryboard.AppStoryboard.Booking.instance.instantiateViewController(withIdentifier: UIViewController.Identifiers.Booking.BookingPaymentOptionsViewController) as! BookingPaymentOptionsViewController
        
        paymentOptionsVC.fareEstimate = self.fareEstimate
        paymentOptionsVC.serviceInfo = self.serviceInfo
        paymentOptionsVC.pickUpLocation = self.pickUpLocation
        paymentOptionsVC.destinationLocation = self.destinationLocation
        paymentOptionsVC.pkgCategory = pkgCategory
        paymentOptionsVC.pkgType = pkgType
        paymentOptionsVC.weight = weight
        paymentOptionsVC.weightUnit = weightUnit
        paymentOptionsVC.pkgHeight = pkgHeight
        paymentOptionsVC.pkgWidth = pkgWidth
        paymentOptionsVC.instrutions = instrutions
        paymentOptionsVC.pkdDetails = pkdDetails
        paymentOptionsVC.receiverName = receiverName.text!
        paymentOptionsVC.receiverNumber = receiverPhone.text!
        paymentOptionsVC.attachment1Path = self.attachment1Path
        paymentOptionsVC.attachment2Path = self.attachment2Path
        paymentOptionsVC.attachment3Path = self.attachment3Path
        
        self.navigationController?.pushViewController(paymentOptionsVC, animated: true)
    
    }

}
