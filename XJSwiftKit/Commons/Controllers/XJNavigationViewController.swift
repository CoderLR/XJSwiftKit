//
//  XJNavigationViewController.swift
//  XJSwiftKit
//
//  Created by Mr.Yang on 2021/4/14.
//

import UIKit

class XJNavigationViewController: UINavigationController, UIGestureRecognizerDelegate {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.visibleViewController?.supportedInterfaceOrientations ?? .portrait
    }
    
    override var shouldAutorotate: Bool {
        return self.visibleViewController?.shouldAutorotate ?? false
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.visibleViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.interactivePopGestureRecognizer?.delegate = self
        
        // 不透明
        self.navigationBar.isTranslucent = false
        
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: KLargeFont,NSAttributedString.Key.foregroundColor:Color_292A2D_DEDFDF]
        let image = UIImage.xj.create(color: Color_FFFFFF_151515)
        self.navigationBar.setBackgroundImage(image, for: .default)
    }
    

    // fix iOS14 POP导航隐藏问题
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if #available(iOS 14.0, *) {
            if self.viewControllers.count > 1 {
                self.topViewController?.hidesBottomBarWhenPushed = false
            }
        }
        return super.popToViewController(viewController, animated: animated)
    }
    
    // fix iOS14 POP导航隐藏问题
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        if #available(iOS 14.0, *) {
            if self.viewControllers.count > 1 {
                self.topViewController?.hidesBottomBarWhenPushed = false
            }
        }
        return super.popToRootViewController(animated: animated)
    }
    
    // 跳转控制器调用
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.topViewController?.hidesBottomBarWhenPushed = true
        super.pushViewController(viewController, animated: animated)
        self.viewControllers[0].hidesBottomBarWhenPushed = false
    }
    
    // 跳转多控制器调用
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        guard let viewController = viewControllers.last else { return }
        print("viewController = \(viewController)")
        viewController.hidesBottomBarWhenPushed = true
        super.setViewControllers(viewControllers, animated: animated)
        viewControllers[0].hidesBottomBarWhenPushed = false
    }
}
