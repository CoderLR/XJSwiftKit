//
//  YSActivityIndicatorView+Extension.swift
//  LeiFengHao
//
//  Created by xj on 2021/10/20.
//

import Foundation

extension YSActivityIndicatorView {
    /// 显示指示器
    /// - Parameters:
    ///   - view: 父视图
    ///   - text: 子标题
    class func showHUD(_ view: UIView? = UIApplication.shared.keyWindow, text: String = "") {
        guard let bgView = view else { return }
        YSActivityIndicatorView.showAdded(to: bgView, animated: true)
    }

    /// 隐藏指示器
    /// - Parameter view: 父视图
    class func dismissHUD(_ view: UIView? = UIApplication.shared.keyWindow) {
        guard let bgView = view else { return }
        YSActivityIndicatorView.hide(for: bgView, animated: true)
    }

}
