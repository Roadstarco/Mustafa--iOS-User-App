//
//  InternationalBookingViewController.swift
//  RoadStar Customer
//
//  Created by Apple on 02/12/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//

import Foundation
import UIKit
import iOSDropDown
import GoogleMaps
import CoreLocation
import GooglePlacesSearchController
import SDWebImage
import AVFoundation
import Photos

class InternationalBookingViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    @IBOutlet weak var itemNameView: UIView!
    @IBOutlet weak var itemViewTextField: TextField!
    @IBOutlet weak var deliveryFromView: UIView!
    @IBOutlet weak var lblDeliveryFrom: UILabel!
    @IBOutlet weak var deliveryToView: UIView!
    @IBOutlet weak var lblDeliveryTo: UILabel!
    @IBOutlet weak var arrivalDateView: UIView!
    @IBOutlet weak var lblArrivalDate: UILabel!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var btnImg1: UIButton!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var btnImg2: UIButton!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var btnImg3: UIButton!
    @IBOutlet weak var itenSizeView: UIView!
    @IBOutlet weak var lblItemSize: DropDown!
    @IBOutlet weak var itemaTypeView: UIView!
    @IBOutlet weak var lblItemType: DropDown!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var amounTextField: TextField!
    @IBOutlet weak var parcelDetailsView: UIView!
    @IBOutlet weak var textViewParcelDetails: PrimaryTextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentSwitch: UISegmentedControl!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnNext: PrimaryButton!
    
    var availableRequests: [AvailableTripsResponse]?
    var mediaSelection = 0
    var attachment1Path = ""
    var attachment2Path = ""
    var attachment3Path = ""
    public static var dropDownColor: UIColor = UIColor.rgba(243, 238, 241, 1.0)
    var deliveryFrom = false
    let GoogleMapsAPIServerKey = "AIzaSyCO--TQ_iF9WC2_Gv7KgjasEmnEoxwbF-E"
    lazy var placesSearchController: GooglePlacesSearchController = {
        let controller = GooglePlacesSearchController(delegate: self,
                                                      apiKey: GoogleMapsAPIServerKey,
                                                      placeType: .address
                                                      
            // Optional: coordinate: CLLocationCoordinate2D(latitude: 55.751244, longitude: 37.618423),
            // Optional: radius: 10,
            // Optional: strictBounds: true,
            // Optional: searchBarPlaceholder: "Start typing..."
        )
        lblDeliveryFrom.isUserInteractionEnabled = false
        lblDeliveryTo.isUserInteractionEnabled = false
        //Optional: controller.searchBar.isTranslucent = false
        //Optional: controller.searchBar.barStyle = .black
        //Optional: controller.searchBar.tintColor = .white
        //Optional: controller.searchBar.barTintColor = .black
        return controller
    }()
    
    
    override func setupUI() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                tap.cancelsTouchesInView = false
                view.addGestureRecognizer(tap)
        
        if segmentSwitch.selectedSegmentIndex == 0 {
            tableView.isHidden = true
            scrollView.isHidden = false
            btnNext.isHidden = false
        } else {
            tableView.isHidden = false
            scrollView.isHidden = true
            btnNext.isHidden = true
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
        }
        self.getAvailableTrips()
        
        self.registerXib()
        
        lblItemSize.optionArray = ["Small", "Medium", "Large", "Extra Large"]
        lblItemSize.rowBackgroundColor = Theme.dropDownColor
        
        lblItemType.optionArray = ["Item to be bought", "Personal Item"]
        lblItemType.rowBackgroundColor = Theme.dropDownColor
        
