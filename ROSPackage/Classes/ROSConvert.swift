//
//  ROSConvert.swift
//  ROSPackage
//
//  Created by ogawa on 2022/2/12.
//

import UIKit

struct ROSConvert {
    
    
    static func convertMapOrigin(imageInfo: ROSImageInfo) -> CGPoint {
        guard imageInfo.origin != .zero else { return .zero}
        
        if imageInfo.R == nil {
            let originX = -(imageInfo.origin.x / CGFloat(imageInfo.resolution))
            let originY = imageInfo.srcHeight + imageInfo.origin.y / CGFloat(imageInfo.resolution)
            return CGPoint(x: originX, y: originY)
        }
        else {
            let originX = -(imageInfo.origin.x / CGFloat(imageInfo.resolution))
            let originY = imageInfo.srcHeight + imageInfo.origin.y / CGFloat(imageInfo.resolution)
            let pointMat = MatOfPoint2f(array: [Point2f(x: Float(originX), y: Float(originY))])
            
            opencv2.Core.transform(src: pointMat, dst: pointMat, m: imageInfo.R!)
            guard let result = pointMat.toArray().first else { return .zero }
            let resultX = CGFloat(result.x)
            let resultY = CGFloat(result.y)
            return CGPoint(x: resultX, y: resultY)
        }
    }
    
    static func convertPoint(point: CGPoint,imageInfo: ROSImageInfo) -> CGPoint {
        guard imageInfo.origin != .zero else { return .zero}
        
        if imageInfo.R == nil {
            let originX = (-(imageInfo.origin.x / CGFloat(imageInfo.resolution))) + point.x / CGFloat(imageInfo.resolution)
            let originY = (imageInfo.srcHeight + imageInfo.origin.y / CGFloat(imageInfo.resolution)) + point.y / CGFloat(imageInfo.resolution)
            return CGPoint(x: originX, y: originY)
        }
        else {
            let originX = (-(imageInfo.origin.x / CGFloat(imageInfo.resolution))) + point.x / CGFloat(imageInfo.resolution)
            let originY = (imageInfo.srcHeight + imageInfo.origin.y / CGFloat(imageInfo.resolution)) + point.y / CGFloat(imageInfo.resolution)
            let pointMat = MatOfPoint2f(array: [Point2f(x: Float(originX), y: Float(originY))])
            
            opencv2.Core.transform(src: pointMat, dst: pointMat, m: imageInfo.R!)
            guard let result = pointMat.toArray().first else { return .zero }
            let resultX = CGFloat(result.x)
            let resultY = CGFloat(result.y)
            return CGPoint(x: resultX, y: resultY)
        }
    }
    
    static func convertAngle(initialAngle: CGFloat,angle: CGFloat,imageInfo: ROSImageInfo) -> CGFloat {
        
        return angle + initialAngle + CGFloat(imageInfo.angle)
    }
    
    static func reductionPoint(point: CGPoint,imageInfo: ROSImageInfo) -> CGPoint {
        
        if imageInfo.R == nil {
            let resultX = point.x * CGFloat(imageInfo.resolution)
            let resultY = (imageInfo.srcHeight - point.y) * CGFloat(imageInfo.resolution)
            return CGPoint(x: resultX, y: resultY)
        }
        else {

            let b00: MatAt<Double> = imageInfo.R!.at(row: 0, col: 2)
            let b10: MatAt<Double> = imageInfo.R!.at(row: 1, col: 2)
            
            let tempX = Float(Double(point.x) - b00.v)
            let tempY = Float(Double(point.y) - b10.v)
            
            let point = opencv2.Point2f(x: tempX, y: tempY)
            
            let r = opencv2.Mat(mat: imageInfo.R!.clone(), rowRange: Range(start: 0, end: 2), colRange: Range(start: 0, end: 2))
            opencv2.Core.invert(src: r, dst: r)
            
            let pointMat = opencv2.MatOfPoint2f(array: [point])
            
            opencv2.Core.transform(src: pointMat, dst: pointMat, m: r)
            guard let result = pointMat.toArray().first else { return .zero }
            let srcX = CGFloat(result.x) * CGFloat(imageInfo.resolution)
            let srcY = (imageInfo.srcHeight - CGFloat(result.y)) * CGFloat(imageInfo.resolution)

            return CGPoint(x: srcX, y: srcY)
        }
        
    }
}
