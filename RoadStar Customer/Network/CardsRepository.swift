//
//  CardsRepository.swift
//  RoadStar Customer
//
//  Created by Usman Nisar on 29/07/2021.
//  Copyright © 2021 Faizan.Technology. All rights reserved.
//
import Foundation
import UIKit
import Alamofire
import SwiftyJSON
class CardsRepository {

    func getCardList(block: @escaping (CardList?, Error?) -> Void) {
        
        let token = UserDefaults.standard.value(forKey: "loginToken") as? String ?? ""
        print(token)
        let url = "https://myroadstar.org/api/user/card"
        let headers: HTTPHeaders = ["Content-Type": "application/json",
                                    "X-Requested-With": "XMLHttpRequest",
                                    "Authorization":"Bearer \(token)"]
        

        AF.request(url, method: .get, headers: headers).validate(statusCode: 200..<300).validate(contentType: ["application/json"]).responseDecodable(of: CardList.self) { (response) in
            
            switch response.result{
            case .success:
                
                guard let responseV = response.value else{
                    block(nil, nil)
                    return
                }
                block(responseV, nil)
            case let .failure(error):
                block(nil, error)
            }
        }
    }
    
    func deleteCardList(card:PaymentCardModel2, block: @escaping (Bool, Error?) -> Void) {
        
        let token = UserDefaults.standard.value(forKey: "loginToken") as? String ?? ""
        print(token)
        let url = "https://myroadstar.org/api/user/card/destory"
        let headers: HTTPHeaders = ["Content-Type": "application/json",
                                    "X-Requested-With": "XMLHttpRequest",
                                    "Authorization":"Bearer \(token)"]
//        let params : Parameters = ["card_id":card.cardID, "_method":"DELETE"]
//        print(params)
        AF.request(url, method: .post, parameters: card,encoder: JSONParameterEncoder.default, headers: headers).validate(statusCode: 200..<600).validate(contentType: ["application/json"]).response{ (response) in
            
            switch response.result{
            case .success:
                
                guard response.value != nil else{
                    block(false, nil)
                    return
                }
                block(true, nil)
            case let .failure(error):
                block(false, error)
            }
        }
    }
    
    func addCardToServer(with card: PaymentCard, block: @escaping (PaymentCardResponse?, Error?) -> Void) {
        
//        let url = "https://myroadstar.org/api/user/signup"
        let url = "https://myroadstar.org/api/user/card"
        
        
        let token = UserDefaults.standard.value(forKey: "loginToken") as? String ?? ""
        
        let headers: HTTPHeaders = ["Content-Type": "application/json",
                                    "X-Requested-With": "XMLHttpRequest",
                                    "Authorization":"Bearer \(token)"]
        
        AF.request(url, method: .post, parameters: card, encoder: JSONParameterEncoder.default, headers: headers).validate(statusCode: 200..<300).validate(contentType: ["application/json"]).responseDecodable(of: PaymentCardResponse.self) { (response) in
            
            switch response.result{
            case .success:
                
                guard let apiResponse = response.value else{
                    block(nil, nil)
                    return
                }
                block(apiResponse, nil)
            case let .failure(error):
                block(nil, error)
            }
        }
    }

}
