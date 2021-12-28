//
//  OfferCounterViewController.swift
//  RoadStar Customer
//
//  Created by Apple on 06/12/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField
class OfferCounterViewController: BaseViewController{
    
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var txtAmount: SkyFloatingLabelTextField!
    
    
    
    var bid_id = 0
    override func setupUI() {
        
        print(self.bid_id)
        
    }
    
        func offerCounter(){
    
            let params = CounterOfferModel(bid_id: self.bid_id , counter_amount: txtAmount.text)
    
        NetworkRepository.shared.addCounterUserTripRepository.offerCounter(with: params)  { (apiResponse, error) in
    
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
                Toast.show(message: "Counter Offer Sent To The Driver")
                self.continueToMain()
                
            } else{
                Toast.show(message: "Something went wrong!")
                print("Something went wrong in SIGNUP THE USER.")
              }
           }
        }
    
    func continueToMain() {
        let homeNav = UIStoryboard.AppStoryboard.Main.instance.instantiateViewController(withIdentifier: UINavigationController.Identifiers.HomeNav) as! UINavigationController
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.replaceRootViewControllerWith(homeNav, animated: true, completion: nil)
    }
    
    @IBAction func btnAddBidTapped(_ sender: Any) {
        offerCounter()
        
    }
    
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        self.continueToMain()
    }
    
    
    @IBAction func btnBackTapped(_ sender: Any) {
        
        
    }
    
    
}
