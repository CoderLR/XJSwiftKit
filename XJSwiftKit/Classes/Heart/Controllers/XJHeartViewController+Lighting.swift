//
//  XJHeartViewController+Lighting.swift
//  XJHeartLighting
//
//  Created by xj on 2021/11/8.
//

import Foundation

// MARK: - 各种点亮模式
extension XJHeartViewController {
    
    // MARK: - 连续亮
    
    /// 点亮一圈
    /// - Parameter:
    /// - isSpeed: 是否加速执行
    /// - clockwise: 顺时针
    /// - Returns: 是否完成
    @discardableResult
    func turnOnOneCircle(_ isSpeed: Bool = false, isClockwise: Bool = true) -> Bool {
        let index = loopIndex % heartView.allArray.count
        let loopNum = loopIndex / heartView.allArray.count
        
        print("\(loopIndex)---\(index)---\(loopNum)")
        
        // 循环一周
        if index == 0 && loopIndex != 0 {
            
            // 熄灭所有
            self.extinctAll()
            
            // 执行一次-该模式结束
            if !isSpeed == true { return true }
            
            // 下次循环时间
            let loopTime = timeInterval - Double(loopNum) * 0.05
            
            // 该模式结束
            if loopTime == 0 { return true }
            
            // 销毁旧定时器
            self.invalidateTimer()
            
            // 创新新定时器
            self.createTimer(loopTime, isFire: true)
        }
        
        if isClockwise {
            let view = heartView.allArray[index]
            view.backgroundColor = lightingColor
        } else {
            let view = heartView.allArray.reversed()[index]
            view.backgroundColor = lightingColor
        }
        loopIndex += 1
        return false
    }
    
    /// 点亮半圈
    /// - Parameter:
    /// - isSpeed: 是否加速执行
    /// - isUp: 从上面
    /// - Returns: 是否完成
    @discardableResult
    func turnOnHalfCircle(_ isSpeed: Bool = false, isClockwise: Bool = true) -> Bool {
        let index = loopIndex % heartView.leftArray.count
        let loopNum = loopIndex / heartView.leftArray.count
        
        print("\(loopIndex)---\(index)---\(loopNum)")
        
        // 循环一周
        if index == 0 && loopIndex != 0 {
            
            // 熄灭所有
            self.extinctAll()
            
            // 执行一次-该模式结束
            if !isSpeed == true { return true }
            
            // 下次循环时间
            let loopTime = timeInterval - Double(loopNum) * 0.05
            
            // 该模式结束
            if loopTime == 0 { return true }
            
            // 销毁旧定时器
            self.invalidateTimer()
            
            // 创新新定时器
            self.createTimer(loopTime, isFire: true)
        }
        if isClockwise {
            let leftView = heartView.leftArray[index]
            leftView.backgroundColor = lightingColor
            
            let rightView = heartView.rightArray[index]
            rightView.backgroundColor = lightingColor
        } else {
            let leftView = heartView.leftArray.reversed()[index]
            leftView.backgroundColor = lightingColor
            
            let rightView = heartView.rightArray.reversed()[index]
            rightView.backgroundColor = lightingColor
        }
        loopIndex += 1
        return false
    }
    
    /// 点亮1/4圈
    /// - Parameter:
    /// - isSpeed: 是否加速执行
    /// - isUp: 从上面
    /// - Returns: 是否完成
    @discardableResult
    func turnOnQuarter_1234_Circle(_ isSpeed: Bool = false, isClockwise: Bool = true) -> Bool {
        let index = loopIndex % heartView.rightUpArray.count
        let loopNum = loopIndex / heartView.rightUpArray.count
        
        print("\(loopIndex)---\(index)---\(loopNum)")
        
        // 循环一周
        if index == 0 && loopIndex != 0 {
            
            // 熄灭所有
            self.extinctAll()
            
            // 执行一次-该模式结束
            if !isSpeed == true { return true }
            
            // 下次循环时间
            let loopTime = timeInterval - Double(loopNum) * 0.05
            
            // 该模式结束
            if loopTime == 0 { return true }
            
            // 销毁旧定时器
            self.invalidateTimer()
            
            // 创新新定时器
            self.createTimer(loopTime, isFire: true)
        }
        
        if isClockwise {
            let rightUpView = heartView.rightUpArray[index]
            rightUpView.backgroundColor = lightingColor
            
            let rightDownView = heartView.rightDownArray[index]
            rightDownView.backgroundColor = lightingColor
            
            let leftUpView = heartView.leftUpArray[index]
            leftUpView.backgroundColor = lightingColor
            
            let leftDownView = heartView.leftDownArray[index]
            leftDownView.backgroundColor = lightingColor
        } else {
            let rightUpView = heartView.rightUpArray.reversed()[index]
            rightUpView.backgroundColor = lightingColor
            
            let rightDownView = heartView.rightDownArray.reversed()[index]
            rightDownView.backgroundColor = lightingColor
            
            let leftUpView = heartView.leftUpArray.reversed()[index]
            leftUpView.backgroundColor = lightingColor
            
            let leftDownView = heartView.leftDownArray.reversed()[index]
            leftDownView.backgroundColor = lightingColor
        }
        loopIndex += 1
        return false
    }
    
