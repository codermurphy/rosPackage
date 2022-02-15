//
//  ViewController.swift
//  PROJECT
//
//  Created by PROJECT_OWNER on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import UIKit
import ROSPackage

class ViewController: UIViewController {
    
    var mod = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageInfo = ROSImageInfo(resolution: 0.05,
                                     negate: false,
                                     occupiedThresh: 0.65,
                                     freeThresh: 0.196,
                                     occupiedColor: UIColor.blue.withAlphaComponent(0.4),
                                     freeColor: UIColor.blue.withAlphaComponent(0.2))
        
        let canvas = ROSMapCanvas(imageInfo: imageInfo)
        canvas.frame = self.view.bounds
        self.view.addSubview(canvas)
        
        let path1 = Bundle.main.path(forResource: "map1", ofType: "pgm")!
        let image1 = UIImage(contentsOfFile: path1)
    
        let robot = RobotView(identifier: "identifier", origin: CGPoint(x: 0, y: 0))
        canvas.addRobots(view: robot)
        
        let chargingpile = RobotChargingpileView(identifier: "identifier-2", origin: .zero)
        canvas.addChargingPile(view: chargingpile)
        
        canvas.updateRosImage(image: image1!,origin: CGPoint(x: -10, y: -10))

        
    }


}

