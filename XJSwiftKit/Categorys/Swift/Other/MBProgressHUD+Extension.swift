//
//  MBProgressHUD+Extension.swift
//  ShiJianYun
//
//  Created by Mr.Yang on 2021/10/14.
//

import UIKit

// MARK: - 网络指示器
// 注意：需要在主线程调用

extension MBProgressHUD {
    
    /// 显示指示器
    /// - Parameters:
    ///   - view: 父视图
    ///   - text: 子标题
    @discardableResult
    class func showHUD(_ view: UIView? = UIApplication.shared.keyWindow, text: String = "") -> MBProgressHUD? {
        guard let bgView = view else { return nil }
        let hud = MBProgressHUD.showAdded(to: bgView, animated: true)
        
        // 设置背景
        hud.margin = 20
        hud.animationType = .zoomOut
        hud.removeFromSuperViewOnHide = true
        if 0 == 1 {
            hud.bezelView.style = .solidColor
            hud.bezelView.backgroundColor = UIColor.black
            hud.contentColor = UIColor.white
        }
        
        // 设置显示
        if text.count > 0 {
            hud.label.text = text
            hud.label.font = KDefaultFont
            hud.label.textColor = UIColor.white
        }
        
        return hud
    }
    
    /// 隐藏指示器
    /// - Parameter view: 父视图
    class func dismissHUD(_ view: UIView? = UIApplication.shared.keyWindow) {
        guard let bgView = view else { return }
        MBProgressHUD.hide(for: bgView, animated: true)
    }
    
    /// 显示文字
    /// - Parameters:
    ///   - view: 父视图
    ///   - text: 子标题
    class func showText(_ view: UIView? = UIApplication.shared.keyWindow, text: String) {
        guard let bgView = view else { return }
        let hud = MBProgressHUD.showAdded(to: bgView, animated: true)
        hud.mode = .text // 显示模式
        
        // 设置背景
        hud.margin = 12
        hud.animationType = .zoomOut
        hud.removeFromSuperViewOnHide = true
        
        hud.bezelView.style = .solidColor
        hud.bezelView.backgroundColor = UIColor.black
        
        // 设置显示
        hud.label.text = text
        hud.label.font = KSmallFont
        hud.label.textColor = UIColor.white
        hud.label.numberOfLines = 0
        hud.hide(animated: true, afterDelay: 2.5)
    }
    
    /// 显示成功图片
    /// - Parameters:
    ///   - view: 父视图
    ///   - text: 子标题
    class func showSuccess(_ view: UIView? = UIApplication.shared.keyWindow,
                           text: String = "") {
        guard let bgView = view else { return }
        let hud = MBProgressHUD.showAdded(to: bgView, animated: true)
        hud.mode = .customView // 显示模式
        
        // 设置背景
        hud.margin = 20
        
        // 设置显示
        let image = UIImage(named: "icon_hud_mark")?.withRenderingMode(.alwaysTemplate)
        hud.customView = UIImageView(image: image)
        
        hud.label.text = text
        hud.label.font = KSmallFont
        hud.hide(animated: true, afterDelay: 2.5)
    }
    
    /// 显示图片
    /// - Parameters:
    ///   - view: 父视图
    ///   - imgName: 图片名
    ///   - text: 子标题
    class func showImage(_ view: UIView? = UIApplication.shared.keyWindow,
                           imgName: String = "",
                           text: String = "") {
        guard let bgView = view else { return }
        let hud = MBProgressHUD.showAdded(to: bgView, animated: true)
        hud.mode = .customView // 显示模式
        
        // 设置背景
        hud.margin = 20
        
        // 设置显示
        let image = UIImage(named: imgName)?.withRenderingMode(.alwaysTemplate)
        hud.customView = UIImageView(image: image)
        
        hud.label.text = text
        hud.label.font = KSmallFont
        hud.hide(animated: true, afterDelay: 2.5)
    }
    
    /// 显示失败图片
    /// - Parameters:
    ///   - view: 父视图
    ///   - text: 子标题
    class func showFail(_ view: UIView? = UIApplication.shared.keyWindow, text: String = "") {
        guard let bgView = view else { return }
        let hud = MBProgressHUD.showAdded(to: bgView, animated: true)
        hud.mode = .customView // 显示模式
        
        // 设置背景
        hud.margin = 20
        
        // 设置显示
        let image = UIImage(named: "icon_hud_error")?.withRenderingMode(.alwaysTemplate)
        hud.customView = UIImageView(image: image)
        
        hud.label.text = text
        hud.label.font = KSmallFont
        hud.hide(animated: true, afterDelay: 2.5)
    }
    
    
    /// 显示进度
    /// - Parameters:
    ///   - view: 父视图
    ///   - text: 子标题
    /// - Returns: MBProgressHUD
    /// use: hud.progress = 0..1
    @discardableResult
    class func showProgress(_ view: UIView? = UIApplication.shared.keyWindow, text: String = "") -> MBProgressHUD? {
        guard let bgView = view else { return nil }
        let hud = MBProgressHUD.showAdded(to: bgView, animated: true)
        hud.mode = .annularDeterminate // 显示模式
        
        // 设置背景
        hud.margin = 20
        
        // 设置显示
        hud.label.text = text
        hud.label.font = KSmallFont
        hud.hide(animated: true, afterDelay: 2.5)
        
        return hud
    }
}
