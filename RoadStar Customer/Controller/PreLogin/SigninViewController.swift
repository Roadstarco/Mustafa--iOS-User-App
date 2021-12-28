//
//  SigninViewController.swift
//  RoadStar Customer
//
//  Created by Roamer on 11/07/2020.
//  Copyright © 2020 Osama Azmat Khan. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn

class SigninViewController: BaseViewController {
    
    

    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var googleLogin: UIImageView!
    @IBOutlet weak var fbLogin: UIImageView!
    var email: String = ""
    var socialID: String = ""
    let signInConfig = GIDConfiguration.init(clientID: "234677169665-tnjog21glmuv8r57usem3ovr4cp0r7e9.apps.googleusercontent.com")
//    let signInConfig = GIDConfiguration.init(clientID: "48653661783-cvnnnb8bodbia29fh39seb960htt0g66.apps.googleusercontent.com")
    
    override func setupUI() {
        
        // MARK: - userintercation on google button
        txtPassword.isSecureTextEntry = true
        googleLogin.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(gmailLoginTapped))
        googleLogin.addGestureRecognizer(gestureRecognizer)
        
        fbLogin.isUserInteractionEnabled = true
        let gestureRecognizer1 = UITapGestureRecognizer(target: self, action:  #selector(fbLoginTapped))
        fbLogin.addGestureRecognizer(gestureRecognizer1)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                tap.cancelsTouchesInView = false
                view.addGestureRecognizer(tap)
        
//        txtEmail.text = "tester@test.com"
//        txtPassword.text = "1234Abc@"
    }
    
    override func setupTheme() {
        super.setupTheme()
        
    }
    

    // MARK: - function called when user tappes on facebook button
    