    /// 点亮1/4 一三象限对角亮
    /// - Parameter:
    /// - isSpeed: 是否加速执行
    /// - isUp: 从上面
    /// - Returns: 是否完成
    @discardableResult
    func turnOnQuarter_13_Circle(_ isSpeed: Bool = false, isClockwise: Bool = true) -> Bool {
        let index = loopIndex % heartView.rightUpArray.count
        let loopNum = loopIndex / heartView.rightUpArray.count
        
        print("\(loopIndex)---\(index)---\(loopNum)")
        
        // 循环一周
        if index == 0 && loopIndex != 0 {
            
            // 熄灭所有
            self.extinctAll()
            
            // 执行一次-该模式结束
            if !isSpeed == true { return true }
            
            // 下次循环时间
            let loopTime = timeInterval - Double(loopNum) * 0.05
            
            // 该模式结束
            if loopTime == 0 { return true }
            
            // 销毁旧定时器
            self.invalidateTimer()
            
            // 创新新定时器
            self.createTimer(loopTime, isFire: true)
        }
        if isClockwise {
            let leftView = heartView.leftDownArray[index]
            leftView.backgroundColor = lightingColor
            
            let rightView = heartView.rightUpArray[index]
            rightView.backgroundColor = lightingColor
        } else {
            let leftView = heartView.leftDownArray.reversed()[index]
            leftView.backgroundColor = lightingColor
            
            let rightView = heartView.rightUpArray.reversed()[index]
            rightView.backgroundColor = lightingColor
        }
        loopIndex += 1
        return false
    }
    
    /// 点亮1/4 二四象限对角亮
    /// - Parameter:
    /// - isSpeed: 是否加速执行
    /// - isUp: 从上面
    /// - Returns: 是否完成
    @discardableResult
    func turnOnQuarter_24_Circle(_ isSpeed: Bool = false, isClockwise: Bool = true) -> Bool {
        let index = loopIndex % heartView.rightDownArray.count
        let loopNum = loopIndex / heartView.rightDownArray.count
        
        print("\(loopIndex)---\(index)---\(loopNum)")
        
        // 循环一周
        if index == 0 && loopIndex != 0 {
            
            // 熄灭所有
            self.extinctAll()
            
            // 执行一次-该模式结束
            if !isSpeed == true { return true }
            
            // 下次循环时间
            let loopTime = timeInterval - Double(loopNum) * 0.05
            
            // 该模式结束
            if loopTime == 0 { return true }
            
            // 销毁旧定时器
            self.invalidateTimer()
            
            // 创新新定时器
            self.createTimer(loopTime, isFire: true)
        }
        if isClockwise {
            let leftView = heartView.leftUpArray[index]
            leftView.backgroundColor = lightingColor
            
            let rightView = heartView.rightDownArray[index]
            rightView.backgroundColor = lightingColor
        } else {
            let leftView = heartView.leftUpArray.reversed()[index]
            leftView.backgroundColor = lightingColor
            
            let rightView = heartView.rightDownArray.reversed()[index]
            rightView.backgroundColor = lightingColor
        }
        loopIndex += 1
        return false
    }
    
