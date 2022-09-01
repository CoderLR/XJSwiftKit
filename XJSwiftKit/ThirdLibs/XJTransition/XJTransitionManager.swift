//
//  XJTransitionManager.swift
//  LibraryA
//
//  Created by xj on 2022/7/15.
//

import UIKit

class XJTransitionManager: NSObject {
    
    /// 动画属性设置
    var property: XJTransitionProperty? {
        didSet {
            self.animationType = property?.animationType ?? .normal
            self.animationTime = property?.animationTime ?? 0.5
            self.isSystemBack = property?.isSystemBack ?? false
            self.isPushHidenNav = property?.isPushHidenNav ?? true
        }
    }
    
    /// 控制器操作方式
    var transitionType: XJTransitionType = .none
    
    /// 是否通过系统手势返回
    var isSystemBack: Bool = false
    
    /// 完成
    var completionBlock: (() -> Void)?
    
    /// 交互结束执行一些操作
    var endInteractiveBlock: ((_ success: Bool) -> Void)?
    
    /// 动画时长
    fileprivate var animationTime: TimeInterval = 0.5
    
    /// 动画类型
    fileprivate var animationType: XJTransitionAnimationType = .normal {
        didSet {
            self.backAnimationType = setBackAnimationType(type: animationType)
        }
    }
    
    /// 返回动画类型
    fileprivate var backAnimationType: XJTransitionAnimationType = .normal
    
    /// push控制器是否隐藏导航栏
    fileprivate var isPushHidenNav: Bool = true
    
    /// 转场上下文，需使用弱引用
    fileprivate weak var transitionContext: UIViewControllerContextTransitioning?
    
    /// 跳转之前的控制器
    fileprivate var fromVc: UIViewController? {
        get {
            return transitionContext?.viewController(forKey: .from)
        }
    }
    
    /// 跳转之后的控制器
    fileprivate var toVc: UIViewController? {
        get {
            return transitionContext?.viewController(forKey: .to)
        }
    }
    
    /// 跳转之前的视图
    fileprivate var fromView: UIView? {
        get {
            return transitionContext?.view(forKey: .from)
        }
    }
    
    /// 跳转之后的视图
    fileprivate var toView: UIView? {
        get {
            return transitionContext?.view(forKey: .to)
        }
    }
    
    /// 单例对象
    static var shared = XJTransitionManager()
    
    override init() {
        super.init()
       
    }
    
    fileprivate func removeDelegate() {
        let removeBlock = { [weak self] in
            guard let self = self else { return }
            self.fromVc?.transitioningDelegate = nil
            self.fromVc?.navigationController?.delegate = nil
            self.toVc?.transitioningDelegate = nil
            self.toVc?.navigationController?.delegate = nil
        }
        
        switch transitionType {
        case .push,
             .present:
            if isSystemBack { removeBlock() }
        case .pop,
             .dismiss:
            removeBlock()
        default:
            break
        }
    }
    
    /// 自定义动画
    fileprivate func animateTransition(isShow: Bool, type: XJTransitionAnimationType) {
        // 打开视图
        if isShow {
            switch type {
            case .page:
                self.pageTransitionAnimation(type: type)
            case .cover:
                self.coverTransitionAnimation(type: type)
            case .pointSpread:
                self.pointSpreadTransitionAnimation(type: type)
            case .spreadFromRight,
                 .spreadFromLeft,
                 .spreadFromTop,
                 .spreadFromBottom:
                self.spreadTransitionAnimation(type: type)
            case .boom:
                self.boomTransitionAnimation(type: type)
            case .brickOpenHorizontal,
                 .brickOpenVertical:
                self.brickOpenTransitionAnimation(type: type)
            case .brickCloseHorizontal,
                 .brickCloseVertical:
                self.brickCloseTransitionAnimation(type: type)
            case .inside:
                self.insideTransitionAnimation(type: type)
            case .fragmentShowFromRight,
                 .fragmentShowFromLeft,
                 .fragmentShowFromTop,
                 .fragmentShowFromBottom:
                self.fragmentShowTransitionAnimation(type: type)
            case .fragmentHideFromRight,
                 .fragmentHideFromLeft,
                 .fragmentHideFromTop,
                 .fragmentHideFromBottom:
                self.fragmentHideTransitionAnimation(type: type)
            case .flipFromRight:
                self.flipFromRightTransitionAnimation(type: type)
            case .flipFromLeft:
                self.flipFromLeftTransitionAnimation(type: type)
            case .flipFromTop:
                self.flipFromTopTransitionAnimation(type: type)
            case .flipFromBottom:
                self.flipFromBottomTransitionAnimation(type: type)
            default: break
            }
        } else {
            switch type {
            case .page:
                self.pageTransitionBackAnimation(type: type)
            case .cover:
                self.coverTransitionBackAnimation(type: type)
            case .pointSpread:
                self.pointSpreadTransitionBackAnimation(type: type)
            case .spreadFromRight,
                 .spreadFromLeft,
                 .spreadFromTop,
                 .spreadFromBottom:
                self.spreadTransitionBackAnimation(type: type)
            case .boom:
                self.boomTransitionBackAnimation(type: type)
            case .brickOpenHorizontal,
                 .brickOpenVertical:
                self.brickOpenTransitionBackAnimation(type: type)
            case .brickCloseHorizontal,
                 .brickCloseVertical:
                self.brickCloseTransitionBackAnimation(type: type)
            case .inside:
                self.insideTransitionBackAnimation(type: type)
            case .fragmentShowFromRight,
                 .fragmentShowFromLeft,
                 .fragmentShowFromTop,
                 .fragmentShowFromBottom:
                self.fragmentShowTransitionBackAnimation(type: type)
            case .fragmentHideFromRight,
                 .fragmentHideFromLeft,
                 .fragmentHideFromTop,
                 .fragmentHideFromBottom:
                self.fragmentHideTransitionBackAnimation(type: type)
            case .flipFromRight:
                self.flipFromLeftTransitionAnimation(type: type)
            case .flipFromLeft:
                self.flipFromRightTransitionAnimation(type: type)
            case .flipFromTop:
                self.flipFromBottomTransitionAnimation(type: type)
            case .flipFromBottom:
                self.flipFromTopTransitionAnimation(type: type)
            default: break
            }
        }
    }
    
    /// 获取屏幕截图
    func image(for view: UIView, atFrame rect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContext(view.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.saveGState()
        UIRectClip(rect)
        view.layer.render(in: context)
        let cutImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return cutImage
    }
}


// MARK: - UIViewControllerAnimatedTransitioning
extension XJTransitionManager: UIViewControllerAnimatedTransitioning {
    
    /// 转场动画持续的时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationTime
    }
    
    /// 转场要做的动画
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        setNavBar(isEnded: false)
        
        // 转场上下文
        self.transitionContext = transitionContext
        
        if transitionType == .push || transitionType == .present {
            print("self.animationType = \(self.animationType.rawValue)")
            if self.animationType.rawValue < 34 {
                self.systemTransitionAnimation(type: self.animationType)
            } else {
                self.animateTransition(isShow: true, type: self.animationType)
            }
            
        } else if transitionType == .pop || transitionType == .dismiss {
            if self.animationType.rawValue < 34 {
                self.systemTransitionBackAnimation(type: self.backAnimationType)
            } else {
                self.animateTransition(isShow: false, type: self.animationType)
            }

        }
    }
    
    /// 动画结束
    func animationEnded(_ transitionCompleted: Bool) {
        //print("\(#function)----\(transitionCompleted)")
        if transitionCompleted {
            removeDelegate()
        }
        
        setNavBar(isEnded: true)
    }
    
    /// 设置导航栏--效果不好
    func setNavBar(isEnded: Bool) {
        /*
        if self.transitionType == .present || self.transitionType == .dismiss { return }
        if self.isPushHidenNav == false { return }
        guard let fromVc = fromVc else { return }
        guard let toVc = toVc else { return }
        if isEnded {
            toVc.navigationController?.isNavigationBarHidden = false
        } else {
            fromVc.navigationController?.isNavigationBarHidden = true
        }*/
    }
}

// MARK: - CAAnimationDelegate
extension XJTransitionManager: CAAnimationDelegate {
    