//        self.itemNameView.layer.borderColor = UIColor.red.cgColor
//        self.itemNameView.layer.borderWidth = 1
//        self.deliveryFromView.layer.borderColor = UIColor.red.cgColor
//        self.deliveryFromView.layer.borderWidth = 1
//        self.deliveryToView.layer.borderColor = UIColor.red.cgColor
//        self.deliveryToView.layer.borderWidth = 1
//        self.arrivalDateView.layer.borderColor = UIColor.red.cgColor
//        self.arrivalDateView.layer.borderWidth = 1
//        self.itenSizeView.layer.borderColor = UIColor.red.cgColor
//        self.itenSizeView.layer.borderWidth = 1
//        self.itemaTypeView.layer.borderColor = UIColor.red.cgColor
//        self.itemaTypeView.layer.borderWidth = 1
//        self.amountView.layer.borderColor = UIColor.red.cgColor
//        self.amountView.layer.borderWidth = 1
//        self.parcelDetailsView.layer.borderColor = UIColor.red.cgColor
//        self.parcelDetailsView.layer.borderWidth = 1
        
        lblDeliveryFrom.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(deliveryFromTapped))
        lblDeliveryFrom.addGestureRecognizer(gestureRecognizer)
        
        lblDeliveryTo.isUserInteractionEnabled = true
        let gestureRecognizer1 = UITapGestureRecognizer(target: self, action:  #selector(deliveryToTapped))
        lblDeliveryTo.addGestureRecognizer(gestureRecognizer1)
        
        lblArrivalDate.isUserInteractionEnabled = true
        let gestureRecognizer2 = UITapGestureRecognizer(target: self, action:  #selector(arrivalDateTapped))
        lblArrivalDate.addGestureRecognizer(gestureRecognizer2)
        
    }
    
    func registerXib() {
        
        let nib = UINib.init(nibName: AvailableTripsCell.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: AvailableTripsCell.cellReuseIdentifier)
    }

    
    @objc override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func deliveryFromTapped(){
        self.deliveryFrom = true
        self.present(placesSearchController, animated: true, completion: nil)
        
    }
    
    @objc func deliveryToTapped(){
        self.deliveryFrom = false
        self.present(placesSearchController, animated: true, completion: nil)
        
    }
    
    @objc func arrivalDateTapped(){
        
        RPicker.selectDate(title: "Select Date & Time", cancelText: "Cancel", datePickerMode: .date, minDate: Date(), maxDate: Date().dateByAddingYears(10000), style: .Inline, didSelectDate: {[weak self] (selectedDate) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM-dd-YYYY"
            let stringDate = dateFormatter.string(from: selectedDate)
            print(stringDate)
            self?.lblArrivalDate.text = stringDate
            
        })
        
    }
    
    func getAvailableTrips()
    {
        
        
        NetworkRepository.shared.getAvailableTripsRepository.getAvailableTrips() { (response, error) in
            
            if let error = error{
                Toast.show(message: "Something went wrong!")
                print("Something went wrong in SIGNUP THE USER. \(error)")
                
            } else if let response = response {
                print(response)
                self.availableRequests = response
                
            } else{
                Toast.show(message: "Something went wrong!")
                print("Something went wrong in SIGNUP THE USER.")
            }
        }
    }
    
    
    @IBAction func btnBackTapped(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    @IBAction func segmentTapped(_ sender: Any) {
        
        if segmentSwitch.selectedSegmentIndex == 0 {
            tableView.isHidden = true
            scrollView.isHidden = false
            btnNext.isHidden = false
        } else {
            tableView.isHidden = false
            scrollView.isHidden = true
            btnNext.isHidden = true
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
        }
    }
    
    
    @IBAction func btnAttachmentTapped(_ sender: UIButton) {
        mediaSelection = sender.tag
        
        //ask for image from camera or library
        let alertVC = UIAlertController(title: "", message: "Select Photo", preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            
            self.proceedToGetImageFromCamera()
        }))
        
        alertVC.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            //
            self.proceedToGetImageFromLibrary()
        }))
        
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
            
        }))
        
        self.present(alertVC, animated: true, completion: nil)
    
    
    
    }
    
    func proceedToGetImageFromCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            //check permission status of camera to this app
            let cameraPermissionStatus = AVCaptureDevice.authorizationStatus(for: .video)
            if cameraPermissionStatus ==  .authorized {
                //already authorized
                self.displayCameraToPickImage()
            }
            else if cameraPermissionStatus ==  .denied || cameraPermissionStatus ==  .restricted {
                //denied
                let alertVC = UIAlertController(title:nil, message: "Camera permission seems not allowed", preferredStyle: .alert)
                
                alertVC.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: { (action) in
                    //
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                }))
                
                alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                    //
                    
                }))
                
                self.present(alertVC, animated: true, completion: nil)
            }
            else
            {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    if granted
                    {
                        //access allowed
                        DispatchQueue.main.async {
                            //
                            self.proceedToGetImageFromCamera()
                        }
                    }
                    else
                    {
                        //access denied
                        
                    }
                })
            }
        }
        else
        {
            let alertVC = UIAlertController(title: nil, message: "Camera not supported", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
                //
                self.proceedToGetImageFromLibrary()
            }))
            
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                //
                
            }))
            
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func proceedToGetImageFromLibrary()
    {
        //check permission status of photo library to this app
        let photoLibraryAccessStatus = PHPhotoLibrary.authorizationStatus()
        if photoLibraryAccessStatus == .authorized
        {
            //handle authorized status
            self.displayLibraryToPickImage()
        }
        else if photoLibraryAccessStatus == .denied || photoLibraryAccessStatus == .restricted
        {
            //handle denied status
            let alertVC = UIAlertController(title: nil, message: "Please allow permission for photo library", preferredStyle: .alert)
            
            alertVC.addAction(UIAlertAction(title: "Go to settings", style: .default, handler: { (action) in
                //
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }))
            
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                //
                
            }))
            
            self.present(alertVC, animated: true, completion: nil)
        }
        else
        {
            PHPhotoLibrary.requestAuthorization() { (status) -> Void in
                if status == .authorized
                {
                    DispatchQueue.main.async {
                        //
                        self.proceedToGetImageFromLibrary()
                    }
                }
            }
        }
    }
    
    func displayCameraToPickImage()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func displayLibraryToPickImage()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //***************************************************************************//
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //
        DispatchQueue.main.async {
            //
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //***************************************************************************//
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        //
        DispatchQueue.main.async {
            //
            self.dismiss(animated: true, completion: nil)
            
            if let pickedImage = info[.originalImage] as? UIImage {
                
                let imageToSave = App.correctOrrientationOfImage(pickedImage)
                
                self.saveImageLocallyAlongWithThumb(image: imageToSave) { (errorMessage, localPath) in
                    //
                    if localPath.isEmpty
                    {
                        print("error occured: \(errorMessage)")
                    }
                    else
                    {
                        print("image saved at: \(localPath)")
                        
                        DispatchQueue.main.async {
                            //
                            if self.mediaSelection == 1
                            {
                                self.img1.image = UIImage(contentsOfFile: localPath)
                                self.attachment1Path = localPath
                            }
                            else if self.mediaSelection == 2
                            {
                                self.img2.image = UIImage(contentsOfFile: localPath)
                                self.attachment2Path = localPath
                            }
                            else if self.mediaSelection == 3
                            {
                                self.img3.image = UIImage(contentsOfFile: localPath)
                                self.attachment3Path = localPath
                            }
                        }
                    }
                }
            }
            else
            {
                print("originalImage not found for camera image")
            }
        }
    }
    
    //***************************************************************************//
    
    func saveImageLocallyAlongWithThumb(image:UIImage, completionHandler:@escaping ( _ errorMessage : String ,_ localPath : String)-> Void)
    {
        let documentsDirectory = App.getMediaTemproryFolderPath()
        
        // choose a name for your image
        let uuid = UUID().uuidString
        let fileName = "\(uuid).jpg"
        
        // create the destination file url to save your image
        let filePath = (documentsDirectory as NSString).appendingPathComponent(fileName)
        
        // get your UIImage jpeg data representation and check if the destination file url already exists
        
        // resize image to 1200 x 1200
        let originalImage = App.resizeImage(image: image, targetSize: CGSize(width: 1200, height: 1200))
        
        
        if let data = originalImage.jpegData(compressionQuality:  0.7) {
            do {
                // writes the image data to disk
                try data.write(to: URL(fileURLWithPath: filePath))
                print("file saved")
                
            } catch
            {
                print("error saving file:", error)
                completionHandler(error.localizedDescription, "")
                return
            }
        }
        
        completionHandler("", filePath)
    }
    
    func isValidate() -> Bool {
        
        if itemViewTextField.text == nil {
            Toast.showError(message: "Please Enter Item Name")
            return false
        } else if itemViewTextField.text!.isEmpty {
            Toast.showError(message: "Please Enter Item Name")
            return false
        } else if lblDeliveryFrom.text == nil {
            Toast.showError(message: "Please Enter Pickup Location")
            return false
        } else if lblDeliveryFrom.text!.isEmpty {
            Toast.showError(message: "Please Enter Pickup Location")
            return false
        }else if lblDeliveryTo.text == nil {
            Toast.showError(message: "Please Enter Destination")
            return false
        } else if lblDeliveryTo.text!.isEmpty {
            Toast.showError(message: "Please Enter Destination")
            return false
        }else if lblArrivalDate.text == nil {
            Toast.showError(message: "Please Enter Arrival Date")
            return false
        } else if lblArrivalDate.text!.isEmpty {
            Toast.showError(message: "Please Enter Arrival Date")
            return false
        }else if lblItemSize.text == nil {
            Toast.showError(message: "Please Specify Item Size")
            return false
        } else if lblItemSize.text!.isEmpty {
            Toast.showError(message: "Please Specify Item Size")
            return false
        }else if lblItemType.text == nil {
            Toast.showError(message: "Please Specify Item Type")
            return false
        } else if lblItemType.text!.isEmpty {
            Toast.showError(message: "Please Specify Item Type")
            return false
        }else if amounTextField.text == nil {
            Toast.showError(message: "Please Enter Amount")
            return false
        } else if amounTextField.text!.isEmpty {
            Toast.showError(message: "Please Enter Amount")
            return false
        }
        
        return true
        
    }
    
    @IBAction func btnNextTapped(_ sender: Any) {
        if isValidate(){
        let distanceVC = UIStoryboard.AppStoryboard.Booking.instance.instantiateViewController(withIdentifier: UIViewController.Identifiers.Booking.InternationalReceiverViewController) as! InternationalReceiverViewController
            distanceVC.itemName = self.itemViewTextField.text!
            distanceVC.deliveryFrom = self.lblDeliveryFrom.text!
            distanceVC.deliveryTo = self.lblDeliveryTo.text!
            distanceVC.arrivalDate = self.lblArrivalDate.text!
            distanceVC.image1 = self.attachment1Path
            distanceVC.image2 = self.attachment2Path
            distanceVC.image3 = self.attachment3Path
            distanceVC.itemSize = self.lblItemSize.text!
            distanceVC.itemType = self.lblItemType.text!
            distanceVC.Amount = self.amounTextField.text!
            distanceVC.parcelDetails = self.textViewParcelDetails.text ?? ""
            distanceVC.fromManualRequest = true
        let navigationCont = UINavigationController(rootViewController: distanceVC)
        navigationCont.navigationController?.setNavigationBarHidden(true, animated: false)
        navigationCont.modalPresentationStyle = .overCurrentContext
        self.present(navigationCont, animated: true, completion: nil)
        
        }
    }
}

