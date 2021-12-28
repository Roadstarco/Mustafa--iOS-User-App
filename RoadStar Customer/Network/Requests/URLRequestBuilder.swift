//
//  NetworkRepository.swift
//  RoadStar Customer
//
//  Created by Faizan Ali  on 2020/10/4.
//  Copyright © 2020 Faizan.Technology. All rights reserved.
//

import Foundation
import Alamofire

enum AppURL:String {
    case AppBaseURl = "https://alazba.com/public/api/v1/"
    case legalURl = "http://alazba.com/legal"
    case helpURl = "http://alazba.com/help"
}

enum AppConstant:String {
    case foloosiTestKey = "test_$2y$10$AQ.iua.lRC4Xl6iJ9bO10u4fr3ZgpGKxuwis6VwS5qladSBxGpoSG"
}

protocol URLRequestBuilder: URLRequestConvertible, APIRequestHandler {
    
    var mainURL: URL { get }
    var requestURL: URL { get }
    // MARK: - Path
    var path: String { get }
    
    // MARK: - Parameters
    var parameters: Parameters? { get }
    
    var headers: HTTPHeaders { get }
    
    // MARK: - Methods
    var method: HTTPMethod { get }
    
    var encoding: ParameterEncoding { get }
    
    var urlRequest: URLRequest { get }
}


extension URLRequestBuilder {
    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var mainURL: URL  {
        
        return URL(string: AppURL.AppBaseURl.rawValue)!
    }
    
    var requestURL: URL {
        return mainURL.appendingPathComponent(path)
    }
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        headers.forEach { (header) in
            request.addValue(header.value, forHTTPHeaderField: header.name)
        }
        
        return request
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        return try encoding.encode(urlRequest, with: parameters)
    }
}