    @objc func fbLoginTapped(){
        
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [.publicProfile, .email, .userLocation ], viewController: self) { (result) in
                switch result{
                case .cancelled:
                    print("Cancel button click")
                    Toast.showError(message: "Please login to facebook to complete the process")
                case .success:
                    let params = ["fields":"email, name, first_name, last_name, location"]
                    let graphRequest = GraphRequest.init(graphPath: "/me", parameters: params)
                    let Connection = GraphRequestConnection()
                    Connection.add(graphRequest) { (Connection, result, error) in
                        let result = result as! [String:Any]
                        print(result)
                        self.email = result["email"] as! String
                        self.socialID = result["id"] as! String
                        
                        let deviceid = (UIDevice.current.identifierForVendor?.uuidString)!
                        print("\(deviceid)")
                        let logIn = LogIn(grant_type: "password",
                                          client_id: 2,
                                          client_secret: "WX2IZR5Yi6gpZ3ajSJ4meKik3R0K1z2vomJVc2Qw",
                                          username: self.email,
                                          password: self.socialID,
                                          scope: "",
                                          device_type: "ios",
                                          device_id: deviceid,
                                          device_token: UserDefaults.standard.string(forKey: "fcmtoken") ?? "" )
                        
                        NetworkRepository.shared.logInRepository.logIn(with: logIn) { (logInResponse, error) in
                            
                            if let error = error{
                                Toast.show(message: "Something went wrong!")
                                print("Something went wrong in SIGNUP THE USER. \(error.localizedDescription)")
                                
                            } else if let loginRes = logInResponse{
                                
                                print(loginRes)
                                if  loginRes.access_token == nil{
                                    
                                    Toast.showError(message: "User does not exist please signup first")
                                    let signUpVc = UIStoryboard.AppStoryboard.PreLogin.instance.instantiateViewController(withIdentifier: UIViewController.Identifiers.PreLogin.SignUpViewController) as! SignUpViewController
                                    self.navigationController?.pushViewController(signUpVc, animated: true)
                                }else{
                                UserDefaults.standard.setValue(loginRes.access_token, forKey: "loginToken")
                                UserDefaults.standard.synchronize()
                                UserDefaults.standard.set(true, forKey: "alreadyLoggedIn")
                                let homeNav = UIStoryboard.AppStoryboard.Main.instance.instantiateViewController(withIdentifier: UINavigationController.Identifiers.HomeNav) as! UINavigationController
                                UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.replaceRootViewControllerWith(homeNav, animated: true, completion: nil)
                                }
                            }
                        }
                       
                    }
                    
                    Connection.start()
                default:
                    print("??")
                }
            }
        
        
    }
    
    @objc override func dismissKeyboard() {
            view.endEditing(true)
        }
    
    // MARK: - function called when user tappes on google button
    @objc func gmailLoginTapped() {
    
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }
            let email = user.profile?.email
            let socialID = user.userID
            let deviceid = (UIDevice.current.identifierForVendor?.uuidString)!
            print("\(deviceid)")
            let logIn = LogIn(grant_type: "password",
                              client_id: 2,
                              client_secret: "WX2IZR5Yi6gpZ3ajSJ4meKik3R0K1z2vomJVc2Qw",
                              username: email!,
                              password: socialID!,
                              scope: "",
                              device_type: "ios",
                              device_id: deviceid,
                              device_token: UserDefaults.standard.string(forKey: "fcmtoken") ?? "" )
            
            NetworkRepository.shared.logInRepository.logIn(with: logIn) { (logInResponse, error) in
                
                if let error = error{
                    Toast.show(message: "Something went wrong!")
                    print("Something went wrong in SIGNUP THE USER. \(error.localizedDescription)")
                    
                } else if let loginRes = logInResponse{
                    print(loginRes)
                    if  loginRes.access_token == nil{
                        
                        Toast.showError(message: "User does not exist please signup first")
                        
                        let signUpVc = UIStoryboard.AppStoryboard.PreLogin.instance.instantiateViewController(withIdentifier: UIViewController.Identifiers.PreLogin.SignUpViewController) as! SignUpViewController
                        self.navigationController?.pushViewController(signUpVc, animated: true)
                    }else{
                    UserDefaults.standard.setValue(loginRes.access_token, forKey: "loginToken")
                    UserDefaults.standard.synchronize()
                    UserDefaults.standard.set(true, forKey: "alreadyLoggedIn")
                    let homeNav = UIStoryboard.AppStoryboard.Main.instance.instantiateViewController(withIdentifier: UINavigationController.Identifiers.HomeNav) as! UINavigationController
                    UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.replaceRootViewControllerWith(homeNav, animated: true, completion: nil)
                    }
                }
            }
        
        if let error = error {
            Toast.showError(message: "Please login to facebook to complete the process")
            print(error)
        }
    }
}

    //MARK: - manual login
    @IBAction func onCLickNextBtn(_ sender: Any) {
        
        if isValid(){
            let deviceid = (UIDevice.current.identifierForVendor?.uuidString)!
            print("\(deviceid)")
            let logIn = LogIn(grant_type: "password",
                              client_id: 2,
                              client_secret: "WX2IZR5Yi6gpZ3ajSJ4meKik3R0K1z2vomJVc2Qw",
                              username: txtEmail.text!,
                              password: txtPassword.text!,
                              scope: "",
                              device_type: "ios",
                              device_id: deviceid,
                              device_token: UserDefaults.standard.string(forKey: "fcmtoken") ?? "" )
            
            NetworkRepository.shared.logInRepository.logIn(with: logIn) { (logInResponse, error) in
                
                if let error = error{
                    Toast.show(message: "Something went wrong!")
                    print("Something went wrong in SIGNUP THE USER. \(error.localizedDescription)")
                    
                } else if let loginRes = logInResponse{
                    
                    print(loginRes)
                    if  loginRes.access_token == nil{
                        
                        Toast.showError(message: loginRes.message!)
                        
                    }else{
                    UserDefaults.standard.setValue(loginRes.access_token, forKey: "loginToken")
                    UserDefaults.standard.synchronize()
                    UserDefaults.standard.set(true, forKey: "alreadyLoggedIn")
                    let homeNav = UIStoryboard.AppStoryboard.Main.instance.instantiateViewController(withIdentifier: UINavigationController.Identifiers.HomeNav) as! UINavigationController
                    UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.replaceRootViewControllerWith(homeNav, animated: true, completion: nil)
                    }
                } else{
                    Toast.show(message: "Something went wrong!")
                    print("Something went wrong in SIGNUP THE USER.")
                }
            }
        }
        
    }
    
    @IBAction func onCLickSignUp(_ sender: Any) {
        let signUpVc = UIStoryboard.AppStoryboard.PreLogin.instance.instantiateViewController(withIdentifier: UIViewController.Identifiers.PreLogin.SignUpViewController) as! SignUpViewController
        self.navigationController?.pushViewController(signUpVc, animated: true)
    }
    
    @IBAction func onCLickForgotPassBtn(_ sender: Any) {
        let forgotPassVC = UIStoryboard.AppStoryboard.PreLogin.instance.instantiateViewController(withIdentifier: UIViewController.Identifiers.PreLogin.ForgetPasswordViewController) as! ForgetPasswordViewController
        self.navigationController?.pushViewController(forgotPassVC, animated: true)
    }
    
    @IBAction func onClickBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func isValid() -> Bool {
        
        if txtEmail.text == nil || txtEmail.text == ""{
            Toast.show(message: "Email field is empty.")
            return false
        } else if txtPassword.text == nil || txtPassword.text == ""{
            Toast.show(message: "Password field is empty.")
            return false
        }
        return true
    }
    
}
//    // MARK: - delegate method for login button tap
//    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
//        let token = result?.token?.tokenString
//        let request = FBSDKLoginKit.GraphRequest(graphPath: "me",
//                                                 parameters: ["fields":"email, name, first_name, last_name, location"],
//                                                 tokenString: token,
//                                                 version: nil,
//                                                 httpMethod: .get)
//        request.start(completion: { connection, result, error in
//            if let result = result {
//                print(result)
//                let result = result as! [String:Any]
//                self.email = result["email"] as! String
//                self.socialID = result["id"] as! String
//                let deviceid = (UIDevice.current.identifierForVendor?.uuidString)!
//                print("\(deviceid)")
//                let logIn = LogIn(grant_type: "password",
//                                  client_id: 2,
//                                  client_secret: "WX2IZR5Yi6gpZ3ajSJ4meKik3R0K1z2vomJVc2Qw",
//                                  username: self.email,
//                                  password: self.socialID,
//                                  scope: "",
//                                  device_type: "ios",
//                                  device_id: deviceid,
//                                  device_token: UserDefaults.standard.string(forKey: "fcmtoken") ?? "" )
//
//                NetworkRepository.shared.logInRepository.logIn(with: logIn) { (logInResponse, error) in
//
//                    if let error = error{
//                        Toast.show(message: "Something went wrong!")
//                        print("Something went wrong in SIGNUP THE USER. \(error.localizedDescription)")
//
//                    } else if let loginRes = logInResponse{
//
//                        print(loginRes.access_token ?? "no token")
//
//                        UserDefaults.standard.setValue(loginRes.access_token, forKey: "loginToken")
//                        UserDefaults.standard.synchronize()
//                        UserDefaults.standard.set(true, forKey: "alreadyLoggedIn")
//                        let homeNav = UIStoryboard.AppStoryboard.Main.instance.instantiateViewController(withIdentifier: UINavigationController.Identifiers.HomeNav) as! UINavigationController
//                        UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.replaceRootViewControllerWith(homeNav, animated: true, completion: nil)
//
//                    } else{
//                        Toast.show(message: "Something went wrong!")
//                        print("Something went wrong in SIGNUP THE USER.")
//                    }
//                }
//            }
//            if let error = error {
//                Toast.showError(message: "Please login to facebook to complete the process")
//                print(error)
//            }
//
//        })
//    }
//
//    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
//
//    }
//MARK: - facebook login button
//        let loginButton = FBLoginButton()
//        loginButton.translatesAutoresizingMaskIntoConstraints = false
//        loginButton.delegate = self
//        loginButton.permissions = ["public_profile", "email", "user_location"]
//
//        loginView.addSubview(loginButton)
//
//        NSLayoutConstraint.activate([
//            loginButton.topAnchor.constraint(equalTo:  loginView.topAnchor),
//            loginButton.centerXAnchor.constraint(equalTo:  loginView.centerXAnchor),
//            ])
