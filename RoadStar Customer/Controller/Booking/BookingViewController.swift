//
//  BookingViewController.swift
//  RoadStar Customer
//
//  Created by Roamer on 16/07/2020.
//  Copyright © 2020 Osama Azmat Khan. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import GooglePlacesSearchController
import SDWebImage
import Contacts

class BookingViewController: BaseViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pickupAddressLbl: UILabel!
    @IBOutlet weak var destinationAddressLbl: UILabel!
    @IBOutlet weak var btnPickUp: UIButton!
    
    @IBOutlet weak var btnDropOff: UIButton!
    @IBOutlet weak var addressHeight: NSLayoutConstraint!
    
    var pickUpLocation : PlaceDetails? = nil
    var destinationLocation : PlaceDetails? = nil
    
    var bDestinationAddress = false
    
    var availableServiceList = [ServiceModel]()
    var strLat = 0.0
    var strLong = 0.0
    let GoogleMapsAPIServerKey = "AIzaSyCO--TQ_iF9WC2_Gv7KgjasEmnEoxwbF-E"
    let locationManager = CLLocationManager()
   
    lazy var placesSearchController: GooglePlacesSearchController = {
        let controller = GooglePlacesSearchController(delegate: self,
                                                      apiKey: GoogleMapsAPIServerKey,
                                                      placeType: .all
//                                                      coordinate: CLLocationCoordinate2D(latitude: strLat /*55.751244*/, longitude: strLong /*37.618423*/),
//                                                      radius: 1000,
//                                                      strictBounds: true
            // Optional: searchBarPlaceholder: "Start typing..."
        )
        
        //Optional: controller.searchBar.isTranslucent = false
        //Optional: controller.searchBar.barStyle = .black
        //Optional: controller.searchBar.tintColor = .white
        //Optional: controller.searchBar.barTintColor = .black
        return controller
    }()
    
    override func setupUI() {
//        // Ask for Authorisation from the User.
//        self.locationManager.requestAlwaysAuthorization()
//
//        // For use in foreground
//        self.locationManager.requestWhenInUseAuthorization()
//
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locationManager.startUpdatingLocation()
//        }
        
        self.collectionView.register(UINib(nibName: ModeCollectionViewCell.nibName, bundle: Bundle.main), forCellWithReuseIdentifier: ModeCollectionViewCell.cellReuseIdentifier)
        print(strLat)
        print(strLong)
        let sourceLat =  strLat //37.0902 //33.5651 //
        let sourceLng = strLong //95.7129 //73.0169 //
        let camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: sourceLat, longitude: sourceLng), zoom: 100)
        self.mapView.animate(to: camera)
        self.mapView.settings.compassButton = true
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        LocationManager.shared.requestUserPermissionsAndStartUpdatingLocation()
        NotificationCenter.default.addObserver(self, selector: #selector(locationUpdateNotification), name: Notification.Name("UserLocationNotification"), object: nil)
        
        getServicesInfo()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didDismissedWithResponse), name: Notification.Name("request_submitted"), object: nil)
    }
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//
//        let sourceLat = locValue.latitude //33.5651
//        let sourceLng = locValue.longitude //73.0169
//        let camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: sourceLat, longitude: sourceLng), zoom: 11)
//        self.mapView.animate(to: camera)
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//    }
    
    @objc func locationUpdateNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo?["location"] as? CLLocation {
            //Store user location
            let userLat = userInfo.coordinate.latitude
            let userLong  = userInfo.coordinate.longitude
            
            DispatchQueue.main.async {
                //
                let camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: userLat, longitude: userLong), zoom: 200)
                self.mapView.animate(to: camera)
            }
           
        }
    }
    
    func getServicesInfo()
    {
        
        
        NetworkRepository.shared.servicesRepository.getServicesList() { (response, error) in
            
            if let error = error{
                Toast.show(message: "Something went wrong!")
                print("Something went wrong in SIGNUP THE USER. \(error.localizedDescription)")
                
            } else if let servicesList = response {
                
                print(servicesList)
                
                self.availableServiceList.append(contentsOf: servicesList)
                print(self.availableServiceList.count)
                DispatchQueue.main.async {
                    //
                    self.collectionView.reloadData()
                }
                
                
            } else{
                Toast.show(message: "Something went wrong!")
                print("Something went wrong in SIGNUP THE USER.")
            }
        }
    }
    
    @IBAction func onBackClicked(_ id:UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onDestinationAddressClicked(_ id:UIButton)
    {
        bDestinationAddress = true
        btnPickUp.isUserInteractionEnabled = false
        btnDropOff.isUserInteractionEnabled = false
        self.present(placesSearchController, animated: true, completion: nil)
    }
    
    @IBAction func onStartingAddressClicked(_ id:UIButton)
    {
        bDestinationAddress = false
        btnPickUp.isUserInteractionEnabled = false
        btnDropOff.isUserInteractionEnabled = false
        self.present(placesSearchController, animated: true, completion: nil)
    }
    
    func fetchRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        
        let session = URLSession.shared
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving&key=\(GoogleMapsAPIServerKey)")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let jsonResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] else {
                print("error in JSONSerialization")
                return
            }
            
            
            guard let routes = jsonResult["routes"] as? [Any] else {
                 return
             }
             
             guard let route = routes[0] as? [String: Any] else {
                 return
             }

             guard let overview_polyline = route["overview_polyline"] as? [String: Any] else {
                 return
             }
             
             guard let polyLineString = overview_polyline["points"] as? String else {
                 return
             }
             
            DispatchQueue.main.async {
                //
                //Call this method to draw path on map. on main thread always
                self.drawPath(from: polyLineString)
            }
         })
         task.resume()
     }
    
    func drawPath(from polyStr: String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.map = mapView // Google MapView
    }
}

