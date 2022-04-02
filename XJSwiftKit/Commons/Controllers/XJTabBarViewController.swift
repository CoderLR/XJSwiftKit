//
//  XJTabBarViewController.swift
//  ShiJianYun
//
//  Created by Mr.Yang on 2021/4/14.
//

import UIKit

/// tabbar动画类型
enum TabbarAnimationType {
    case bigToSmall   // 先放大再缩小
    case rotationZ    // Z轴旋转
    case translationY // Y轴位移
    case bigToKeep    // 放大并保持
}

class XJTabBarViewController: UITabBarController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.selectedViewController?.supportedInterfaceOrientations ?? .portrait
    }
    
    override var shouldAutorotate: Bool {
        return self.selectedViewController?.shouldAutorotate ?? false
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.selectedViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
    
    fileprivate var indexFlag: Int = 0
    
    fileprivate lazy var heartBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.clear
        btn.setBackgroundImage(UIImage(named: "tab_icon_add_select"), for: .normal)
        btn.setBackgroundImage(UIImage(named: "tab_heart_select"), for: .selected)
        btn.addTarget(self, action: #selector(heartBtnClick(_:)), for: .touchUpInside)
        return btn
    }()
    
    var xjTabBar = XJTabBar(frame: CGRect.zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 不透明
        self.tabBar.isTranslucent = false
        
        self.setValue(xjTabBar, forKeyPath: "tabBar")
        
        // 不透明
        self.xjTabBar.isTranslucent = false
        
        xjTabBar.addBtnClickBlock = {[weak self]  in
            guard let self = self else { return }
            let heartVc = XJHeartViewController()
            self.present(heartVc, animated: true, completion: nil)
        }
        
        setupController()
    }
    
    fileprivate func setupUI() {
        self.tabBar.addSubview(heartBtn)
        heartBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(0)
        }
    }
    
    func setupController() {
        
        let homeVc = setupTabBarItem(controller: XJHomeViewController(), title: KTabbarHomeTitle, image: KTabbarHomeNormalImage, selectedImage: KTabbarHomeSelectImage)
        
        let _ = setupTabBarItem(controller: XJHeartViewController(), title: KTabbarHeartTitle, image: KTabbarHeartNormalImage, selectedImage: KTabbarHeartSelectImage)
        
        let mineVc = setupTabBarItem(controller: XJMineViewController(), title: KTabbarMineTitle, image: KTabbarMineNormalImage, selectedImage: KTabbarMineSelectImage)
        
        self.viewControllers = [homeVc, mineVc];
    }
    
    func setupTabBarItem(controller: UIViewController, title: String, image: UIImage?, selectedImage: UIImage?) -> UINavigationController{
        
        let item = UITabBarItem(title: title, image:image?.withRenderingMode(.alwaysOriginal), selectedImage: selectedImage?.withRenderingMode(.alwaysOriginal))
        item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Color_333333_333333], for: .normal)
        item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Color_System], for: .selected)
        controller.tabBarItem = item
        self.tabBar.tintColor = Color_System
        let navic = XJNavigationViewController(rootViewController: controller)
        return navic
    }
    
}
// MARK: - Action
extension XJTabBarViewController {
    
    @objc fileprivate func heartBtnClick(_ btn: UIButton) {
        if indexFlag == 1 { return }
        setBtnAnimation(true)
        indexFlag = 1
    }
    
    /// 按钮旋转动画
    fileprivate func setBtnAnimation(_ isSelect: Bool) {
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
}


// MARK: - Animation
extension XJTabBarViewController {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        let index = tabBar.items?.firstIndex(of: item) ?? 0
        print("index = \(index)")
        
        // 已经选中
        if index == indexFlag { return }
        
        /*
        // 自定义动画
        if index == 1 {
            indexFlag = index
            setBtnAnimation(true)
            return
        } else {
            setBtnAnimation(false)
        }
        */
     
        var viewArray: [UIView] = []
        for view in self.tabBar.subviews {
            if NSStringFromClass(view.classForCoder) == "UITabBarButton" {
                viewArray.append(view)
            }
        }

        /// UITabBarButton加入数组顺序错乱
        /*
        viewArray.sort { (view1, view2) -> Bool in
            return ((view1.frame.origin.x - view2.frame.origin.x) > 0 ? false : true)
        }
        */
        
        // 获取图片
        let tabbarButton = viewArray[index]
        //print("select = \(tabbarButton)")
        var selectImage: UIView?
        for view in tabbarButton.subviews {
            if NSStringFromClass(view.classForCoder) == "UITabBarSwappableImageView" {
                selectImage = view
                break
            }
        }
        
        tabBarAnimation(layer: selectImage!.layer, aniType: .bigToSmall)
        
        indexFlag = index
    }
    
    /// 其他动画实现方式
    fileprivate func otherTabbarAnimation(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        let tabIndex = tabBar.items?.firstIndex(of: item) ?? 0
        let button = tabBar.subviews[tabIndex + 1]
        print(button.subviews)
        var animationView : UIView?
        for subView in button.subviews{
            if NSStringFromClass(subView.classForCoder) == "UITabBarSwappableImageView"{
                animationView = subView
            }
        }
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                animationView?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                animationView?.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }, completion: nil)
    }
    
    /// tabbar执行点击动画
    /// - Parameters:
    ///   - layer: 执行动画layer
    ///   - aniType: 动画类型
    fileprivate func tabBarAnimation(layer: CALayer, aniType: TabbarAnimationType) {
        if aniType == .bigToSmall {
            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            animation.duration = 0.2;       //执行时间
            animation.repeatCount = 1;      //执行次数
            animation.autoreverses = true;    //完成动画后会回到执行动画之前的状态
            animation.fromValue = 1.0
            animation.toValue = 1.3
            layer.add(animation, forKey: nil)
        } else if aniType == .rotationZ {
            let animation = CABasicAnimation(keyPath: "transform.rotation.z")
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            animation.duration = 0.2;       //执行时间
            animation.repeatCount = 1;      //执行次数
            animation.autoreverses = true;    //完成动画后会回到执行动画之前的状态
            animation.fromValue = 0
            animation.toValue = Double.pi
            layer.add(animation, forKey: nil)
        } else if aniType == .translationY {
            let animation = CABasicAnimation(keyPath: "transform.translation.y")
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            animation.duration = 0.2;       //执行时间
            animation.repeatCount = 1;      //执行次数
            animation.autoreverses = true;    //完成动画后会回到执行动画之前的状态
            animation.fromValue = 0
            animation.toValue = -10
            layer.add(animation, forKey: nil)
        } else if aniType == .bigToKeep {
            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            animation.duration = 0.2;       //执行时间
            animation.repeatCount = 1;      //执行次数
            animation.autoreverses = false;    //完成动画后会回到执行动画之前的状态
            animation.fillMode =  CAMediaTimingFillMode.forwards           //保证动画效果延续
            animation.fromValue = 1.0
            animation.toValue = 1.2
            layer.add(animation, forKey: nil)
        }
    }
}