    func animationDidStart(_ anim: CAAnimation) {
        //print(#function)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        //print(#function + "\(flag)")
        
        if flag {
            if let completionBlock = self.completionBlock {
                completionBlock()
            }
        }
    }
}

// MARK: - 动画实现

// MARK: - 系统默认动画
extension XJTransitionManager {
    func systemTransitionAnimation(type: XJTransitionAnimationType) {
        guard let tempView = toVc?.view?.snapshotView(afterScreenUpdates: true) else { return }
        guard let tempView1 = fromVc?.view?.snapshotView(afterScreenUpdates: true) else { return }
        
        let containerView = transitionContext?.containerView
        guard let fromView = fromVc?.view else { return }
        guard let toView = toVc?.view else { return }
        
        containerView?.addSubview(fromView)
        containerView?.addSubview(toView)
        
        containerView?.bringSubviewToFront(fromView)
        containerView?.bringSubviewToFront(toView)
        
        let transition = self.getSystemTransition(type: type)
        containerView?.layer.add(transition, forKey: nil)

        self.completionBlock = { [weak self] in
            guard let self = self else { return }
            if self.transitionContext?.transitionWasCancelled ?? false {
                self.transitionContext?.completeTransition(false)
            } else {
                self.transitionContext?.completeTransition(true)
                self.toVc?.view?.isHidden = false
            }
            tempView.removeFromSuperview()
            tempView1.removeFromSuperview()
        }
    }
    
    func systemTransitionBackAnimation(type: XJTransitionAnimationType) {
        guard let tempView = toVc?.view?.snapshotView(afterScreenUpdates: true) else { return }
        guard let tempView1 = fromVc?.view?.snapshotView(afterScreenUpdates: true) else { return }
        
        let containerView = transitionContext?.containerView
        guard let fromView = fromVc?.view else { return }
        guard let toView = toVc?.view else { return }
        
        containerView?.addSubview(fromView)
        containerView?.addSubview(toView)
        
        let transition = self.getSystemTransition(type: type)
        containerView?.layer.add(transition, forKey: nil)

        self.completionBlock = { [weak self] in
            guard let self = self else { return }
            if self.transitionContext?.transitionWasCancelled ?? false {
                self.transitionContext?.completeTransition(false)
                containerView?.bringSubviewToFront(fromView)
            } else {
                self.transitionContext?.completeTransition(true)
//                self.transitionContext = nil
            }
            
            tempView.removeFromSuperview()
            tempView1.removeFromSuperview()
        }
        
        self.endInteractiveBlock = { (success) in
            if success {
                //toView.isHidden = false
            } else {
                //toView.isHidden = true
            }
        }
    }
}

// MARK: - pageTransition动画
extension XJTransitionManager {
    func pageTransitionAnimation(type: XJTransitionAnimationType) {
        guard let tempView = fromVc?.view?.snapshotView(afterScreenUpdates: false) else { return }
        
        guard let containerView = transitionContext?.containerView else { return }
        guard let fromView = fromVc?.view else { return }
        guard let toView = toVc?.view else { return }
        
        containerView.addSubview(toView)
        containerView.addSubview(tempView)
        containerView.insertSubview(toView, at: 0)
        
        tempView.frame = fromVc?.view.frame ?? .zero
        fromVc?.view.isHidden = true
        let point = CGPoint(x: 0, y: 0.5)
        
        tempView.frame = tempView.frame.offsetBy(dx: (point.x - tempView.layer.anchorPoint.x) * tempView.frame.size.width, dy: (point.y - tempView.layer.anchorPoint.y) * tempView.frame.size.height)
        
        print("dx = \((point.x - tempView.layer.anchorPoint.x) * tempView.frame.size.width)")
        print("dy = \((point.y - tempView.layer.anchorPoint.y) * tempView.frame.size.height)")

        tempView.layer.anchorPoint = point
        var transfrom3d = CATransform3DIdentity
        transfrom3d.m34 = -0.002
        containerView.layer.sublayerTransform = transfrom3d
        
        UIView.animate(withDuration: self.animationTime) {
            tempView.layer.transform = CATransform3DMakeRotation(-(.pi * 0.5), 0, 1, 0)
        } completion: { finished in
            if self.transitionContext?.transitionWasCancelled ?? false {
                self.transitionContext?.completeTransition(false)
            } else {
                self.transitionContext?.completeTransition(true)
            }
            fromView.isHidden = false
        }
    }
    
    func pageTransitionBackAnimation(type: XJTransitionAnimationType) {
    
        guard let containerView = transitionContext?.containerView else { return }
        guard let fromView = fromVc?.view else { return }
        guard let toView = toVc?.view else { return }
        guard let tempView = containerView.subviews.last else { return }

        tempView.isHidden = false
        
        containerView.addSubview(toView)
        containerView.addSubview(tempView)
        toView.isHidden = true
    
        UIView.animate(withDuration: self.animationTime) {
            tempView.layer.transform = CATransform3DIdentity
            fromView.alpha = 0.2
        } completion: { finished in
            if self.transitionContext?.transitionWasCancelled ?? false {
                self.transitionContext?.completeTransition(false)
                fromView.alpha = 1
            } else {
                self.transitionContext?.completeTransition(true)
                tempView.removeFromSuperview()
                toView.alpha = 1
                toView.isHidden = false

            }
        }

        self.endInteractiveBlock = { (success) in
            if success {
                toView.isHidden = false
                toView.alpha = 1
            } else {
                tempView.isHidden = true
                fromView.alpha = 1
            }
        }
    }
}

// MARK: - coverTransition动画
extension XJTransitionManager {
    func coverTransitionAnimation(type: XJTransitionAnimationType) {
        guard let tempView = toVc?.view?.snapshotView(afterScreenUpdates: true) else { return }
        
        let containerView = transitionContext?.containerView
        guard let fromView = fromVc?.view else { return }
        guard let toView = toVc?.view else { return }
        
        containerView?.addSubview(toView)
        containerView?.addSubview(fromView)
        containerView?.addSubview(tempView)
        
        tempView.layer.transform = CATransform3DMakeScale(4, 4, 1)
        tempView.alpha = 0.1
        tempView.isHidden = false
        
        UIView.animate(withDuration: self.animationTime) {
            tempView.layer.transform = CATransform3DIdentity
            tempView.alpha = 1
        } completion: { finished in
            if self.transitionContext?.transitionWasCancelled ?? false {
                self.toVc?.view?.isHidden = true
                self.transitionContext?.completeTransition(false)
            } else {
                self.toVc?.view?.isHidden = false
                self.transitionContext?.completeTransition(true)
            }
            tempView.removeFromSuperview()
        }
    }
    
    func coverTransitionBackAnimation(type: XJTransitionAnimationType) {
        guard let tempView = fromVc?.view?.snapshotView(afterScreenUpdates: true) else { return }
        
        let containerView = transitionContext?.containerView
        guard let fromView = fromVc?.view else { return }
        guard let toView = toVc?.view else { return }
    
        containerView?.addSubview(fromView)
        containerView?.addSubview(toView)
        containerView?.addSubview(tempView)
        
        fromView.isHidden = true
        if toView.isHidden == true { toView.isHidden = false}
        toView.alpha = 1
        tempView.isHidden = false
        tempView.alpha = 1
        
        UIView.animate(withDuration: self.animationTime) {
            tempView.layer.transform = CATransform3DMakeScale(4, 4, 1)
            tempView.alpha = 0
        } completion: { finished in
            if self.transitionContext?.transitionWasCancelled ?? false {
                fromView.isHidden = false
                toView.isHidden = true //
                self.transitionContext?.completeTransition(false)
                tempView.alpha = 1
            } else {
                self.transitionContext?.completeTransition(true)
                toView.isHidden = false
            }
            tempView.removeFromSuperview()
        }
        
        self.endInteractiveBlock = { (success) in
            if success {
                toView.isHidden = false
                tempView.removeFromSuperview()
            } else {
                fromView.isHidden = false
                toView.isHidden = true //
                tempView.alpha = 1
            }
        }
    }
}

