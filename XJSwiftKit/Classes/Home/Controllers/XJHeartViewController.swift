//
//  XJHeartViewController.swift
//  XJSwiftKit
//
//  Created by xj on 2021/11/8.
//

import UIKit

/// 循环次数
var loopIndex: Int = 0
/// 循环时间
var timeInterval: TimeInterval = 0.2
// 熄灭颜色
let extinctColor = UIColor.black
// 点亮颜色
let lightingColor = UIColor.red

// MARK: - 点亮模式
enum XJHeartMode {
    
    // 点亮一圈
    case one_clockwise_all    // 顺时针一圈连续
    case one_anticlockwise_all // 逆时针一圈连续
    case one_clockwise_one      // 顺时针一圈一个接一个
    case one_anticlockwise_one  // 逆时针一圈一个接一个
    
    // 点亮半圈
    case half_clockwise_all
    case half_anticlockwise_all
    case half_clockwise_one
    case half_anticlockwise_one
    
    // 点亮1234象限
    case quarter1234_clockwise_all
    case quarter1234_anticlockwise_all
    case quarter1234_clockwise_aone
    case quarter1234_anticlockwise_one
    
    // 点亮13象限
    case quarter13_clockwise_all
    case quarter13_anticlockwise_all
    case quarter13_clockwise_aone
    case quarter13_anticlockwise_one
    
    // 点亮24象限
    case quarter24_clockwise_all
    case quarter24_anticlockwise_all
    case quarter24_clockwise_aone
    case quarter24_anticlockwise_one
    
    // 点亮14象限
    case quarter14_clockwise_all
    case quarter14_anticlockwise_all
    case quarter14_clockwise_aone
    case quarter14_anticlockwise_one
    
    // 点亮23象限
    case quarter23_clockwise_all
    case quarter23_anticlockwise_all
    case quarter23_clockwise_aone
    case quarter23_anticlockwise_one
    
    case allin_allout
    case left_right
    case top_bottom
    case leftup_rightbottom
    case rightup_leftbottom
    case odd_even
}

// MARK: - 控制器
class XJHeartViewController: XJBaseViewController {
    
    lazy var heartView: XJHeartView = {
        let heart = XJHeartView(frame: self.view.bounds)
        return heart
    }()
    
    /// 定时器
    var timer: Timer?
    var switchTimer: Timer?
    
    /// 点亮模式
    var heartMode: XJHeartMode = .one_clockwise_all
    
    /// one by one
    var tempView: UIView?
    var tempLeftView: UIView?
    var tempRightView: UIView?
    var tempLeftUpView: UIView?
    var tempLeftDownView: UIView?
    var tempRightUpView: UIView?
    var tempRightDownView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loopIndex = 0
        self.title = "流水灯"
        
        self.view.addSubview(heartView)
        
        self.createTimer(timeInterval, isFire: false)
    }
    
    /// 创建定时器
    func createTimer(_ timeInterval: TimeInterval, isFire: Bool) {
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) {[weak self] (timer) in
            guard let self = self else { return }
            
            self.executionTimer()
        }
        if !isFire {
            timer?.fireDate = .distantFuture
        }
        
    }
    
    /// 销毁定时器
    func invalidateTimer() {
        guard let timer = timer else { return }
        timer.invalidate()
    }
    
    /// 创建定时器--用于切换
    func createSwitchTimer(_ timeInterval: TimeInterval) {
        switchTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) {[weak self] (timer) in
            guard let self = self else { return }
            
            self.executionTimer()
        }
    }
    
    /// 销毁定时器--用于切换
    func invalidateSwitchTimer() {
        guard let switchTimer = switchTimer else { return }
        switchTimer.invalidate()
    }
    
    /// 触发定时器
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        timer?.fireDate = .distantPast
    }
    
    /// 点击返回
    override func backBtnClick(_ button: UIButton) {
        self.invalidateTimer()
        self.invalidateSwitchTimer()
        super.backBtnClick(button)
    }
    
    /// 设置模式
    func setNextMode(_ heartMode: XJHeartMode) {
    
        // 清空标识
        loopIndex = 0
        
        // 设置新模式
        self.heartMode = heartMode
        
        // 销毁切换定时器
        self.invalidateSwitchTimer()
        
        // 销毁旧定时器
        self.invalidateTimer()
        
        // 创新新定时器
        if heartMode == .allin_allout || heartMode == .left_right || heartMode == .top_bottom || heartMode == .leftup_rightbottom || heartMode == .rightup_leftbottom || heartMode == .odd_even {
            
            self.createSwitchTimer(1.0)
        } else {
            self.createTimer(timeInterval, isFire: true)
        }
    }
    
    /// 执行定时器
    func executionTimer() {
        
        self.personalizedDesignLighting()
    }

}

