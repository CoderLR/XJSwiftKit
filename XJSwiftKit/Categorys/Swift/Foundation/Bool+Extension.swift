//
//  Bool+Extension.swift
//  XJSwiftKit
//
//  Created by Mr.Yang on 2021/10/20.
//

import Foundation

extension Bool: XJCompatible {}

// MARK:- 一、基本的扩展
public extension XJExtension where Base == Bool {
 
    // MARK: 1.1、Bool 值转 Int
    /// Bool 值转 Int
    var boolToInt: Int { return self.base ? 1 : 0 }
}