    /// 点亮1/4 一四象限对角亮
    /// - Parameter:
    /// - isSpeed: 是否加速执行
    /// - isUp: 从上面
    /// - Returns: 是否完成
    @discardableResult
    func turnOnQuarter_14_Circle(_ isSpeed: Bool = false, isClockwise: Bool = true) -> Bool {
        let index = loopIndex % heartView.rightUpArray.count
        let loopNum = loopIndex / heartView.rightUpArray.count
        
        print("\(loopIndex)---\(index)---\(loopNum)")
        
        // 循环一周
        if index == 0 && loopIndex != 0 {
            
            // 熄灭所有
            self.extinctAll()
            
            // 执行一次-该模式结束
            if !isSpeed == true { return true }
            
            // 下次循环时间
            let loopTime = timeInterval - Double(loopNum) * 0.05
            
            // 该模式结束
            if loopTime == 0 { return true }
            
            // 销毁旧定时器
            self.invalidateTimer()
            
            // 创新新定时器
            self.createTimer(loopTime, isFire: true)
        }
        if isClockwise {
            let leftView = heartView.leftUpArray[index]
            leftView.backgroundColor = lightingColor
            
            let rightView = heartView.rightUpArray[index]
            rightView.backgroundColor = lightingColor
        } else {
            let leftView = heartView.leftUpArray.reversed()[index]
            leftView.backgroundColor = lightingColor
            
            let rightView = heartView.rightUpArray.reversed()[index]
            rightView.backgroundColor = lightingColor
        }
        loopIndex += 1
        return false
    }
    
    /// 点亮1/4 二三象限对角亮
    /// - Parameter:
    /// - isSpeed: 是否加速执行
    /// - isUp: 从上面
    /// - Returns: 是否完成
    @discardableResult
    func turnOnQuarter_23_Circle(_ isSpeed: Bool = false, isClockwise: Bool = true) -> Bool {
        let index = loopIndex % heartView.rightDownArray.count
        let loopNum = loopIndex / heartView.rightDownArray.count
        
        print("\(loopIndex)---\(index)---\(loopNum)")
        
        // 循环一周
        if index == 0 && loopIndex != 0 {
            
            // 熄灭所有
            self.extinctAll()
            
            // 执行一次-该模式结束
            if !isSpeed == true { return true }
            
            // 下次循环时间
            let loopTime = timeInterval - Double(loopNum) * 0.05
            
            // 该模式结束
            if loopTime == 0 { return true }
            
            // 销毁旧定时器
            self.invalidateTimer()
            
            // 创新新定时器
            self.createTimer(loopTime, isFire: true)
        }
        if isClockwise {
            let leftView = heartView.leftDownArray[index]
            leftView.backgroundColor = lightingColor
            
            let rightView = heartView.rightDownArray[index]
            rightView.backgroundColor = lightingColor
        } else {
            let leftView = heartView.leftDownArray.reversed()[index]
            leftView.backgroundColor = lightingColor
            
            let rightView = heartView.rightDownArray.reversed()[index]
            rightView.backgroundColor = lightingColor
        }
        loopIndex += 1
        return false
    }
    
    // MARK: - 一个接一个亮
    
    /// 点亮一圈 一个接一个
    /// - Parameter:
    /// - isSpeed: 是否加速执行
    /// - clockwise: 顺时针
    /// - Returns: 是否完成
    @discardableResult
    func turnOnOneCircleOneByOne(_ isSpeed: Bool = false, isClockwise: Bool = true) -> Bool {
        let index = loopIndex % heartView.allArray.count
        let loopNum = loopIndex / heartView.allArray.count
        
        print("\(loopIndex)---\(index)---\(loopNum)")
        
        // 循环一周
        if index == 0 && loopIndex != 0 {
            
            // 熄灭所有
            self.extinctAll()
            
            // 执行一次-该模式结束
            if !isSpeed == true { return true }
            
            // 下次循环时间
            let loopTime = timeInterval - Double(loopNum) * 0.05
            
            // 该模式结束
            if loopTime == 0 { return true }
            
            // 销毁旧定时器
            self.invalidateTimer()
            
            // 创新新定时器
            self.createTimer(loopTime, isFire: true)
        }
        
        if isClockwise {
            let view = heartView.allArray[index]
            tempView?.backgroundColor = extinctColor
            view.backgroundColor = lightingColor
            tempView = view
        } else {
            let view = heartView.allArray.reversed()[index]
            tempView?.backgroundColor = extinctColor
            view.backgroundColor = lightingColor
            tempView = view
        }
        loopIndex += 1
        return false
    }
    
