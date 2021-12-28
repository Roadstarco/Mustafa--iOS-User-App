//
//  AuthRoutes.swift
//  RoadStar Customer
//
//  Created by Faizan Ali  on 2020/12/25.
//  Copyright © 2020 Faizan.Technology. All rights reserved.
//

import Foundation
import Alamofire

enum AuthRoutes: URLRequestBuilder  {
    
    case logIn(email: String, password: String)
    case register(email: String, phoneNumber: String)
    case proceed(signUpModel: SignUp)
    
    // MARK: - Path
    internal var path: String {
        switch self {
        case .logIn:
            return "login"
        case .register:
            return "register"
        case .proceed:
            return "proceed"
        }
    }
    
    // MARK: - Parameters
    internal var parameters: Parameters? {
        var params = Parameters.init()
        
        switch self {
        case .logIn(let email, let password):
        
            params["email"] = email
            params["password"] = password
            
        case .register(let email, let phoneNumber):
        
            params["email"] = email
            params["phone_number"] = phoneNumber
        
        case .proceed(let signUpModel):
        break
//            params["first_name"] = signUpModel.firstName
//            params["last_name"] = signUpModel.lastName
//            params["email"] = signUpModel.email
//            params["password"] = signUpModel.password
//            params["signup_as"] = signUpModel.signupAs
//            params["phone_number"] = signUpModel.phoneNumber
//            params["code"] = signUpModel.code
//            params["user_name"] = signUpModel.userName
            
        }
        
        
        return params
    }
    
    
    // MARK: - Methods
    internal var method: HTTPMethod {
        switch self {
        default:
            return .post
        }
        
    }
    
    // MARK: - HTTPHeaders
    internal var headers: HTTPHeaders {
        switch self {
        default:
            return HTTPHeaders()
            
        }
    }
}