// MARK: - Spread动画
extension XJTransitionManager {
    func spreadTransitionAnimation(type: XJTransitionAnimationType) {
        guard let tempView = toVc?.view?.snapshotView(afterScreenUpdates: true) else { return }
        
        guard let containerView = transitionContext?.containerView else { return }
        guard let fromView = fromVc?.view else { return }
        guard let toView = toVc?.view else { return }
        
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        containerView.addSubview(tempView)
        
        
        let screenW = UIScreen.main.bounds.size.width
        let screenH = UIScreen.main.bounds.size.height
        
        var rect0 = CGRect.zero
        let rect1 = CGRect(x: 0, y: 0, width: screenW, height: screenH)
        
        switch type {
        case .spreadFromRight:
            rect0 = CGRect(x: screenW, y: 0, width: 2, height: screenH)
        case .spreadFromLeft:
            rect0 = CGRect(x: 0, y: 0, width: 2, height: screenH)
        case .spreadFromTop:
            rect0 = CGRect(x: 0, y: 0, width: screenW, height: 2)
        case .spreadFromBottom:
            rect0 = CGRect(x: 0, y: screenH, width: screenW, height: 2)
        default: break
        }
        
        
        let startPath = UIBezierPath(rect: rect0)
        let endPath = UIBezierPath(rect: rect1)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = endPath.cgPath
        tempView.layer.mask = maskLayer
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.delegate = self
        animation.fromValue = startPath.cgPath
        animation.toValue = endPath.cgPath
        animation.duration = self.animationTime
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        maskLayer.add(animation, forKey: "NextPath")
        
        self.completionBlock = { [weak self] in
            guard let self = self else { return }
            if self.transitionContext?.transitionWasCancelled ?? false {
                self.transitionContext?.completeTransition(false)
            } else {
                self.transitionContext?.completeTransition(true)
                self.toVc?.view?.isHidden = false
            }
            tempView.removeFromSuperview()
        }
    }
    
    func spreadTransitionBackAnimation(type: XJTransitionAnimationType) {
        guard let tempView = toVc?.view?.snapshotView(afterScreenUpdates: true) else { return }
        
        guard let containerView = transitionContext?.containerView else { return }
        guard let fromView = fromVc?.view else { return }
        guard let toView = toVc?.view else { return }
        
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        containerView.addSubview(tempView)
        
        
        let screenW = UIScreen.main.bounds.size.width
        let screenH = UIScreen.main.bounds.size.height
        
        var rect0 = CGRect.zero
        let rect1 = CGRect(x: 0, y: 0, width: screenW, height: screenH)
        
        switch type {
        case .spreadFromRight:
            rect0 = CGRect(x: 0, y: 0, width: 2, height: screenH)
        case .spreadFromLeft:
            rect0 = CGRect(x: screenW - 2, y: 0, width: 2, height: screenH)
        case .spreadFromTop:
            rect0 = CGRect(x: 0, y: screenH - 2, width: screenW, height: 2)
        case .spreadFromBottom:
            rect0 = CGRect(x: 0, y: 0, width: screenW, height: 2)
        default: break
        }
        
        
        let startPath = UIBezierPath(rect: rect0)
        let endPath = UIBezierPath(rect: rect1)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = endPath.cgPath
        tempView.layer.mask = maskLayer
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.delegate = self
        animation.fromValue = startPath.cgPath
        animation.toValue = endPath.cgPath
        animation.duration = self.animationTime
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        maskLayer.add(animation, forKey: "NextPath")
        
        self.completionBlock = { [weak self] in
            guard let self = self else { return }
            if self.transitionContext?.transitionWasCancelled ?? false {
                self.transitionContext?.completeTransition(false)
            } else {
                self.transitionContext?.completeTransition(true)
                self.toVc?.view?.isHidden = false
            }
            tempView.removeFromSuperview()
        }
        
        self.endInteractiveBlock = { (success) in
            if success {
                maskLayer.path = endPath.cgPath
            } else {
                maskLayer.path = startPath.cgPath
            }
        }
    }
}

// MARK: - pointSpread动画
extension XJTransitionManager {
    func pointSpreadTransitionAnimation(type: XJTransitionAnimationType) {
        guard let tempView = toVc?.view?.snapshotView(afterScreenUpdates: true) else { return }
        
        guard let containerView = transitionContext?.containerView else { return }
        guard let fromView = fromVc?.view else { return }
        guard let toView = toVc?.view else { return }
        
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        containerView.addSubview(tempView)
        
        
        let screenW = UIScreen.main.bounds.size.width
        let screenH = UIScreen.main.bounds.size.height
        
        let rect = CGRect(x: containerView.center.x - 1, y: containerView.center.y - 1, width: 2, height: 2)
        
        let startPath = UIBezierPath(ovalIn: rect)
        let endPath = UIBezierPath(arcCenter: containerView.center, radius: sqrt(screenW * screenW + screenH * screenH), startAngle: 0, endAngle: .pi * 2, clockwise: true)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = endPath.cgPath
        tempView.layer.mask = maskLayer
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.delegate = self
        animation.fromValue = startPath.cgPath
        animation.toValue = endPath.cgPath
        animation.duration = self.animationTime
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        maskLayer.add(animation, forKey: "PointNextPath")
        
        self.completionBlock = { [weak self] in
            guard let self = self else { return }
            if self.transitionContext?.transitionWasCancelled ?? false {
                self.transitionContext?.completeTransition(false)
            } else {
                self.transitionContext?.completeTransition(true)
                self.toVc?.view?.isHidden = false
            }
            tempView.removeFromSuperview()
        }
    }
    
    func pointSpreadTransitionBackAnimation(type: XJTransitionAnimationType) {
        guard let tempView = fromVc?.view?.snapshotView(afterScreenUpdates: true) else { return }
        
        guard let containerView = transitionContext?.containerView else { return }
        guard let toView = toVc?.view else { return }
        
        containerView.addSubview(toView)
        containerView.addSubview(tempView)
        
        if toView.isHidden == true { toView.isHidden = false }
        
        let screenW = UIScreen.main.bounds.size.width
        let screenH = UIScreen.main.bounds.size.height
        
        let rect = CGRect(x: containerView.center.x - 1, y: containerView.center.y - 1, width: 2, height: 2)
        
        let endPath = UIBezierPath(ovalIn: rect)
        let startPath = UIBezierPath(arcCenter: containerView.center, radius: sqrt(screenW * screenW + screenH * screenH) * 0.5, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = endPath.cgPath
        tempView.layer.mask = maskLayer
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.delegate = self
        animation.fromValue = startPath.cgPath
        animation.toValue = endPath.cgPath
        animation.duration = self.animationTime
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        maskLayer.add(animation, forKey: "PointBackPath")
        
        self.completionBlock = { [weak self] in
            guard let self = self else { return }
            if self.transitionContext?.transitionWasCancelled ?? false {
                self.transitionContext?.completeTransition(false)
                toView.isHidden = true
            } else {
                self.transitionContext?.completeTransition(true)
                toView.isHidden = false
            }
            tempView.removeFromSuperview()
        }
        
        self.endInteractiveBlock = { (success) in
            if success {
                maskLayer.path = endPath.cgPath
            } else {
                maskLayer.path = startPath.cgPath
            }
        }
    }
}

// MARK: - Boom动画
extension XJTransitionManager {
    func boomTransitionAnimation(type: XJTransitionAnimationType) {
        guard let tempView = toVc?.view?.snapshotView(afterScreenUpdates: true) else { return }
        
        guard let containerView = transitionContext?.containerView else { return }
        guard let fromView = fromVc?.view else { return }
        guard let toView = toVc?.view else { return }
        
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        containerView.addSubview(tempView)
        
        tempView.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        
        UIView.animate(withDuration: self.animationTime, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0 / 0.4, options: UIView.AnimationOptions.init(rawValue: 0)) {
            tempView.layer.transform = CATransform3DIdentity
        } completion: { finished in
            if self.transitionContext?.transitionWasCancelled ?? false {
                self.transitionContext?.completeTransition(false)
            } else {
                self.transitionContext?.completeTransition(true)
                self.toVc?.view?.isHidden = false
            }
            tempView.removeFromSuperview()
        }
    }
    
