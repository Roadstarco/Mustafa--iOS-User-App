//
//  BookingPaymentOptionsViewController.swift
//  RoadStar Customer
//
//  Created by Roamer on 21/07/2020.
//  Copyright © 2020 Osama Azmat Khan. All rights reserved.
//

import UIKit
import GooglePlacesSearchController
import Stripe

class BookingPaymentOptionsViewController: BaseViewController {

    var fareEstimate : FareEstimate? = nil
    var serviceInfo : ServiceModel? = nil
    var pickUpLocation : PlaceDetails? = nil
    var destinationLocation : PlaceDetails? = nil
    
    @IBOutlet weak var cardInfoView: UIView!
    @IBOutlet weak var cardIcon: UIImageView!
    @IBOutlet weak var cardNumberLbl: UILabel!
    
    @IBOutlet weak var paymentTYpeIcon: UIImageView!
    @IBOutlet weak var paymentTypeLbl: UILabel!
    
    @IBOutlet weak var addCardInfoView: UIView!
    var usersCardList = [PaymentCardModel]()
    
    var paymentType = 1 //cash = 1, card =  2
    
    var pkgCategory = ""
    var pkgType = ""
    var weight = ""
    var weightUnit = ""
    var pkgHeight = ""
    var pkgWidth = ""
    var instrutions = ""
    var pkdDetails = ""
    
    var receiverName = ""
    var receiverNumber = ""
    
    var attachment1Path = ""
    var attachment2Path = ""
    var attachment3Path = ""
    
    override func setupUI() {
        getCardAdded()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                tap.cancelsTouchesInView = false
                view.addGestureRecognizer(tap)
    }
    
    override func setupTheme() {
        super.setupTheme()
        
    }
    
@objc override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func getCardInfoIfAny()
    {
        self.addCardInfoView.isHidden = false
        self.cardInfoView.isHidden = true
        
        if self.paymentType == 1
        {
            self.addCardInfoView.isHidden = true
            self.cardInfoView.isHidden = true
            
            self.paymentTypeLbl.text = "Payment: Cash"
            self.paymentTYpeIcon.image = #imageLiteral(resourceName: "cash")
        }
        else
        {
            self.paymentTypeLbl.text = "Payment: Card"
            self.paymentTYpeIcon.image = #imageLiteral(resourceName: "credit_card")
            
            self.addCardInfoView.isHidden = false
            
            if usersCardList.count > 0
            {
                let cardInfo = usersCardList[0]
                
                self.cardNumberLbl.text = "**** **** **** \(cardInfo.lastFour)"
                
                let cardType = cardInfo.brand
                
                if cardType == STPCardBrandUtilities.stringFrom(.visa)
                {
                    self.cardIcon.image = #imageLiteral(resourceName: "visa")
                }
                else if cardType == STPCardBrandUtilities.stringFrom(.amex)
                {
                    self.cardIcon.image = #imageLiteral(resourceName: "american_express")
                }
                else if cardType == STPCardBrandUtilities.stringFrom(.JCB)
                {
                    self.cardIcon.image = #imageLiteral(resourceName: "jcb")
                }
                else if cardType == STPCardBrandUtilities.stringFrom(.discover)
                {
                    self.cardIcon.image = #imageLiteral(resourceName: "discover")
                }
                else if cardType == STPCardBrandUtilities.stringFrom(.mastercard)
                {
                    self.cardIcon.image = #imageLiteral(resourceName: "mastercard")
                }
                else
                {
                    self.cardIcon.image = #imageLiteral(resourceName: "credit_card")
                }
                
                self.addCardInfoView.isHidden = true
                self.cardInfoView.isHidden = false
            }
        }
        
        
        
    }
    