extension InternationalBookingViewController: UITableViewDelegate, UITableViewDataSource{
    
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableRequests?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AvailableTripsCell.cellReuseIdentifier, for: indexPath) as! AvailableTripsCell

            cell.setUp(request: (self.availableRequests?[indexPath.row])!)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.AppStoryboard.Booking.instance.instantiateViewController(withIdentifier: UIViewController.Identifiers.Booking.AvailableTripDetailViewController) as! AvailableTripDetailViewController
        vc.request = self.availableRequests![indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}

extension InternationalBookingViewController: GooglePlacesAutocompleteViewControllerDelegate{
func viewController(didAutocompleteWith place: PlaceDetails) {
    if self.deliveryFrom == true{
        lblDeliveryFrom.text = place.name
        
    }else if self.deliveryFrom == false{
        lblDeliveryTo.text = place.name
    }
    self.dismiss(animated: true)
    lblDeliveryFrom.isUserInteractionEnabled = true
    lblDeliveryTo.isUserInteractionEnabled = true
}
    
}

extension Date {
    func dateString(_ format: String = "MMM-dd-YYYY") -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: self)
  }
  func dateByAddingYears(_ dYears: Int) -> Date {
    var dateComponents = DateComponents()
    dateComponents.year = dYears
    return Calendar.current.date(byAdding: dateComponents, to: self)!
  }
}
