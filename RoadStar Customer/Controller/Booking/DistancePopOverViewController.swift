//
//  DistancePopOverViewController.swift
//  RoadStar Customer
//
//  Created by Roamer on 21/07/2020.
//  Copyright © 2020 Osama Azmat Khan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import GoogleMaps
import SDWebImage
import GooglePlacesSearchController
import CoreLocation

protocol  DistancePopoverProtocol  {
    func didDismissedWithResponse()
}

class DistancePopOverViewController: BaseViewController {

    var delegate : DistancePopoverProtocol?
    
    @IBOutlet weak var lblVehicleName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var vehicleDistance: UILabel!
    @IBOutlet weak var fareLbl: UILabel!
    
    var fareEstimate : FareEstimate? = nil
    
    var serviceInfo : ServiceModel? = nil
    
    var pickUpLocation : PlaceDetails? = nil
    var destinationLocation : PlaceDetails? = nil
    
    override func setupUI() {
        lblVehicleName.text = serviceInfo!.name
        
        
        if let url = URL(string: serviceInfo!.image)
        {
            imgView.sd_setImage(with: url) { image, error, cashe, urlv in
                //
            }
        }

        //Display the result in km
        self.lblVehicleName.text = serviceInfo?.name
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        
        self.getDestinationFareInfo()
    }
    
    
    func getDestinationFareInfo()
    {
        var fareInfo = FareEstimateRequest()
        fareInfo.pickup_lat = pickUpLocation?.coordinate?.latitude ?? 0.0
        fareInfo.pickup_long = pickUpLocation?.coordinate?.longitude ?? 0.0
        fareInfo.drop_lat = destinationLocation?.coordinate?.latitude ?? 0.0
        fareInfo.drop_long = destinationLocation?.coordinate?.longitude ?? 0.0
        fareInfo.service_id = serviceInfo?.id ?? 0
        
        NetworkRepository.shared.fareRepository.getFareEstimation(with: fareInfo) { (response, error) in
            
            if let error = error{
                Toast.show(message: "Something went wrong!")
                print("Something went wrong in SIGNUP THE USER. \(error.localizedDescription)")
                
            } else if let fareRes = response {
                
//                print(servicesRes)
                
                self.fareEstimate = fareRes
                
                DispatchQueue.main.async {
                    //
                    self.vehicleDistance.text = String(format: "%d km", self.fareEstimate!.distance)
                    
                    let estimateFare = Float(self.fareEstimate!.estimatedFare)
                    let basePrice = Float(self.fareEstimate!.basePrice) ?? 0.0
                    let tax = Float(self.fareEstimate!.taxPrice)
                    let totalPrice = estimateFare + basePrice + tax
                    self.fareLbl.text = String(format: "%.02f $", totalPrice)
                }
                
                
            } else{
                Toast.show(message: "Something went wrong!")
                print("Something went wrong in SIGNUP THE USER.")
            }
        }
    }
    
    
    @IBAction func onBackClicked(_ id:UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    override func setupTheme() {
        
    }
    
    
    
    @IBAction func onClickBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNextTapped(_ sender: Any) {
        
        
        if self.fareEstimate == nil
        {
            Toast.show(message: "Fare estimation is missing")
        }
        else
        {
            let packageDetailVC = UIStoryboard.AppStoryboard.Booking.instance.instantiateViewController(withIdentifier: UIViewController.Identifiers.Booking.PackageDetailsViewController) as! PackageDetailsViewController
            
            packageDetailVC.fareEstimate = self.fareEstimate
            packageDetailVC.serviceInfo = self.serviceInfo
            packageDetailVC.pickUpLocation = self.pickUpLocation
            packageDetailVC.destinationLocation = self.destinationLocation
            
            self.navigationController?.pushViewController(packageDetailVC, animated: true)
        }
        
        
    }
    
}