    func boomTransitionBackAnimation(type: XJTransitionAnimationType) {
        guard let tempView = fromVc?.view?.snapshotView(afterScreenUpdates: true) else { return }
        guard let containerView = transitionContext?.containerView else { return }
        guard let fromView = fromVc?.view else { return }
        guard let toView = toVc?.view else { return }
        
        containerView.addSubview(toView)
        containerView.addSubview(tempView)
        
        // 侧滑返回cancle Bug修复
        if toView.isHidden == true { toView.isHidden = false }
        
        tempView.layer.transform = CATransform3DIdentity
        
        UIView.animate(withDuration: self.animationTime) {
            tempView.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        } completion: { finished in
            if self.transitionContext?.transitionWasCancelled ?? false {
                print("transitionWasCancelled---true")
                self.transitionContext?.completeTransition(false)
                toView.isHidden = true // nav
                fromView.isHidden = false // Pre
            } else {
                print("transitionWasCancelled---false")
                self.transitionContext?.completeTransition(true)
            }
            tempView.removeFromSuperview()
        }
        
        self.endInteractiveBlock = { (success) in
            if success {
                print("end----success")
            } else {
                print("end----cancle")
                toView.isHidden = true // nav
                fromView.isHidden = false // Pre
            }
            tempView.removeFromSuperview()
        }
    }
}

// MARK: - brick动画
extension XJTransitionManager {
    func brickOpenTransitionAnimation(type: XJTransitionAnimationType) {
        guard let containerView = transitionContext?.containerView else { return }
        guard let fromView = fromVc?.view else { return }
        guard let toView = toVc?.view else { return }
        
        let screenW = UIScreen.main.bounds.size.width
        let screenH = UIScreen.main.bounds.size.height
        
        var rect0 = CGRect.zero
        var rect1 = CGRect.zero
        
        switch type {
        case .brickOpenHorizontal:
            rect0 = CGRect(x: 0 , y: 0 , width: screenW * 0.5, height: screenH)
            rect1 = CGRect(x: screenW * 0.5 , y: 0 , width: screenW * 0.5, height: screenH)
        case .brickOpenVertical:
            rect0 = CGRect(x: 0 , y: 0 , width: screenW, height: screenH * 0.5)
            rect1 = CGRect(x: 0 , y: screenH * 0.5 , width: screenW, height: screenH * 0.5)
        default: break
        }
        
        let image0 = self.image(for: fromView, atFrame: rect0)
        let image1 = self.image(for: fromView, atFrame: rect1)
        
        let imageView0 = UIImageView(image: image0)
        let imageView1 = UIImageView(image: image1)
        
        containerView.addSubview(fromView)
        containerView.addSubview(toView)
        containerView.addSubview(imageView0)
        containerView.addSubview(imageView1)
        
        UIView.animate(withDuration: self.animationTime) {
            switch type {
            case .brickOpenHorizontal:
                imageView0.layer.transform = CATransform3DMakeTranslation(-screenW * 0.5, 0, 0)
                imageView1.layer.transform = CATransform3DMakeTranslation(screenW * 0.5, 0, 0)
            case .brickOpenVertical:
                imageView0.layer.transform = CATransform3DMakeTranslation(0, -screenH * 0.5, 0);
                imageView1.layer.transform = CATransform3DMakeTranslation(0, screenH * 0.5, 0);
            default: break
            }
        } completion: { finished in
            if self.transitionContext?.transitionWasCancelled ?? false {
                self.transitionContext?.completeTransition(false)
            } else {
                self.transitionContext?.completeTransition(true)
            }
            imageView0.removeFromSuperview()
            imageView1.removeFromSuperview()
        }
    }
    
    func brickOpenTransitionBackAnimation(type: XJTransitionAnimationType) {
        guard let containerView = transitionContext?.containerView else { return }
        guard let fromView = fromVc?.view else { return }
        guard let toView = toVc?.view else { return }
        
        let screenW = UIScreen.main.bounds.size.width
        let screenH = UIScreen.main.bounds.size.height
        
        var rect0 = CGRect.zero
        var rect1 = CGRect.zero
        
        switch type {
        case .brickOpenHorizontal:
            rect0 = CGRect(x: 0 , y: 0 , width: screenW * 0.5, height: screenH)
            rect1 = CGRect(x: screenW * 0.5 , y: 0 , width: screenW * 0.5, height: screenH)
        case .brickOpenVertical:
            rect0 = CGRect(x: 0 , y: 0 , width: screenW, height: screenH * 0.5)
            rect1 = CGRect(x: 0 , y: screenH * 0.5 , width: screenW, height: screenH * 0.5)
        default: break
        }
        
        let image0 = self.image(for: toView, atFrame: rect0)
        let image1 = self.image(for: toView, atFrame: rect1)
        
        let imageView0 = UIImageView(image: image0)
        let imageView1 = UIImageView(image: image1)
        
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        containerView.addSubview(imageView0)
        containerView.addSubview(imageView1)
        
        toView.isHidden = true
        
        switch type {
        case .brickOpenHorizontal:
            imageView0.layer.transform = CATransform3DMakeTranslation(-screenW * 0.5, 0, 0)
            imageView1.layer.transform = CATransform3DMakeTranslation(screenW * 0.5, 0, 0)
        case .brickOpenVertical:
            imageView0.layer.transform = CATransform3DMakeTranslation(0, -screenH * 0.5, 0);
            imageView1.layer.transform = CATransform3DMakeTranslation(0, screenH * 0.5, 0);
        default: break
        }
        
        UIView.animate(withDuration: self.animationTime) {
            imageView0.layer.transform = CATransform3DIdentity
            imageView1.layer.transform = CATransform3DIdentity
        } completion: { finished in
            if self.transitionContext?.transitionWasCancelled ?? false {
                self.transitionContext?.completeTransition(false)
            } else {
                self.transitionContext?.completeTransition(true)
            }
            
            toView.isHidden = false
            imageView0.removeFromSuperview()
            imageView1.removeFromSuperview()
        }
        
        self.endInteractiveBlock = { (success) in
            if success {
                toView.isHidden = false
                fromView.isHidden = true
            } else {
                toView.isHidden = true
                fromView.isHidden = false
            }
            imageView0.removeFromSuperview()
            imageView1.removeFromSuperview()
        }
    }
    
    func brickCloseTransitionAnimation(type: XJTransitionAnimationType) {
        guard let containerView = transitionContext?.containerView else { return }
        guard let fromView = fromVc?.view else { return }
        guard let toView = toVc?.view else { return }
        
        let screenW = UIScreen.main.bounds.size.width
        let screenH = UIScreen.main.bounds.size.height
        
        var rect0 = CGRect.zero
        var rect1 = CGRect.zero
        
        switch type {
        case .brickCloseHorizontal:
            rect0 = CGRect(x: 0 , y: 0 , width: screenW * 0.5, height: screenH)
            rect1 = CGRect(x: screenW * 0.5 , y: 0 , width: screenW * 0.5, height: screenH)
        case .brickCloseVertical:
            rect0 = CGRect(x: 0 , y: 0 , width: screenW, height: screenH * 0.5)
            rect1 = CGRect(x: 0 , y: screenH * 0.5 , width: screenW, height: screenH * 0.5)
        default: break
        }
        
        let image0 = self.image(for: toView, atFrame: rect0)
        let image1 = self.image(for: toView, atFrame: rect1)
        
        let imageView0 = UIImageView(image: image0)
        let imageView1 = UIImageView(image: image1)
        
        containerView.addSubview(fromView)
        containerView.addSubview(toView)
        containerView.addSubview(imageView0)
        containerView.addSubview(imageView1)
        
        self.toVc?.view.isHidden = true
        
        switch type {
        case .brickCloseHorizontal:
            imageView0.layer.transform = CATransform3DMakeTranslation(-screenW * 0.5, 0, 0)
            imageView1.layer.transform = CATransform3DMakeTranslation(screenW * 0.5, 0, 0)
        case .brickCloseVertical:
            imageView0.layer.transform = CATransform3DMakeTranslation(0, -screenH * 0.5, 0);
            imageView1.layer.transform = CATransform3DMakeTranslation(0, screenH * 0.5, 0);
        default: break
        }
        
        UIView.animate(withDuration: self.animationTime) {
            imageView0.layer.transform = CATransform3DIdentity
            imageView1.layer.transform = CATransform3DIdentity
        } completion: { finished in
            if self.transitionContext?.transitionWasCancelled ?? false {
                print("transitionWasCancelled------true")
                self.transitionContext?.completeTransition(false)
            } else {
                print("transitionWasCancelled------false")
                self.transitionContext?.completeTransition(true)
                self.toVc?.view.isHidden = false
            }
            imageView0.removeFromSuperview()
            imageView1.removeFromSuperview()
        }
    }
    
