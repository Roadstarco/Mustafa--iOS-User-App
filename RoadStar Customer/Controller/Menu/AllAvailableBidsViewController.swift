//
//  AllAvailableBidsViewController.swift
//  RoadStar Customer
//
//  Created by Apple on 06/12/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class AllAvailableBidsViewController: BaseViewController, UITableViewDataSource , UITableViewDelegate{
    
    
    
    @IBOutlet weak var lblNoBids: UILabel!
    @IBOutlet weak var theTableView: UITableView!
    
    var trip_id = 0
    var bids: [GetUserTripBidsResponse]?
    override func setupUI() {
        self.lblNoBids.isHidden = true
        registerXib()
        getAllBids()
        theTableView.dataSource = self
        theTableView.delegate = self
        theTableView.reloadData()
    }
    
    func registerXib() {
        
        let nib = UINib.init(nibName: AllBidsTableViewCell.nibName, bundle: nil)
        theTableView.register(nib, forCellReuseIdentifier: AllBidsTableViewCell.cellReuseIdentifier)
    }
    
    func getAllBids(){
        
        let params = GetUserTripBidsRequest(trip_id: self.trip_id)
        
    NetworkRepository.shared.getUserTripBidsRepository.getAllBids(with: params)  { (apiResponse, error) in
        
        if let error = error{
            
            if apiResponse != nil
            {
                Toast.show(message: "error: \(String(describing: apiResponse))")
                print("Something went wrong in SIGNUP THE USER. \(String(describing: apiResponse))")
            }
            else
            {
                
//                Toast.show(message: "Something Went Wrong Please Try Again")
                self.lblNoBids.isHidden = false
                print("Something went wrong in SIGNUP THE USER. \(error)")
            }
            
        } else if apiResponse != nil{
            print(apiResponse as Any)
            self.bids = apiResponse
            print("number of bids are")
            print(self.bids?.count)
            self.theTableView.reloadData()
            
        } else{
            Toast.show(message: "Something went wrong!")
            print("Something went wrong in SIGNUP THE USER.")
          }
       }
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        self.dismiss(animated: true)
//        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bids?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllBidsTableViewCell.cellReuseIdentifier, for: indexPath) as! AllBidsTableViewCell
        cell.setUp(request: (self.bids?[indexPath.row])!)
        cell.trip_id = self.trip_id
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 270
    }
    
}
