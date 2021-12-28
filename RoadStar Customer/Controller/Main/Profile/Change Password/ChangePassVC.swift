//
//  ChangePassVC.swift
//  RoadStar Customer
//
//  Created by Apple on 01/11/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import SwiftyJSON

class ChangePassVC: BaseViewController {
    
    @IBOutlet weak var txtOldPass: SkyFloatingLabelTextField!
    @IBOutlet weak var txtnewPass: SkyFloatingLabelTextField!
    @IBOutlet weak var txtConfPass: SkyFloatingLabelTextField!
    
    override func setupUI() {
        
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnSaveTapped(_ sender: Any) {
        if isValidate(){
            
            changePassword()
            
        }
    }
    
    func isValidate() -> Bool {
        
        if txtOldPass.text == nil {
            Toast.showError(message: "Old Pass field is empty")
            return false
        } else if txtOldPass.text!.isEmpty {
            Toast.showError(message: "Old Pass field is empty")
            return false
        } else if txtnewPass.text == nil {
            Toast.showError(message: "Password field is empty")
            return false
        } else if txtnewPass.text!.isEmpty {
            Toast.showError(message: "Password field is empty")
            return false
        } else if txtConfPass.text == nil {
            Toast.showError(message: "Conf Password field is empty")
            return false
        } else if txtConfPass.text!.isEmpty {
            Toast.showError(message: "Conf Password field is empty")
            return false
        } else if txtConfPass.text! != txtnewPass.text! {
            Toast.showError(message: "Conf Password & Password not matching.")
            return false
        }
        return true
    }
    
}
extension ChangePassVC{
    
    func changePassword()
    {
        let request = ChangePasswordRequest(password: txtnewPass.text!,
                                            old_password: txtOldPass.text!,
                                            password_confirmation: txtConfPass.text!)
        
        NetworkRepository.shared.changePasswordRepository.changePass(request: request) { (response, error) in
            
            if let error = error{
                Toast.show(message: "Something went wrong!")
                print("Something went wrong in changing password. \(error.localizedDescription)")
                
            } else  {
                Toast.show(message: "Password changed succesfully")
                
//                let encoder = JSONEncoder()
//                if let encoded = try? encoder.encode(response) {
//                    let defaults = UserDefaults.standard
//                    defaults.set(encoded, forKey: "UserProfileInfo")
//                    defaults.synchronize()
//                }
                
                
            }
        }
    }
    
}
//if let response = profileResponse