    func brickCloseTransitionBackAnimation(type: XJTransitionAnimationType) {
        guard let containerView = transitionContext?.containerView else { return }
        guard let fromView = fromVc?.view else { return }
        guard let toView = toVc?.view else { return }
        
        let screenW = UIScreen.main.bounds.size.width
        let screenH = UIScreen.main.bounds.size.height
        
        var rect0 = CGRect.zero
        var rect1 = CGRect.zero
        
        switch type {
        case .brickCloseHorizontal:
            rect0 = CGRect(x: 0 , y: 0 , width: screenW * 0.5, height: screenH)
            rect1 = CGRect(x: screenW * 0.5 , y: 0 , width: screenW * 0.5, height: screenH)
        case .brickCloseVertical:
            rect0 = CGRect(x: 0 , y: 0 , width: screenW, height: screenH * 0.5)
            rect1 = CGRect(x: 0 , y: screenH * 0.5 , width: screenW, height: screenH * 0.5)
        default: break
        }
        
        let image0 = self.image(for: fromView, atFrame: rect0)
        let image1 = self.image(for: fromView, atFrame: rect1)
        
        let imageView0 = UIImageView(image: image0)
        let imageView1 = UIImageView(image: image1)
        
        containerView.addSubview(fromView)
        containerView.addSubview(toView)
        containerView.addSubview(imageView0)
        containerView.addSubview(imageView1)
        
        // 侧滑返回cancle Bug修复
        if toView.isHidden == true { toView.isHidden = false }

        UIView.animate(withDuration: self.animationTime) {
            switch type {
            case .brickCloseHorizontal:
                imageView0.layer.transform = CATransform3DMakeTranslation(-screenW * 0.5, 0, 0)
                imageView1.layer.transform = CATransform3DMakeTranslation(screenW * 0.5, 0, 0)
            case .brickCloseVertical:
                imageView0.layer.transform = CATransform3DMakeTranslation(0, -screenH * 0.5, 0);
                imageView1.layer.transform = CATransform3DMakeTranslation(0, screenH * 0.5, 0);
            default: break
            }
        } completion: { finished in
            if self.transitionContext?.transitionWasCancelled ?? false {
                print("transitionWasCancelled------true")
                self.transitionContext?.completeTransition(false)
                
                toView.isHidden = true // nav
                fromView.isHidden = false // Pre
            } else {
                print("transitionWasCancelled------false")
                self.transitionContext?.completeTransition(true)
            }

            imageView0.removeFromSuperview()
            imageView1.removeFromSuperview()
        }
        
        self.endInteractiveBlock = { (success) in
            if success {

            } else {
                toView.isHidden = true // nav
                fromView.isHidden = false // Pre
            }
            imageView0.removeFromSuperview()
            imageView1.removeFromSuperview()
        }
    }
}

// MARK: - inside动画
extension XJTransitionManager {
    func insideTransitionAnimation(type: XJTransitionAnimationType) {
        guard let containerView = transitionContext?.containerView else { return }
        guard let fromView = fromVc?.view else { return }
        guard let toView = toVc?.view else { return }
        
        containerView.addSubview(fromView)
        containerView.addSubview(toView)
        
        let screenW = UIScreen.main.bounds.size.width
        toView.layer.transform = CATransform3DMakeTranslation(screenW, 0, 0)
        
        UIView.animate(withDuration: self.animationTime) {
            fromView.layer.transform = CATransform3DMakeScale(0.95, 0.95, 1)
            toView.layer.transform = CATransform3DIdentity
        } completion: { finished in
            if self.transitionContext?.transitionWasCancelled ?? false {
                self.transitionContext?.completeTransition(false)
            } else {
                self.transitionContext?.completeTransition(true)
            }
            fromView.layer.transform = CATransform3DIdentity
        }
    }
    
    func insideTransitionBackAnimation(type: XJTransitionAnimationType) {
        
        guard let tempToView = toVc?.view?.snapshotView(afterScreenUpdates: true) else { return }
        guard let tempFromView = fromVc?.view?.snapshotView(afterScreenUpdates: true) else { return }
        
        guard let containerView = transitionContext?.containerView else { return }
        guard let fromView = fromVc?.view else { return }
        guard let toView = toVc?.view else { return }
        
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        
        let screenW = UIScreen.main.bounds.size.width
        toView.layer.transform = CATransform3DMakeScale(0.95, 0.95, 1)
        fromView.layer.transform = CATransform3DIdentity
        
        UIView.animate(withDuration: self.animationTime) {
            toView.layer.transform = CATransform3DIdentity
            fromView.layer.transform = CATransform3DMakeTranslation(screenW, 0, 0)
        } completion: { finished in
            if self.transitionContext?.transitionWasCancelled ?? false {
                self.transitionContext?.completeTransition(false)
            } else {
                self.transitionContext?.completeTransition(true)
            }
            toView.isHidden = false
            tempToView.removeFromSuperview()
            tempFromView.removeFromSuperview()
        }
        
        self.endInteractiveBlock = { (success) in
            if success {
                toView.layer.transform = CATransform3DIdentity
                fromView.isHidden = true
                containerView.addSubview(tempToView)
            } else {
                fromView.isHidden = false
                toView.layer.transform = CATransform3DIdentity
                tempToView.removeFromSuperview()
                containerView.addSubview(tempToView)
            }
        }
    }
}

// MARK: - fragment动画
extension XJTransitionManager {
    func fragmentShowTransitionAnimation(type: XJTransitionAnimationType) {
        guard let tempToView = toVc?.view?.snapshotView(afterScreenUpdates: true) else { return }
        guard let containerView = transitionContext?.containerView else { return }
        guard let fromView = fromVc?.view else { return }
        guard let toView = toVc?.view else { return }
        
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        
        var fragmentViews: [UIView] = []
        
        let size = fromView.frame.size
        let fragmentWidth: CGFloat = 20.0
        
        let rowNum: Int = Int(size.width / fragmentWidth + 1)
        let columNum: Int = Int(size.height / fragmentWidth + 1)
        for i in 0..<rowNum {
            for j in 0..<columNum {
                let rect = CGRect(x: CGFloat(i) * fragmentWidth, y: CGFloat(j) * fragmentWidth, width: fragmentWidth, height: fragmentWidth)
                guard let fragmentView = tempToView.resizableSnapshotView(from: rect, afterScreenUpdates: false, withCapInsets: .zero) else { return }
                fragmentView.frame = rect
                containerView.addSubview(fragmentView)
                fragmentViews.append(fragmentView)
                
                switch type {
                case .fragmentShowFromRight:
                   
                    fragmentView.layer.transform = CATransform3DMakeTranslation( CGFloat(arc4random() % 50 * 50), 0, 0)
                case .fragmentShowFromLeft:
                    fragmentView.layer.transform = CATransform3DMakeTranslation( -CGFloat(arc4random() % 50 * 50), 0 , 0)
                case .fragmentShowFromTop:
                    fragmentView.layer.transform = CATransform3DMakeTranslation(0, -CGFloat(arc4random() % 50 * 50), 0)
                case .fragmentShowFromBottom:
                    fragmentView.layer.transform = CATransform3DMakeTranslation(0, CGFloat(arc4random() % 50 * 50), 0)
                default: break
                }
                fragmentView.alpha = 0
            }
        }
        
        UIView.animate(withDuration: self.animationTime) {
            
            for fragmentView in fragmentViews {
                fragmentView.layer.transform = CATransform3DIdentity
                fragmentView.alpha = 1
            }
            
        } completion: { finished in
            if self.transitionContext?.transitionWasCancelled ?? false {
                self.transitionContext?.completeTransition(false)
            } else {
                self.transitionContext?.completeTransition(true)
            }
            
            fromView.isHidden = false
            
            for fragmentView in fragmentViews {
                fragmentView.removeFromSuperview()
            }
        }
    }
    
