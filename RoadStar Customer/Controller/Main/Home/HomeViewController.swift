//
//  HomeViewController.swift
//  RoadStar Customer
//
//  Created by Roamer on 04/07/2020.
//  Copyright © 2020 Osama Azmat Khan. All rights reserved.
//

import UIKit
import CoreLocation
import Contacts
class HomeViewController: BaseViewController, CLLocationManagerDelegate {
    
    
    // MARK: Variables, Constants And Outlets
    
    @IBOutlet weak var localDeliveryView: HomeDeliveryOptionsView!
    @IBOutlet weak var internationalDeliveryView: HomeDeliveryOptionsView!
        
    
    var strLat = 0.0
    var strLong = 0.0
    let manager = CLLocationManager()
    let geocoder = CLGeocoder()
    var locality = ""
    var administrativeArea = ""
    var country = ""
    
//    open var postalAddress: CNPostalAddress? { get }
    // MARK: Private Functions
    
    override func setupUI() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        self.updateFCM()
        
        let gestureLocal = UITapGestureRecognizer(target: self, action:  #selector(self.onClickLocalDelivery))
        self.localDeliveryView.addGestureRecognizer(gestureLocal)
        
        let gestureInternational = UITapGestureRecognizer(target: self, action:  #selector(self.onClickInternationalDelivery))
        self.internationalDeliveryView.addGestureRecognizer(gestureInternational)
        
        self.getUserInf()
        
        LocationManager.shared.requestUserPermissionsAndStartUpdatingLocation()
        NotificationCenter.default.addObserver(self, selector: #selector(locationUpdateNotification), name: Notification.Name("UserLocationNotification"), object: nil)
        
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.first else {
//                    return
//                }
//                print("Current location is :", location.coordinate)
//                getAddressFromLocation(loc: location)
////                mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 10, bearing: 0, viewingAngle: 0)
//        manager.stopUpdatingLocation()
        
//            let location = locations[0]
//            manager.stopUpdatingLocation()
//
//        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
//            if (error != nil) {
//                print("Error in reverseGeocode")
//                }
//
//            let placemark = placemarks! as [CLPlacemark]
//            print(placemarks)
//            print(placemark)
//            if placemark.count > 0 {
//                let placemark = placemarks![0]
//
//
//                self.locality = placemark.locality!
//                self.administrativeArea = placemark.administrativeArea!
//                self.country = placemark.country!
//                print(self.locality)
//                print(self.administrativeArea)
//                print(self.country)
//                print(placemark.name as Any)
//                print(placemark.postalAddress as Any)
//                print(placemark.postalCode as Any)
//                print(placemark.subAdministrativeArea as Any)
//                print(placemark.subLocality as Any)
//                print(placemark.subThoroughfare as Any)
//                print(placemark.location as Any)
//            }
//        })
//    }
    
//    func getAddressFromLocation(loc: CLLocation) {
//            let ceo: CLGeocoder = CLGeocoder()
//            ceo.reverseGeocodeLocation(loc, completionHandler:
//                {(placemarks, error) in
//                    if (error != nil){
//                        print("reverse geodcode fail: \(error!.localizedDescription)")
//                    }
//                    let pm = placemarks! as [CLPlacemark]
//                    if pm.count > 0 {
//                        let pm = placemarks![0]
//                        print("country = ", pm.country as Any)
//                        print("administrativeArea = ", pm.administrativeArea as Any)
//                        print("locality = ", pm.locality as Any)
//                        print("subLocality = ", pm.subLocality as Any)
//                        print("thoroughfare = ", pm.thoroughfare as Any)
//                        print("thoroughfare = ", pm.postalCode as Any)
//                        print("subThoroughfare = ", pm.subThoroughfare as Any)
//
//                        var addressString : String = ""
//                        if pm.subLocality != nil {
//                            addressString = addressString + pm.subLocality! + ", "
//                        }
//                        if pm.thoroughfare != nil {
//                            addressString = addressString + pm.thoroughfare! + ", "
//                        }
//                        if pm.locality != nil {
//                            addressString = addressString + pm.locality! + ", "
//                        }
//                        if pm.administrativeArea != nil {
//                            addressString = addressString + pm.administrativeArea! + ", "
//                        }
//                        if pm.country != nil {
//                            addressString = addressString + pm.country! + ", "
//                        }
//                        if pm.postalCode != nil {
//                            addressString = addressString + pm.postalCode! + " "
//                        }
//                        print(addressString)
//                    }
//            })
//
//        }
    
//    func userLocationString() -> String {
//        let userLocationString = "\(locality), \(administrativeArea), \(country)"
//        return userLocationString
//    }
    
//    func getAddress(handler: @escaping (String) -> Void)
//    {
//        var address: String = ""
//        let geoCoder = CLGeocoder()
//        let location = CLLocation(latitude: self.strLat, longitude: self.strLong)
//        //selectedLat and selectedLon are double values set by the app in a previous process
//
//        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
//
//            // Place details
//            var placeMark: CLPlacemark?
//            placeMark = placemarks?[0]
//
//            // Address dictionary
//            print(placeMark?.addressDictionary ?? "")
//
//            // Location name
//            if let locationName = placeMark?.addressDictionary?["Name"] as? String {
//                address += locationName + ", "
//                print(address)
//            }
//
//            // Street address
//            if let street = placeMark?.addressDictionary?["Thoroughfare"] as? String {
//                address += street + ", "
//                print(address)
//            }
//
//            // City
//            if let city = placeMark?.addressDictionary?["City"] as? String {
//                address += city + ", "
//                print(address)
//            }
//
//            // Zip code
//            if let zip = placeMark?.addressDictionary?["ZIP"] as? String {
//                address += zip + ", "
//                print(address)
//            }
//
//            // Country
//            if let country = placeMark?.addressDictionary?["Country"] as? String {
//                address += country
//                print(address)
//            }
//
//           // Passing address back
//           handler(address)
//        })
//    }
    
//    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
//            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
//            let lat: Double = Double("\(pdblLatitude)")!
//            //21.228124
//            let lon: Double = Double("\(pdblLongitude)")!
//            //72.833770
//            let ceo: CLGeocoder = CLGeocoder()
//            center.latitude = lat
//            center.longitude = lon
//
//            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
//
//
//            ceo.reverseGeocodeLocation(loc, completionHandler:
//                {(placemarks, error) in
//                    if (error != nil)
//                    {
//                        print("reverse geodcode fail: \(error!.localizedDescription)")
//                    }
//                    let pm = placemarks! as [CLPlacemark]
//
//                    if pm.count > 0 {
//                        let pm = placemarks![0]
//                        print(pm.name)
//                        print(pm.administrativeArea)
//                        print(pm.postalAddress)
//                        print(pm.country)
//                        print(pm.locality)
//                        print(pm.subLocality)
//                        print(pm.thoroughfare)
//                        print(pm.postalCode)
//                        print(pm.subThoroughfare)
//                        var addressString : String = ""
//                        if pm.subLocality != nil {
//                            addressString = addressString + pm.subLocality! + ", "
//                        }
//                        if pm.thoroughfare != nil {
//                            addressString = addressString + pm.thoroughfare! + ", "
//                        }
//                        if pm.locality != nil {
//                            addressString = addressString + pm.locality! + ", "
//                        }
//                        if pm.country != nil {
//                            addressString = addressString + pm.country! + ", "
//                        }
//                        if pm.postalCode != nil {
//                            addressString = addressString + pm.postalCode! + " "
//                        }
//
//
//                        print(addressString)
//                  }
//            })
//
//        }
    
    
//    func getCurrentLocation(){
//    CLGeocoder().reverseGeocodeLocation(location, preferredLocale: nil) { (clPlacemark: [CLPlacemark]?, error: Error?) in
//        guard let place = clPlacemark?.first else {
//            print("No placemark from Apple: \(String(describing: error))")
//            return
//        }
//
//        let postalAddressFormatter = CNPostalAddressFormatter()
//        postalAddressFormatter.style = .mailingAddress
//        var addressString: String?
//        if let postalAddress = place.postalAddress {
//            addressString = postalAddressFormatter.string(from: postalAddress)
//        }
//    }
//    }
    @objc func locationUpdateNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo?["location"] as? CLLocation {
            
            //Store user location
    print(userInfo)
            let userLat = userInfo.coordinate.latitude
            let userLong  = userInfo.coordinate.longitude
            
            var strLat = ""
            var strLong = ""
            if  userLat > 0 {
                strLat = String(userLat)
                self.strLat = userLat
                print(userLat)
                print(self.strLat)
            }
            if userLong > 0 {
                strLong = String(userLong)
                self.strLong = userLong
                print(userLong)
                print(self.strLong)
            }
            let lat: Double = self.strLat
            let latString: String = String(format: "%.14f", lat)
            print(lat)
            print(latString)
            let long: Double = self.strLong
            let longString: String = String(format: "%.14f", long)
            print(long)
            print(longString)
//            self.getAddress { result in
//                print(result)
//            }
//            self.getAddressFromLatLon(pdblLatitude: latString, withLongitude: longString)
        }
    }
    
    func updateFCM(){
    
        let fcm = FCMUpdate(fcm: UserDefaults.standard.string(forKey: "fcmtoken") ?? "no fcmtoken")
        NetworkRepository.shared.updateFcmRepository.updateFCM(with: fcm) { (response, error) in
            
            if let error = error{
                Toast.show(message: "Something went wrong!")
                print("Something went wrong. \(error.localizedDescription)")
                
            } else  {
                
                print(response as Any)
                
                
            }
        }
    }
    
    func getUserInf(){
        let token = UserDefaults.standard.value(forKey: "loginToken") as? String ?? ""
        let profile = ProfileRequest(token: token)
        
        NetworkRepository.shared.userProfileRepository.getUserProfile(with: profile) { (profileResponse, error) in
            
            if let error = error{
                Toast.show(message: "Something went wrong!")
                print("Something went wrong in SIGNUP THE USER. \(error)")
                
            } else if let userProf = profileResponse {
                
                print(userProf.firstName)
                print(userProf.email)
                
                let uid = userProf.id! as Int
                print(uid)
                let uidString = String(uid)
                print(uidString)
                UserDefaults.standard.set(uidString, forKey: "uid")
                print(UserDefaults.standard.string(forKey: "uid"))
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(userProf) {
                    let defaults = UserDefaults.standard
                    defaults.set(encoded, forKey: "UserProfileInfo")
                    defaults.synchronize()
                }
                
            } else{
                Toast.show(message: "Something went wrong!")
                print("Something went wrong in SIGNUP THE USER.")
            }
        }
    }
    
    
    // MARK: Action Functions
    
    @objc func onClickLocalDelivery(_ sender:UITapGestureRecognizer){
        let bookingVC = UIStoryboard.AppStoryboard.Booking.instance.instantiateViewController(withIdentifier: UIViewController.Identifiers.Booking.BookingViewController) as! BookingViewController
        bookingVC.strLat = self.strLat
        bookingVC.strLong = self.strLong
        self.navigationController?.pushViewController(bookingVC, animated: true)
    }
    
    @objc func onClickInternationalDelivery(_ sender:UITapGestureRecognizer){
        let bookingVC = UIStoryboard.AppStoryboard.Booking.instance.instantiateViewController(withIdentifier: UIViewController.Identifiers.Booking.InternationalBookingViewController) as! InternationalBookingViewController
        self.navigationController?.pushViewController(bookingVC, animated: true)
        
    }
    
    
    
    // MARK: App Flow Functions
    
}
