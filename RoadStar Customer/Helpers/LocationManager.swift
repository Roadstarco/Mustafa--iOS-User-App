//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Mutahir on 06/03/2021.
//

import UIKit
import CoreLocation

protocol MyLocationDelegate: class {
    func newLocationArrived(location: CLLocation)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    
    /**************************************************/
    //MARK: Declarations.
    /**************************************************/
    
    // Swifty way of creating a singleton
    static let shared = LocationManager()
    var delegate : MyLocationDelegate?
    
    // set the manager object right when it gets initialized
    let manager: CLLocationManager = {
        
        $0.desiredAccuracy = kCLLocationAccuracyBest
        $0.requestWhenInUseAuthorization()
        $0.distanceFilter  = 0
        $0.startUpdatingLocation()
        $0.pausesLocationUpdatesAutomatically = false
        //$0.requestWhenInUseAuthorization()
        
        return $0
    }(CLLocationManager())
    
    var currentLocation: CLLocation? = nil
    var currentHeading: CLHeading!
    
    var currentLocInfo : ReversedGeoLocation!
    
    var authorizationChangeHandler : ((CLAuthorizationStatus)->Void)?
    var bLocationReceived : Bool = false
   
    override init() {
        super.init()
        // delegate MUST be set while initialization
        manager.delegate = self
    }
    
    func requestUserPermissionsAndStartUpdatingLocation()
    {
        self.manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    /**************************************************/
    // MARK: Control Mechanisms
    /**************************************************/
    
    func startUpdatingLocation() {
        manager.startUpdatingLocation()
    }
    
    /**************************************************/
    
    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }
    
    /**************************************************/
    
    func startUpdatingHeading() {
        manager.startUpdatingHeading()
    }
    
    /**************************************************/
    
    func stopUpdatingHeading() {
        manager.stopUpdatingHeading()
    }
    
    /**************************************************/
    // MARK: Location Updates
    /**************************************************/
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        // If location data can be determined
        if let location = locations.last//, currentLocation == nil
        {
            if !bLocationReceived {
                bLocationReceived = true
                currentLocation = location
                self.stopUpdatingLocation()
                let userInfo: NSDictionary = ["location": location]

                //Post notification
                NotificationCenter.default.post(name: NSNotification.Name("UserLocationNotification"), object: self, userInfo: userInfo as [NSObject : AnyObject])

                //            NotificationCenter.default.post(name: .didReceiveLocation, object: currentLocation)
                
            }
        }
    }
    
    /**************************************************/
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error)
    {
        print("Location Manager Error: \(error)")
    }
    
    /**************************************************/
    // TAK: Task 165 App permissions in dashboard
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationChangeHandler?(status)
    }
    
    /**************************************************/
    // MARK: Heading Updates
    /**************************************************/
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateHeading newHeading: CLHeading)
    {
        currentHeading = newHeading
    }
    
    /**************************************************/
    
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
    
    /**************************************************/
    
}

struct ReversedGeoLocation {
    let name: String            // eg. Apple Inc.
    let streetName: String      // eg. Infinite Loop
    let streetNumber: String    // eg. 1
    let city: String            // eg. Cupertino
    let state: String           // eg. CA
    let zipCode: String         // eg. 95014
    let country: String         // eg. United States
    let isoCountryCode: String  // eg. US
    
    var formattedAddress: String {
        return """
        \(name),
        \(streetNumber) \(streetName),
        \(city), \(state) \(zipCode)
        \(country)
        """
    }
    
    // Handle optionals as needed
    init(with placemark: CLPlacemark) {
        self.name           = placemark.name ?? ""
        self.streetName     = placemark.thoroughfare ?? ""
        self.streetNumber   = placemark.subThoroughfare ?? ""
        self.city           = placemark.locality ?? ""
        self.state          = placemark.administrativeArea ?? ""
        self.zipCode        = placemark.postalCode ?? ""
        self.country        = placemark.country ?? ""
        self.isoCountryCode = placemark.isoCountryCode ?? ""
    }
}


