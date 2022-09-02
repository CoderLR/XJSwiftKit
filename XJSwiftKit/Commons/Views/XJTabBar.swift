//
//  XJTabBar.swift
//  ShiJianYun
//
//  Created by xj on 2022/3/18.
//

import UIKit

class XJTabBar: UITabBar {
    
    fileprivate lazy var heartBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.clear
        btn.adjustsImageWhenHighlighted = false // 去除高亮
        btn.setBackgroundImage(UIImage(named: "tab_icon_add_select"), for: .normal)
        btn.setBackgroundImage(UIImage(named: "tab_heart_select"), for: .selected)
        btn.addTarget(self, action: #selector(heartBtnClick(_:)), for: .touchUpInside)
        return btn
    }()
    
    var addBtnClickBlock: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(heartBtn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var viewArray: [UIView] = []
        for view in self.subviews {
            if NSStringFromClass(view.classForCoder) == "UITabBarButton" {
                viewArray.append(view)
            }
        }
        
        for i in 0..<viewArray.count {
            let button = viewArray[i]
            let btnWidth: CGFloat = CGFloat(self.width) / CGFloat(viewArray.count + 1)
            if i == 0 {
                button.frame = CGRect(x: 0, y: 0, width: btnWidth, height: 49)
            } else {
                button.frame = CGRect(x: btnWidth * 2, y: 0, width: btnWidth, height: 49)
            }
            
        }
        
        heartBtn.size = CGSize(width: 60, height: 60)
        heartBtn.frame = CGRect(x: 0.5 * (self.width - heartBtn.width), y: 0, width: heartBtn.width, height: heartBtn.height)
    }

}

extension XJTabBar {
    
    /// 按钮点击事件
    @objc fileprivate func heartBtnClick(_ btn: UIButton) {
        setBtnAnimation(true)
        
        if let addBtnClickBlock = addBtnClickBlock {
            addBtnClickBlock()
        }
    }
    
    /// 按钮旋转动画
    func setBtnAnimation(_ isSelect: Bool) {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.duration = 0.2;       //执行时间
        animation.repeatCount = 1;      //执行次数
        animation.autoreverses = false;    //完成动画后会回到执行动画之前的状态
        animation.fromValue = isSelect ? 0 : Double.pi * 0.25
        animation.toValue = isSelect ? Double.pi * 0.25 : 0
        animation.fillMode =  CAMediaTimingFillMode.forwards           //保证动画效果延续
        animation.isRemovedOnCompletion = false
        self.heartBtn.layer.add(animation, forKey: nil)
    }
    
    /// 处理超出区域点击无效的问题
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if !self.isHidden{
            //转换坐标
            let tempPoint = heartBtn.convert(point, from: self)
            //判断点击的点是否在按钮区域内
            if heartBtn.bounds.contains(tempPoint) {
                // 返回按钮
                return heartBtn
            }
        }
        return super.hitTest(point, with: event)
    }
}