// MARK: - 个性化设计点亮方式
extension XJHeartViewController {
    /*
     1.顺时针一圈-加速
     2.顺时针半圈-加速
     3.逆时针半圈
     4.1234象限顺时针点亮
     5.1234象限逆时针点亮
     6.点亮与熄灭执行3次
     7.顺时针一圈-一个-加速
     8.逆时针半圈-一个
     9.左右切换3次
     10.奇偶切换5次
     11.上下切换3次
     12.13象限顺时针点亮
     13.右上左下切换3次
     14.24象限顺时针点亮
     15.左上右下切换3次
     ----------->循环
     */
    
    /// 设计点亮个性化特效
    func personalizedDesignLighting() {
        // 1.顺时针一圈-加速
        if heartMode == .one_clockwise_all {
            if turnOnOneCircle(true, isClockwise: true) {
                self.setNextMode(.half_clockwise_all)
//                self.setNextMode(.left_right)
            }
        // 2.顺时针半圈-加速
        } else if heartMode == .half_clockwise_all {
            if turnOnHalfCircle(true, isClockwise: true) {
                self.setNextMode(.half_anticlockwise_all)
            }
        // 3.逆时针半圈
        } else if heartMode == .half_anticlockwise_all {
            if turnOnHalfCircle(false, isClockwise: false) {
                self.setNextMode(.quarter1234_clockwise_all)
            }
        // 4.1234象限顺时针点亮
        } else if heartMode == .quarter1234_clockwise_all {
            if turnOnQuarter_1234_Circle(false, isClockwise: true) {
                self.setNextMode(.quarter1234_anticlockwise_all)
            }
        // 5.1234象限逆时针点亮
        } else if heartMode == .quarter1234_anticlockwise_all {
            if turnOnQuarter_1234_Circle(false, isClockwise: false) {
                self.setNextMode(.allin_allout)
            }
        // 6.点亮与熄灭执行3次
        } else if heartMode == .allin_allout {
            if switchLightingAndExtinct(number: 3) {
                self.setNextMode(.one_clockwise_one)
            }
        // 7.顺时针一圈-一个-加速
        } else if heartMode == .one_clockwise_one {
            if turnOnOneCircleOneByOne(true, isClockwise: true) {
                self.setNextMode(.half_anticlockwise_one)
            }
        // 8.逆时针半圈-一个
        } else if heartMode == .half_anticlockwise_one {
            if turnOnHalfCircleOneByOne(false, isClockwise: false) {
                self.setNextMode(.left_right)
            }
        // 9.左右切换3次
        } else if heartMode == .left_right {
            if switchLeftAndRight(number: 3) {
                self.setNextMode(.odd_even)
            }
        // 10.奇偶切换5次
        } else if heartMode == .odd_even {
            if switchOddAndEven(number: 5) {
                self.setNextMode(.top_bottom)
            }
        // 11.上下切换3次
        } else if heartMode == .top_bottom {
            if switch14And23(number: 3) {
                self.setNextMode(.quarter13_clockwise_all)
            }
        // 12.13象限顺时针点亮
        } else if heartMode == .quarter13_clockwise_all {
            if turnOnQuarter_13_Circle(false, isClockwise: true) {
                self.setNextMode(.rightup_leftbottom)
            }
        // 13.右上左下切换3次
        } else if heartMode == .rightup_leftbottom {
            if switch13And24(number: 3) {
                self.setNextMode(.quarter24_clockwise_all)
            }
        // 14.24象限顺时针点亮
        } else if heartMode == .quarter24_clockwise_all {
            if turnOnQuarter_24_Circle(false, isClockwise: true) {
                self.setNextMode(.leftup_rightbottom)
            }
        // 15.左上右下切换3次
        } else if heartMode == .leftup_rightbottom {
            if switch13And24(number: 3) {
                // 循环第一步
                self.setNextMode(.one_clockwise_all)
            }
        }
    }
}

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
