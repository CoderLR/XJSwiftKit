//
//  UISlider+Extension.swift
//  XJSwiftKit
//
//  Created by Mr.Yang on 2021/10/20.
//

import Foundation

//MARK:- 一、基本的扩展
public extension XJExtension where Base: UISlider {
    
    /// 颜色创建UISlider
    /// - Parameters:
    ///   - bgColor: 背景颜色
    ///   - minimumValue: 最小值
    ///   - maximumValue: 最大值
    ///   - minimumTrackTintColor: 未经滑动的颜色
    ///   - maximumTrackTintColor: 滑动过的颜色
    ///   - thumbTintColor: 圆点颜色
    /// - Returns: UISlider
    static func create(bgColor: UIColor = UIColor.clear,
                       minimumValue: Float = 0,
                       maximumValue: Float = 100,
                       minimumTrackTintColor: UIColor = Color_System,
                       maximumTrackTintColor: UIColor = Color_999999_999999,
                       thumbTintColor: UIColor = Color_System) -> UIView {
        let slider = UISlider()
        slider.backgroundColor = bgColor
        slider.minimumValue = minimumValue
        slider.maximumValue = maximumValue
        slider.minimumTrackTintColor = minimumTrackTintColor
        slider.maximumTrackTintColor = maximumTrackTintColor
        slider.thumbTintColor = thumbTintColor
        return slider
    }
    
    /// 图片创建UISlider
    /// - Parameters:
    ///   - bgColor: 背景颜色
    ///   - minimumValue: 最大值
    ///   - maximumValue: 最小值
    ///   - minimumTrackImage: 未经滑动的图片
    ///   - maximumTrackImage: 滑动过的图片
    ///   - thumbImage: 圆点图片
    /// - Returns: UISlider
    static func create(bgColor: UIColor = UIColor.clear,
                       minimumValue: Float = 0,
                       maximumValue: Float = 100,
                       minimumTrackImage: UIImage,
                       maximumTrackImage: UIImage,
                       thumbImage: UIImage) -> UIView {
        let slider = UISlider()
        slider.backgroundColor = bgColor
        slider.minimumValue = minimumValue
        slider.maximumValue = maximumValue
        slider.setMinimumTrackImage(minimumTrackImage, for: .normal)
        slider.setMaximumTrackImage(maximumTrackImage, for: .normal)
        slider.setThumbImage(thumbImage, for: .normal)
        return slider
    }
}
