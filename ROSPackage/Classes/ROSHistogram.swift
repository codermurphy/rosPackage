//
//  ROSHistogram.swift
//  ROSPackage
//
//  Created by ogawa on 2022/2/11.
//

import Foundation


class ROSHistogram<T: BinaryFloatingPoint> {
    
    typealias RawData = Array<(T,Double)>
    
    init(lowerBound: T,upperBound: T,histogramBins: Int) {
        self.lowerBound = lowerBound
        self.upperBound = upperBound
        self.rangeInverse = 1.0 / (upperBound - lowerBound)
        self.histogramBins = histogramBins
        self.data = Array<Double>(repeating: 0, count: histogramBins)
        self.rawData = Array<RawData>(repeating: [], count: histogramBins)
    }
    
    func addData(val: T,weight: Double = 1.0) {
        let nearestIndex = min(histogramBins - 1,Int((val - lowerBound) * rangeInverse * T(histogramBins)))
        let index = max(0,min(histogramBins - 1,nearestIndex))
        data[index] += weight
        rawData[index].append((val,weight))
    }
    
    func getMaxBin() -> Int {
        var maxVal: Double = 0
        var maxBin: Int = 0
        for index in 0..<data.count {
            if maxVal < data[index] {
                maxVal = data[index]
                maxBin = index
            }
        }
        return maxBin
    }
    
    func getMaxBinPreciseVal() -> T {
        if rawData.isEmpty || rawData.count != data.count {
            return 0
        }
        let maxBin = getMaxBin()
        var sum: T = 0
        var weightSum: T = 0
        let data = rawData[maxBin]
        for index in 0..<data.count {
            sum += data[index].0 * T(data[index].1)
            weightSum += T(data[index].1)
        }
        if sum == 0 {
            weightSum = 1
        }
        return sum / weightSum
    }
    
    private var lowerBound: T
    
    private var upperBound: T
    
    private var histogramBins: Int
    
    private var rangeInverse: T
    
    private var data: [Double]
    
    private var rawData: [RawData]
}