    @IBAction func onBackClicked(_ id:UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onDeleteCardClicked(_ id:UIButton)
    {
        let alertvc = UIAlertController(title: "Confirm Card Deletion", message: "Are you sure you want to delete card", preferredStyle: .actionSheet)
        
        alertvc.addAction(UIAlertAction(title: "Yes Delete", style: .default, handler: { action in
            //
            self.deleteCardApi()
        }))
        
        alertvc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            //
            
        }))
        
        self.present(alertvc, animated: true, completion: nil)
    }
    
    @IBAction func btnNextTapped(_ sender: Any) {
        
        if self.paymentType == 2 && self.usersCardList.count == 0
        {
            Toast.show(message: "Please add card")
            return
        }
        else
        {
            let requestInfo = SendRequestModel(s_latitude: "\(self.pickUpLocation!.coordinate!.latitude)",
                                               s_longitude: "\(self.pickUpLocation!.coordinate!.longitude)",
                                               d_latitude: "\(self.destinationLocation!.coordinate!.latitude)",
                                               d_longitude: "\(self.destinationLocation!.coordinate!.longitude)",
                                               s_address: "\(self.pickUpLocation!.formattedAddress)",
                                               d_address: "\(self.destinationLocation!.formattedAddress)",
                                               service_type: "\(self.serviceInfo!.id)",
                                               distance: "\(self.fareEstimate!.distance)",
                                               use_wallet: "0",
                                               payment_mode: self.paymentType == 1 ? "CASH" : "CARD",
                                               card_id: self.paymentType == 2 ? self.usersCardList[0].cardID : "",
                                               category: pkgCategory,
                                               product_type: pkgType,
                                               product_weight: weight,
                                               weight_unit: weightUnit,
                                               product_width: pkgWidth,
                                               product_height: pkgHeight,
                                               receiver_name: receiverName,
                                               receiver_phone: receiverNumber,
                                               instruction: instrutions,
                                               product_distribution: pkdDetails)
            
            
            var attachments = [String]()
            if !attachment1Path.isEmpty
            {
                attachments.append(attachment1Path)
            }
            
            if !attachment2Path.isEmpty
            {
                attachments.append(attachment2Path)
            }
            
            if !attachment2Path.isEmpty
            {
                attachments.append(attachment2Path)
            }
            
            NetworkRepository.shared.sendRequestRepository.sendRequestForTrip(request: requestInfo, attachemnts: attachments) { (apiResponse, error) in
                
                if let error = error{
                    
                    if apiResponse != nil
                    {
                        Toast.show(message: "error: \(apiResponse!.message)")
                        print("Something went wrong in SIGNUP THE USER. \(error)")
                    }
                    else
                    {
                        Toast.show(message: "error: \(error.localizedDescription)")
                        print("Something went wrong in SIGNUP THE USER. \(error.localizedDescription)")
                    }
                    
//                    self.delegate?.didDismissedWithResponse()
                    
//                    let distanceVC = UIStoryboard.AppStoryboard.Booking.instance.instantiateViewController(withIdentifier: UIViewController.Identifiers.Booking.RequestStatusViewController) as! RequestStatusViewController
//                    distanceVC.serviceInfo = self.serviceInfo
//                    self.navigationController?.pushViewController(distanceVC, animated: true)
                    
                } else if apiResponse != nil{
                    
                    Toast.show(message: apiResponse?.message ?? "\(apiResponse.debugDescription)")
                    
//                    self.delegate?.didDismissedWithResponse()
                    
                    NotificationCenter.default.post(name: NSNotification.Name("request_submitted"), object: nil, userInfo: nil)
                    
                } else{
                    Toast.show(message: "Something went wrong!")
                    print("Something went wrong in SIGNUP THE USER.")
                }
            }
        }
        
//        let ratingVC = UIStoryboard.AppStoryboard.Booking.instance.instantiateViewController(withIdentifier: UIViewController.Identifiers.Booking.RatingViewController) as! RatingViewController
//
//        self.navigationController?.pushViewController(ratingVC, animated: true)
    
    }
    
    func deleteCardApi()
    {
        if usersCardList.count > 0
        {
//            let cardInfo = usersCardList[0]

            let params = PaymentCardModel2(card_id: usersCardList[0].cardID, _method: "DELETE")
            NetworkRepository.shared.cardRepository.deleteCardList(card: params, block: { (response, error) in

                if let error = error{
                    Toast.show(message: "Something went wrong!")
                    print("Something went wrong: . \(error.localizedDescription)")

                } else if response {

                    self.getCardAdded()

                } else{
                    Toast.show(message: "Something went wrong!")
                    print("Something went wrong")
                }
            })
        }
    }
    
    @IBAction func onClickPaymentTypeBtn(_ sender: Any) {
    
        let alertvc = UIAlertController(title: "Select Payment Method", message: "", preferredStyle: .actionSheet)
        
        alertvc.addAction(UIAlertAction(title: "Card", style: .default, handler: { action in
            //
            self.paymentType = 2
            self.getCardInfoIfAny()
        }))
        
        alertvc.addAction(UIAlertAction(title: "Cash", style: .default, handler: { action in
            //
            self.paymentType = 1
            self.getCardInfoIfAny()
        }))
        
        alertvc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            //
            
        }))
        
        self.present(alertvc, animated: true, completion: nil)
    }
    
    @IBAction func onClickAddCardInfo(_ sender:Any)
    {
        // 2
        let addCardViewController = CardEntryViewController(nibName: "CardEntryViewController", bundle: nil)
        addCardViewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        self.present(navigationController, animated: true, completion: nil)
    }

}