extension BookingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return availableServiceList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ModeCollectionViewCell.cellReuseIdentifier, for: indexPath) as? ModeCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let item = self.availableServiceList[indexPath.row]
        cell.mainLabel.text = item.name
//        cell.mainImageView.image = UIImage(named: UIImage.AppImages.Booking.DeliveryModes.Cycle)
        
        if let url = URL(string: item.image)
        {
            cell.mainImageView.sd_setImage(with: url) { image, error, cashe, urlv in
                //
            }
        }
        
//        if indexPath.item == 0 {
//
//        }
//        else if indexPath.item == 1 {
//            cell.mainLabel.text = "Scooter"
//            cell.mainImageView.image = UIImage(named: UIImage.AppImages.Booking.DeliveryModes.Scooter)
//        }
//        else {
//            cell.mainLabel.text = "Car"
//            cell.mainImageView.image = UIImage(named: UIImage.AppImages.Booking.DeliveryModes.Car)
//        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.pickUpLocation == nil
        {
            Toast.show(message: "Please pick source location")
        }
        else if self.destinationLocation == nil
        {
            Toast.show(message: "Please pick destination location")
        }
        else
        {
            let distanceVC = UIStoryboard.AppStoryboard.Booking.instance.instantiateViewController(withIdentifier: UIViewController.Identifiers.Booking.DistancePopOverViewController) as! DistancePopOverViewController
            distanceVC.delegate = self
            distanceVC.serviceInfo = self.availableServiceList[indexPath.item]
            distanceVC.pickUpLocation = pickUpLocation
            distanceVC.destinationLocation = destinationLocation
            
            let navigationCont = UINavigationController(rootViewController: distanceVC)
            navigationCont.navigationController?.setNavigationBarHidden(true, animated: false)
            navigationCont.modalPresentationStyle = .overCurrentContext
            self.present(navigationCont, animated: true, completion: nil)
        }
//        self.navigationController?.pushViewController(distanceVC, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width / 3) - 8, height: self.collectionView.frame.height - 16)
    }
}

extension BookingViewController : DistancePopoverProtocol
{
    @objc func didDismissedWithResponse() {
        //
        self.dismiss(animated: true) {
            //
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension BookingViewController: GooglePlacesAutocompleteViewControllerDelegate {
    func viewController(didAutocompleteWith place: PlaceDetails) {
        print(place.description)
        DispatchQueue.main.async {
            self.placesSearchController.isActive = false
            
            if self.bDestinationAddress
            {
                self.destinationLocation = place
                
                self.destinationAddressLbl.text = place.formattedAddress
            }
            else
            {
                self.pickUpLocation = place
                
                self.pickupAddressLbl.text = place.formattedAddress
            }
            self.dismiss(animated: true)
            self.populateMapAndAddressForLocation()
            self.btnPickUp.isUserInteractionEnabled = true
            self.btnDropOff.isUserInteractionEnabled = true
            
        }
    }
    
    func populateMapAndAddressForLocation()
    {
        self.mapView.clear()
        
        if self.pickUpLocation == nil
        {
            //clear all data
            self.pickupAddressLbl.text = "----"
//            self.mapView.clear()
        }
        else
        {
            let marker = GMSMarker()

            marker.position = CLLocationCoordinate2D(latitude: self.pickUpLocation!.coordinate!.latitude, longitude: self.pickUpLocation!.coordinate!.longitude)

//            marker.iconView = markerView
            marker.snippet = self.pickUpLocation!.formattedAddress
            marker.map = mapView
        }
        
        if self.destinationLocation == nil
        {
            //clear all data
            self.destinationAddressLbl.text = "----"
        }
        else
        {
            let marker = GMSMarker()

            marker.position = CLLocationCoordinate2D(latitude: self.destinationLocation!.coordinate!.latitude, longitude: self.destinationLocation!.coordinate!.longitude)

//            marker.iconView = markerView
            marker.snippet = self.destinationLocation!.formattedAddress
            marker.map = mapView
        }
        
        if self.pickUpLocation != nil && self.destinationLocation != nil
        {
            DispatchQueue.main.async {
                //
                self.fetchRoute(from: CLLocationCoordinate2D(latitude: self.pickUpLocation!.coordinate!.latitude, longitude: self.pickUpLocation!.coordinate!.longitude),
                                to: CLLocationCoordinate2D(latitude: self.destinationLocation!.coordinate!.latitude, longitude: self.destinationLocation!.coordinate!.longitude))
            }
        }
        
    }
    
    func viewController(didManualCompleteWith text: String) {
        print(text)
        DispatchQueue.main.async {
            //
            self.placesSearchController.isActive = false
            
            if self.bDestinationAddress
            {
                self.destinationLocation = nil
            }
            else
            {
                self.pickUpLocation = nil
            }
            
            self.populateMapAndAddressForLocation()
        }
    }
}
