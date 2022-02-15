//
//  ROSRoomRotator.swift
//  ROSPackage
//
//  Created by ogawa on 2022/2/10.
//

import Foundation

//+--------+----+----+----+----+------+------+------+------+
//|        | C1 | C2 | C3 | C4 | C(5) | C(6) | C(7) | C(8) |
//+--------+----+----+----+----+------+------+------+------+
//| CV_8U  |  0 |  8 | 16 | 24 |   32 |   40 |   48 |   56 |
//| CV_8S  |  1 |  9 | 17 | 25 |   33 |   41 |   49 |   57 |
//| CV_16U |  2 | 10 | 18 | 26 |   34 |   42 |   50 |   58 |
//| CV_16S |  3 | 11 | 19 | 27 |   35 |   43 |   51 |   59 |
//| CV_32S |  4 | 12 | 20 | 28 |   36 |   44 |   52 |   60 |
//| CV_32F |  5 | 13 | 21 | 29 |   37 |   45 |   53 |   61 |
//| CV_64F |  6 | 14 | 22 | 30 |   38 |   46 |   54 |   62 |
//+--------+----+----+----+----+------+------+------+------+

public struct ROSRoomRotator {
    
    static func computeRoomMainDirection(src: opencv2.Mat,imageInfo: ROSImageInfo) -> opencv2.Mat {
        
        let edge_map = opencv2.Mat()
        
        opencv2.Imgproc.Canny(image: src, edges: edge_map, threshold1: 50, threshold2: 150,apertureSize: 3)
        if imageInfo.R != nil {
            let validRect = opencv2.Imgproc.boundingRect(array: edge_map)
            
            let centerPoint: opencv2.Point2f = opencv2.Point2f(x: Float(validRect.x) + 0.5 * Float(validRect.width),
                                                               y: Float(validRect.y) + 0.5 * Float(validRect.height))
            let size = opencv2.Size2f(width: Float(src.size().width), height: Float(src.size().height))
            let boundRect = opencv2.RotatedRect(center: centerPoint, size: size, angle: imageInfo.angle * 180.0 / Double.pi).boundingRect()
            
            opencv2.Imgproc.warpAffine(src: src,
                                       dst: src,
                                       M: imageInfo.R!,
                                       dsize: opencv2.Size2i(width: Int32(boundRect.width), height: Int32(boundRect.height)),
                                       flags: opencv2.InterpolationFlags.INTER_NEAREST.rawValue,
                                       borderMode: .BORDER_REPLICATE)
            return src
        }
        else {
            let mapResolutionInverse = Double(1.0 / imageInfo.resolution)
            
            let lines = opencv2.Mat()
            
            var minLineLength: Double = 1.0
            while minLineLength > 0.1 {
                opencv2.Imgproc.HoughLinesP(image: edge_map,
                                            lines: lines,
                                            rho: 1,
                                            theta: Double.pi / 180.0,
                                            threshold: Int32(minLineLength * mapResolutionInverse),
                                            minLineLength: minLineLength * mapResolutionInverse,
                                            maxLineGap: 1.5 * minLineLength * mapResolutionInverse)
                if lines.rows() >= 4 {
                    break
                }

                minLineLength -= 0.2
            }
            let histogram = ROSHistogram(lowerBound: 0, upperBound: Double.pi, histogramBins: 36)
            for index in 0..<lines.rows() {
                let point: MatAt<Int32> = lines.at(row: index, col: 0)
                let dx = Double(point.v4c.2 - point.v4c.0)
                let dy = Double(point.v4c.3 - point.v4c.1)
                
                if dx * dx + dy * dy > 0 {
                    var currentDirection = atan2(dy, dx)
                    while currentDirection < 0 {
                        currentDirection += Double.pi
                    }
                    while currentDirection > Double.pi {
                        currentDirection -= Double.pi
                    }
                    histogram.addData(val: currentDirection, weight: sqrt(dy*dy+dx*dx))
                }
            }
            
            let validRect = opencv2.Imgproc.boundingRect(array: edge_map)
            
            let centerPoint: opencv2.Point2f = opencv2.Point2f(x: Float(validRect.x) + 0.5 * Float(validRect.width),
                                                               y: Float(validRect.y) + 0.5 * Float(validRect.height))
            
//            imageInfo.center = CGPoint(x: CGFloat(centerPoint.x), y: CGFloat(centerPoint.y))
            
            let angle = histogram.getMaxBinPreciseVal()
            
            let R = opencv2.Imgproc.getRotationMatrix2D(center: centerPoint, angle: angle * 180.0 / Double.pi, scale: 1.0)
            
            let size = opencv2.Size2f(width: Float(src.size().width), height: Float(src.size().height))
            let boundRect = opencv2.RotatedRect(center: centerPoint, size: size, angle: angle * 180.0 / Double.pi).boundingRect()
            
            let validWidth: MatAt<Double> = R.at(row: 0, col: 2)
            validWidth.v += Double(0.5*boundRect.width - centerPoint.x)
            let validHeight: MatAt<Double> = R.at(row: 1, col: 2)
            validHeight.v += Double(0.5*boundRect.height - centerPoint.y)
            
            opencv2.Imgproc.warpAffine(src: src,
                                       dst: src,
                                       M: R,
                                       dsize: opencv2.Size2i(width: Int32(boundRect.width), height: Int32(boundRect.height)),
                                       flags: opencv2.InterpolationFlags.INTER_NEAREST.rawValue,
                                       borderMode: .BORDER_REPLICATE)
            
            imageInfo.R = R
            imageInfo.angle = angle
            return src
        }
        
        
    }
}
