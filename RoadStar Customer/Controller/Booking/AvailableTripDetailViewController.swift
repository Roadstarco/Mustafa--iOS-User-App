//
//  AvailableTripDetailViewController.swift
//  RoadStar Customer
//
//  Created by Apple on 03/12/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation
import UIKit
class AvailableTripDetailViewController: BaseViewController{
    
    @IBOutlet weak var vwMain: RoundShadowView!
    @IBOutlet weak var lblFrom_To: UILabel!
    @IBOutlet weak var lblArrivalDate: UILabel!
    @IBOutlet weak var lblPracticalDetails: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblServiceType: UILabel!
    @IBOutlet weak var BTNADDBID: PrimaryButton!
    @IBOutlet weak var btnViewCounter: PrimaryButton!
    
    var request: AvailableTripsResponse?
    
    
    override func setupUI() {
        print(request)
        btnViewCounter.isHidden = true
        if request?.bid_details?.id != nil{
            BTNADDBID.setTitle("DETAILS SENT", for: .normal)
            BTNADDBID.isUserInteractionEnabled = false
        }
        if request?.bid_details?.is_counter == 1{
            btnViewCounter.isHidden = false

        }
        vwMain.containerView.backgroundColor = Theme.backgroundColor
        lblFrom_To.text = "\(request?.tripfrom ?? "")-\(request?.tripto ?? "")"
        lblArrivalDate.text = request?.arrival_date
        lblPracticalDetails.text = request?.other_information
        lblSize.text = request?.item_size
        lblServiceType.text = request?.service_type
        
    }
    
    
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnAddBidTapped(_ sender: Any) {
        let VC = UIStoryboard.AppStoryboard.Booking.instance.instantiateViewController(withIdentifier: UIViewController.Identifiers.Booking.InternationalBookingBidViewController) as! InternationalBookingBidViewController
        VC.trip_id = request?.id ?? 0
            print(VC.trip_id)
        let navigationCont = UINavigationController(rootViewController: VC)
        navigationCont.navigationController?.setNavigationBarHidden(true, animated: false)
        navigationCont.modalPresentationStyle = .overCurrentContext
        self.present(navigationCont, animated: true, completion: nil)
        
    }
    
    @IBAction func btnViewCounterDetails(_ sender: Any) {
        
        let VC = UIStoryboard.AppStoryboard.Booking.instance.instantiateViewController(withIdentifier: UIViewController.Identifiers.Booking.AcceptRejectCounterViewController) as! AcceptRejectCounterViewController
        VC.request = self.request
        let navigationCont = UINavigationController(rootViewController: VC)
        navigationCont.navigationController?.setNavigationBarHidden(true, animated: false)
        navigationCont.modalPresentationStyle = .overCurrentContext
        self.present(navigationCont, animated: true, completion: nil)
    }
    
    
}
