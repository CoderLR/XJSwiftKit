//
//  XJHeartViewController.swift
//  ShiJianYun
//
//  Created by xj on 2021/11/8.
//

import UIKit

/// 循环次数
var loopIndex: Int = 0
/// 循环时间
var timeInterval: TimeInterval = 0.2
/// 切换时间
var switchTimeInterval: TimeInterval = 1.0
// 熄灭颜色
let extinctColor = UIColor.black
// 点亮颜色
let lightingColor = UIColor.red

// MARK: - 点亮模式
enum XJHeartMode: Int {
    
    // 点亮一圈
    case one_clockwise_all              // 顺时针一圈连续
    case one_anticlockwise_all          // 顺时针一圈连续
    case one_clockwise_one              // 顺时针一圈一个接一个
    case one_anticlockwise_one          // 逆时针一圈一个接一个
    
    // 点亮半圈
    case half_clockwise_all             // 从上至下半圈连续
    case half_anticlockwise_all         // 从下至上圈连续
    case half_clockwise_one             // 从上至下半圈一个接一个
    case half_anticlockwise_one         // 从下至上半圈一个接一个
    
    // 点亮1234象限
    case quarter1234_clockwise_all      // 顺时针全象限连续
    case quarter1234_anticlockwise_all  // 顺时针全象限连续
    case quarter1234_clockwise_one      // 顺时针全象限一个接一个
    case quarter1234_anticlockwise_one  // 逆时针全象限一个接一个
    
    // 点亮13象限
    case quarter13_clockwise_all        // 顺时针13象限连续
    case quarter13_anticlockwise_all    // 顺时针13象限连续
    case quarter13_clockwise_one        // 顺时针13象限一个接一个
    case quarter13_anticlockwise_one    // 逆时针13象限一个接一个
    
    // 点亮24象限
    case quarter24_clockwise_all        // 顺时针24象限连续
    case quarter24_anticlockwise_all    // 顺时针24象限连续
    case quarter24_clockwise_one        // 顺时针24象限一个接一个
    case quarter24_anticlockwise_one    // 逆时针24象限一个接一个
    
    // 点亮14象限
    case quarter14_clockwise_all        // 顺时针14象限连续
    case quarter14_anticlockwise_all    // 顺时针14象限连续
    case quarter14_clockwise_one        // 顺时针14象限一个接一个
    case quarter14_anticlockwise_one    // 逆时针14象限一个接一个
    
    // 点亮23象限
    case quarter23_clockwise_all        // 顺时针23象限连续
    case quarter23_anticlockwise_all    // 顺时针23象限连续
    case quarter23_clockwise_one        // 顺时针23象限一个接一个
    case quarter23_anticlockwise_one    // 逆时针23象限一个接一个
    
    // 亮熄切换
    case allin_allout                   // 全亮全熄切换
    case left_right                     // 左右切换
    case top_bottom                     // 上下切换
    case leftup_rightbottom             // 左上右下切换
    case rightup_leftbottom             // 右上左下切换
    case odd_even                       // 奇偶切换
}

extension XJHeartViewController {
    
    fileprivate func setupUI() {
        
        self.view.addSubview(heartView)
        
        self.view.addSubview(closeBtn)
        
        closeBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 44, height: 44))
            make.left.equalTo(10)
            make.top.equalTo(KStatusBarH)
        }
    }
    
    @objc func closeBtnClick(_ btn: UIButton) {
        self.dismiss(animated: true) {
            // 发送通知
            NotificationCenter.default.post(name: KCloseHeartViewNotify, object: nil, userInfo: nil)
        }
    }
}

// MARK: - 控制器
class XJHeartViewController: UIViewController {
    
    /// UI图
    lazy var closeBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.setImage(UIImage(named: "icon_hud_error"), for: .normal)
        button.addTarget(self, action: #selector(closeBtnClick(_:)), for: .touchUpInside)
        return button
    }()
    
    /// UI图
    lazy var heartView: XJHeartView = {
        let heart = XJHeartView(frame: self.view.bounds)
        return heart
    }()
    
    /// 定时器
    var timer: Timer?
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.extinctAll()
        loopIndex = 0
        self.heartMode = .one_clockwise_all
        timer?.fireDate = .distantFuture
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loopIndex = 0
        
        setupUI()
        
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
    
    /// 触发定时器
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        timer?.fireDate = .distantPast
    }
    
    /// 点击返回
    func backBtnClick(_ button: UIButton) {
        self.invalidateTimer()
    }
    
    /// 设置模式
    func setNextMode(_ heartMode: XJHeartMode) {
    
        // 清空标识
        loopIndex = 0
        
        // 设置新模式
        self.heartMode = heartMode
        
        // 销毁旧定时器
        self.invalidateTimer()
        
        // 创新新定时器
        let time = heartMode.rawValue >= 28 ? switchTimeInterval : timeInterval
        self.createTimer(time, isFire: true)
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