    func fragmentShowTransitionBackAnimation(type: XJTransitionAnimationType) {
        
        guard let tempFromView = fromVc?.view?.snapshotView(afterScreenUpdates: false) else { return }
        
        guard let containerView = transitionContext?.containerView else { return }
        guard let fromView = fromVc?.view else { return }
        guard let toView = toVc?.view else { return }
        
        containerView.addSubview(toView)
        
        if toView.isHidden == true { toView.isHidden = false }
        
        var fragmentViews: [UIView] = []
        
        let size = fromView.frame.size
        let fragmentWidth: CGFloat = 20.0
        
        let rowNum: Int = Int(size.width / fragmentWidth + 1)
        let columNum: Int = Int(size.height / fragmentWidth + 1)
        for i in 0..<rowNum {
            for j in 0..<columNum {
                let rect = CGRect(x: CGFloat(i) * fragmentWidth, y: CGFloat(j) * fragmentWidth, width: fragmentWidth, height: fragmentWidth)
                guard let fragmentView = tempFromView.resizableSnapshotView(from: rect, afterScreenUpdates: false, withCapInsets: .zero) else { return }
                fragmentView.frame = rect
                containerView.addSubview(fragmentView)
                fragmentViews.append(fragmentView)
            }
        }
        
        UIView.animate(withDuration: self.animationTime) {
            for fragmentView in fragmentViews {
                
                var rect = fragmentView.frame
                
                switch type {
                case .fragmentShowFromRight:
                    rect.origin.x = rect.origin.x + CGFloat(arc4random() % (50 * 50))
                case .fragmentShowFromLeft:
                    rect.origin.x = rect.origin.x - CGFloat(arc4random() % (50 * 50))
                case .fragmentShowFromTop:
                    rect.origin.y = rect.origin.y - CGFloat(arc4random() % (50 * 50))
                case .fragmentShowFromBottom:
                    rect.origin.y = rect.origin.y + CGFloat(arc4random() % (50 * 50))
                default: break
                    
                }
                
                fragmentView.frame = rect
                fragmentView.alpha = 0
            }
        } completion: { finished in
            if self.transitionContext?.transitionWasCancelled ?? false {
                self.transitionContext?.completeTransition(false)
                toView.isHidden = true
                fromView.isHidden = false
            } else {
                self.transitionContext?.completeTransition(true)
            }
            fromView.isHidden = false
            for fragmentView in fragmentViews {
                fragmentView.removeFromSuperview()
            }
        }
        
        self.endInteractiveBlock = { (success) in
            if success {
                for fragmentView in fragmentViews {
                    fragmentView.removeFromSuperview()
                }
            } else {
              
            }
        }
    }
    
    func fragmentHideTransitionAnimation(type: XJTransitionAnimationType) {
        
        guard let tempFromView = fromVc?.view?.snapshotView(afterScreenUpdates: false) else { return }
        
        guard let containerView = transitionContext?.containerView else { return }
        guard let fromView = fromVc?.view else { return }
        guard let toView = toVc?.view else { return }
        
        containerView.addSubview(toView)
        
        var fragmentViews: [UIView] = []
        
        let size = fromView.frame.size
        let fragmentWidth: CGFloat = 20.0
        
        let rowNum: Int = Int(size.width / fragmentWidth + 1)
        let columNum: Int = Int(size.height / fragmentWidth + 1)
        for i in 0..<rowNum {
            for j in 0..<columNum {
                let rect = CGRect(x: CGFloat(i) * fragmentWidth, y: CGFloat(j) * fragmentWidth, width: fragmentWidth, height: fragmentWidth)
                guard let fragmentView = tempFromView.resizableSnapshotView(from: rect, afterScreenUpdates: false, withCapInsets: .zero) else { return }
                fragmentView.frame = rect
                containerView.addSubview(fragmentView)
                fragmentViews.append(fragmentView)
            }
        }
        
        toView.isHidden = false
        fromView.isHidden = true
        
        UIView.animate(withDuration: self.animationTime) {
            for fragmentView in fragmentViews {
                
                var rect = fragmentView.frame
                
                switch type {
                case .fragmentHideFromRight:
                    rect.origin.x = rect.origin.x - CGFloat(arc4random() % (50 * 50))
                case .fragmentHideFromLeft:
                    rect.origin.x = rect.origin.x + CGFloat(arc4random() % (50 * 50))
                case .fragmentHideFromTop:
                    rect.origin.y = rect.origin.y + CGFloat(arc4random() % (50 * 50))
                case .fragmentHideFromBottom:
                    rect.origin.y = rect.origin.y - CGFloat(arc4random() % (50 * 50))
                default: break
                    
                }
                
                fragmentView.frame = rect
                fragmentView.alpha = 0
            }
        } completion: { finished in
            for fragmentView in fragmentViews {
                fragmentView.removeFromSuperview()
            }
            if self.transitionContext?.transitionWasCancelled ?? false {
                self.transitionContext?.completeTransition(false)
            } else {
                self.transitionContext?.completeTransition(true)
            }
            fromView.isHidden = false
        }
    }
    
    func fragmentHideTransitionBackAnimation(type: XJTransitionAnimationType) {
        guard let containerView = transitionContext?.containerView else { return }
        guard let fromView = fromVc?.view else { return }
        guard let toView = toVc?.view else { return }
        
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        
        if toView.isHidden == true { toView.isHidden = false }
        
        var fragmentViews: [UIView] = []
        
        let size = fromView.frame.size
        let fragmentWidth: CGFloat = 20.0
        
        let rowNum: Int = Int(size.width / fragmentWidth + 1)
        let columNum: Int = Int(size.height / fragmentWidth + 1)
        for i in 0..<rowNum {
            for j in 0..<columNum {
                let rect = CGRect(x: CGFloat(i) * fragmentWidth, y: CGFloat(j) * fragmentWidth, width: fragmentWidth, height: fragmentWidth)
                guard let fragmentView = toView.resizableSnapshotView(from: rect, afterScreenUpdates: false, withCapInsets: .zero) else { return }
                fragmentView.frame = rect
                containerView.addSubview(fragmentView)
                fragmentViews.append(fragmentView)
                
                switch type {
                case .fragmentHideFromRight:
                    fragmentView.layer.transform = CATransform3DMakeTranslation( -CGFloat(arc4random() % 50 * 50), 0, 0)
                case .fragmentHideFromLeft:
                    fragmentView.layer.transform = CATransform3DMakeTranslation( CGFloat(arc4random() % 50 * 50), 0 , 0)
                case .fragmentHideFromTop:
                    fragmentView.layer.transform = CATransform3DMakeTranslation(0, CGFloat(arc4random() % 50 * 50), 0)
                case .fragmentHideFromBottom:
                    fragmentView.layer.transform = CATransform3DMakeTranslation(0, -CGFloat(arc4random() % 50 * 50), 0)
                default: break
                }
                fragmentView.alpha = 0
            }
        }
        
//        toView.isHidden = true
//        fromView.isHidden = false
        
        
        UIView.animate(withDuration: self.animationTime) {
            
            for fragmentView in fragmentViews {
                fragmentView.alpha = 1
                fragmentView.layer.transform = CATransform3DIdentity
            }
            
        } completion: { finished in
            
            for fragmentView in fragmentViews {
                fragmentView.removeFromSuperview()
            }
            
            if self.transitionContext?.transitionWasCancelled ?? false {
                self.transitionContext?.completeTransition(false)
                
                toView.isHidden = true
                fromView.isHidden = false
                
            } else {
                self.transitionContext?.completeTransition(true)
                toView.isHidden = false
                fromView.isHidden = true
            }
            
//            toView.isHidden = false
        }
        
        self.endInteractiveBlock = { (success) in
            if success {
//                for fragmentView in fragmentViews {
//                    fragmentView.removeFromSuperview()
//                }
//                toView.isHidden = false
            } else {
              
            }
        }
    }
}

// MARK: - filp动画
extension XJTransitionManager {
    func flipFromRightTransitionAnimation(type: XJTransitionAnimationType) {
        guard let containerView = transitionContext?.containerView else { return }
        guard let fromView = fromVc?.view else { return }
        guard let toView = toVc?.view else { return }
        
        let screenW = UIScreen.main.bounds.size.width
        let screenH = UIScreen.main.bounds.size.height
        
        
        let leftImg = self.image(for: toView, atFrame: CGRect(x: 0, y: 0, width: screenW * 0.5, height: screenH))
        let leftView = UIImageView(image: leftImg)
        leftView.contentMode = .scaleAspectFill
        leftView.layer.transform = CATransform3DMakeRotation(.pi, 0.0, 1.0, 0.0)
        leftView.layer.isDoubleSided = false
        
        let fromImgLeft = self.image(for: fromView, atFrame: CGRect(x: 0, y: 0, width: screenW * 0.5, height: screenH))
        let fromLeftView = UIImageView(image: fromImgLeft)
        fromLeftView.layer.isDoubleSided = false
        
        let fromImgRight = self.image(for: fromView, atFrame: CGRect(x: screenW * 0.5, y: 0, width: screenW * 0.5, height: screenH))
        let fromRightView = UIImageView(image: fromImgRight)
        fromRightView.layer.isDoubleSided = false
        
        let flipView = UIView(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH))
        flipView.backgroundColor = UIColor.clear
        flipView.layer.addSublayer(leftView.layer)
        flipView.layer.addSublayer(fromRightView.layer)
        
