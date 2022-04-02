//
//  UISwitch+Extension.swift
//  ShiJianYun
//
//  Created by Mr.Yang on 2021/10/19.
//

import Foundation

// MARK: - Create
public extension XJExtension where Base: UISwitch {
    
    static func create(onTintColor: UIColor = Color_System) -> UISwitch {
        let sw = UISwitch()
        sw.onTintColor = onTintColor
        return sw
    }
}
