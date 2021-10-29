//
//  XJAppConst.swift
//  XJSwiftKit
//
//  Created by Mr.Yang on 2021/4/14.
//

import Foundation

// MARK: - 定义计算常量

// Screen width
let KScreenW: CGFloat = UIScreen.main.bounds.width

// Screen height
let KScreenH: CGFloat = UIScreen.main.bounds.height

// Screen scale
let KScale: CGFloat = UIScreen.main.scale

// StatusBar
let KStatusBarH: CGFloat = UIApplication.shared.statusBarFrame.height

// Navbar
let KNavBarH: CGFloat = KStatusBarH + 44

// TabBar
let KTabBarH: CGFloat  = filletScreen() ? (34 + 49) : 49

// HomeBar
let KHomeBarH: CGFloat = filletScreen() ? 34 : 0
