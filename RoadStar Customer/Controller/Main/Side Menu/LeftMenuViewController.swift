//
//  LeftMenuViewController.swift
//  RoadStar Customer
//
//  Created by Roamer on 13/07/2020.
//  Copyright © 2020 Osama Azmat Khan. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
class LeftMenuViewController: BaseViewController {

    
    // MARK: Variables And Outlets

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func setupUI() {
        print(AccessToken.current)
        getUserInf()
        self.tableView.register(UINib(nibName: GenericTableViewCell.nibName, bundle: Bundle.main), forCellReuseIdentifier: GenericTableViewCell.cellReuseIdentifier)
        
        self.tableView.reloadData()
        
        if let savedPerson = UserDefaults.standard.object(forKey: "UserProfileInfo") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(ProfileModel.self, from: savedPerson) {
                
            }
        }
    }
    
    override func setupTheme() {
        super.setupTheme()
        
    }
    
    func getUserInf(){
        let token = UserDefaults.standard.value(forKey: "loginToken") as? String ?? ""
        let profile = ProfileRequest(token: token)
        
        NetworkRepository.shared.userProfileRepository.getUserProfile(with: profile) { (profileResponse, error) in
            
            if let error = error{
                Toast.show(message: "Something went wrong!")
                print("Something went wrong in SIGNUP THE USER. \(error.localizedDescription)")
                
            } else if let userProf = profileResponse {
                self.userNameLbl.text = "\(userProf.firstName ?? "") \(userProf.lastName ?? "")"
                print(userProf.loginBy)
                self.emailLbl.text = "\(userProf.email ?? "")"
                if let url = URL(string: userProf.picture ?? "") {
                    self.profileImageView.sd_setImage(with: url)
                }
                
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(userProf) {
                    let defaults = UserDefaults.standard
                    defaults.set(encoded, forKey: "UserProfileInfo")
                    defaults.synchronize()
                }
            }else{
                Toast.show(message: "Something went wrong!")
                print("Something went wrong in SIGNUP THE USER.")
            }
        }
    }
    @IBAction func btnProfileTapped(_ sender: Any) {
        let bookingVC = UIStoryboard.AppStoryboard.Main.instance.instantiateViewController(withIdentifier: UIViewController.Identifiers.Main.ProfileVC) as! ProfileVC
        self.navigationController?.pushViewController(bookingVC, animated: true)
        
    }
}

extension LeftMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GenericTableViewCell.cellReuseIdentifier) as? GenericTableViewCell else {
            return UITableViewCell()
        }
        
        if indexPath.item == 0 {
            cell.mainLabel.text = Strings.MainMenuNames.Home
            cell.mainImageView.image = UIImage(named: UIImage.AppImages.Settings.Home)
        }
        else if indexPath.item == 1 {
            cell.mainLabel.text = Strings.MainMenuNames.PostATrip
            cell.mainImageView.image = UIImage(named: UIImage.AppImages.Settings.PostATrip)
        }
        else if indexPath.item == 2 {
            cell.mainLabel.text = Strings.MainMenuNames.TrackPackage
            cell.mainImageView.image = UIImage(named: UIImage.AppImages.Settings.TrackPackage)
        }
        else if indexPath.item == 3 {
            cell.mainLabel.text = Strings.MainMenuNames.BookingHistory
            cell.mainImageView.image = UIImage(named: UIImage.AppImages.Settings.BookingHistory)
        }
        else if indexPath.item == 4 {
            cell.mainLabel.text = Strings.MainMenuNames.Claim
            cell.mainImageView.image = UIImage(named: UIImage.AppImages.Settings.Claim)
        }
        else if indexPath.item == 5 {
            cell.mainLabel.text = Strings.MainMenuNames.PaymentMethod
            cell.mainImageView.image = UIImage(named: UIImage.AppImages.Settings.PaymentMethod)
        }
        else if indexPath.item == 6 {
            cell.mainLabel.text = Strings.MainMenuNames.Support
            cell.mainImageView.image = UIImage(named: UIImage.AppImages.Settings.Support)
        }
        else if indexPath.item == 7 {
            cell.mainLabel.text = Strings.MainMenuNames.Logout
            cell.mainImageView.image = UIImage(named: UIImage.AppImages.Settings.Logout)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            
            let homeNav = UIStoryboard.AppStoryboard.Main.instance.instantiateViewController(withIdentifier: UINavigationController.Identifiers.HomeNav) as! UINavigationController
            
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.replaceRootViewControllerWith(homeNav, animated: true, completion: nil)
            
//            setRootViewController(homeNav)
//            self.dismiss(animated: true, completion: nil)
        }
        else if indexPath.item == 1 {
            
            let bookingVC = UIStoryboard.AppStoryboard.Booking.instance.instantiateViewController(withIdentifier: UIViewController.Identifiers.Booking.InternationalBookingViewController) as! InternationalBookingViewController
            self.navigationController?.pushViewController(bookingVC, animated: true)
            
//            setRootViewController(vc)
//            self.dismiss(animated: true, completion: nil)
            
        }
        else if indexPath.item == 2 {
            
            let vc = UIStoryboard.AppStoryboard.Menu.instance.instantiateViewController(withIdentifier: UIViewController.Identifiers.Menu.TrackPackageViewController) as! TrackPackageViewController

            UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.replaceRootViewControllerWith(vc, animated: true, completion: nil)
        }
        else if indexPath.item == 3 {
            
            let vc = UIStoryboard.AppStoryboard.Menu.instance.instantiateViewController(withIdentifier: UIViewController.Identifiers.Menu.BookingHistoryViewController) as! BookingHistoryViewController
            
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.replaceRootViewControllerWith(vc, animated: true, completion: nil)
        }
        else if indexPath.item == 4 {
            let vc = UIStoryboard.AppStoryboard.Menu.instance.instantiateViewController(withIdentifier: UIViewController.Identifiers.Menu.ClaimViewController) as! ClaimViewController
            
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.replaceRootViewControllerWith(vc, animated: true, completion: nil)
            
        }
        else if indexPath.item == 5 {
            let vc = UIStoryboard.AppStoryboard.Menu.instance.instantiateViewController(withIdentifier: UIViewController.Identifiers.Menu.PaymentMethodsViewController) as! PaymentMethodsViewController
            
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.replaceRootViewControllerWith(vc, animated: true, completion: nil)
            
        }
        else if indexPath.item == 6 {
            let vc = UIStoryboard.AppStoryboard.Menu.instance.instantiateViewController(withIdentifier: UIViewController.Identifiers.Menu.SupportViewController) as! SupportViewController
            
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.replaceRootViewControllerWith(vc, animated: true, completion: nil)
            
        } else if indexPath.item == 7 {
            UserDefaults.standard.set(false, forKey: "alreadyLoggedIn")
            UserDefaults.standard.setValue("", forKey: "loginToken")
            AccessToken.current = nil
            let welcomNav = UIStoryboard.AppStoryboard.PreLogin.instance.instantiateViewController(withIdentifier: UINavigationController.Identifiers.WelcomNav) as! UINavigationController
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.replaceRootViewControllerWith(welcomNav, animated: true, completion: nil)
        }
    }
    
    func setRootViewController(_ vc: UIViewController, animated: Bool = true) {
        setRootController(controller: vc)
        UIView.transition(with: UIApplication.AppDelegate().window!,
                                 duration: 0.5,
                                 options: .transitionFlipFromLeft,
                                 animations: nil,
                                 completion: nil)
       
    }
    
    func setRootController(controller: UIViewController){
        UIApplication.AppDelegate().setRootController(controller: controller)
    }
    
}
