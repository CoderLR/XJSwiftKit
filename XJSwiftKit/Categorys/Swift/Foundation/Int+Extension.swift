//
//  Int+Extension.swift
//  XJSwiftKit
//
//  Created by Mr.Yang on 2021/10/20.
//

import Foundation

extension Int: XJCompatible {}

// MARK:- 一、Int 与其他类型的转换
public extension XJExtension where Base == Int {
    
    // MARK: 1.1、转 Double
    /// 转 Double
    var intToDouble: Double { return Double(self.base) }

    // MARK: 1.2、转 Float
    /// 转 Float
    var intToFloat: Float { return Float(self.base) }
    
    // MARK: 1.3、转 Int64
    /// 转 Int64
    var intToInt64: Int64 { return Int64(self.base) }

    // MARK: 1.4、转 CGFloat
    /// 转 CGFloat
    var intToCGFloat: CGFloat { return CGFloat(self.base) }

    // MARK: 1.5、转 String
    /// 转 String
    var intToString: String { return String(self.base) }

    // MARK: 1.6、转 UInt
    /// 转 UInt
    var intToUInt: UInt { return UInt(self.base) }

    // MARK: 1.7、转 range
    /// 转 range
    var intToTange: CountableRange<Int> { return 0..<self.base }
}

// MARK:- 二、其他常用方法
public extension XJExtension where Base == Int {

    // MARK: 2.1、取区间内的随机数，如取  0..<10 之间的随机数
    ///  取区间内的随机数，如取  0..<10 之间的随机数
    /// - Parameter within: 0..<10
    /// - Returns: 返回区间内的随机数
    static func random(within: Range<Int>) -> Int {
        let delta = within.upperBound - within.lowerBound
        return within.lowerBound + Int(arc4random_uniform(UInt32(delta)))
    }
    
    // MARK: 2.2、转换万单位
    /// 转换万的单位
    /// - Parameter scale: 小数点后舍入值的位数，默认 1 位
    /// - Returns: 返回万的字符串
    func toTenThousandString(scale: Int = 1) -> String {
        if self.base < 0 {
            return "0"
        } else if self.base <= 9999 {
            return "\(self.base)"
        } else {
            let doub = CGFloat(self.base) / 10000
            let str = String(format: "%.\(scale)f", doub)
            let start_index = str.index(str.endIndex, offsetBy: -1)
            let suffix = String(str[start_index ..< str.endIndex])
            if suffix == "0" {
                let toIndex = str.index(str.endIndex, offsetBy: -2)
                return String(str[str.startIndex ..< toIndex]) + "万"
            } else {
                return str + "万"
            }
        }
    }
    
    // MARK: 2.3、计算大小：UInt64 -> String
    /// 计算大小：UInt64 -> String
    /// - Parameter size: 大小
    /// - Returns: 转换后的文件大小
    func covertUInt64ToString() -> String {
        var convertedValue: Double = Double(self.base)
        var multiplyFactor = 0
        let tokens = ["bytes", "KB", "MB", "GB", "TB", "PB",  "EB",  "ZB", "YB"]
        while convertedValue > 1024 {
            convertedValue /= 1024
            multiplyFactor += 1
        }
        return String(format: "%4.2f %@", convertedValue, tokens[multiplyFactor])
    }
}
