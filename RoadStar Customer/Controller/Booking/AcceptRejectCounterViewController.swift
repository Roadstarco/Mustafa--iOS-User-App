//
//  AcceptRejectCounterViewController.swift
//  RoadStar Customer
//
//  Created by Apple on 04/12/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation
import UIKit
import iOSDropDown
import GoogleMaps
import CoreLocation
import GooglePlacesSearchController
import SDWebImage
import AVFoundation
import Photos
import SkyFloatingLabelTextField
class AcceptRejectCounterViewController: BaseViewController{
    
    @IBOutlet weak var txtAmount: SkyFloatingLabelTextField!
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    
    var request: AvailableTripsResponse?
    
    override func setupUI() {
      
        self.txtAmount.isUserInteractionEnabled = false
        let counterAmount = (self.request?.bid_details?.counter_amount ?? 0) as Int
        let counterAmountString = String(counterAmount)
        self.txtAmount.text = counterAmountString
        
    }
    
    @IBAction func btnAcceptTapped(_ sender: Any) {
        let params = AcceptRejectModel(bid_id: request?.bid_details?.id,
                                       trip_id: request?.id)
        
        NetworkRepository.shared.acceptRejectCounterRepository.acceptCounter(with: params)  { (apiResponse, error) in
            
            if let error = error{
                
                if apiResponse != nil
                {
                    Toast.show(message: "error: \(String(describing: apiResponse))")
                    print("Something went wrong in SIGNUP THE USER. \(String(describing: apiResponse))")
                }
                else
                {
                    Toast.show(message: "Something Went Wrong Please Try Again")
                    print("Something went wrong in SIGNUP THE USER. \(error.localizedDescription)")
                }
                
            } else if apiResponse != nil{
                print(apiResponse)
                Toast.show(message: "Counter Offer Accepted")
                self.continueToHome()
                
            } else{
                Toast.show(message: "Something went wrong!")
                print("Something went wrong in SIGNUP THE USER.")
              }
           }
        
        
    }
    
    @IBAction func btnRejectTapped(_ sender: Any) {
        
        let params = AcceptRejectModel(bid_id: request?.bid_details?.id,
                                       trip_id: request?.id)
        
        NetworkRepository.shared.acceptRejectCounterRepository.rejectCounter(with: params)  { (apiResponse, error) in
            
            if let error = error{
                
                if apiResponse != nil
                {
                    Toast.show(message: "error: \(String(describing: apiResponse))")
                    print("Something went wrong in SIGNUP THE USER. \(String(describing: apiResponse))")
                }
                else
                {
                    Toast.show(message: "Something Went Wrong Please Try Again")
                    print("Something went wrong in SIGNUP THE USER. \(error.localizedDescription)")
                }
                
            } else if apiResponse != nil{
                print(apiResponse)
                Toast.show(message: "Counter Offer Rejected")
                self.continueToHome()
                
            } else{
                Toast.show(message: "Something went wrong!")
                print("Something went wrong in SIGNUP THE USER.")
              }
           }
        
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        
        self.dismiss(animated: true)
        
    }
    
    
    func continueToHome() {
        let homeNav = UIStoryboard.AppStoryboard.Main.instance.instantiateViewController(withIdentifier: UINavigationController.Identifiers.HomeNav) as! UINavigationController
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.replaceRootViewControllerWith(homeNav, animated: true, completion: nil)
    }

}
