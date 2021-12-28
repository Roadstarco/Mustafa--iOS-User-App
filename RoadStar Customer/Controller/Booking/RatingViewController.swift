//
//  RatingViewController.swift
//  RoadStar Customer
//
//  Created by Roamer on 21/07/2020.
//  Copyright © 2020 Osama Azmat Khan. All rights reserved.
//

import UIKit
import Cosmos

protocol  RateTripPopoverProtocol  {
    func didDismissedWithResponse()
}

class RatingViewController: BaseViewController {
    var fromInternational = false
    var delegate : RateTripPopoverProtocol?
    
    var tripId = -1
    var rating = 0
    
    @IBOutlet var commentView : UITextView!
    @IBOutlet var ratingView : CosmosView!
    
    override func setupUI() {
        self.commentView.layer.borderWidth = 3
        self.commentView.layer.borderColor = UIColor.black.cgColor
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
    
    @IBAction func btnRateStarTapped(_ sender: Any) {
        if !fromInternational{
        let request = RatingTripsRequest(request_id: tripId, rating: Int(ratingView.rating), comment: commentView.text!)
        print(self.tripId)
        print(Int(ratingView.rating))
        NetworkRepository.shared.rateTripRepository.rateTrip(with: request) { (response, error) in
            if let error = error{
                Toast.show(message: "Trip not completed")
                print("Something went wrong in Searching THE Driver. \(error.localizedDescription)")
                
            } else {
                print("response")
                
                //
                DispatchQueue.main.async {
                    //
                    
                    Toast.show(message: "Thank you for feedback")
                    self.delegate?.didDismissedWithResponse()
                  }
              }
          }
        }else {
            
            let request = RatingTripsRequest2(trip_id: tripId, rating: Int(ratingView.rating), comment: commentView.text!)
            print(self.tripId)
            print(Int(ratingView.rating))
            NetworkRepository.shared.rateTripRepository.rateTrip2(with: request) { (response, error) in
                if let error = error{
                    Toast.show(message: "Trip not completed")
                    print("Something went wrong in Searching THE Driver. \(error.localizedDescription)")
                    
                } else {
                    print(response)
                    DispatchQueue.main.async {
                    Toast.show(message: "Thank you for feedback")
                        self.continueToMain()
//                    self.delegate?.didDismissedWithResponse()
                      }
                  }
              }
            
        }
    }
    
    func continueToMain() {
        let homeNav = UIStoryboard.AppStoryboard.Main.instance.instantiateViewController(withIdentifier: UINavigationController.Identifiers.HomeNav) as! UINavigationController
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.replaceRootViewControllerWith(homeNav, animated: true, completion: nil)
    }
}