    /// 点亮半圈 一个接一个
    /// - Parameter:
    /// - isSpeed: 是否加速执行
    /// - isUp: 从上面
    /// - Returns: 是否完成
    @discardableResult
    func turnOnHalfCircleOneByOne(_ isSpeed: Bool = false, isClockwise: Bool = true) -> Bool {
        let index = loopIndex % heartView.leftArray.count
        let loopNum = loopIndex / heartView.leftArray.count
        
        print("\(loopIndex)---\(index)---\(loopNum)")
        
        // 循环一周
        if index == 0 && loopIndex != 0 {
            
            // 熄灭所有
            self.extinctAll()
            
            // 执行一次-该模式结束
            if !isSpeed == true { return true }
            
            // 下次循环时间
            let loopTime = timeInterval - Double(loopNum) * 0.05
            
            // 该模式结束
            if loopTime == 0 { return true }
            
            // 销毁旧定时器
            self.invalidateTimer()
            
            // 创新新定时器
            self.createTimer(loopTime, isFire: true)
        }
        if isClockwise {
            let leftView = heartView.leftArray[index]
            tempLeftView?.backgroundColor = extinctColor
            leftView.backgroundColor = lightingColor
            tempLeftView = leftView
            
            let rightView = heartView.rightArray[index]
            tempRightView?.backgroundColor = extinctColor
            rightView.backgroundColor = lightingColor
            tempRightView = rightView
        } else {
            let leftView = heartView.leftArray.reversed()[index]
            tempLeftView?.backgroundColor = extinctColor
            leftView.backgroundColor = lightingColor
            tempLeftView = leftView
            
            let rightView = heartView.rightArray.reversed()[index]
            tempRightView?.backgroundColor = extinctColor
            rightView.backgroundColor = lightingColor
            tempRightView = rightView
        }
        loopIndex += 1
        return false
    }
    
    /// 点亮1/4圈 一个接一个
    /// - Parameter:
    /// - isSpeed: 是否加速执行
    /// - isUp: 从上面
    /// - Returns: 是否完成
    @discardableResult
    func turnOnQuarter_1234_CircleOneByOne(_ isSpeed: Bool = false, isClockwise: Bool = true) -> Bool {
        let index = loopIndex % heartView.rightUpArray.count
        let loopNum = loopIndex / heartView.rightUpArray.count
        
        print("\(loopIndex)---\(index)---\(loopNum)")
        
        // 循环一周
        if index == 0 && loopIndex != 0 {
            
            // 熄灭所有
            self.extinctAll()
            
            // 执行一次-该模式结束
            if !isSpeed == true { return true }
            
            // 下次循环时间
            let loopTime = timeInterval - Double(loopNum) * 0.05
            
            // 该模式结束
            if loopTime == 0 { return true }
            
            // 销毁旧定时器
            self.invalidateTimer()
            
            // 创新新定时器
            self.createTimer(loopTime, isFire: true)
        }
        
        if isClockwise {
            let rightUpView = heartView.rightUpArray[index]
            tempRightUpView?.backgroundColor = extinctColor
            rightUpView.backgroundColor = lightingColor
            tempRightUpView = rightUpView
            
            let rightDownView = heartView.rightDownArray[index]
            tempRightDownView?.backgroundColor = extinctColor
            rightDownView.backgroundColor = lightingColor
            tempRightDownView = rightDownView
            
            let leftUpView = heartView.leftUpArray[index]
            tempLeftUpView?.backgroundColor = extinctColor
            leftUpView.backgroundColor = lightingColor
            tempLeftUpView = leftUpView
            
            let leftDownView = heartView.leftDownArray[index]
            tempLeftDownView?.backgroundColor = extinctColor
            leftDownView.backgroundColor = lightingColor
            tempLeftDownView = leftDownView
        } else {
            let rightUpView = heartView.rightUpArray.reversed()[index]
            tempRightUpView?.backgroundColor = extinctColor
            rightUpView.backgroundColor = lightingColor
            tempRightUpView = rightUpView
            
            let rightDownView = heartView.rightDownArray.reversed()[index]
            tempRightDownView?.backgroundColor = extinctColor
            rightDownView.backgroundColor = lightingColor
            tempRightDownView = rightDownView
            
            let leftUpView = heartView.leftUpArray.reversed()[index]
            tempLeftUpView?.backgroundColor = extinctColor
            leftUpView.backgroundColor = lightingColor
            tempLeftUpView = leftUpView
            
            let leftDownView = heartView.leftDownArray.reversed()[index]
            tempLeftDownView?.backgroundColor = extinctColor
            leftDownView.backgroundColor = lightingColor
            tempLeftDownView = leftDownView
        }
        loopIndex += 1
        return false
    }
    