        containerView.addSubview(toView)
        containerView.addSubview(fromLeftView)
        containerView.addSubview(flipView)
        
        UIView.animate(withDuration: self.animationTime) {
            fromRightView.layer.transform = CATransform3DMakeRotation(-.pi, 0.0, 1.0, 0.0)
            leftView.layer.transform = CATransform3DIdentity
        } completion: { finished in
            
         
            
            if self.transitionContext?.transitionWasCancelled ?? false {
                self.transitionContext?.completeTransition(false)
                containerView.bringSubviewToFront(fromView)
            } else {
                self.transitionContext?.completeTransition(true)
            }
            
            fromLeftView.removeFromSuperview()
            fromRightView.removeFromSuperview()
            leftView.removeFromSuperview()
            flipView.removeFromSuperview()
        }
        
        self.endInteractiveBlock = { sucess in
            if sucess {
                
            } else {

            }
        }
    }
    
    func flipFromLeftTransitionAnimation(type: XJTransitionAnimationType) {
        guard let containerView = transitionContext?.containerView else { return }
        guard let fromView = fromVc?.view else { return }
        guard let toView = toVc?.view else { return }
        
        let screenW = UIScreen.main.bounds.size.width
        let screenH = UIScreen.main.bounds.size.height
        
        let rightImg = self.image(for: toView, atFrame: CGRect(x: screenW * 0.5, y: 0, width: screenW * 0.5, height: screenH))
        let RightView = UIImageView(image: rightImg)
        RightView.contentMode = .scaleAspectFill
        RightView.layer.transform = CATransform3DMakeRotation(-.pi, 0.0, 1.0, 0.0)
        RightView.layer.isDoubleSided = false
        
        let fromImgLeft = self.image(for: fromView, atFrame: CGRect(x: 0, y: 0, width: screenW * 0.5, height: screenH))
        let fromLeftView = UIImageView(image: fromImgLeft)
        fromLeftView.layer.isDoubleSided = false
        
        let fromImgRight = self.image(for: fromView, atFrame: CGRect(x: screenW * 0.5, y: 0, width: screenW * 0.5, height: screenH))
        let fromRightView = UIImageView(image: fromImgRight)
        fromRightView.layer.isDoubleSided = false
        
        let flipView = UIView(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH))
        flipView.backgroundColor = UIColor.clear
        flipView.layer.addSublayer(RightView.layer)
        flipView.layer.addSublayer(fromLeftView.layer)
        
        containerView.addSubview(toView)
        containerView.addSubview(fromRightView)
        containerView.addSubview(flipView)
        
        UIView.animate(withDuration: self.animationTime) {
            fromLeftView.layer.transform = CATransform3DMakeRotation(.pi, 0.0, 1.0, 0.0)
            RightView.layer.transform = CATransform3DIdentity
        } completion: { finished in
            
            if self.transitionContext?.transitionWasCancelled ?? false {
                print("transitionWasCancelled-----true")
                self.transitionContext?.completeTransition(false)
                containerView.bringSubviewToFront(fromView)
            } else {
                print("transitionWasCancelled-----false")
                self.transitionContext?.completeTransition(true)
            }
            
            fromLeftView.removeFromSuperview()
            fromRightView.removeFromSuperview()
            RightView.removeFromSuperview()
            flipView.removeFromSuperview()
        }
        
        self.endInteractiveBlock = { sucess in
            if sucess {
                print("end-----true")
            } else {
                print("end-----false")
            }
        }
    }
    
    func flipFromBottomTransitionAnimation(type: XJTransitionAnimationType) {
        guard let containerView = transitionContext?.containerView else { return }
        guard let fromView = fromVc?.view else { return }
        guard let toView = toVc?.view else { return }
        
        let screenW = UIScreen.main.bounds.size.width
        let screenH = UIScreen.main.bounds.size.height
        
        let topImg = self.image(for: toView, atFrame: CGRect(x: 0, y: 0, width: screenW, height: screenH * 0.5))
        let topView = UIImageView(image: topImg)
        topView.contentMode = .scaleAspectFill
        topView.layer.transform = CATransform3DMakeRotation(.pi, 1.0, 0.0, 0.0)
        topView.layer.isDoubleSided = false
        
        let fromImgTop = self.image(for: fromView, atFrame: CGRect(x: 0, y: 0, width: screenW, height: screenH * 0.5))
        let fromTopView = UIImageView(image: fromImgTop)
        fromTopView.layer.isDoubleSided = false
        
        let fromImgBottom = self.image(for: fromView, atFrame: CGRect(x: 0, y: screenH * 0.5, width: screenW, height: screenH * 0.5))
        let fromBottomView = UIImageView(image: fromImgBottom)
        fromBottomView.layer.isDoubleSided = false
        
        let flipView = UIView(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH))
        flipView.backgroundColor = UIColor.clear
        flipView.layer.addSublayer(topView.layer)
        flipView.layer.addSublayer(fromBottomView.layer)
        
        containerView.addSubview(toView)
        containerView.addSubview(fromTopView)
        containerView.addSubview(flipView)
        
        UIView.animate(withDuration: self.animationTime) {
            fromBottomView.layer.transform = CATransform3DMakeRotation(-.pi, 1.0, 0.0, 0.0)
            topView.layer.transform = CATransform3DIdentity
        } completion: { finished in
            
            fromTopView.removeFromSuperview()
            fromBottomView.removeFromSuperview()
            topView.removeFromSuperview()
            flipView.removeFromSuperview()
            
            if self.transitionContext?.transitionWasCancelled ?? false {
                self.transitionContext?.completeTransition(false)
                containerView.bringSubviewToFront(fromView)
            } else {
                self.transitionContext?.completeTransition(true)
            }
        }
        
        self.endInteractiveBlock = { sucess in
            if sucess {
              
            } else {
     
            }
        }
    }
    
    func flipFromTopTransitionAnimation(type: XJTransitionAnimationType) {
        guard let containerView = transitionContext?.containerView else { return }
        guard let fromView = fromVc?.view else { return }
        guard let toView = toVc?.view else { return }
        
        let screenW = UIScreen.main.bounds.size.width
        let screenH = UIScreen.main.bounds.size.height
        
        let bottomImg = self.image(for: toView, atFrame: CGRect(x: 0, y: screenH * 0.5, width: screenW, height: screenH * 0.5))
        let bottomView = UIImageView(image: bottomImg)
        bottomView.contentMode = .scaleAspectFill
        bottomView.layer.transform = CATransform3DMakeRotation(-.pi, 1.0, 0.0, 0.0)
        bottomView.layer.isDoubleSided = false
        
        let fromImgTop = self.image(for: fromView, atFrame: CGRect(x: 0, y: 0, width: screenW, height: screenH * 0.5))
        let fromTopView = UIImageView(image: fromImgTop)
        fromTopView.layer.isDoubleSided = false
        
        let fromImgBottom = self.image(for: fromView, atFrame: CGRect(x: 0, y: screenH * 0.5, width: screenW, height: screenH * 0.5))
        let fromBottomView = UIImageView(image: fromImgBottom)
        fromBottomView.layer.isDoubleSided = false
        
        let flipView = UIView(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH))
        flipView.backgroundColor = UIColor.clear
        flipView.layer.addSublayer(bottomView.layer)
        flipView.layer.addSublayer(fromTopView.layer)
        
        containerView.addSubview(toView)
        containerView.addSubview(fromBottomView)
        containerView.addSubview(flipView)
        
        UIView.animate(withDuration: self.animationTime) {
            fromTopView.layer.transform = CATransform3DMakeRotation(.pi, 1.0, 0.0, 0.0)
            bottomView.layer.transform = CATransform3DIdentity
        } completion: { finished in
            
            fromTopView.removeFromSuperview()
            fromBottomView.removeFromSuperview()
            bottomView.removeFromSuperview()
            flipView.removeFromSuperview()
            
            if self.transitionContext?.transitionWasCancelled ?? false {
                self.transitionContext?.completeTransition(false)
                containerView.bringSubviewToFront(fromView)
            } else {
                self.transitionContext?.completeTransition(true)
            }
        }
        
        self.endInteractiveBlock = { sucess in
            if sucess {
       
            } else {
    
            }
        }
    }
}

