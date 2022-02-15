//
//  OGRosResterizedView.swift
//  ROSPackage
//
//  Created by ogawa on 2022/2/8.
//

import UIKit

internal class OGRosResterizedView: UIView {

    init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear
                
        self.layer.addSublayer(columnsLayer)
        columnsLayer.addSublayer(columnLayer)

        self.layer.addSublayer(rowsLayer)
        rowsLayer.addSublayer(rowLayer)
        
        
        columnsLayer.instanceTransform = CATransform3DMakeTranslation(CGFloat(resterizedSize), 0, 0)
        rowsLayer.instanceTransform = CATransform3DMakeTranslation(0,CGFloat(resterizedSize), 0)
        
        columnsLayer.instanceColor = lineColor?.cgColor
        rowsLayer.instanceColor = lineColor?.cgColor
        
        columnLayer.backgroundColor = lineColor?.cgColor
        rowLayer.backgroundColor = lineColor?.cgColor

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - property
    var lineColor: UIColor? = UIColor(red: 241.0 / 255, green: 244.0 / 255.0, blue: 253.0 / 255.0, alpha: 1.0) {
        didSet {
            guard let color = lineColor else { return }
            columnsLayer.instanceColor = color.cgColor
            rowsLayer.instanceColor = color.cgColor
            
            columnLayer.backgroundColor = color.cgColor
            rowLayer.backgroundColor = color.cgColor
        }
    }
    
    var resterizedSize: Int = 10 {
        didSet {
            columnsLayer.instanceTransform = CATransform3DMakeTranslation(CGFloat(resterizedSize), 0, 0)
            rowsLayer.instanceTransform = CATransform3DMakeTranslation(0,CGFloat(resterizedSize), 0)
        }
    }
    
    private let columnsLayer: CAReplicatorLayer = {
        let layer = CAReplicatorLayer()
        layer.drawsAsynchronously = true
        return layer
    }()
    
    
    private let columnLayer: CALayer = {
        let layer = CALayer()
        layer.drawsAsynchronously = true
        return layer
    }()
     
    
    private let rowsLayer: CAReplicatorLayer = {
        let layer = CAReplicatorLayer()
        layer.drawsAsynchronously = true
        return layer
    }()
    
    
    private let rowLayer: CALayer = {
        let layer = CALayer()
        layer.drawsAsynchronously = true
        return layer
    }()

    
    
    private var isFinishLayout = false
    
    //MARK: - create resterized
    
    private func createResteried() {
        
        guard self.resterizedSize > 0 else { return }
        
        let max = max(self.bounds.width,self.bounds.height)
        var contentSize = max * 3
        let mod = contentSize.truncatingRemainder(dividingBy: CGFloat(resterizedSize))
        if mod != 0 { contentSize += mod }
        let offset = contentSize / 3
        let instanceCount = Int(contentSize) / self.resterizedSize + 1

        
        columnsLayer.frame = CGRect(x: -offset, y: -offset, width: contentSize, height: contentSize)
        columnsLayer.instanceCount = instanceCount

        columnLayer.frame = CGRect(x: 0, y: 0, width: 1, height: contentSize)

        rowsLayer.frame = CGRect(x: -offset, y: -offset, width: contentSize, height: contentSize)
        rowsLayer.instanceCount = instanceCount


        rowLayer.frame = CGRect(x:0, y: 0, width: contentSize, height: 1)
        
        
    }
    
    //MARK: -  update frame
        
    func reset() {
        guard let superOffset = self.superview?.bounds.origin else { return }

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        var offsetx: CGFloat = 0
        var offsety: CGFloat = 0
        let modx = abs(superOffset.x).truncatingRemainder(dividingBy: CGFloat(resterizedSize))
        let mody = abs(superOffset.y).truncatingRemainder(dividingBy: CGFloat(resterizedSize))
        if modx == 0 {
            offsetx = -superOffset.x
        }
        else {
            if superOffset.x < 0 {
                offsetx = abs(superOffset.x) - modx + CGFloat(resterizedSize)
            }
            if superOffset.x > 0 {
                offsetx = -(abs(superOffset.x) - modx - CGFloat(resterizedSize))
            }

        }
        
        if mody == 0 {
            offsety = -superOffset.y
        }
        else {
            if superOffset.y < 0 {
                offsety = abs(superOffset.y) - mody + CGFloat(resterizedSize)
            }
            if superOffset.y > 0 {
                offsety = -(abs(superOffset.y) - mody - CGFloat(resterizedSize))
            }

        }

        self.bounds = CGRect(x: offsetx, y: offsety, width: self.bounds.width, height: self.bounds.height)
        CATransaction.commit()

    }
    
     
    
    //MARK: - layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard isFinishLayout == false else { return }
        createResteried()
        isFinishLayout = true

    }
    
}
