//
//  SignUpViewController.swift
//  RoadStar Customer
//
//  Created by Roamer on 04/07/2020.
//  Copyright © 2020 Osama Azmat Khan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FlagPhoneNumber
import FBSDKLoginKit
import FBSDKCoreKit

class SignUpViewController: BaseViewController  {

    @IBOutlet weak var btnNext: PrimaryButton!
    @IBOutlet weak var phoneTxtField: FPNTextField!

    
    var selectedPhoneNum: String? = nil
    var countryName: String = ""
    
    override func setupUI() {
        phoneTxtField.delegate = self
        btnNext.isEnabled = true// selectedPhoneNum != nil
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                tap.cancelsTouchesInView = false
                view.addGestureRecognizer(tap)
        
    }
    
    override func setupTheme() {
        super.setupTheme()
        
    }
    
    @objc func fbLoginTapped(){
        
        
        
        
    }
    @objc func googleLoginTapped(){
        
        
        
        
    }
    
    @objc override func dismissKeyboard() {
            view.endEditing(true)
        }
    
    @IBAction func onCLickNextBtn(_ sender: Any) {
        
//        let vc = UIStoryboard.AppStoryboard.PreLogin.instance.instantiateViewController(withIdentifier: UIViewController.Identifiers.PreLogin.VerifyOTPViewController) as! VerifyOTPViewController
//        vc.otpCode = "verificationID"
//        vc.selectedPhoneNumber = "self.selectedPhoneNum!"
//        self.navigationController?.pushViewController(vc, animated: true)
        
      let loader = ProgressIndicator.show(message: "Sending OTP Code...")

        PhoneAuthProvider.provider().verifyPhoneNumber(selectedPhoneNum!, uiDelegate: nil) { (verificationID, error) in
            loader.close()
          if let error = error {
            Toast.showError(message: error.localizedDescription)
              print(error)
            return
          }
//
            if verificationID != nil{
                let vc = UIStoryboard.AppStoryboard.PreLogin.instance.instantiateViewController(withIdentifier: UIViewController.Identifiers.PreLogin.VerifyOTPViewController) as! VerifyOTPViewController
                vc.verificationId = verificationID
                vc.selectedPhoneNumber = self.selectedPhoneNum! //"+923340117716" //
                vc.countryname = self.countryName
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func onClickBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension SignUpViewController: FPNTextFieldDelegate{
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        dismissKeyboard()
        let listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
        
        phoneTxtField.displayMode = .picker // .picker by default

        listController.setup(repository: phoneTxtField.countryRepository)
        listController.didSelect = { [weak self] country in
            self?.phoneTxtField.setFlag(countryCode: country.code)
            self?.countryName = country.name as String
        }
        let navigationViewController = UINavigationController(rootViewController: listController)
        
        present(navigationViewController, animated: true, completion: nil)

    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        
        if isValid {
        let num = textField.getFormattedPhoneNumber(format: .E164)
            selectedPhoneNum = num
            dismissKeyboard()
            print("final selected Phone Number = \(num ?? "")")
        } else{
            selectedPhoneNum = nil
        }
        btnNext.isEnabled = selectedPhoneNum != nil
    }
    
    func fpnDisplayCountryList() {
        
        
    }
}



