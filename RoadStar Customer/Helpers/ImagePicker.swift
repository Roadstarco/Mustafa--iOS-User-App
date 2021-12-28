//
//  ImagePicker.swift
//  OffSide
//
//  Created by Faizan Ali  on 2021/2/10.
//

import Foundation
import UIKit

public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?)
    func didSelect(videoUrl: NSURL?)
    func imageUrl(imageUrl: URL)
}
open class ImagePicker: NSObject {
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate, allowMovie: Bool = false) {
        self.pickerController = UIImagePickerController()
        super.init()
        self.presentationController = presentationController
        self.delegate = delegate
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        if allowMovie {
            self.pickerController.mediaTypes = ["public.image", "public.movie"]
        } else {
            self.pickerController.mediaTypes = ["public.image"]
        }
        
    }
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
    public func present(from sourceView: UIView, showCamera:Bool = true, showLibrary:Bool = true) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if showCamera {
            if let action = self.action(for: .camera, title: "Take photo") {
                alertController.addAction(action)
            }
        }
        if showLibrary{
            if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
                alertController.addAction(action)
            }
            if let action = self.action(for: .photoLibrary, title: "Photo library") {
                alertController.addAction(action)
            }
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        self.presentationController?.present(alertController, animated: true)
    }
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?, videoUrl: NSURL?) {
        controller.dismiss(animated: true, completion: nil)
        if videoUrl != nil {
            self.delegate?.didSelect(videoUrl: videoUrl)
            return
        }
        self.delegate?.didSelect(image: image)
        
    }
}
extension ImagePicker: UIImagePickerControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil, videoUrl: nil)
    }
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.editedImage] as? UIImage {
            if info[.imageURL] != nil{
            delegate?.imageUrl(imageUrl: info[.imageURL] as! URL)
            }else{
                let imgName = "\(UUID().uuidString).jpeg"
                        let documentDirectory = NSTemporaryDirectory()
                        let localPath = documentDirectory.appending(imgName)
                        
                        let data = image.jpegData(compressionQuality: 0.3)! as NSData
                        data.write(toFile: localPath, atomically: true)
                delegate?.imageUrl(imageUrl: URL.init(fileURLWithPath: localPath))
//                delegate?.imageUrl = URL.init(fileURLWithPath: localPath)
            }
           return self.pickerController(picker, didSelect: image, videoUrl: nil)
        }
        
        if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL {
            return self.pickerController(picker, didSelect: nil, videoUrl: videoURL)
        }
        
        self.pickerController(picker, didSelect: nil, videoUrl: nil)
    }
}
extension ImagePicker: UINavigationControllerDelegate {
}

//1: CheckForJobs in 3 sec every....
//2: If req comes then show count and if driver click then open and show requests to driver.
//3: If driver click on request and click accept then call api "AcceptTrip" {{base_url}}trip/958

//4: CLICK on arrived then send status "ARRIVED"
//5: Click on droppedOf then send status: "PICKEDUP"
//6: 



//api/provider/trip/{id}
//api/provider/trip/{id}/calculate
//latitude, longitude ,distance

//_method = PATCH

//ARRIVED
//PICKEDUP
//DROPPED
//COMPLETED
//RATE

//_method = PATCH
//status
//pickedUpImage
//droppedOfImage
//ARRIVED
//PICKEDUP


//Base url for attachment needed.
//Local request accept Api "update-trip" needed the status codes for it e.g "ACCEPTED"

//Local Request...
//Api: CheckForJobs.
//{
//    "account_status": "approved",
//    "service_status": "active",
//    "requests": [
//        {
//            "id": 1427,
//            "request_id": 958,
//            "provider_id": 352,
//            "status": 0,
//            "time_left_to_respond": 119709,
//            "request": {
//                "id": 958,
//                "booking_id": "MRDSTAR171195",
//                "user_id": 571,
//                "provider_id": 0,
//                "current_provider_id": 0,
//                "service_type_id": 12,
//                "status": "SEARCHING",
//                "cancelled_by": "NONE",
//                "cancel_reason": null,
//                "payment_mode": "CARD",
//                "paid": 0,
//                "is_track": "YES",
//                "distance": 1,
//                "travel_time": null,
//                "s_address": "Unnamed Road, G-11 Markaz G 11 Markaz G-11, Islamabad, Islamabad Capital Territory, Pakistan",
//                "s_latitude": 33.66787494,
//                "s_longitude": 72.99732786,
//                "d_address": "G-10, Islamabad, Islamabad Capital Territory, Pakistan",
//                "d_latitude": 33.6768883,
//                "track_distance": 0,
//                "track_latitude": 0,
//                "track_longitude": 0,
//                "d_longitude": 73.0148908,
//                "altitude": null,
//                "bearing": null,
//                "assigned_at": "2021-06-09 08:05:31",
//                "schedule_at": null,
//                "started_at": null,
//                "finished_at": null,
//                "user_rated": 0,
//                "provider_rated": 0,
//                "use_wallet": 0,
//                "surge": 0,
//                "route_key": "ownlEcip|LvDiCK]{@oBcC_GkAoC{@kB]c@QOi@U_AMk@?i@N_Al@kEbDiBeEOe@Ic@GaA?}B?cFIgDMaAKe@s@qBUo@Yq@EAMIGO@QBG_AeCg@eAC?E?GEGI@W?C_BwDyE_L}CmHgAoCgDoH",
//                "deleted_at": null,
//                "created_at": "2021-06-09 08:05:31",
//                "updated_at": "2021-06-09 08:05:31",
//                "category": "Steel",
//                "product_type": "Parcel",
//                "product_weight": "6868",
//                "product_width": "jcjc",
//                "product_height": "hx",
//                "weight_unit": "Gm",
//                "attachment1": null,
//                "attachment2": null,
//                "attachment3": null,
//                "pickedup_image": "NULL",
//                "droppedof_image": "NULL",
//                "instruction": "Jvj",
//                "product_distribution": "Uviv",
//                "receiver_name": "jcjv",
//                "receiver_phone": "3868",
//                "user": {
//                    "id": 571,
//                    "first_name": "Shakeel",
//                    "last_name": "Ahmed",
//                    "payment_mode": "CARD",
//                    "email": "shakeelgujjar.qau@gmail.com",
//                    "gender": "MALE",
//                    "mobile": "03036781757",
//                    "picture": "https://myroadstar.org/public/uploads/user/profile/1614231588.jpeg",
//                    "points": 0,
//                    "device_token": null,
//                    "device_id": "c734cd65df89c6d8",
//                    "device_type": "android",
//                    "login_by": "manual",
//                    "social_unique_id": null,
//                    "latitude": null,
//                    "longitude": null,
//                    "stripe_cust_id": "cus_IxL9B7W46JZeIR",
//                    "wallet_balance": 0,
//                    "rating": "4.38",
//                    "otp": 500508,
//                    "updated_at": "2021-06-09 08:05:31",
//                    "referral_code": null,
//                    "is_referral_used": 0,
//                    "country_name": "Pakistan",
//                    "address": "testr"
//                },
//                "payment": null
//            }
//        }
//    ],
//    "user_trips": []
//}
