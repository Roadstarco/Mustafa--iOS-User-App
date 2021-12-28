//
//  InternationalBookingBidViewController.swift
//  RoadStar Customer
//
//  Created by Apple on 04/12/2021.
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

class InternationalBookingBidViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var txtParcelName: UITextField!
    @IBOutlet weak var itemSize: DropDown!
    @IBOutlet weak var itemType: DropDown!
    @IBOutlet weak var txtAmount: PrimaryTextView!
    @IBOutlet weak var txtParcelDetails: PrimaryTextView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    
    var mediaSelection = 0
    var attachment1Path = ""
    var attachment2Path = ""
    var attachment3Path = ""
    var trip_id = 0
    override func setupUI() {
        
        itemSize.optionArray = ["Small", "Medium", "Large", "Extra Large"]
        itemSize.rowBackgroundColor = Theme.dropDownColor
        
        itemType.optionArray = ["Item to be bought", "Personal Item"]
        itemType.rowBackgroundColor = Theme.dropDownColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                tap.cancelsTouchesInView = false
                view.addGestureRecognizer(tap)
        
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    @IBAction func addImageBtnTapped(_ sender: UIButton) {
        
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
    
    @objc override func dismissKeyboard() {
            view.endEditing(true)
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
        
        if txtParcelName.text == nil {
            Toast.showError(message: "Please Enter Parcel Name")
            return false
        } else if txtParcelName.text!.isEmpty {
            Toast.showError(message: "Please Enter Parcel Name")
            return false
        }else if itemSize.text == nil {
            Toast.showError(message: "Please Specify Item Size")
            return false
        } else if itemSize.text!.isEmpty {
            Toast.showError(message: "Please Specify Item Size")
            return false
        }else if itemType.text == nil {
            Toast.showError(message: "Please Specify Item Type")
            return false
        } else if itemType.text!.isEmpty {
            Toast.showError(message: "Please Specify Item Type")
            return false
        }else if txtAmount.text == nil {
            Toast.showError(message: "Please Enter Amount")
            return false
        } else if txtAmount.text!.isEmpty {
            Toast.showError(message: "Please Enter Amount")
            return false
        }
        
        return true
        
    }
    @IBAction func btnNextTapped(_ sender: Any) {
        if isValidate(){
        let vc = UIStoryboard.AppStoryboard.Booking.instance.instantiateViewController(withIdentifier: UIViewController.Identifiers.Booking.InternationalReceiverViewController) as! InternationalReceiverViewController
        vc.itemName = self.txtParcelName.text!
        vc.image1 = self.attachment1Path
        vc.image2 = self.attachment2Path
        vc.image3 = self.attachment3Path
        vc.itemSize = self.itemSize.text!
        vc.itemType = self.itemType.text!
        vc.Amount = self.txtAmount.text!
        vc.parcelDetails = self.txtParcelDetails.text ?? ""
        vc.trip_id = self.trip_id
        vc.fromManualRequest = false
        let navigationCont = UINavigationController(rootViewController: vc)
        navigationCont.navigationController?.setNavigationBarHidden(true, animated: false)
        navigationCont.modalPresentationStyle = .overCurrentContext
        self.present(navigationCont, animated: true, completion: nil)
        }
    }
    
}