// MARK: - 动画类型
extension XJTransitionManager {
    
    func setBackAnimationType(type: XJTransitionAnimationType) -> XJTransitionAnimationType {
        var backType: XJTransitionAnimationType = .normal
        switch type {
        case .fade:
            backType = .fade
        case .pushFromRight:
            backType = .pushFromLeft
        case .pushFromLeft:
            backType = .pushFromRight
        case .pushFromTop:
            backType = .pushFromBottom
        case .pushFromBottom:
            backType = .pushFromTop
        case .revealFromRight:
            backType = .revealFromLeft
        case .revealFromLeft:
            backType = .revealFromRight
        case .revealFromTop:
            backType = .revealFromBottom
        case .revealFromBottom:
            backType = .revealFromTop
        case .moveInFromRight:
            backType = .moveInFromLeft
        case .moveInFromLeft:
            backType = .moveInFromRight
        case .moveInFromTop:
            backType = .moveInFromBottom
        case .moveInFromBottom:
            backType = .moveInFromTop
        case .cubeFromRight:
            backType = .cubeFromLeft
        case .cubeFromLeft:
            backType = .cubeFromRight
        case .cubeFromTop:
            backType = .cubeFromBottom
        case .cubeFromBottom:
            backType = .cubeFromTop
        case .suckEffect:
            backType = .suckEffect
        case .oglFlipFromRight:
            backType = .oglFlipFromLeft
        case .oglFlipFromLeft:
            backType = .oglFlipFromRight
        case .oglFlipFromTop:
            backType = .oglFlipFromBottom
        case .oglFlipFromBottom:
            backType = .oglFlipFromTop
        case .rippleEffect:
            backType = .rippleEffect
        case .pageCurlFromRight:
            backType = .pageCurlFromLeft
        case .pageCurlFromLeft:
            backType = .pageCurlFromRight
        case .pageCurlFromTop:
            backType = .pageCurlFromBottom
        case .pageCurlFromBottom:
            backType = .pageCurlFromTop
        case .pageUnCurlFromRight:
            backType = .pageUnCurlFromLeft
        case .pageUnCurlFromLeft:
            backType = .pageUnCurlFromRight
        case .pageUnCurlFromTop:
            backType = .pageUnCurlFromBottom
        case .pageUnCurlFromBottom:
            backType = .pageUnCurlFromTop
        case .cameraIrisHollowOpen:
            backType = .cameraIrisHollowClose
        case .cameraIrisHollowClose:
            backType = .cameraIrisHollowOpen
        default:
            backType = .pointSpread
            break
        }
        return backType
    }
    
    /// 获取系统动画类型
    func getSystemTransition(type: XJTransitionAnimationType) -> CATransition {
        
        print("type ==== \(type)")
        
        let transion = CATransition()
        transion.duration = self.animationTime
        transion.delegate = self
        
        switch type {
        case .fade:
            transion.type = .fade
        case .pushFromRight:
            transion.type = .push
            transion.subtype = .fromRight
        case .pushFromLeft:
            transion.type = .push
            transion.subtype = .fromLeft
        case .pushFromTop:
            transion.type = .push
            transion.subtype = .fromTop
        case .pushFromBottom:
            transion.type = .push
            transion.subtype = .fromBottom
        case .revealFromRight:
            transion.type = .reveal
            transion.subtype = .fromRight
        case .revealFromLeft:
            transion.type = .reveal
            transion.subtype = .fromLeft
        case .revealFromTop:
            transion.type = .reveal
            transion.subtype = .fromTop
        case .revealFromBottom:
            transion.type = .reveal
            transion.subtype = .fromBottom
        case .moveInFromRight:
            transion.type = .moveIn
            transion.subtype = .fromRight
        case .moveInFromLeft:
            transion.type = .moveIn
            transion.subtype = .fromLeft
        case .moveInFromTop:
            transion.type = .moveIn
            transion.subtype = .fromTop
        case .moveInFromBottom:
            transion.type = .moveIn
            transion.subtype = .fromBottom
        case .cubeFromRight:
            transion.type = CATransitionType(rawValue: "cube")
            transion.subtype = .fromRight
        case .cubeFromLeft:
            transion.type = CATransitionType(rawValue: "cube")
            transion.subtype = .fromLeft
        case .cubeFromTop:
            transion.type = CATransitionType(rawValue: "cube")
            transion.subtype = .fromTop
        case .cubeFromBottom:
            transion.type = CATransitionType(rawValue: "cube")
            transion.subtype = .fromBottom
        case .suckEffect:
            transion.type = CATransitionType(rawValue: "suckEffect")
        case .oglFlipFromRight:
            transion.type = CATransitionType(rawValue: "oglFlip")
            transion.subtype = .fromRight
        case .oglFlipFromLeft:
            transion.type = CATransitionType(rawValue: "oglFlip")
            transion.subtype = .fromLeft
        case .oglFlipFromTop:
            transion.type = CATransitionType(rawValue: "oglFlip")
            transion.subtype = .fromTop
        case .oglFlipFromBottom:
            transion.type = CATransitionType(rawValue: "oglFlip")
            transion.subtype = .fromBottom
        case .rippleEffect:
            transion.type = CATransitionType(rawValue: "rippleEffect")
        case .pageCurlFromRight:
            transion.type = CATransitionType(rawValue: "pageCurl")
            transion.subtype = .fromRight
        case .pageCurlFromLeft:
            transion.type = CATransitionType(rawValue: "pageCurl")
            transion.subtype = .fromLeft
        case .pageCurlFromTop:
            transion.type = CATransitionType(rawValue: "pageCurl")
            transion.subtype = .fromTop
        case .pageCurlFromBottom:
            transion.type = CATransitionType(rawValue: "pageCurl")
            transion.subtype = .fromBottom
        case .pageUnCurlFromRight:
            transion.type = CATransitionType(rawValue: "pageUnCurl")
            transion.subtype = .fromRight
        case .pageUnCurlFromLeft:
            transion.type = CATransitionType(rawValue: "pageUnCurl")
            transion.subtype = .fromLeft
        case .pageUnCurlFromTop:
            transion.type = CATransitionType(rawValue: "pageUnCurl")
            transion.subtype = .fromTop
        case .pageUnCurlFromBottom:
            transion.type = CATransitionType(rawValue: "pageUnCurl")
            transion.subtype = .fromBottom
        case .cameraIrisHollowOpen:
            transion.type = CATransitionType(rawValue: "cameraIrisHollowOpen")
        case .cameraIrisHollowClose:
            transion.type = CATransitionType(rawValue: "cameraIrisHollowClose")
        default: break
        }
        
        return transion
    }
}
