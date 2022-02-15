//
//  ROSImageInfo.swift
//  ROSPackage
//
//  Created by ogawa on 2022/2/11.
//

import Foundation
import UIKit

public class ROSImageInfo: NSObject {
    
    //MARK: - initial
    
    public init(resolution: Float,negate: Bool,occupiedThresh: Float,freeThresh: Float,occupiedColor: UIColor,freeColor: UIColor,isNeedCorrectAngle: Bool = true) {
        super.init()
        
        self.resolution = resolution
        self.negate = negate
        self.occupiedThresh = occupiedThresh
        self.freeThresh = freeThresh
        self.occupiedColor = occupiedColor
        self.freeColor = freeColor
        self.isNeedCorrectAngle = isNeedCorrectAngle
    }
    
    
    //MARK: - property
    
    public var R: opencv2.Mat?
    
    /// 分辨率
    private(set) var resolution: Float = 1
    
    /// If negate is false, p = (255 - x) / 255.0 f negate is true, p = x / 255.0
    private(set) var negate: Bool = false
    
    /// 障碍物颜色阈值
    private(set) var occupiedThresh: Float = 1.0
    
    /// 自由通行颜色阈值
    private(set) var freeThresh: Float = 1.0
    
    /// 障碍物颜色
    private(set) var occupiedColor: UIColor = .black
    
    /// 自由通行颜色
    private(set) var freeColor: UIColor = .white
    
    /// 是否需要矫正图像角度
    private(set) var isNeedCorrectAngle: Bool = true
    
    
    
    /// 地图原点
    internal var origin: CGPoint = .zero
    
    /// 偏转的角度
    public var angle: Double = 0
        
    /// 图像矫正后宽度
    private(set) var width: CGFloat = 0
    
    /// 图像矫正后高度
    private(set) var height: CGFloat = 0
    
    /// 图像原始宽度
    private(set) var srcWidth: CGFloat = 0
    
    /// 图像原始后宽度
    private(set) var srcHeight: CGFloat = 0
    
    //MARK: - public
    
    public func updateImage(image: UIImage) -> UIImage {
        self.srcWidth = image.size.width
        self.srcHeight = image.size.height
        let src = opencv2.Mat(uiImage: image, alphaExist: false)
        let rotate = ROSRoomRotator.computeRoomMainDirection(src: src, imageInfo: self)
        let result = cv8uc1Tocv8uc4(src: rotate)
        let png = result.toUIImage()
        self.width = png.size.width
        self.height = png.size.height
        return png
    }
    
    public func updateImage(data: Data,width: Int,height: Int) -> UIImage {
        self.srcWidth = CGFloat(width)
        self.srcHeight = CGFloat(height)
        let src = opencv2.Mat(rows: Int32(height), cols: Int32(width), type: opencv2.CvType.CV_8UC1, data: data)
        let rotate = ROSRoomRotator.computeRoomMainDirection(src: src, imageInfo: self)
        let result = cv8uc1Tocv8uc4(src: rotate)
        let png = result.toUIImage()
        self.width = png.size.width
        self.height = png.size.height
        return png
    }
    
    //MARK: - image proccess

    /// 单通道转4通道
    /// - Parameters:
    ///   - src: 源mat
    /// - Returns: 4通道Mat
    private func cv8uc1Tocv8uc4(src: opencv2.Mat) -> opencv2.Mat {
        
        let mat_8u4c = opencv2.Mat()
        let mat_8u3c = opencv2.Mat()
        let result = opencv2.Mat()
        
        opencv2.Imgproc.cvtColor(src: src, dst: mat_8u3c, code: .COLOR_GRAY2BGR)

        opencv2.Core.merge(mv: [mat_8u3c,src], dst: mat_8u4c)
        
        let table = opencv2.Mat(rows: 1, cols: 256, type: opencv2.CvType.CV_8UC4)

        let freeColors: [UInt8] = freeColor.cgColor.components?.map({ UInt8($0 * 255)}) ?? [0,0,0,0]

        let occupiedColors: [UInt8] = occupiedColor.cgColor.components?.map({ UInt8($0 * 255)}) ?? [0,0,0,0]

        let unKnowColors: [UInt8] = [0,0,0,0]

        for col in 0..<256 {
            let thresh = negate ? Float(col) / 255.0 : (255.0 - Float(col)) / 255.0
            if thresh > occupiedThresh {
                let _ = try? table.put(row: 0, col: Int32(col), data: occupiedColors)
            }
            else if thresh < freeThresh {
                let _ = try? table.put(row: 0, col: Int32(col), data: freeColors)
            }
            else {
                let _ = try? table.put(row: 0, col: Int32(col), data: unKnowColors)
            }
        }

        opencv2.Core.LUT(src: mat_8u4c, lut: table, dst: result)
            
        return result
        
    }
    
}
