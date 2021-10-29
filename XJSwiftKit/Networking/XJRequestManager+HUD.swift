//
//  XJRequestManager+HUD.swift
//  XJSwiftKit
//
//  Created by Mr.Yang on 2021/10/15.
//

import Foundation

// MARK: - 请求提示
extension XJRequestManager {
    
    /// 显示指示器 - 控制器view
    /// - Parameter text: 显示文字
    func showHUD(_ text: String = "") {
        self.topViewController = UIViewController.xj.topViewController()
        if Thread.current != Thread.main {
            DispatchQueue.main.async {
                YSActivityIndicatorView.showHUD(self.topViewController?.view, text: text)
                return
            }
        }
        
        YSActivityIndicatorView.showHUD(self.topViewController?.view, text: text)
    }
    
    /// 隐藏指示器 - 控制器view
    func dismissHUD() {
        if Thread.current != Thread.main {
            DispatchQueue.main.async {
                YSActivityIndicatorView.dismissHUD(self.topViewController?.view)
                self.topViewController = nil
                return
            }
        }
        YSActivityIndicatorView.dismissHUD(self.topViewController?.view)
        self.topViewController = nil
    }
    
    /// 显示文字 - window自动消失
    /// - Parameter text: 显示文字
    func showText(_ text: String) {
        if Thread.current != Thread.main {
            DispatchQueue.main.async {
                MBProgressHUD.showText(text: text)
                return
            }
        }
        MBProgressHUD.showText(text: text)
    }
}

// MARK: - 错误提示
extension XJRequestManager {
    /// 请求成功错误消息提示
    /// - Parameters:
    ///   - errCode: 错误码
    ///   - errMsg: 错误描述
    func showSuccessError(errCode: Int?, errMsg: String?) {
        guard let code = errCode else { return }
        if code == SUCCESSCODE { return }
        
        // 提示错误
        self.showText("errCode:\(code) errMsg:\(errMsg ?? "")")
    }
    
    /// 请求失败错误消息提示
    /// - Parameters:
    ///   - errCode: 错误码
    ///   - errMsg: 错误描述
    func showFailureError(errCode: Int?, errMsg: String?) {
        // 提示错误
        self.showText("errCode:\(errCode ?? 1000) errMsg:\(errMsg ?? "")")
    }
}
