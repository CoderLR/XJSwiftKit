//
//  XJHeartViewController+Mode.swift
//  XJHeartLighting
//
//  Created by xj on 2021/11/8.
//

import Foundation

// MARK: - 常亮控制闪烁
extension XJHeartViewController {
    
    /// 全亮与全灭切换
    func switchLightingAndExtinct(number: Int) -> Bool {
        
        if loopIndex % 2 == 0 {
            lightingAll()
        } else {
            extinctAll()
        }
        
        if loopIndex == number * 2 - 1 {
            // 熄灭所有
            self.extinctAll()
            return true
        }
        
        loopIndex += 1
        return false
    }
    
    /// 左右切换
    func switchLeftAndRight(number: Int) -> Bool {
        
        if loopIndex % 2 == 0 {
            lightingLeftHalf()
        } else {
            lightingRightHalf()
        }
        
        if loopIndex == number * 2 - 1 {
            // 熄灭所有
            self.extinctAll()
            return true
        }
        
        loopIndex += 1
        return false
    }
    
    /// 奇偶切换
    func switchOddAndEven(number: Int) -> Bool {
        
        if loopIndex % 2 == 0 {
            lightingOdd()
        } else {
            lightingEven()
        }
        
        if loopIndex == number * 2 - 1 {
            // 熄灭所有
            self.extinctAll()
            return true
        }
        
        loopIndex += 1
        return false
    }
    
    /// 1324切换
    func switch13And24(number: Int) -> Bool {
        
        if loopIndex % 2 == 0 {
            lightingquarter13()
        } else {
            lightingquarter24()
        }
        
        if loopIndex == number * 2 - 1 {
            // 熄灭所有
            self.extinctAll()
            return true
        }
        
        loopIndex += 1
        return false
    }
    
    /// 1423切换
    func switch14And23(number: Int) -> Bool {
        
        if loopIndex % 2 == 0 {
            lightingquarter14()
        } else {
            lightingquarter24()
        }
        
        if loopIndex == number * 2 - 1 {
            // 熄灭所有
            self.extinctAll()
            return true
        }
        
        loopIndex += 1
        return false
    }
}


// MARK: - 常亮控制
extension XJHeartViewController {
    
    /// 点亮所有
    func lightingAll() {
        for view in heartView.allArray {
            view.backgroundColor = lightingColor
        }
    }
    
    /// 熄灭所有
    func extinctAll() {
        for view in heartView.allArray {
            view.backgroundColor = extinctColor
        }
    }
    
    /// 点亮奇数
    func lightingOdd() {
        for i in 0..<heartView.allArray.count {
            let view = heartView.allArray[i]
            if i % 2 == 1 {
                view.backgroundColor = lightingColor
            } else {
                view.backgroundColor = extinctColor
            }
        }
    }
    
    /// 点亮偶数
    func lightingEven() {
        for i in 0..<heartView.allArray.count {
            let view = heartView.allArray[i]
            if i % 2 == 0 {
                view.backgroundColor = lightingColor
            } else {
                view.backgroundColor = extinctColor
            }
        }
    }
    
    /// 点亮左半边
    func lightingLeftHalf() {
        for view in heartView.leftArray {
            view.backgroundColor = lightingColor
        }
        for view in heartView.rightArray {
            view.backgroundColor = extinctColor
        }
    }
    
    /// 点亮右半边
    func lightingRightHalf() {
        for view in heartView.rightArray {
            view.backgroundColor = lightingColor
        }
        for view in heartView.leftArray {
            view.backgroundColor = extinctColor
        }
    }
    
    /// 点亮13象限
    func lightingquarter13() {
        for view in heartView.rightUpArray {
            view.backgroundColor = lightingColor
        }
        
        for view in heartView.leftDownArray {
            view.backgroundColor = lightingColor
        }
        for view in heartView.rightDownArray {
            view.backgroundColor = extinctColor
        }
        
        for view in heartView.leftUpArray {
            view.backgroundColor = extinctColor
        }
    }
    
    /// 点亮24象限
    func lightingquarter24() {

        for view in heartView.rightDownArray {
            view.backgroundColor = lightingColor
        }
        
        for view in heartView.leftUpArray {
            view.backgroundColor = lightingColor
        }
        for view in heartView.rightUpArray {
            view.backgroundColor = extinctColor
        }
        
        for view in heartView.leftDownArray {
            view.backgroundColor = extinctColor
        }
    }
    
    /// 点亮14象限
    func lightingquarter14() {

        for view in heartView.rightUpArray {
            view.backgroundColor = lightingColor
        }
        
        for view in heartView.leftUpArray {
            view.backgroundColor = lightingColor
        }
        for view in heartView.rightDownArray {
            view.backgroundColor = extinctColor
        }
        
        for view in heartView.leftDownArray {
            view.backgroundColor = extinctColor
        }
    }
    
    /// 点亮23象限
    func lightingquarter23() {
        for view in heartView.rightDownArray {
            view.backgroundColor = lightingColor
        }
        
        for view in heartView.leftDownArray {
            view.backgroundColor = lightingColor
        }
        for view in heartView.rightUpArray {
            view.backgroundColor = extinctColor
        }
        
        for view in heartView.leftUpArray {
            view.backgroundColor = extinctColor
        }
    }
}
