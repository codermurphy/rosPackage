//
//  UIImage+ROSData.swift
//  ROSPackage
//
//  Created by ogawa on 2022/2/9.
//

import UIKit

extension UIImage {
    
    public func getOriginData() -> Data? {
        
        guard let cfData = self.cgImage?.dataProvider?.data else { return nil }
        let length = CFDataGetLength(cfData)
        let range = CFRange(location: 0, length: length)
        let pointer = UnsafeMutablePointer<UInt8>.allocate(capacity: length)
        CFDataGetBytes(cfData, range, pointer)
        let bufferPointter = UnsafeMutableBufferPointer(start: pointer, count: length)
        let data = Data(buffer: bufferPointter)
        return data
    }
    
}
