//
//  RobotView.swift
//  ROSPackage_Example
//
//  Created by ogawa on 2022/2/14.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import ROSPackage

class RobotView: UIImageView,ROSSubViewProtocol {
    
    
    
    init(identifier: String,origin: CGPoint) {
        self.identifier = identifier
        self.origin = origin
        super.init(image: UIImage(named: "robots"))
        
        self.clipsToBounds = true
        self.layer.cornerRadius = size.height * 0.5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ROSSubViewProtocol
    var identifier: String
    
    var origin: CGPoint
    
    var size: CGSize {
        return self.image!.size
    }
    
    var offSet: CGPoint {
        return .zero
    }
    
    var initialAngle: CGFloat {
        return CGFloat.pi * 0.5
    }
    
    var currentAngle: CGFloat = 0
    

    

    
}
