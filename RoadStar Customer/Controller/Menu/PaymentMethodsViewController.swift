//
//  PaymentMethodsViewController.swift
//  RoadStar Customer
//
//  Created by Roamer on 21/07/2020.
//  Copyright © 2020 Osama Azmat Khan. All rig hts reserved.
//

import UIKit
import Braintree
import BraintreeDropIn
import Stripe
class PaymentMethodsViewController: BaseViewController {
    
    
    @IBOutlet weak var btnAddNewCard: UIButton!
    @IBOutlet weak var theTableView: UITableView!
    
    var cardsList:[PaymentCardModel] = []
    var delegate : CardEntryProtocol?
    
    override func setupUI() {
        getCardsList()
        
//        btnAddNewCard.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        btnAddNewCard.layer.cornerRadius = 50
        btnAddNewCard.dropShadow()
        btnAddNewCard.setImage(UIImage(named: "stp_icon_add"), for: .normal)
        
        theTableView.delegate = self
        theTableView.dataSource = self
    }
    
    override func setupTheme() {
        super.setupTheme()
    }
    @IBAction func btnBackTapped(_ sender: Any) {
        
        let homeNav = UIStoryboard.AppStoryboard.Main.instance.instantiateViewController(withIdentifier: UINavigationController.Identifiers.HomeNav) as! UINavigationController
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.replaceRootViewControllerWith(homeNav, animated: true, completion: nil)
    }
    
    @IBAction func btnAddCard(_ sender: Any) {
        let addCardViewController = CardEntryViewController(nibName: "CardEntryViewController", bundle: nil)
        addCardViewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        self.present(navigationController, animated: true, completion: nil)
//        showDropIn(clientTokenOrTokenizationKey: "sandbox_f252zhq7_hh4cpc39zq4rgjcg")
    }
//    func showDropIn(clientTokenOrTokenizationKey: String) {
//        let request =  BTDropInRequest()
//        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
//        { (controller, result, error) in
//            if (error != nil) {
//                print("ERROR")
//            } else if (result?.isCanceled == true) {
//                print("CANCELED")
//            } else if let result = result {
//                // Use the BTDropInResult properties to update your UI
//                // result.paymentMethodType
//                // result.paymentMethod
//                // result.paymentIcon
//                // result.paymentDescription
//
//                result.paymentMethod?.nonce
//                print(result.paymentMethodType)
//                print(result.paymentMethod?.nonce)
//            }
//            controller.dismiss(animated: true, completion: nil)
//        }
//        self.present(dropIn!, animated: true, completion: nil)
//    }
    
    func deleteCardApi(index: Int){
        
        if cardsList.count > 0{
            
            let params = PaymentCardModel2(card_id: cardsList[index].cardID, _method: "DELETE")
            NetworkRepository.shared.cardRepository.deleteCardList(card: params, block: { (response, error) in
                
                if let error = error{
                    Toast.show(message: "Something went wrong!")
                    print("Something went wrong: . \(error)")
                    
                } else if response {
                    print("Card deleted")
                    self.getCardsList()
                    
                } else{
                    Toast.show(message: "Something went wrong!")
                    print("Something went wrong")
                }
            })
        }
    }
    
    func getCardsList(){
        
        NetworkRepository.shared.cardRepository.getCardList() { (response, error) in
            
            if let error = error{
                Toast.show(message: "Something went wrong!")
                print("Something went wrong in SIGNUP THE USER. \(error.localizedDescription)")
                
            } else if let datalist = response {
                
                self.cardsList = datalist
                print(self.cardsList)
                print(self.cardsList.count)
                self.theTableView.reloadData()
                DispatchQueue.main.async {
                    
                    
                }
                
            } else{
                Toast.show(message: "Something went wrong!")
                print("Something went wrong in SIGNUP THE USER.")
            }
        }
    }

}
extension PaymentMethodsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CardsTableViewCell
        cell.lblCardNmbr.text = "xxxx-xxxx-xxxx-\(cardsList[indexPath.row].lastFour)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let alertVC = UIAlertController(title: "Delete card", message: "Delete the selected card", preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.deleteCardApi(index: indexPath.row)
            
        }))
        
        alertVC.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
            
        }))
        
        
        self.present(alertVC, animated: true, completion: nil)
    }
}
extension PaymentMethodsViewController : CardEntryProtocol {
    func didCompletedCardEntry(card: STPPaymentMethodCardParams) {
        print("didCreateToken")
        let value = STPAPIClient(publishableKey: "pk_test_51HeDaeHV7Xodq4BS6RlcHrqGwXVVQZNgTcZPUn3T3lQdxr7jbGFQ72lx8ZcpAhiLZCmnghkuTTrI9u0dLdhnPgo600rrYtZzSS")
        let cardParams: STPCardParams = STPCardParams()
        cardParams.number = card.number
        cardParams.expMonth = card.expMonth as! UInt
        cardParams.expYear = card.expYear as! UInt
        cardParams.cvc = card.cvc
        value.createToken(withCard: cardParams, completion: { (token, error) -> Void in
                if error == nil {
                    
                }
                else {
                    
                }
            
            let cardDetail = PaymentCard(stripe_token: token!.tokenId, last_four: card.last4!, brand: STPCardBrandUtilities.stringFrom(STPCardValidator.brand(forNumber: card.number!)) ?? "unknown")
            
            NetworkRepository.shared.cardRepository.addCardToServer(with: cardDetail) { (apiResponse, error) in
                
                if let error = error{
                    Toast.show(message: "Something went wrong!")
                    print("Something went wrong in SIGNUP THE USER. \(error.localizedDescription)")
                    
                } else if apiResponse != nil{
                    
                    Toast.show(message: "Card added")
                    self.getCardsList()
                    self.theTableView.reloadData()
                    
                } else{
                    Toast.show(message: "Something went wrong!")
                    print("Something went wrong in SIGNUP THE USER.")
                }
            }
            })
        
        
    }
}

