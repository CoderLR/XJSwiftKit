//
//  UIViewController+Extension.swift
//  ShiJianYun
//
//  Created by Mr.Yang on 2021/10/20.
//

import Foundation

// MARK:- 一、基本的扩展
extension UIViewController: XJCompatible {}

public extension XJExtension where Base: UIViewController {
    
    // MARK: 1.1、pop回上一个界面
    /// pop回上一个界面
    func popToPreviousVC() {
        guard let nav = self.base.navigationController else { return }
        if let index = nav.viewControllers.firstIndex(of: self.base), index > 0 {
            let vc = nav.viewControllers[index - 1]
            nav.popToViewController(vc, animated: true)
        }
    }
    
    // MARK: 1.2、获取push进来的 VC
    /// 获取push进来的 VC
    /// - Returns: push进来的 VC
    func getPreviousNavVC() -> UIViewController? {
        guard let nav = self.base.navigationController else { return nil }
        if nav.viewControllers.count <= 1 {
            return nil
        }
        if let index = nav.viewControllers.firstIndex(of: self.base), index > 0 {
            let vc = nav.viewControllers[index - 1]
            return vc
        }
        return nil
    }
    
    // MARK: 1.3、获取顶部控制器(类方法)
    /// 获取顶部控制器
    /// - Returns: VC
    static func topViewController() -> UIViewController? {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first, let rootVC = window.rootViewController  else {
            return nil
        }
        return top(rootVC: rootVC)
    }
    
    // MARK: 1.4、获取顶部控制器(实例方法)
    /// 获取顶部控制器
    /// - Returns: VC
    func topViewController() -> UIViewController? {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first, let rootVC = window.rootViewController  else {
            return nil
        }
        return Self.top(rootVC: rootVC)
    }
    
    private static func top(rootVC: UIViewController?) -> UIViewController? {
        if let presentedVC = rootVC?.presentedViewController {
            return top(rootVC: presentedVC)
        }
        if let nav = rootVC as? UINavigationController,
            let lastVC = nav.viewControllers.last {
            return top(rootVC: lastVC)
        }
        if let tab = rootVC as? UITabBarController,
            let selectedVC = tab.selectedViewController {
            return top(rootVC: selectedVC)
        }
        return rootVC
    }
    
    // MARK: 1.5、是否正在展示
    /// 是否正在展示
    var isCurrentVC: Bool {
        return base.isViewLoaded == true && (base.view!.window != nil)
    }
    
    // MARK: 1.6、关闭当前的控制器
    /// 关闭当前的控制器
    func closeCurrentVC() {
        guard let nav = self.base.navigationController else {
            base.dismiss(animated: true, completion: nil)
            return
        }
        if nav.viewControllers.count > 1 {
            nav.popViewController(animated: true)
        } else if let _ = nav.presentingViewController {
            nav.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK:- 二、Storyboard 的 VC 交互
/**
 提示：
 1、Storyboard 一定要设置一个初始化的控制器，勾选：Is Initial View Controller
 2、VC 之间的连线，比如 button，按住 ctrl 拖到其他的VC后，松开后在弹出界面选择跳转的方式
 3、在进行 Storyboard 里面指定 VC 跳转的时候记得设置 identifier，不然找不到对应的VC
 */
public extension XJExtension where Base: UIViewController {
    
    // MARK: 2.1、push跳转Storyboard(首个初始化的控制器)，一定要设置一个初始化的控制器，勾选：Is Initial View Controller
    /// push跳转Storyboard(首个初始化的控制器)
    /// - Parameters:
    ///   - storyboardName: storyboardName 的名字
    ///   - sender: 处理携带参数
    func pushStoryboard(_ storyboardName: String, sender: ((UIViewController) -> Void)?) {
        // 1、获取 UIStoryboard
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        // 2.1、入口为UIViewController
        guard var vc = storyboard.instantiateInitialViewController() else {
            print("一定要设置一个初始化的控制器，勾选：Is Initial View Controller")
            return
        }
        if let nc = vc as? UINavigationController, let topVc = nc.topViewController {
            // 2.2、入口为 UINavigationController
            vc = topVc
        }
        // 3、数据处理
        sender?(vc)
        self.base.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: 2.2、push跳转到Storyboard中指定UIViewController
    /// push跳转到Storyboard中指定UIViewController
    /// - Parameters:
    ///   - storyboardName: storyboardName的名字
    ///   - identifier: 定位UIViewController的标示符
    ///   - sender: 处理携带参数
    func pushStoryboard(_ storyboardName: String, identifier: String, sender: ((UIViewController) -> Void)?) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)
        sender?(vc)
        self.base.navigationController?.pushViewController(vc, animated: true)
    }
}
