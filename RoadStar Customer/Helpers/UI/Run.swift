//
//  Run.swift
//  RoadStar Customer
//
//  Created by Faizan Ali  on 2020/8/29.
//  Copyright © 2020 Faizan.Technology. All rights reserved.
//

import Foundation
public struct Run
{
    typealias Block = () ->Void
    
    static public func onMain(_ sync: Bool = false, block: @escaping ()->Void)
    {
        let queue = DispatchQueue.main
        queue.async(execute: block)
    }
    
    static public func inBackground(_ name: String = "com.FaizanTech",  block: @escaping ()->Void)
    {
        _ = DispatchQoS(qosClass: DispatchQoS.QoSClass.background, relativePriority: 0)
        let queue = DispatchQueue(label: name, attributes: .concurrent)
        queue.async(execute: block)
    }
}
