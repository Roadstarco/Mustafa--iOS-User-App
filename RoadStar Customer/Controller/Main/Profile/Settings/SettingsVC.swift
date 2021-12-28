//
//  SettingsVC.swift
//  RoadStar Customer
//
//  Created by Apple on 29/10/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation
import UIKit

class SettingsVC: BaseViewController{
    
    @IBOutlet weak var lblChangePass: UILabel!
    @IBOutlet weak var btnArrow: UIButton!
    @IBOutlet weak var btnChangePass: UIButton!
    
    override func setupUI() {
        self.lblChangePass.isHidden = true
        self.btnArrow.isHidden = true
        self.btnChangePass.isHidden = true
        getUserInf()
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnSwitchTapped(_ sender: Any) {
        
        
        
    }
    
    @IBAction func btnChangePassTapped(_ sender: Any) {
       
        let VC = UIStoryboard.AppStoryboard.Main.instance.instantiateViewController(withIdentifier: UIViewController.Identifiers.Main.ChangePassVC) as! ChangePassVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func getUserInf()
    {
        let token = UserDefaults.standard.value(forKey: "loginToken") as? String ?? ""
        print(token)
        let profile = ProfileRequest(token: token)
        
        NetworkRepository.shared.userProfileRepository.getUserProfile(with: profile) { (profileResponse, error) in
            
            if let error = error{
                Toast.show(message: "Something went wrong!")
                print("Something went wrong in SIGNUP THE USER. \(error.localizedDescription)")
                
            } else if let userProf = profileResponse {
                
                if userProf.loginBy == "manual"{
                    self.lblChangePass.isHidden = false
                    self.btnArrow.isHidden = false
                    self.btnChangePass.isHidden = false
                }
                
            }
        }
    }
    
}