extension BookingPaymentOptionsViewController : CardEntryProtocol {
    func didCompletedCardEntry(card: STPPaymentMethodCardParams) {
        //
        print("didCreateToken")
        let value = STPAPIClient(publishableKey: "pk_test_51HeDaeHV7Xodq4BS6RlcHrqGwXVVQZNgTcZPUn3T3lQdxr7jbGFQ72lx8ZcpAhiLZCmnghkuTTrI9u0dLdhnPgo600rrYtZzSS")
            //
        let cardParams: STPCardParams = STPCardParams()
        cardParams.number = card.number
        cardParams.expMonth = card.expMonth as! UInt
        cardParams.expYear = card.expYear as! UInt
        cardParams.cvc = card.cvc
        value.createToken(withCard: cardParams, completion: { (token, error) -> Void in
                if error == nil {}
                else {}
            
            let cardDetail = PaymentCard(stripe_token: token!.tokenId, last_four: card.last4!, brand: STPCardBrandUtilities.stringFrom(STPCardValidator.brand(forNumber: card.number!)) ?? "unknown")
            
            NetworkRepository.shared.cardRepository.addCardToServer(with: cardDetail) { (apiResponse, error) in
                
                if let error = error{
                    Toast.show(message: "Something went wrong!")
                    print("Something went wrong in SIGNUP THE USER. \(error.localizedDescription)")
                    
                } else if apiResponse != nil{
                    
                    Toast.show(message: "Card added")
                    
                } else{
                    Toast.show(message: "Something went wrong!")
                    print("Something went wrong in SIGNUP THE USER.")
                }
            }
            })
        
        
    }
    
    
    func getCardAdded()
    {
        self.getCardInfoIfAny()
        
        NetworkRepository.shared.cardRepository.getCardList() { (response, error) in
            
            if let error = error{
                Toast.show(message: "Something went wrong!")
                print("Something went wrong in SIGNUP THE USER. \(error.localizedDescription)")
                
            } else if let datalist = response {
                
//                print(servicesRes)
                self.usersCardList.removeAll()
                self.usersCardList.append(contentsOf: datalist)
                
                DispatchQueue.main.async {
                    //
                    self.getCardInfoIfAny()
                }
                
                
            } else{
                Toast.show(message: "Something went wrong!")
                print("Something went wrong in SIGNUP THE USER.")
            }
        }
    }
    
}
