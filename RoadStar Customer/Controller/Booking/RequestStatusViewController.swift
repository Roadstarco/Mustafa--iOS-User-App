//
//  RequestStatusViewController.swift
//  RoadStar Customer
//
//  Created by Usman Nisar on 16/08/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import UIKit

class RequestStatusViewController: BaseViewController {

    @IBOutlet var imageView : UIImageView!
    @IBOutlet var serviceImage : UIImageView!
    @IBOutlet var statusLabel : UILabel!
    @IBOutlet var lblVehicleName : UILabel!
    
    var serviceInfo : ServiceModel? = nil
    var request_id = ""
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        imageView.startAnimating()
//    }
    
    override func setupUI() {
        //
//        let jeremyGif = UIImage(g)
        imageView.image = UIImage.gifImageWithName(name: "waiting")
        statusLabel.text = "Getting Info"
        lblVehicleName.text = serviceInfo!.name
        
        
        if let url = URL(string: serviceInfo!.image)
        {
            serviceImage.sd_setImage(with: url) { image, error, cashe, urlv in
                //
            }
        }
        
        getRequestInfo()
    }
    
    func getRequestInfo()
    {
        
        
//        NetworkRepository.shared.sendRequestRepository.getRequestStatusForTrip { (response, error) in
//
//            if let error = error{
//                Toast.show(message: "Something went wrong!")
//                print("Something went wrong in SIGNUP THE USER. \(error.localizedDescription)")
//
//            } else if let statusObj = response {
//
//                if statusObj.data.count > 0
//                {
//                    let statusV = statusObj.data[0]
//                    DispatchQueue.main.async {
//                        //
//                        self.statusLabel.text = statusV.status == "SEARCHING" ? "Searching Driver" : statusV.status
//                    }
//                    
//                    self.getRequestInfo()
//                }
//                
//            } else{
//                Toast.show(message: "Something went wrong!")
//                print("Something went wrong in SIGNUP THE USER.")
//            }
//        }
    }
    
    @IBAction func onBackClicked(_ id:UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }

}
