//
//  XJTabBarViewController.swift
//  XJSwiftKit
//
//  Created by Mr.Yang on 2021/4/14.
//

import UIKit

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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 不透明
        self.tabBar.isTranslucent = false

        setupController()
    }
    
    func setupController() {
        
        let homeVc = setupTabBarItem(controller: XJHomeViewController(), title: KTabbarHomeTitle, image: KTabbarHomeNormalImage, selectedImage: KTabbarHomeSelectImage)
        
        let mineVc = setupTabBarItem(controller: XJMineViewController(), title: KTabbarMineTitle, image: KTabbarMineNormalImage, selectedImage: KTabbarMineSelectImage)
        
        self.viewControllers = [homeVc, mineVc];
    }
    
    func setupTabBarItem(controller: UIViewController, title: String, image: UIImage?, selectedImage: UIImage?) -> UINavigationController{
        
        let item = UITabBarItem(title: title, image:image?.withRenderingMode(.alwaysOriginal), selectedImage: selectedImage?.withRenderingMode(.alwaysOriginal))
        item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Color_333333_333333], for: .normal)
        item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Color_System], for: .selected)
        controller.tabBarItem = item
        self.tabBar.tintColor = UIColor.yellow
        let navic = XJNavigationViewController(rootViewController: controller)
        return navic
    }
    
}

extension XJTabBarViewController {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let tabIndex = tabBar.items?.firstIndex(of: item) ?? 0
        let button = tabBar.subviews[tabIndex+1]
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
}