    /// 点亮1/4 一三象限对角亮  一个接一个
    /// - Parameter:
    /// - isSpeed: 是否加速执行
    /// - isUp: 从上面
    /// - Returns: 是否完成
    @discardableResult
    func turnOnQuarter_13_CircleOneByOne(_ isSpeed: Bool = false, isClockwise: Bool = true) -> Bool {
        let index = loopIndex % heartView.rightUpArray.count
        let loopNum = loopIndex / heartView.rightUpArray.count
        
        print("\(loopIndex)---\(index)---\(loopNum)")
        
        // 循环一周
        if index == 0 && loopIndex != 0 {
            
            // 熄灭所有
            self.extinctAll()
            
            // 执行一次-该模式结束
            if !isSpeed == true { return true }
            
            // 下次循环时间
            let loopTime = timeInterval - Double(loopNum) * 0.05
            
            // 该模式结束
            if loopTime == 0 { return true }
            
            // 销毁旧定时器
            self.invalidateTimer()
            
            // 创新新定时器
            self.createTimer(loopTime, isFire: true)
        }
        if isClockwise {
            let leftView = heartView.leftDownArray[index]
            tempLeftView?.backgroundColor = extinctColor
            leftView.backgroundColor = lightingColor
            tempLeftView = leftView
            
            let rightView = heartView.rightUpArray[index]
            tempRightView?.backgroundColor = extinctColor
            rightView.backgroundColor = lightingColor
            tempRightView = rightView
        } else {
            let leftView = heartView.leftDownArray.reversed()[index]
            tempLeftView?.backgroundColor = extinctColor
            leftView.backgroundColor = lightingColor
            tempLeftView = leftView
            
            let rightView = heartView.rightUpArray.reversed()[index]
            tempRightView?.backgroundColor = extinctColor
            rightView.backgroundColor = lightingColor
            tempRightView = rightView
        }
        loopIndex += 1
        return false
    }
    
    /// 点亮1/4 二四象限对角亮 一个接一个
    /// - Parameter:
    /// - isSpeed: 是否加速执行
    /// - isUp: 从上面
    /// - Returns: 是否完成
    @discardableResult
    func turnOnQuarter_24_CircleOneByOne(_ isSpeed: Bool = false, isClockwise: Bool = true) -> Bool {
        let index = loopIndex % heartView.rightDownArray.count
        let loopNum = loopIndex / heartView.rightDownArray.count
        
        print("\(loopIndex)---\(index)---\(loopNum)")
        
        // 循环一周
        if index == 0 && loopIndex != 0 {
            
            // 熄灭所有
            self.extinctAll()
            
            // 执行一次-该模式结束
            if !isSpeed == true { return true }
            
            // 下次循环时间
            let loopTime = timeInterval - Double(loopNum) * 0.05
            
            // 该模式结束
            if loopTime == 0 { return true }
            
            // 销毁旧定时器
            self.invalidateTimer()
            
            // 创新新定时器
            self.createTimer(loopTime, isFire: true)
        }
        if isClockwise {
            let leftView = heartView.leftUpArray[index]
            tempLeftView?.backgroundColor = extinctColor
            leftView.backgroundColor = lightingColor
            tempLeftView = leftView
            
            let rightView = heartView.rightDownArray[index]
            tempRightView?.backgroundColor = extinctColor
            rightView.backgroundColor = lightingColor
            tempRightView = rightView
        } else {
            let leftView = heartView.leftUpArray.reversed()[index]
            tempLeftView?.backgroundColor = extinctColor
            leftView.backgroundColor = lightingColor
            tempLeftView = leftView
            
            let rightView = heartView.rightDownArray.reversed()[index]
            tempRightView?.backgroundColor = extinctColor
            rightView.backgroundColor = lightingColor
            tempRightView = rightView
        }
        loopIndex += 1
        return false
    }
    
