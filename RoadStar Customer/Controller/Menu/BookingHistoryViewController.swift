//
//  BookingHistoryViewController.swift
//  RoadStar Customer
//
//  Created by Roamer on 21/07/2020.
//  Copyright © 2020 Osama Azmat Khan. All rights reserved.
//

import UIKit

class BookingHistoryViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var history: UserTripsHistoryModel?

    @IBOutlet weak var theTableView: UITableView!
    
    override func setupUI() {
        registerXib()
        getBookingHistoryTrips()
    }
    
    override func setupTheme() {
        super.setupTheme()
    }
    
    func registerXib() {
        
        let nib = UINib.init(nibName: BookingHistoryTableViewCell.nibName, bundle: nil)
        theTableView.register(nib, forCellReuseIdentifier: BookingHistoryTableViewCell.cellReuseIdentifier)
    }
    func getBookingHistoryTrips()
    {
        
        
        NetworkRepository.shared.bookingHistoryTripsRepository.getBookingHistoryTrips() { (response, error) in
            
            if let error = error{
                Toast.show(message: "Something went wrong!")
                print("Something went wrong in SIGNUP THE USER. \(error)")
                
            } else if let response = response {
                print(response)
                self.history = response
                self.theTableView.reloadData()
                
            } else{
                Toast.show(message: "Something went wrong!")
                print("Something went wrong in SIGNUP THE USER.")
            }
        }
    }
    @IBAction func btnBackTapped(_ sender: Any) {
        
        let homeNav = UIStoryboard.AppStoryboard.Main.instance.instantiateViewController(withIdentifier: UINavigationController.Identifiers.HomeNav) as! UINavigationController
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.replaceRootViewControllerWith(homeNav, animated: true, completion: nil)
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history?.internationalJobs.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BookingHistoryTableViewCell.cellReuseIdentifier, for: indexPath) as! BookingHistoryTableViewCell
        let id = (self.history?.internationalJobs[indexPath.row].id ?? 0) as Int
        let stringId = String(id)
        let amount = (self.history?.internationalJobs[indexPath.row].trip_request?.amount ?? 0) as Int
        let stringAmount = String(amount)
        cell.lblCreatedAt.text = self.history?.internationalJobs[indexPath.row].created_at
        cell.lblId_Servicetype.text = "\(stringId ),\(self.history?.internationalJobs[indexPath.row].service_type ?? "")"
        cell.lblAmount.text = stringAmount
        cell.lblfrom.text = self.history?.internationalJobs[indexPath.row].tripfrom
        cell.lblTripTo.text = self.history?.internationalJobs[indexPath.row].tripto
        return cell
    }

    
}

