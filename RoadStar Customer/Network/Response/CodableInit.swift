//
//  NetworkRepository.swift
//  RoadStar Customer
//
//  Created by Faizan Ali  on 2020/10/4.
//  Copyright © 2020 Faizan.Technology. All rights reserved.
//

import Foundation

protocol CodableInit: Codable {
    init(data: Data) throws
}

extension CodableInit  {
    init(data: Data) throws {
        let decoder = JSONDecoder()

        self = try decoder.decode(Self.self, from: data)
    }
}


