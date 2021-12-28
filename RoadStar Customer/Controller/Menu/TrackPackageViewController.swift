//
//  TrackPackageViewController.swift
//  RoadStar Customer
//
//  Created by Roamer on 21/07/2020.
//  Copyright © 2020 Osama Azmat Khan. All rights reserved.
//

import UIKit
import GoogleMaps
import Cosmos
import SDWebImage
enum CircleAnimation{
    case In
    case Out
}

class TrackPackageViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    

    let GoogleMapsAPIServerKey = "AIzaSyCO--TQ_iF9WC2_Gv7KgjasEmnEoxwbF-E"
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var localView: UIView!
    @IBOutlet weak var internationalView: UIView!
    @IBOutlet weak var cancelRideButton: UIButton!
    @IBOutlet weak var shareRideButton: UIButton!
    
    @IBOutlet weak var rideDetailViewBottom: NSLayoutConstraint!
    @IBOutlet weak var rideStatusLbl: UILabel!
    
    @IBOutlet weak var driverNameLbl: UILabel!
    @IBOutlet weak var vehicleTypeLbl: UILabel!
    @IBOutlet weak var vehicleNoLbl: UILabel!
    
    @IBOutlet weak var riderDetailView: UIView!
    @IBOutlet weak var riderRatingView: CosmosView!
    @IBOutlet weak var theTableView: UITableView!
    
    @IBOutlet weak var btnChat: PrimaryButton!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var riderImage: UIImageView!
    
    var trips: [UserTripsModel]?
    var circleAnimation = CircleAnimation.Out
    var arrRadius : [GMSCircle] = [GMSCircle]()
    var radius : Int = 0
    var timer : Timer = Timer()
    var statusTimer : Timer = Timer()
    
    var userLocation : CLLocation? = nil
    
    var requestStatusV : StatusResponse? = nil
    
    var bRatingShown = false
    
    
    override func setupUI() {
        self.rightView.isHidden = true
//        riderDetailView.addSubview(btnChat)
        self.riderDetailView.isHidden = true
        getUserTrips()
        registerXib()
        
        self.theTableView.isHidden = true
        
        self.localView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(localPackageTapped))
        localView.addGestureRecognizer(gestureRecognizer)
        
        self.internationalView.isUserInteractionEnabled = true
        let gestureRecognizer1 = UITapGestureRecognizer(target: self, action:  #selector(internationPackageTapped))
        internationalView.addGestureRecognizer(gestureRecognizer1)
        
        // MARK: Define the source latitude and longitude
        if LocationManager.shared.currentLocation != nil
        {
            self.getDisplayMap()
        }
        
        cancelButton.isHidden = true
        
        LocationManager.shared.requestUserPermissionsAndStartUpdatingLocation()
        NotificationCenter.default.addObserver(self, selector: #selector(locationUpdateNotification), name: Notification.Name("UserLocationNotification"), object: nil)
        
        self.statusTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.getRequestInfo), userInfo: nil, repeats: true)
        
        self.getRequestInfo()
    }
    
    @objc func localPackageTapped(){
        self.rightView.isHidden = true
        self.leftView.isHidden = false
        self.mapView.isHidden = false
        self.riderDetailView.isHidden = false
        self.theTableView.isHidden = true
    }
    
    @objc func internationPackageTapped(){
        self.rightView.isHidden = false
        self.leftView.isHidden = true
        self.mapView.isHidden = true
        self.cancelButton.isHidden = true
        self.riderDetailView.isHidden = true
        self.theTableView.isHidden = false
        theTableView.dataSource = self
        theTableView.delegate = self
        theTableView.reloadData()
    }
    
    func getUserTrips()
    {
        
        
        NetworkRepository.shared.getUserTripsRepository.getUserTrips() { (response, error) in
            
            if let error = error{
                Toast.show(message: "Something went wrong!")
                print("Something went wrong in SIGNUP THE USER. \(error)")
                
            } else if let response = response {
                print(response)
                self.trips = response
                self.theTableView.reloadData()
                
            } else{
                Toast.show(message: "Something went wrong!")
                print("Something went wrong in SIGNUP THE USER.")
            }
        }
    }
    
    @objc func locationUpdateNotification(notification: NSNotification) {
        if (notification.userInfo?["location"] as? CLLocation) != nil {
            //Store user location
            
            self.getDisplayMap()
        }
    }
    
    func getDisplayMap()
    {
        self.userLocation = LocationManager.shared.currentLocation!
        let userLat = self.userLocation!.coordinate.latitude
        let userLong  = self.userLocation!.coordinate.longitude
        
        DispatchQueue.main.async {
            //
            let camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: userLat, longitude: userLong), zoom: 11)
            self.mapView.animate(to: camera)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
               self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.timerFired), userInfo: nil, repeats: true)
           }
           
           let circleCenter = CLLocationCoordinate2D(latitude: userLat, longitude: userLong)
           let circ = GMSCircle(position: circleCenter, radius: 5000)//radius in meters
           
           circ.fillColor = UIColor(red: 0.35, green: 0, blue: 0, alpha: 0.05)
           circ.strokeColor = UIColor.red
           circ.strokeWidth = 1
           
           let update = GMSCameraUpdate.fit(circ.bounds())
            self.mapView.animate(with: update)
            
        }
    }
    
    override func setupTheme() {
        super.setupTheme()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //
        super.viewDidDisappear(animated)
        
        self.statusTimer.invalidate()
        self.timer.invalidate()
        self.mapView.clear()
    }

    func registerXib() {
        
        let nib = UINib.init(nibName: AvailableTripsCell.nibName, bundle: nil)
        theTableView.register(nib, forCellReuseIdentifier: AvailableTripsCell.cellReuseIdentifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AvailableTripsCell.cellReuseIdentifier, for: indexPath) as! AvailableTripsCell
        cell.lblDate.text = self.trips?[indexPath.row].created_at
        cell.lblAcNo.text = "Provider Id: \(self.trips?[indexPath.row].provider_id ?? 0)"
        cell.lblfrom.text = self.trips?[indexPath.row].tripfrom
        cell.lblTo.text = self.trips?[indexPath.row].tripto
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if self.trips![indexPath.row].trip_status == "PENDING"{
        let storyBoard = UIStoryboard(name: "Menu", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "AllAvailableBidsViewController") as! AllAvailableBidsViewController
        vc.trip_id = self.trips?[indexPath.row].id ?? 0
        vc.modalPresentationStyle = .fullScreen
        self.present(vc,animated: true,completion: nil)
        }else{
            
            let storyBoard = UIStoryboard(name: "Menu", bundle: nil)
            let vc = storyBoard.instantiateViewController(identifier: "PackageDetailViewController") as! PackageDetailViewController
            vc.trips = self.trips![indexPath.row]
            vc.receiverName = self.trips![indexPath.row].receiver_name ?? ""
            vc.packageName = self.trips![indexPath.row].item ?? ""
            vc.packageType = self.trips![indexPath.row].item_type ?? ""
            vc.packageSize = self.trips![indexPath.row].item_size ?? ""
            vc.providerId = self.trips![indexPath.row].provider_id ?? 0
            vc.pickupFrom = self.trips![indexPath.row].tripfrom ?? ""
            vc.dropoffTo = self.trips![indexPath.row].tripto ?? ""
            vc.tripStatus = self.trips![indexPath.row].trip_status ?? ""
            vc.modalPresentationStyle = .fullScreen
            self.present(vc,animated: true,completion: nil)
            
            
        }
        
        
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        
        let homeNav = UIStoryboard.AppStoryboard.Main.instance.instantiateViewController(withIdentifier: UINavigationController.Identifiers.HomeNav) as! UINavigationController
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.replaceRootViewControllerWith(homeNav, animated: true, completion: nil)
    }
    @IBAction func btnCancelBooking(_ sender: Any) {
        //api/user/cancel/request
        //Params: request_id, cancel_reason
        statusTimer.invalidate()
        self.addCancelPopUpView()
    }
    
    func addCancelPopUpView() {
        let storyBoard = UIStoryboard(name: "Menu", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "CancelPopUpVC") as! CancelPopUpVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        self.present(vc,animated: true,completion: nil)
    }
    
    @objc func timerFired(){
            
        let circleCenter = self.userLocation!.coordinate//change to your center point
        let circ = GMSCircle(position: circleCenter, radius: CLLocationDistance(radius))//radius in meters
        
        circ.fillColor = UIColor(red: 0.35, green: 0, blue: 0, alpha: 0.05)
        circ.strokeColor = UIColor.red
        circ.strokeWidth = 1
        
        if circleAnimation == .Out{
            radius += 50
            
            if radius >= 5000{
                radius = 5000
                circleAnimation = .In
            }
        }else{
            radius -= 50

            if radius <= 0{
                radius = 0
                circleAnimation = .Out
            }
        }
        
        arrRadius.append(circ)
        circ.map = mapView
        
        if arrRadius.count > 0{
            for i in 0..<arrRadius.count - 1{
                let circle = arrRadius[i]
                circle.map = nil
                arrRadius.removeAll(where: { $0 == circle})
            }
        }
    }
    
    @objc func getRequestInfo()
    {
        print("getRequestInfo")
        NetworkRepository.shared.sendRequestRepository.getRequestStatus { (response, error) in

            if let error = error{
                Toast.show(message: "Something went wrong!")
                print("Something went wrong in Searching THE Driver. \(error)")

            } else if let statusObj = response, let dataValue = statusObj.data {

                if dataValue.count > 0
                {
                    self.requestStatusV = dataValue[0]
                    DispatchQueue.main.async {
                        //
                        print("statusV.status: \(self.requestStatusV?.status ?? "")")
                        
                        self.cancelButton.isHidden = true
                        
                        if self.requestStatusV != nil
                        {
                            self.displayViewForStatus()
                        }
                    }
                    
                }
                else
                {
                    DispatchQueue.main.async {
                        self.cancelButton.isHidden = true
                        Toast.show(message: "No request found")
                        self.viewDidDisappear(true)
                    }
                    
                }
                
            } else{
                Toast.show(message: "Something went wrong!")
                print("Something went wrong in SIGNUP THE USER.")
            }
        }
    }
    
    func displayViewForStatus()
    {
        if self.requestStatusV!.status?.lowercased() == "searching"
        {
            self.cancelButton.isHidden = false
        }
        else if self.requestStatusV!.status!.lowercased() == "started"
        {
            self.rideStatusLbl.text = "RoadStar driver has accepted your request"
            self.mapView.clear()
            self.cancelButton.isHidden = true
            self.shareRideButton.isHidden = true
            self.cancelRideButton.isHidden = false
            
//            if self.rideDetailViewBottom.constant != 0
//            {
                UIView.animate(withDuration: 0.5) {
                    //
                    self.riderDetailView.isHidden = false
//                    self.rideDetailViewBottom.constant = 0
//                    self.view.layoutSubviews()
                }
//            }
            
            if let provider = self.requestStatusV!.provider
            {
                self.driverNameLbl.text = provider.firstName + " " + provider.lastName
                self.riderRatingView.rating = Double(provider.rating) ?? 0.0
                self.riderImage.sd_setImage(with: URL(string: provider.avatar ?? ""))
            }
            
            if let serviceType = self.requestStatusV?.serviceType
            {
                self.vehicleTypeLbl.text = serviceType.providerName
            }
            
            if let service = self.requestStatusV?.providerService
            {
                self.vehicleNoLbl.text = service.serviceNumber
            }
            
            self.timer.invalidate()
            
            self.fetchRoute(from: CLLocationCoordinate2D(latitude: self.requestStatusV!.provider!.latitude, longitude: self.requestStatusV!.provider!.longitude), to: userLocation!.coordinate)
            
        }
        else if self.requestStatusV!.status!.lowercased() == "arrived"
        {
            self.rideStatusLbl.text = "RoadStar driver is at your location"
            self.mapView.clear()
            self.cancelButton.isHidden = true
            self.shareRideButton.isHidden = true
            self.cancelRideButton.isHidden = false
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: self.requestStatusV!.provider!.latitude, longitude: self.requestStatusV!.provider!.longitude)
            marker.title = self.requestStatusV?.serviceType?.name ?? "RoadStar Driver"
            marker.snippet = "Arrived"
            marker.map = mapView
            
            if let provider = self.requestStatusV!.provider
            {
                self.driverNameLbl.text = provider.firstName + " " + provider.lastName
                self.riderRatingView.rating = Double(provider.rating) ?? 0.0
                self.riderImage.sd_setImage(with: URL(string: provider.avatar ?? ""))

            }
            
            if let serviceType = self.requestStatusV?.serviceType
            {
                self.vehicleTypeLbl.text = serviceType.providerName
            }
            
            if let service = self.requestStatusV?.providerService
            {
                self.vehicleNoLbl.text = service.serviceNumber
            }
            
            self.timer.invalidate()
            
//            if self.rideDetailViewBottom.constant != 0
//            {
                UIView.animate(withDuration: 0.5) {
                    //
                    self.riderDetailView.isHidden = false

//                    self.rideDetailViewBottom.constant = 0
//                    self.view.layoutSubviews()
                }
//            }
        }
        else if self.requestStatusV!.status!.lowercased() == "pickedup"
        {
            self.rideStatusLbl.text = "Your ride has started"
            self.mapView.clear()
            self.cancelButton.isHidden = true
            self.shareRideButton.isHidden = false
            self.cancelRideButton.isHidden = true
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: self.requestStatusV!.provider!.latitude, longitude: self.requestStatusV!.provider!.longitude)
            marker.title = self.requestStatusV?.serviceType?.name ?? "RoadStar Driver"
            marker.snippet = "Your position"
            marker.map = mapView
            
            let marker2 = GMSMarker()
            marker2.position = CLLocationCoordinate2D(latitude: self.requestStatusV!.d_latitude, longitude: self.requestStatusV!.d_longitude)
            marker2.title = self.requestStatusV?.serviceType?.name ?? "RoadStar Driver"
            marker2.snippet = "Your position"
            marker2.map = mapView
            
            if let provider = self.requestStatusV!.provider
            {
                self.driverNameLbl.text = provider.firstName + " " + provider.lastName
                self.riderRatingView.rating = Double(provider.rating) ?? 0.0
                self.riderImage.sd_setImage(with: URL(string: provider.avatar ?? ""))

            }
            
            if let serviceType = self.requestStatusV?.serviceType
            {
                self.vehicleTypeLbl.text = serviceType.providerName
            }
            
            if let service = self.requestStatusV?.providerService
            {
                self.vehicleNoLbl.text = service.serviceNumber
            }
            
            self.timer.invalidate()
            
