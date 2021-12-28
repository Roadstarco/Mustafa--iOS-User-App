//
//  PackageDetailsViewController.swift
//  RoadStar Customer
//
//  Created by Roamer on 21/07/2020.
//  Copyright © 2020 Osama Azmat Khan. All rights reserved.
//

import UIKit
import iOSDropDown
import GooglePlacesSearchController
import SDWebImage
import AVFoundation
import Photos

class PackageDetailsViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var txtWeight: UITextField!
    @IBOutlet weak var dropDownProductType: DropDown!
    @IBOutlet weak var dropDownCategory: DropDown!
    @IBOutlet weak var weightUnit: DropDown!
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var attach1imgView: UIImageView!
    @IBOutlet weak var attach2imgView: UIImageView!
    @IBOutlet weak var attach3imgView: UIImageView!
    
    @IBOutlet weak var txtWidth: UITextField!
    @IBOutlet weak var txtHeight: UITextField!
    
    @IBOutlet weak var txtInstructions: UITextView!
    @IBOutlet weak var txtDetails: UITextView!
    
    var fareEstimate : FareEstimate? = nil
    var serviceInfo : ServiceModel? = nil
    var pickUpLocation : PlaceDetails? = nil
    var destinationLocation : PlaceDetails? = nil
    
    var attachment1Path = ""
    var attachment2Path = ""
    var attachment3Path = ""
    
    var mediaSelection = 0 //1, 2 and 3 for attachment
    
    override func setupUI() {
        
        if let url = URL(string: serviceInfo!.image)
        {
            imgView.sd_setImage(with: url) { image, error, cashe, urlv in
                //
            }
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                tap.cancelsTouchesInView = false
                view.addGestureRecognizer(tap)


        
        dropDownProductType.optionArray = ["Cargo", "Parcel"]
        dropDownProductType.rowBackgroundColor = Theme.dropDownColor
        
        dropDownCategory.optionArray = ["Wood", "Steel", "Rock", "Fruits", "Flowers"]
        dropDownCategory.rowBackgroundColor = Theme.dropDownColor
        
        weightUnit.optionArray = ["Kgs", "Lbs"]
        weightUnit.rowBackgroundColor = Theme.dropDownColor
    }
    
    override func setupTheme() {
        super.setupTheme()
    }


    @objc override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func onBackClicked(_ id:UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAttachmentTapped(_ sender: UIButton) {
        
        mediaSelection = sender.tag
        
        //ask for image from camera or library
        let alertVC = UIAlertController(title: "", message: "Select Photo", preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            //
            self.proceedToGetImageFromCamera()
        }))
        
        alertVC.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            //
            self.proceedToGetImageFromLibrary()
        }))
        
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            //
            
        }))
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    //***************************************************************************//
    
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
    
    //***************************************************************************//
    
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
    
    //***************************************************************************//
    
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
                                self.attach1imgView.image = UIImage(contentsOfFile: localPath)
                                self.attachment1Path = localPath
                            }
                            else if self.mediaSelection == 2
                            {
                                self.attach2imgView.image = UIImage(contentsOfFile: localPath)
                                self.attachment2Path = localPath
                            }
                            else if self.mediaSelection == 3
                            {
                                self.attach3imgView.image = UIImage(contentsOfFile: localPath)
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
    
    @IBAction func btnNextTapped(_ sender: Any) {
        let weight: Int? = Int(txtWeight.text ?? "")
        if (dropDownProductType.selectedIndex == nil)
        {
            Toast.show(message: "Please pick product type")
            return
        }
        else if (dropDownCategory.selectedIndex == nil)
        {
            Toast.show(message: "Please pick category type")
            return
        }
        else if (txtWeight.text == nil)
        {
            Toast.show(message: "Please mention weight value")
            return
        }
        else if (weightUnit.selectedIndex == nil)
        {
            Toast.show(message: "Please pick weight unit type")
            return
        }else if (txtWidth.text == nil)
        {
            Toast.show(message: "Please mention width value")
            return
        }else if (txtHeight.text == nil)
        {
            Toast.show(message: "Please mention height value")
            return
        }else if self.serviceInfo?.name == "MiniTruck" && weight! > 800{
            Toast.show(message: "Weight cannot be more than 800")
            return
        }else if self.serviceInfo?.name == "Medium Truck" && weight! > 1900{
            Toast.show(message: "Weight cannot be more than 1900")
            return
        }else if self.serviceInfo?.name == "Large Truck" && weight! > 40000{
            Toast.show(message: "Weight cannot be more than 40000")
            return
        }else if let width: Int = Int(txtWidth.text ?? "" ) ,width > 10 {
            Toast.show(message: "Width cannot be more than 10 ft")
            return
        }else if let height: Int = Int(txtHeight.text ?? "" ) , height > 14 {
            Toast.show(message: "Height cannot be more than 14 ft")
            return
        }
        let recieverDetailVC = UIStoryboard.AppStoryboard.Booking.instance.instantiateViewController(withIdentifier: UIViewController.Identifiers.Booking.RecieverDetailsViewController) as! RecieverDetailsViewController
        
        recieverDetailVC.fareEstimate = self.fareEstimate
        recieverDetailVC.serviceInfo = self.serviceInfo
        recieverDetailVC.pickUpLocation = self.pickUpLocation
        recieverDetailVC.destinationLocation = self.destinationLocation
        recieverDetailVC.pkgCategory = dropDownCategory.optionArray[dropDownCategory.selectedIndex!]
        recieverDetailVC.pkgType = dropDownProductType.optionArray[dropDownProductType.selectedIndex!]
        recieverDetailVC.weight = txtWeight.text!
        recieverDetailVC.weightUnit = weightUnit.optionArray[weightUnit.selectedIndex!]
        recieverDetailVC.pkgHeight = txtHeight.text!
        recieverDetailVC.pkgWidth = txtWidth.text!
        recieverDetailVC.instrutions = txtInstructions.text
        recieverDetailVC.pkdDetails = txtDetails.text
        recieverDetailVC.attachment1Path = self.attachment1Path
        recieverDetailVC.attachment2Path = self.attachment2Path
        recieverDetailVC.attachment3Path = self.attachment3Path
        
        self.navigationController?.pushViewController(recieverDetailVC, animated: true)
    
    }
    
}
