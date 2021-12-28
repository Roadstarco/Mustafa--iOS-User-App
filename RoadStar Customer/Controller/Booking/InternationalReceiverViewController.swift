//
//  InternationalReceiverViewController.swift
//  RoadStar Customer
//
//  Created by Apple on 03/12/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation
import UIKit

class InternationalReceiverViewController: BaseViewController{
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    var itemName: String = ""
    var deliveryFrom: String = ""
    var deliveryTo: String = ""
    var arrivalDate: String = ""
    var image1: String = ""
    var image2: String = ""
    var image3: String = ""
    var itemSize: String = ""
    var itemType: String = ""
    var Amount: String = ""
    var parcelDetails: String = ""
    var fromManualRequest = false
    var trip_id = 0
    override func setupUI() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                tap.cancelsTouchesInView = false
                view.addGestureRecognizer(tap)
        
        print(itemName)
        print(deliveryFrom)
        print(deliveryTo)
        print(arrivalDate)
        print(image1)
        print(image2)
        print(image3)
        print(itemSize)
        print(itemType)
        print(Amount)
        print(parcelDetails)
        
    }
    func isValidate() -> Bool {
        
        if nameTextField.text == nil {
            Toast.showError(message: "Please Enter Reciever Name")
            return false
        } else if nameTextField.text!.isEmpty {
            Toast.showError(message: "Please Enter Reciever Name")
            return false
        } else if phoneNumberTextField.text == nil {
            Toast.showError(message: "Please Enter Reciever Phone Number")
            return false
        } else if phoneNumberTextField.text!.isEmpty {
            Toast.showError(message: "Please Enter Reciever Phone Number")
            return false
        }
        return true
        
    }
    
    @IBAction func btnNextTapped(_ sender: Any) {
        
        if isValidate(){
            if fromManualRequest{
        let requestInfo = InternationalRequest(receiver_name: nameTextField.text!,
                                               receiver_phone: phoneNumberTextField.text!,
                                               item: itemName,
                                               tripfrom: deliveryFrom,
                                               tripto: deliveryTo,
                                               item_type: itemType,
                                               item_size: itemSize,
                                               arrival_date: arrivalDate,
                                               other_information: parcelDetails,
                                               trip_amount: Amount)
        
        
        var attachments = [String]()
        if !image1.isEmpty
        {
            attachments.append(image1)
        }
        
        if !image2.isEmpty
        {
            attachments.append(image2)
        }
        
        if !image3.isEmpty
        {
            attachments.append(image3)
        }
        
        NetworkRepository.shared.internationalTripRepository.sendRequestForIntTrip(request: requestInfo, attachemnts: attachments) { (apiResponse, error) in
            
            if let error = error{
                
                if apiResponse != nil
                {
                    Toast.show(message: "error: \(apiResponse)")
                    print("Something went wrong in SIGNUP THE USER. \(apiResponse)")
                }
                else
                {
                    Toast.show(message: "Something Went Wrong Please Try Again")
                    print("Something went wrong in SIGNUP THE USER. \(error.localizedDescription)")
                }
                
            } else if apiResponse != nil{
                
                Toast.show(message: "Trip Created Successfully")
                NotificationCenter.default.post(name: NSNotification.Name("request_submitted"), object: nil, userInfo: nil)
                self.continueToHome()
            } else{
                Toast.show(message: "Something went wrong!")
                print("Something went wrong in SIGNUP THE USER.")
              }
           }
            }else{
                
                
                let requestInfo = AddBidAvailableTripsModel(receiver_name: self.phoneNumberTextField.text!,
                                                            receiver_phone: self.nameTextField.text!,
                                                        item: itemName,
                                                        item_type: itemType,
                                                        item_size: itemSize,
                                                        description: parcelDetails,
                                                        amount: Amount,
                                                        trip_id: trip_id)
            
            
            var attachments = [String]()
                    if !self.image1.isEmpty
            {
                        attachments.append(self.image1)
            }
            
                    if !self.image2.isEmpty
            {
                        attachments.append(self.image2)
            }
            
                    if !self.image3.isEmpty
            {
                        attachments.append(self.image3)
            }
            
            NetworkRepository.shared.addBidAvailableRequestRepository.addBidAvailableTrips(request: requestInfo, attachemnts: attachments) { (apiResponse, error) in
                
                if let error = error{
                    
                    if apiResponse != nil
                    {
                        Toast.show(message: "error: \(apiResponse)")
                        print("Something went wrong in SIGNUP THE USER. \(apiResponse)")
                    }
                    else
                    {
                        Toast.show(message: "Something Went Wrong Please Try Again")
                        print("Something went wrong in SIGNUP THE USER. \(error)")
                    }
                    
                } else if apiResponse != nil{
                    
                    Toast.show(message: "Bid Added Successfully")
                    NotificationCenter.default.post(name: NSNotification.Name("request_submitted"), object: nil, userInfo: nil)
                    self.continueToHome()
                } else{
                    Toast.show(message: "Something went wrong!")
                    print("Something went wrong in SIGNUP THE USER.")
                  }
               }
                }
                
                
            }
        }
    
    
    func continueToHome() {
        let homeNav = UIStoryboard.AppStoryboard.Main.instance.instantiateViewController(withIdentifier: UINavigationController.Identifiers.HomeNav) as! UINavigationController
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.replaceRootViewControllerWith(homeNav, animated: true, completion: nil)
    }
    
    @objc override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
