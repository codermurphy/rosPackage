//
//  ROSRobotViewProtocol.swift
//  ROSPackage
//
//  Created by ogawa on 2022/2/14.
//

import Foundation

public protocol ROSSubViewProtocol where Self: UIView {
    
    var identifier: String {set get}
    
    var origin: CGPoint { set get }
    
    var size: CGSize { get }
    
    var offSet: CGPoint { get }
    
    var initialAngle: CGFloat { get }
    
    var currentAngle: CGFloat { set get }
    
    var isNeedRotation: Bool { get }
    
}


public extension ROSSubViewProtocol {
    
    var initialAngle: CGFloat {
        return  0
    }
    
    var isNeedRotation: Bool {
        return true
    }
}

