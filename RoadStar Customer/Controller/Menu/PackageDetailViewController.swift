//
//  PackageDetailViewController.swift
//  RoadStar Customer
//
//  Created by Apple on 07/12/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField

class PackageDetailViewController: BaseViewController{
    
    
    @IBOutlet weak var lblReceiverName: UILabel!
    @IBOutlet weak var lblPackageName: UILabel!
    
    @IBOutlet weak var lblPackageType: UILabel!
    @IBOutlet weak var lblPackageSize: UILabel!
    
    @IBOutlet weak var lblProviderId: UILabel!
    @IBOutlet weak var lblPickupLocation: UILabel!
    
    @IBOutlet weak var lblDropfffLocation: UILabel!
    @IBOutlet weak var lblApproved: UILabel!
    
    @IBOutlet weak var lblStarted: UILabel!
    @IBOutlet weak var lblArrived: UILabel!
    
    @IBOutlet weak var lblPickedUp: UILabel!
    @IBOutlet weak var lblDelivered: UILabel!
    
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblCompleted: UILabel!
    @IBOutlet weak var btnChat: PrimaryButton!
    
    
    var receiverName = ""
    var packageName = ""
    var packageType = ""
    var packageSize = ""
    var providerId = 0
    var pickupFrom = ""
    var dropoffTo = ""
    var tripStatus = ""
    var trips: UserTripsModel?
    weak var timer: Timer?
    var timerDispatchSourceTimer : DispatchSourceTimer?
    
    override func setupUI() {
        
        self.lblReceiverName.text = receiverName
        self.lblPackageName.text = packageName
        self.lblPackageType.text = packageType
        self.lblPackageSize.text = packageSize
        let providerIdString = String(providerId)
        self.lblProviderId.text = providerIdString
        self.lblPickupLocation.text = pickupFrom
        self.lblDropfffLocation.text = dropoffTo
        print(self.tripStatus)
        
        if self.tripStatus == "STARTED"{
            
            lblApproved.font = UIFont.boldSystemFont(ofSize: 20.0)
            
        }else if self.tripStatus == "ARRIVED"{
            
            lblStarted.font = UIFont.boldSystemFont(ofSize: 20.0)
            
        }else if self.tripStatus == "PICKEDUP"{
            
            lblPickedUp.font = UIFont.boldSystemFont(ofSize: 20.0)
            
        }else if self.tripStatus == "DROPPED"{
            
            lblDelivered.font = UIFont.boldSystemFont(ofSize: 20.0)
            
        }else if self.tripStatus == "COMPLETED"{
            
            lblCompleted.font = UIFont.boldSystemFont(ofSize: 20.0)
            if self.trips?.user_rated == 0 {
                
                self.showRatingView()
                
            }
        }
    }
    
    func showRatingView(){
        
        
        let distanceVC = UIStoryboard.AppStoryboard.Booking.instance.instantiateViewController(withIdentifier: UIViewController.Identifiers.Booking.RatingViewController) as! RatingViewController
        distanceVC.tripId = self.trips!.id ?? 0
        distanceVC.delegate = self
        distanceVC.fromInternational = true
        self.stopTimer()
        let navigationCont = UINavigationController(rootViewController: distanceVC)
        navigationCont.navigationController?.setNavigationBarHidden(true, animated: false)
        navigationCont.modalPresentationStyle = .overCurrentContext
        self.present(navigationCont, animated: true, completion: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        stopTimer()
        startTimer()
    }
    
    func startTimer() {
        
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
            self?.getTripStatus()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        //timerDispatchSourceTimer?.suspend() // if you want to suspend timer
        timerDispatchSourceTimer?.cancel()
    }
    
    // if appropriate, make sure to stop your timer in `deinit`
    deinit {
        stopTimer()
    }
    
    func getTripStatus(){
        
        
        let params = TripStatusModel(trip_id: self.trips?.id)
        
        NetworkRepository.shared.tripUpdateRepository.getTripUpdate(with: params)  { (apiResponse, error) in
            
            if let error = error{
                
                if apiResponse != nil
                {
                    print("Something went wrong in SIGNUP THE USER. \(String(describing: apiResponse))")
                }
                else
                {
                    print("Something went wrong in SIGNUP THE USER. \(error)")
                }
                
            } else if apiResponse != nil{
                print(apiResponse as Any)
                if apiResponse?[0].trip_status == "STARTED"{
                    
                    self.lblApproved.font = UIFont.boldSystemFont(ofSize: 20.0)
                    
                }else if apiResponse?[0].trip_status == "ARRIVED"{
                    
                    self.lblStarted.font = UIFont.boldSystemFont(ofSize: 20.0)
                    
                }else if apiResponse?[0].trip_status == "PICKEDUP"{
                    
                    self.lblPickedUp.font = UIFont.boldSystemFont(ofSize: 20.0)
                    
                }else if apiResponse?[0].trip_status == "DROPPED"{
                    
                    self.lblDelivered.font = UIFont.boldSystemFont(ofSize: 20.0)
                    
                }else if apiResponse?[0].trip_status == "COMPLETED"{
                    
                    self.lblCompleted.font = UIFont.boldSystemFont(ofSize: 20.0)
                    if apiResponse?[0].user_rated == 0{
                        self.showRatingView()
                        
                    }
                    
                }
                
            } else{
                print("Something went wrong in SIGNUP THE USER.")
              }
           }
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        
        self.dismiss(animated: true)
        
        
    }
    
    @IBAction func btnChatTapped(_ sender: Any) {
        
        let vc = SupportViewController.instantiateMenu()
        vc.user_id = self.trips?.provider_id ?? 0
        vc.first_name = self.trips?.first_name ?? ""
        vc.email = self.trips?.email ?? ""
        vc.picture = self.trips?.avatar ?? ""
        let navigationCont = UINavigationController(rootViewController: vc)
        navigationCont.navigationController?.setNavigationBarHidden(true, animated: false)
        navigationCont.modalPresentationStyle = .overCurrentContext
        self.present(navigationCont, animated: true, completion: nil)
        
    }
    
    
}
extension PackageDetailViewController : RateTripPopoverProtocol {
    func didDismissedWithResponse() {
        //
        DispatchQueue.main.async {
            //
            self.dismiss(animated: true) {
                //
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