//            if self.rideDetailViewBottom.constant != 0
//            {
                UIView.animate(withDuration: 0.5) {
                    //
                    self.riderDetailView.isHidden = false
//                    self.rideDetailViewBottom.constant = 0
//                    self.view.layoutSubviews()
                }
//            }
            
            self.fetchRoute(from: CLLocationCoordinate2D(latitude: self.requestStatusV!.provider!.latitude, longitude: self.requestStatusV!.provider!.longitude), to: CLLocationCoordinate2D(latitude: self.requestStatusV!.d_latitude, longitude: self.requestStatusV!.d_longitude))
        }
        else if self.requestStatusV!.status!.lowercased() == "dropped"
        {
            self.rideStatusLbl.text = "You have arrived"
            self.mapView.clear()
            self.cancelButton.isHidden = true
            self.shareRideButton.isHidden = false
            self.cancelRideButton.isHidden = true
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: self.requestStatusV!.provider!.latitude, longitude: self.requestStatusV!.provider!.longitude)
            marker.title = self.requestStatusV?.serviceType?.name ?? "RoadStar Driver"
            marker.snippet = "Your position"
            marker.map = mapView
            
            let marker2 = GMSMarker()
            marker2.position = CLLocationCoordinate2D(latitude: self.requestStatusV!.d_latitude, longitude: self.requestStatusV!.d_longitude)
            marker2.title = self.requestStatusV?.serviceType?.name ?? "RoadStar Driver"
            marker2.snippet = "Your position"
            marker2.map = mapView
            
            if let provider = self.requestStatusV!.provider
            {
                self.driverNameLbl.text = provider.firstName + " " + provider.lastName
                self.riderRatingView.rating = Double(provider.rating) ?? 0.0
                self.riderImage.sd_setImage(with: URL(string: provider.avatar ?? ""))

            }
            
            if let serviceType = self.requestStatusV?.serviceType
            {
                self.vehicleTypeLbl.text = serviceType.providerName
            }
            
            if let service = self.requestStatusV?.providerService
            {
                self.vehicleNoLbl.text = service.serviceNumber
            }
            
            self.timer.invalidate()
            
