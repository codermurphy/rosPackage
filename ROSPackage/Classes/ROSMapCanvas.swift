//
//  ROSMapCanvas.swift
//  ROSPackage
//
//  Created by ogawa on 2022/1/28.
//

import UIKit

public class ROSMapCanvas: UIView {
    
    public init(imageInfo: ROSImageInfo) {
        self.imageInfo = imageInfo
        super.init(frame: .zero)
        self.clipsToBounds = true
        initial()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - common init
    
    private func initial() {
        
        
        self.addSubview(rasterizedView)
        rasterizedView.translatesAutoresizingMaskIntoConstraints = false
        rasterizedView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        rasterizedView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        rasterizedView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        rasterizedView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        self.addSubview(mapImageView)

        mapImageView.translatesAutoresizingMaskIntoConstraints = false
        mapImageView.centerYAnchor.constraint(equalTo: rasterizedView.centerYAnchor).isActive = true
        mapImageView.centerXAnchor.constraint(equalTo: rasterizedView.centerXAnchor).isActive = true
        mapImageViewWidthAnchor = mapImageView.widthAnchor.constraint(equalToConstant: 0)
        mapImageViewWidthAnchor.isActive = true
        mapImageViewHeightAnchor = mapImageView.heightAnchor.constraint(equalToConstant: 0)
        mapImageViewHeightAnchor.isActive = true
        
        
        let panGesture = UIPanGestureRecognizer()
        panGesture.maximumNumberOfTouches  = 1
        panGesture.minimumNumberOfTouches = 1
        panGesture.addTarget(self, action: #selector(panGestureHandler(gesture:)))
        self.addGestureRecognizer(panGesture)
        
        
        let pinch = UIPinchGestureRecognizer()
        pinch.addTarget(self, action: #selector(pinchGestureHandler(gesture:)))
        self.addGestureRecognizer(pinch)
        
    }
    
    //MARK: - property
    
    private var imageInfo: ROSImageInfo
    
    private var isInitial: Bool = false
    
    public var minimumZoomScale: CGFloat = 1
    
    public var maximumZoomScale: CGFloat = 5
    
    public var currentZoomScale: CGFloat = 1
    
    private var mapSubviews: [ROSSubViewProtocol] = []
    
    private var mapImageViewWidthAnchor: NSLayoutConstraint!
    private var mapImageViewHeightAnchor: NSLayoutConstraint!
    
    
    //MARK: - events Handler
    @objc private func panGestureHandler(gesture: UIPanGestureRecognizer) {
        let point = gesture.translation(in: self)

        let originBounds = self.bounds
        
        switch gesture.state {
        case .changed:
            
            self.bounds = CGRect(x: originBounds.origin.x - point.x, y: originBounds.origin.y - point.y, width: originBounds.width, height: originBounds.height)
            gesture.setTranslation(.zero, in: self)
        case .cancelled,
             .failed,
             .ended:
            rasterizedView.reset()
        default:
            break
        }
    }
    
    @objc private func pinchGestureHandler(gesture: UIPinchGestureRecognizer) {
        
        if gesture.numberOfTouches == 2 {
            switch gesture.state {
            case .changed:

                self.transform = self.transform.scaledBy(x: gesture.scale, y: gesture.scale)
                if self.transform.a < minimumZoomScale {
                    self.transform = CGAffineTransform.identity
                }
                
                if self.transform.a > maximumZoomScale {
                    self.transform = CGAffineTransform(scaleX: maximumZoomScale, y: maximumZoomScale)
                }
                
                currentZoomScale = self.transform.a
                gesture.scale = 1

            default:
                break
            }
        }
    }
    
    //MARK: - robots
    
    public func addRobots(view: ROSSubViewProtocol) {
        
        view.frame.size = view.size
        let point = ROSConvert.convertPoint(point: view.origin, imageInfo: imageInfo)
        view.center = CGPoint(x: point.x - view.offSet.x, y: point.y - view.offSet.y)
        mapImageView.addSubview(view)
        view.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 0.5)
        mapSubviews.append(view)
    }
    
    public func addChargingPile(view: ROSSubViewProtocol) {
        view.frame.size = view.size
        let point = ROSConvert.convertPoint(point: view.origin, imageInfo: imageInfo)
        view.center = CGPoint(x: point.x - view.offSet.x, y: point.y - view.offSet.y)
        mapImageView.addSubview(view)
        mapImageView.sendSubviewToBack(view)
        mapSubviews.append(view)
    }

    
    //MARK: - UI
    
    private lazy var rasterizedView: OGRosResterizedView = {
        let view = OGRosResterizedView()
        
        return view
    }()
        
    private let mapImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.backgroundColor = UIColor.clear.cgColor
        imageView.layer.magnificationFilter = .nearest
        imageView.layer.drawsAsynchronously = true
        return imageView
    }()

    
    public override func layoutSubviews() {
        super.layoutSubviews()
        //rasterizedView.frame = self.bounds


    }
}

//MARK: - mapImageView
extension ROSMapCanvas {
    
    public func updateRosImage(image: UIImage,origin: CGPoint) {
        imageInfo.origin = origin
        let png = imageInfo.updateImage(image: image)

        mapImageViewWidthAnchor.constant = imageInfo.width
        mapImageViewHeightAnchor.constant = imageInfo.height
        
        mapImageView.image = png
        
        updateMapSubViewsPosition()
        
    }
}
 
//MARK: - robot
extension ROSMapCanvas {
    
    public func updateMapSubViewposition(identifier: String,point: CGPoint,angle: CGFloat) {
        guard let robot = mapSubviews.first(where: { $0.identifier == identifier}) else { return }
        let result = ROSConvert.convertPoint(point: point, imageInfo: imageInfo)
        let angle = ROSConvert.convertAngle(initialAngle: robot.initialAngle,angle: angle, imageInfo: imageInfo)
        robot.center = CGPoint(x: result.x - robot.offSet.x, y: result.y - robot.offSet.y)
        if robot.isNeedRotation {
            robot.transform = CGAffineTransform(rotationAngle: angle)
        }
        let _ = ROSConvert.reductionPoint(point: result, imageInfo: imageInfo)
    }
    
    private func updateMapSubViewsPosition() {
        for robot in mapSubviews {
            let identifier = robot.identifier
            let point = robot.origin
            let angle = robot.currentAngle
            updateMapSubViewposition(identifier: identifier, point: point,angle: angle)
        }
    }
    
}
