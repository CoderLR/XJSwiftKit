//
//  UIAlertController+Extension.swift
//  XJSwiftKit
//
//  Created by Mr.Yang on 2021/10/19.
//

import Foundation

// MARK: - Create
extension UIAlertController {
    
    /// alertView
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 信息
    ///   - sureTtile: 确认
    ///   - sureHandler: 确认回调
    /// - Returns: alertView
    @discardableResult
    class func alertView(title: String?,
                         message: String?,
                         sureTtile: String,
                         sureHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let sureAction = UIAlertAction(title: sureTtile, style: .default, handler: sureHandler)
        alertView.addAction(sureAction)
        return alertView
    }
    
    /// alertView
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 信息
    ///   - cancleTtile: 返回
    ///   - sureTtile: 返回回调
    ///   - cancleHandler: 确认
    ///   - sureHandler: 确认回调
    /// - Returns: alertView
    @discardableResult
    class func alertView(title: String?,
                         message: String?,
                         cancleTtile: String,
                         sureTtile: String,
                         cancleHandler: ((UIAlertAction) -> Void)? = nil,
                         sureHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: cancleTtile, style: .destructive, handler: cancleHandler)
        let sureAction = UIAlertAction(title: sureTtile, style: .default, handler: sureHandler)
        alertView.addAction(cancleAction)
        alertView.addAction(sureAction)
        return alertView
    }
    
    /// actionSheet
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 信息
    ///   - cancleTtile: 返回
    ///   - titles: 添加选项
    ///   - clickHandler: 添加选项回调
    /// - Returns: actionSheet
    @discardableResult
    class func actionSheet(title: String?,
                           message: String?,
                           cancleTtile: String,
                           titles: [String],
                           clickHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for i in 0..<titles.count {
            let title = titles[i]
            let action = UIAlertAction(title: title, style: .default, handler: clickHandler)
            alertView.addAction(action)
        }
        
        let cancleAction = UIAlertAction(title: cancleTtile, style: .destructive, handler: nil)
        alertView.addAction(cancleAction)
        
        return alertView
    }
}