    /// 点亮1/4 一四象限对角亮 一个接一个
    /// - Parameter:
    /// - isSpeed: 是否加速执行
    /// - isUp: 从上面
    /// - Returns: 是否完成
    @discardableResult
    func turnOnQuarter_14_CircleOneByOne(_ isSpeed: Bool = false, isClockwise: Bool = true) -> Bool {
        let index = loopIndex % heartView.rightUpArray.count
        let loopNum = loopIndex / heartView.rightUpArray.count
        
        print("\(loopIndex)---\(index)---\(loopNum)")
        
        // 循环一周
        if index == 0 && loopIndex != 0 {
            
            // 熄灭所有
            self.extinctAll()
            
            // 执行一次-该模式结束
            if !isSpeed == true { return true }
            
            // 下次循环时间
            let loopTime = timeInterval - Double(loopNum) * 0.05
            
            // 该模式结束
            if loopTime == 0 { return true }
            
            // 销毁旧定时器
            self.invalidateTimer()
            
            // 创新新定时器
            self.createTimer(loopTime, isFire: true)
        }
        if isClockwise {
            let leftView = heartView.leftUpArray[index]
            tempLeftView?.backgroundColor = extinctColor
            leftView.backgroundColor = lightingColor
            tempLeftView = leftView
            
            let rightView = heartView.rightUpArray[index]
            tempRightView?.backgroundColor = extinctColor
            rightView.backgroundColor = lightingColor
            tempRightView = rightView
        } else {
            let leftView = heartView.leftUpArray.reversed()[index]
            tempLeftView?.backgroundColor = extinctColor
            leftView.backgroundColor = lightingColor
            tempLeftView = leftView
            
            let rightView = heartView.rightUpArray.reversed()[index]
            tempRightView?.backgroundColor = extinctColor
            rightView.backgroundColor = lightingColor
            tempRightView = rightView
        }
        loopIndex += 1
        return false
    }
    
    /// 点亮1/4 二三象限对角亮 一个接一个
    /// - Parameter:
    /// - isSpeed: 是否加速执行
    /// - isUp: 从上面
    /// - Returns: 是否完成
    @discardableResult
    func turnOnQuarter_23_CircleOneByOne(_ isSpeed: Bool = false, isClockwise: Bool = true) -> Bool {
        let index = loopIndex % heartView.rightDownArray.count
        let loopNum = loopIndex / heartView.rightDownArray.count
        
        print("\(loopIndex)---\(index)---\(loopNum)")
        
        // 循环一周
        if index == 0 && loopIndex != 0 {
            
            // 熄灭所有
            self.extinctAll()
            
            // 执行一次-该模式结束
            if !isSpeed == true { return true }
            
            // 下次循环时间
            let loopTime = timeInterval - Double(loopNum) * 0.05
            
            // 该模式结束
            if loopTime == 0 { return true }
            
            // 销毁旧定时器
            self.invalidateTimer()
            
            // 创新新定时器
            self.createTimer(loopTime, isFire: true)
        }
        if isClockwise {
            let leftView = heartView.leftDownArray[index]
            tempLeftView?.backgroundColor = extinctColor
            leftView.backgroundColor = lightingColor
            tempLeftView = leftView
            
            let rightView = heartView.rightDownArray[index]
            tempRightView?.backgroundColor = extinctColor
            rightView.backgroundColor = lightingColor
            tempRightView = rightView
        } else {
            let leftView = heartView.leftDownArray.reversed()[index]
            tempLeftView?.backgroundColor = extinctColor
            leftView.backgroundColor = lightingColor
            tempLeftView = leftView
            
            let rightView = heartView.rightDownArray.reversed()[index]
            tempRightView?.backgroundColor = extinctColor
            rightView.backgroundColor = lightingColor
            tempRightView = rightView
        }
        loopIndex += 1
        return false
    }
}
