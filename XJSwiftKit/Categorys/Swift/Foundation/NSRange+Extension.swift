//
//  NSRange+Extension.swift
//  XJSwiftKit
//
//  Created by Mr.Yang on 2021/10/20.
//

import Foundation

extension NSRange: XJCompatible {}

// MARK:- 一、基本的扩展
public extension XJExtension where Base == NSRange {
    
    // MARK: 1.1、NSRange转换成Range的方法
    /// NSRange转换成Range的方法
    /// - Parameter string: 父字符串
    /// - Returns: Range<String.Index>
    func toRange(string: String) -> Range<String.Index>? {
        guard
            let from16 = string.utf16.index(string.utf16.startIndex, offsetBy: self.base.location, limitedBy: string.utf16.endIndex),
            let to16 = string.utf16.index(from16, offsetBy: self.base.length, limitedBy: string.utf16.endIndex),
            let from = String.Index(from16, within: string),
            let to = String.Index(to16, within: string)
            else { return nil }
          return from ..< to
    }
}
