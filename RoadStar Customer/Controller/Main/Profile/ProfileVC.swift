//
//  ProfileVC.swift
//  RoadStar Customer
//
//  Created by Apple on 28/10/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField
import SDWebImage

class ProfileVC: BaseViewController{
    
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var txtSecName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFirstName: SkyFloatingLabelTextField!
    @IBOutlet weak var btnImgProfile: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    
    var delegate : RateTripPopoverProtocol?
    var imagePicker: ImagePicker!
    var imgChanged: Bool = false
    var mobile: String = ""
    var countryName = ""
    var address = ""
    var id: Int = 0
    var picture: String = ""
    var data: UploadData? = nil
    var ImageUrl: URL?
    
    override func setupUI() {
        
        self.getUserInf()
        }
    
    @IBAction func btnSettingTapped(_ sender: Any) {
        let bookingVC = UIStoryboard.AppStoryboard.Main.instance.instantiateViewController(withIdentifier: UIViewController.Identifiers.Main.SettingsVC) as! SettingsVC
        self.navigationController?.pushViewController(bookingVC, animated: true)
        
        
    }
    
    @IBAction func btnImgProfileTapped(_ sender: Any) {
        self.imagePicker.present(from: sender as! UIView, showCamera: true, showLibrary: true)
        
    }
    
    @IBAction func btnUpdateProfileTapped(_ sender: Any) {
        if isValidate() {
        updateProfile()
      }
    
    }
    
    @IBAction func btnSideMenuTapped(_ sender: Any) {
        
    }
    
    
    func updateProfile(){
        data = UploadData(data: imgProfile.image!.pngData()!, fileName: "\(Date().timeIntervalSince1970).png", mimeType: "png", name: "avatar")
        
        let request = UpdateProfileRequest(first_name: txtFirstName.text ?? "", last_name: txtSecName.text ?? "", email: txtEmail.text ?? "", mobile: self.mobile, country_name: self.countryName, address: self.address)
        
        NetworkRepository.shared.updateProfileRepository.updateProfile(request: request, picture: ImageUrl , image: self.imgProfile.image! ) { (response, error) in
            if let error = error{
                Toast.show(message: "Not updated")
                print("Something went wrong in updating the profile. \(error.localizedDescription)")

            }
            else if let response = response {
                

                
                DispatchQueue.main.async {
                    Toast.show(message: "Profile updated")
                    self.delegate?.didDismissedWithResponse()
                
                }
            
            }
            else {
                Toast.show(message: "Something went wrong!")
                print("Something went wrong in updating profile")
            }

        
        }
        
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
                
                print(userProf.firstName as Any)
                print(userProf.email as Any)
                
                self.txtFirstName.text = userProf.firstName
                self.txtSecName.text = userProf.lastName
                self.txtEmail.text = userProf.email
                self.mobile = userProf.mobile ?? ""
                self.imagePicker = ImagePicker(presentationController: self, delegate: self)
                self.countryName = userProf.countryName ?? ""
                self.address = userProf.address ?? ""
                self.id = userProf.id ?? 0
                self.picture = userProf.picture ?? ""
                if let url = URL(string: userProf.picture ?? "") {
                    self.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    self.imgProfile.sd_setImage(with: url)
                    self.ImageUrl = url
//                    UserDefaults.standard.setValue(url, forKey: "userProfilePic")
                }
                
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(userProf) {
                    let defaults = UserDefaults.standard
                    defaults.set(encoded, forKey: "UserProfileInfo")
                    defaults.synchronize()
                }
                
//                let homeNav = UIStoryboard.AppStoryboard.Main.instance.instantiateViewController(withIdentifier: UINavigationController.Identifiers.HomeNav) as! UINavigationController
//                UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.replaceRootViewControllerWith(homeNav, animated: true, completion: nil)
                
            }else{
                Toast.show(message: "Something went wrong!")
                print("Something went wrong in SIGNUP THE USER.")
            }
        }
    }
    
    func isValidate() -> Bool {
        
        if txtEmail.text == nil {
            Toast.showError(message: "Email field is empty")
            return false
        } else if txtEmail.text!.isEmpty {
            Toast.showError(message: "Email field is empty")
            return false
        } else if txtFirstName.text == nil {
            Toast.showError(message: "First Name field is empty")
            return false
        } else if txtFirstName.text!.isEmpty {
            Toast.showError(message: "First Name field is empty")
            return false
        } else if txtSecName.text == nil {
            Toast.showError(message: "Second Name field is empty")
            return false
        } else if txtSecName.text!.isEmpty {
            Toast.showError(message: "Second Name field is empty")
            return false
        }
        return true
        
    }
}

extension ProfileVC: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        
        if let img = image {
            
            imgChanged = true
            self.imgProfile.image = img
            
        }
    }
    
    func didSelect(videoUrl: NSURL?) {
    }
    
    func imageUrl(imageUrl: URL) {
        ImageUrl = imageUrl
    }
    
    
}
