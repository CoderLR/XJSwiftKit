//
//  UIViewController+Transition.swift
//  LibraryA
//
//  Created by xj on 2022/7/15.
//

import UIKit

// MARK: - push跳转
extension UINavigationController {
    
    /// 自定义push动画
    func xj_pushViewController(viewController: UIViewController, animationType: XJTransitionAnimationType) {
        
        // 设置动画参数
        let property = XJTransitionProperty()
        property.animationType = animationType
        XJTransitionManager.shared.property = property
        // 设置代理
        self.delegate = viewController
        // 默认使用自定义动画
        viewController.isUseTransition = true
        // 自定义交互
        viewController.isInteractive = false
        // 执行push
        self.pushViewController(viewController, animated: true)
    }
    
    /// 自定义push动画
    func xj_pushViewController(viewController: UIViewController, property: XJTransitionProperty) {
        
        // 设置动画类型
        XJTransitionManager.shared.property = property
        // 设置代理
        self.delegate = viewController
        // 默认使用自定义动画
        viewController.isUseTransition = true
        // 自定义交互
        viewController.isInteractive = false
        // 执行push
        self.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - present跳转
extension UIViewController {
    
    /// 自定义跳转
    func xj_presentViewController(viewController: UIViewController, animationType: XJTransitionAnimationType) {
        self.xj_presentViewController(viewController: viewController, animationType: animationType, completion: nil)
    }
    
    /// 自定义跳转->回调
    func xj_presentViewController(viewController: UIViewController, animationType: XJTransitionAnimationType, completion: (() -> Void)? = nil) {
        // 设置动画参数
        let property = XJTransitionProperty()
        property.animationType = animationType
        XJTransitionManager.shared.property = property
        // 设置控制器代理
        viewController.transitioningDelegate = viewController
        // 默认使用自定义动画
        viewController.isUseTransition = true
        // 自定义交互
        viewController.isInteractive = true
        // 不加跳转模式会有bug
        viewController.modalPresentationStyle = .fullScreen
        // 执行present
        self.present(viewController, animated: true, completion: completion)
    }
    
    /// 自定义跳转
    func xj_presentViewController(viewController: UIViewController, property: XJTransitionProperty) {
        self.xj_presentViewController(viewController: viewController, property: property, completion: nil)
    }
    
    /// 自定义跳转->回调
    func xj_presentViewController(viewController: UIViewController, property: XJTransitionProperty, completion: (() -> Void)? = nil) {
        // 设置动画参数
        XJTransitionManager.shared.property = property
        // 设置控制器代理
        viewController.transitioningDelegate = viewController
        // 默认使用自定义动画
        viewController.isUseTransition = true
        // 自定义交互
        viewController.isInteractive = false
        // 不加跳转模式会有bug
        viewController.modalPresentationStyle = .fullScreen
        // 执行present
        self.present(viewController, animated: true, completion: completion)
    }
}

// MARK: - UIViewControllerTransitioningDelegate
// 模态的代理
extension UIViewController :UIViewControllerTransitioningDelegate {
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        // 不使用自定义动画
        if isUseTransition == false { return nil }
        
        XJTransitionManager.shared.transitionType = .dismiss
        return XJTransitionManager.shared
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        // 不使用自定义动画
        if isUseTransition == false { return nil }
        
        // 添加互动交互
        if self.isInteractive {
            let interactive = XJPercentDrivenInteractiveTransition.shared
            interactive.addPanGesture(controller: self)
            interactive.transitionType = .dismiss
            interactive.gestureType = .right
            interactive.endInteractiveBlock = {finish in
                if let block = XJTransitionManager.shared.endInteractiveBlock {
                    block(finish)
                }
            }
        }
        
        XJTransitionManager.shared.transitionType = .present
        return XJTransitionManager.shared
    }
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        // 不使用自定义动画
        if isUseTransition == false { return nil }
        
        if isInteractive == false { return nil }
        
        let interactive = XJPercentDrivenInteractiveTransition.shared
        weak var inter = interactive
        if interactive.isInteractive {
            return inter
        } else {
            return nil
        }
    }
}

