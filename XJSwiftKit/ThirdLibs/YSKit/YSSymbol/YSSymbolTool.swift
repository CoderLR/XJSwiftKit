//
//  YSSymbolTool.swift
//  LeiFengHao
//
//  Created by xj on 2022/6/27.
//

import UIKit

// systemName参考 https://developer.apple.com/sf-symbols/
class YSSymbolTool: NSObject {

    
    /// 获取symbol Image
    /// - Parameter systemName: symbol名
    /// - Parameter color: 图标颜色
    /// - Returns: image
    @available(iOS 13.0, *)
    class func image(systemName: String, color: UIColor) -> UIImage? {
        var image = UIImage(systemName: systemName, withConfiguration: nil)
        image = image?.withTintColor(color, renderingMode: .alwaysOriginal)
        return image
    }
    
    /// 获取symbol Image
    /// - Parameter systemName: symbol名
    /// - Parameter color: 图标颜色
    /// - Parameter font: 字体
    /// - Returns: image
    @available(iOS 13.0, *)
    class func image(systemName: String, color: UIColor, font: UIFont) -> UIImage? {
        let config = UIImage.SymbolConfiguration(font: font)
        var image = UIImage(systemName: systemName, withConfiguration: config)
        image = image?.withTintColor(color, renderingMode: .alwaysOriginal)
        return image
    }
    
    /// 获取symbol Image
    /// - Parameter systemName: symbol名
    /// - Parameter color: 图标颜色
    /// - Parameter pointSize: 字体大小
    /// - Returns: image
    @available(iOS 13.0, *)
    class func image(systemName: String, color: UIColor, pointSize: CGFloat) -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: pointSize)
        var image = UIImage(systemName: systemName, withConfiguration: config)
        image = image?.withTintColor(color, renderingMode: .alwaysOriginal)
        return image
    }
    
    /// 获取symbol Image
    /// - Parameter systemName: symbol名
    /// - Parameter color: 图标颜色
    /// - Parameter scale: 图标大小
    /// - Returns: image
    @available(iOS 13.0, *)
    class func image(systemName: String, color: UIColor, scale: UIImage.SymbolScale) -> UIImage? {
        let config = UIImage.SymbolConfiguration(scale: scale)
        var image = UIImage(systemName: systemName, withConfiguration: config)
        image = image?.withTintColor(color, renderingMode: .alwaysOriginal)
        return image
    }
    
    /// 获取symbol Image
    /// - Parameter systemName: symbol名
    /// - Parameter color: 图标颜色
    /// - Parameter weight: 图标宽度
    /// - Returns: image
    @available(iOS 13.0, *)
    class func image(systemName: String, color: UIColor, weight: UIImage.SymbolWeight) -> UIImage? {
        let config = UIImage.SymbolConfiguration(weight: weight)
        var image = UIImage(systemName: systemName, withConfiguration: config)
        image = image?.withTintColor(color, renderingMode: .alwaysOriginal)
        return image
    }
    
    /// 获取symbol Image
    /// - Parameter systemName: symbol名
    /// - Parameter color: 图标颜色
    /// - Parameter weight: 图标宽度
    /// - Parameter font: 字体
    /// - Returns: image
    @available(iOS 13.0, *)
    class func image(systemName: String, color: UIColor, weight: UIImage.SymbolWeight, font: UIFont) -> UIImage? {
        var config = UIImage.SymbolConfiguration(weight: weight)
        let fontConfig = UIImage.SymbolConfiguration(font: font)
        config = config.applying(fontConfig)
        var image = UIImage(systemName: systemName, withConfiguration: config)
        image = image?.withTintColor(color, renderingMode: .alwaysOriginal)
        return image
    }
    
    /// 获取symbol Image
    /// - Parameter systemName: symbol名
    /// - Parameter color: 图标颜色
    /// - Parameter weight: 图标宽度
    /// - Parameter pointSize: 大小
    /// - Returns: image
    @available(iOS 13.0, *)
    class func image(systemName: String, color: UIColor, weight: UIImage.SymbolWeight, pointSize: CGFloat) -> UIImage? {
        var config = UIImage.SymbolConfiguration(weight: weight)
        let pointSizeConfig = UIImage.SymbolConfiguration(pointSize: pointSize)
        config = config.applying(pointSizeConfig)
        var image = UIImage(systemName: systemName, withConfiguration: config)
        image = image?.withTintColor(color, renderingMode: .alwaysOriginal)
        return image
    }
    
    /// 获取symbol Image
    /// - Parameter systemName: symbol名
    /// - Parameter color: 图标颜色
    /// - Parameter weight: 图标宽度
    /// - Parameter scale: 图标大小
    /// - Returns: image
    @available(iOS 13.0, *)
    class func image(systemName: String, color: UIColor, weight: UIImage.SymbolWeight, scale: UIImage.SymbolScale) -> UIImage? {
        var config = UIImage.SymbolConfiguration(weight: weight)
        let scaleConfig = UIImage.SymbolConfiguration(scale: scale)
        config = config.applying(scaleConfig)
        var image = UIImage(systemName: systemName, withConfiguration: config)
        image = image?.withTintColor(color, renderingMode: .alwaysOriginal)
        return image
    }
}
