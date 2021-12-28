//
//  AllBidsTableViewCell.swift
//  RoadStar Customer
//
//  Created by Apple on 06/12/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation
import UIKit

class AllBidsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblProviderId: UILabel!
    @IBOutlet weak var vwMain: RoundShadowView!
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var btnAccept: PrimaryButton!
    @IBOutlet weak var btnAddCounter: PrimaryButton!
    @IBOutlet weak var lblCounterSent: UILabel!
    
    var trip_id = 0
    var bid_id = 0
    var request: GetUserTripBidsResponse?
    
    static let nibName: String = "AllBidsTableViewCell"
    static let cellReuseIdentifier: String  = "AllBidsTableViewCell"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        vwMain.containerView.backgroundColor = Theme.backgroundColor
    }
    
    func setUp(request: GetUserTripBidsResponse) {
        
        
        let date = request.created_at ?? ""
        let providerId = request.provider_id ?? 0 as Int
        let stringProviderId = String(providerId)
        let firstName = request.first_name ?? ""
        let lastName = request.last_name ?? ""
        let amount = (request.amount ?? 0) as Int
        let amountString = String(amount)
        
        lblProviderId.text = stringProviderId
        lblDate.text = date
        lblFirstName.text = "First name: \(firstName)"
        lblLastName.text = "Last name: \(lastName)"
        lblAmount.text = "$\(amountString)"
        bid_id = request.id ?? 0
        print(request.id)
        print(request.amount)
        print(request.is_counter)
        print(request.counter_amount)
        self.request = request
        self.btnAddCounter.isHidden = false
        self.btnAccept.isHidden = false
        self.lblCounterSent.isHidden = true
        if request.is_counter == 1{
            self.btnAddCounter.isHidden = true
            self.btnAccept.isHidden = true
            self.lblCounterSent.isHidden = false
            self.lblCounterSent.text = "Your counter offer of \(request.counter_amount ?? 0) has been sent to the driver"
        }
    }
    
    func continueToMain() {
        let homeNav = UIStoryboard.AppStoryboard.Main.instance.instantiateViewController(withIdentifier: UINavigationController.Identifiers.HomeNav) as! UINavigationController
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.replaceRootViewControllerWith(homeNav, animated: true, completion: nil)
    }
    
    @IBAction func btnAcceptTapped(_ sender: Any) {
        
        let params = AcceptBidModel(trip_id: self.trip_id, bid_id: self.request?.id)
        
        NetworkRepository.shared.acceptBidUserTripRepository.acceptBid(with: params)  { (apiResponse, error) in
            
            if let error = error{
                
                if apiResponse != nil
                {
                    Toast.show(message: "error: \(String(describing: apiResponse))")
                    print("Something went wrong in SIGNUP THE USER. \(String(describing: apiResponse))")
                }
                else
                {
                    Toast.show(message: "Something Went Wrong Please Try Again")
                    print("Something went wrong in SIGNUP THE USER. \(error)")
                }
                
            } else if apiResponse != nil{
                print(apiResponse as Any)
                Toast.show(message: apiResponse?.message ?? "Empty response")
                self.continueToMain()
                
            } else{
                Toast.show(message: "Something went wrong!")
                print("Something went wrong in SIGNUP THE USER.")
              }
           }
        
        
    }
    
    
    @IBAction func btnAddCounter(_ sender: Any) {
        
        let vc = UIStoryboard.AppStoryboard.Menu.instance.instantiateViewController(withIdentifier: UIViewController.Identifiers.Menu.OfferCounterViewController) as! OfferCounterViewController
        vc.bid_id = self.bid_id
        print(vc.bid_id)
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.replaceRootViewControllerWith(vc, animated: true, completion: nil)
        
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