// MARK: - UINavigationControllerDelegate
// 导航栏代理
extension UIViewController :UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        // 不使用自定义动画
        if isUseTransition == false { return nil }
        
        if isInteractive == false { return nil }
        
        if XJTransitionManager.shared.transitionType == .pop {
            let interactive = XJPercentDrivenInteractiveTransition.shared
            if interactive.isInteractive {
                return interactive
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        // 不使用自定义动画
        if isUseTransition == false { return nil }
        
        if operation == .push {
            XJTransitionManager.shared.transitionType = .push
        } else if operation == .pop {
            XJTransitionManager.shared.transitionType = .pop
        }
        
        // 添加互动交互
        if isInteractive && operation == .push && !XJTransitionManager.shared.isSystemBack {
            let interactive = XJPercentDrivenInteractiveTransition.shared
            interactive.addPanGesture(controller: self)
            interactive.transitionType = .pop
            interactive.gestureType = .right
            interactive.endInteractiveBlock = { finish in
                if let block = XJTransitionManager.shared.endInteractiveBlock {
                    block(finish)
                }
            }
        }
        
        return XJTransitionManager.shared
    }
}


fileprivate var isInteractiveKey: String = "isInteractiveKey"
fileprivate var isUseTransitionKey: String = "isUseTransitionKey"

// MARK: - 关联属性
extension UIViewController {
    
    // 是否使用自定义交互
    var isUseTransition: Bool {
        set {
            objc_setAssociatedObject(self, &isUseTransitionKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return (objc_getAssociatedObject(self, &isUseTransitionKey)) as? Bool ?? false
        }
    }
    
    // 是否自定义交互返回
    var isInteractive: Bool {
        set {
             objc_setAssociatedObject(self, &isInteractiveKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return (objc_getAssociatedObject(self, &isInteractiveKey)) as? Bool ?? false
        }
    }
}

// MARK: - 自定义手势交互
class XJPercentDrivenInteractiveTransition: UIPercentDrivenInteractiveTransition {
    
    /// 手势类型
    var gestureType: XJGestureType = .none
    
    /// 控制器操作方式
    var transitionType: XJTransitionType = .none
    
    /// 操作控制器，需使用弱引用
    weak var controller: UIViewController?
    
    var isInteractive: Bool = false
    
    /// 手势滑动进度
    var percent: CGFloat = 0
    
    let screenW: CGFloat = UIScreen.main.bounds.size.width
    let screenH: CGFloat = UIScreen.main.bounds.size.height
    
    /// 交互结束在XJTransitionManager执行一些操作
    var endInteractiveBlock: ((_ success: Bool) -> Void)?
    
    /// 单例对象
    static var shared = XJPercentDrivenInteractiveTransition()
    
    convenience init(type: XJGestureType) {
        self.init()
        
        self.gestureType = type
    }
    
    func addPanGesture(controller: UIViewController?) {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        self.controller = controller
        self.controller?.view.addGestureRecognizer(pan)
    }
    
    @objc func panGesture(_ pan: UIPanGestureRecognizer) {
        self.percent = 0
        
        switch self.gestureType {
        case .left:
            let x = pan.translation(in: pan.view).x
            percent = -(x / screenW)
        case .right:
            let x = pan.translation(in: pan.view).x
            percent = (x / screenW)
        case .down:
            let y = pan.translation(in: pan.view).y
            percent = (y / screenW)
        case .up:
            let y = pan.translation(in: pan.view).y
            percent = -(y / screenW)
        default: break
        }
        
        switch pan.state {
        case .began:
            isInteractive = true
            if transitionType == .dismiss {
                controller?.dismiss(animated: true)
            } else if transitionType == .pop {
                controller?.navigationController?.popViewController(animated: true)
            }
            
            break
        case .changed:
            
            self.update(percent)
            break
        case.ended:
            isInteractive = false
            print("percent = \(percent)")
            if percent >= 0.3 {
                if let endInteractiveBlock = endInteractiveBlock {
                    endInteractiveBlock(true)
                }
                self.finish()
            } else {
                if let endInteractiveBlock = endInteractiveBlock {
                    endInteractiveBlock(false)
                }
                self.cancel()
            }
            break
            
        default:
            self.cancel()
            break
        }
    }
}
