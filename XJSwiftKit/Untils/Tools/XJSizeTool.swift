//
//  XJSizeTool.swift
//  XJSwiftKit
//
//  Created by Mr.Yang on 2021/10/13.
//

import Foundation


/// 获取屏幕宽度
/// - Returns: width
func screenWidth() -> CGFloat {
    let width = UIScreen.main.bounds.size.width
    return width
}

/// 获取屏幕高度
/// - Returns: height
func screenHeight() -> CGFloat {
    let height = UIScreen.main.bounds.size.height
    return height
}

/// 导航栏高度
/// - Returns: height
func navBarHeight() -> CGFloat {
    return KStatusBarH + 44
}

/// homeBar高度
/// - Returns: height
func homeBarHeight() -> CGFloat {
    if filletScreen() {
        return 49 + 34
    }
    return 49
}

/// 圆角屏幕
/// - Returns: Bool
func filletScreen() -> Bool {
    if screenHeight() == 812 ||
       screenHeight() == 896 ||
       screenHeight() == 780 ||
       screenHeight() == 844 ||
       screenHeight() == 926 { return true }
    return false
}
