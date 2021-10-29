//
//  Range+Extension.swift
//  XJSwiftKit
//
//  Created by Mr.Yang on 2021/10/20.
//

import Foundation

// MARK:- 一、基本的扩展
extension Range: XJCompatible {}

public extension XJExtension where Base: RangeExpression, Base.Bound == String.Index {
    
    // MARK: 1.1、Range 转 NSRange
    /// Range 转 NSRange
    /// - Parameter string: 父字符串
    /// - Returns: NSRange
    func toNSRange<S: StringProtocol>(in string: S) -> NSRange {
        return NSRange(self.base, in: string)
    }
}