//            if self.rideDetailViewBottom.constant != 0
//            {
//                UIView.animate(withDuration: 0.5) {
                    //
                    self.riderDetailView.isHidden = false

//                    self.rideDetailViewBottom.constant = 0
//                    self.view.layoutSubviews()
//                }
//            }
            
//            if self.rideDetailViewBottom.constant == 0
//            {
//                UIView.animate(withDuration: 0.5) {
//                    //
//                    self.rideDetailViewBottom.constant = -400
//                    self.view.layoutSubviews()
//                }
//            }
            
            self.timer.invalidate()
            
            
        }
        else if self.requestStatusV!.status?.lowercased() == "completed"
        {
            self.rideStatusLbl.text = ""
            self.mapView.clear()
            self.cancelButton.isHidden = true
            self.shareRideButton.isHidden = true
            self.cancelRideButton.isHidden = true
            
//            if self.rideDetailViewBottom.constant == 0
//            {
//                UIView.animate(withDuration: 0.5) {
                    //
                    self.riderDetailView.isHidden = true

//                    self.rideDetailViewBottom.constant = -400
//                    self.view.layoutSubviews()
//                }
//            }
            
            self.timer.invalidate()
            
            if !self.bRatingShown
            {
                self.bRatingShown = true
                let distanceVC = UIStoryboard.AppStoryboard.Booking.instance.instantiateViewController(withIdentifier: UIViewController.Identifiers.Booking.RatingViewController) as! RatingViewController
                distanceVC.tripId = self.requestStatusV!.id
                distanceVC.delegate = self
                
                let navigationCont = UINavigationController(rootViewController: distanceVC)
                navigationCont.navigationController?.setNavigationBarHidden(true, animated: false)
                navigationCont.modalPresentationStyle = .overCurrentContext
                self.present(navigationCont, animated: true, completion: nil)
            }
        }
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
    
    func cancelBooking(with text:String?) {
        
        if self.requestStatusV == nil
        {
            Toast.show(message: "No Active request found")
            return
        }
        
        let request = CancelBookingModel(request_id: "\(String(describing: self.requestStatusV!.id))", cancel_reason: text)
        
        NetworkRepository.shared.sendRequestRepository.cancelRequest(request: request) { (response, error) in
            if let error = error{
                Toast.show(message: "Something went wrong!")
                print("Something went wrong in Searching THE Driver. \(error.localizedDescription)")
                
            } else {
                print("response")
                
                //
                DispatchQueue.main.async {
                    //
                    self.cancelButton.isHidden = true
                    self.requestStatusV = nil
                    Toast.show(message: "Request Cancelled")
                }
            }
        }
    }
    
    @IBAction func callRiderClicked(_ sender: Any) {
        guard let number = URL(string: "tel://" + (requestStatusV?.provider!.mobile)! ) else { return }
        UIApplication.shared.open(number)
    }
    
    @IBAction func btnChatTapped(_ sender: Any) {
        
        let vc = SupportViewController.instantiateMenu()
        vc.user_id = self.requestStatusV?.provider?.id ?? 0
        vc.first_name = self.requestStatusV?.provider?.firstName ?? ""
        vc.email = self.requestStatusV?.provider?.email ?? ""
        vc.picture = self.requestStatusV?.provider?.avatar ?? ""
        let navigationCont = UINavigationController(rootViewController: vc)
        navigationCont.navigationController?.setNavigationBarHidden(true, animated: false)
        navigationCont.modalPresentationStyle = .overCurrentContext
        self.present(navigationCont, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func shareTripClicked(_ sender: Any) {
        
    }
}


extension GMSCircle {
    func bounds () -> GMSCoordinateBounds {
        func locationMinMax(_ positive : Bool) -> CLLocationCoordinate2D {
            let sign: Double = positive ? 1 : -1
            let dx = sign * self.radius  / 6378000 * (180 / .pi)
            let lat = position.latitude + dx
            let lon = position.longitude + dx / cos(position.latitude * .pi / 180)
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
        
        return GMSCoordinateBounds(coordinate: locationMinMax(true),
                                   coordinate: locationMinMax(false))
    }
}

extension TrackPackageViewController : CancelPopUpVCDelegate {
    func didCancelTapped(text: String?) {
        self.cancelBooking(with: text)
    }
}

extension TrackPackageViewController : RateTripPopoverProtocol {
    func didDismissedWithResponse() {
        //
        DispatchQueue.main.async {
            //
            self.dismiss(animated: true) {
                //
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
