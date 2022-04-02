//
//  UIButton+Extension.swift
//  ShiJianYun
//
//  Created by Mr.Yang on 2021/10/14.
//

import Foundation

// MARK: - Create
public extension XJExtension where Base: UIButton {
    /// UIButton创建
    /// - Parameters:
    ///   - bgColor: 背景颜色
    ///   - imageName: 图片
    ///   - title: 标题
    ///   - titleColor: 标题颜色
    ///   - font: 字体大小
    /// - Returns: UIButton
    static func create(bgColor: UIColor = UIColor.white,
                     imageName: String? = nil,
                     title: String? = nil,
                     titleColor: UIColor = Color_333333_333333,
                     font: CGFloat = 16) -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = bgColor
        if let imageName = imageName {
            button.setImage(UIImage(named: imageName), for: .normal)
        }
        if let title = title {
            button.setTitle(title, for: .normal)
        }
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: font)
        return button
    }
}

// MARK:- 二、链式调用
public extension UIButton {
    
    // MARK: 2.1、设置title
    /// 设置title
    /// - Parameters:
    ///   - text: 文字
    ///   - state: 状态
    /// - Returns: 返回自身
    @discardableResult
    func title(_ text: String, _ state: UIControl.State = .normal) -> Self {
        setTitle(text, for: state)
        return self
    }
    
    // MARK: 2.2、设置文字颜色
    /// 设置文字颜色
    /// - Parameters:
    ///   - color: 文字颜色
    ///   - state: 状态
    /// - Returns: 返回自身
    @discardableResult
    func textColor(_ color: UIColor, _ state: UIControl.State = .normal) -> Self {
        setTitleColor(color, for: state)
        return self
    }
    
    // MARK: 2.3、设置字体大小(UIFont)
    /// 设置字体大小
    /// - Parameter font: 字体 UIFont
    /// - Returns: 返回自身
    @discardableResult
    func font(_ font: UIFont) -> Self {
        titleLabel?.font = font
        return self
    }
    
    // MARK: 2.4、设置字体大小(CGFloat)
    /// 设置字体大小(CGFloat)
    /// - Parameter fontSize: 字体的大小
    /// - Returns: 返回自身
    @discardableResult
    func font(_ fontSize: CGFloat) -> Self {
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        return self
    }
    
    // MARK: 2.5、设置字体粗体
    /// 设置粗体
    /// - Parameter fontSize: 设置字体粗体
    /// - Returns: 返回自身
    @discardableResult
    func boldFont(_ fontSize: CGFloat) -> Self {
        titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSize)
        return self
    }
    
    // MARK: 2.6、设置图片
    /// 设置图片
    /// - Parameters:
    ///   - image: 图片
    ///   - state: 状态
    /// - Returns: 返回自身
    @discardableResult
    func image(_ image: UIImage?, _ state: UIControl.State = .normal) -> Self {
        setImage(image, for: state)
        return self
    }
    
    // MARK: 2.7、设置图片(通过Bundle加载)
    /// 设置图片(通过Bundle加载)
    /// - Parameters:
    ///   - bundle: Bundle
    ///   - imageName: 图片名字
    ///   - state: 状态
    /// - Returns: 返回自身
    @discardableResult
    func image(in bundle: Bundle? = nil, _ imageName: String, _ state: UIControl.State = .normal) -> Self {
        let image = UIImage(named: imageName, in: bundle, compatibleWith: nil)
        setImage(image, for: state)
        return self
    }
    
    // MARK: 2.8、设置图片(通过Bundle加载)
    /// 设置图片(通过Bundle加载)
    /// - Parameters:
    ///   - aClass: className bundle所在的类的类名
    ///   - bundleName: bundle 的名字
    ///   - imageName: 图片的名字
    ///   - state: 状态
    /// - Returns: 返回自身
    @discardableResult
    func image(forParent aClass: AnyClass, bundleName: String, _ imageName: String, _ state: UIControl.State = .normal) -> Self {
        guard let path = Bundle(for: aClass).path(forResource: bundleName, ofType: "bundle") else {
            return self
        }
        let image = UIImage(named: imageName, in: Bundle(path: path), compatibleWith: nil)
        setImage(image, for: state)
        return self
    }
    
    // MARK: 2.9、设置图片(纯颜色的图片)
    /// 设置图片(纯颜色的图片)
    /// - Parameters:
    ///   - color: 图片颜色
    ///   - state: 状态
    /// - Returns: 返回自身
    @discardableResult
    func image(_ color: UIColor, _ size: CGSize = CGSize(width: 20.0, height: 20.0), _ state: UIControl.State = .normal) -> Self {
        let image = UIImage.xj.image(color: color, size: size)
        setImage(image, for: state)
        return self
    }
    
    // MARK: 2.10、设置背景图片
    /// 设置背景图片
    /// - Parameters:
    ///   - image: 图片
    ///   - state: 状态
    /// - Returns: 返回自身
    @discardableResult
    func bgImage(_ image: UIImage?, _ state: UIControl.State = .normal) -> Self {
        setBackgroundImage(image, for: state)
        return self
    }
    
    // MARK: 2.11、设置背景图片(通过Bundle加载)
    /// 设置背景图片(通过Bundle加载)
    /// - Parameters:
    ///   - aClass: className bundle所在的类的类名
    ///   - bundleName: bundle 的名字
    ///   - imageName: 图片的名字
    ///   - state: 状态
    /// - Returns: 返回自身
    @discardableResult
    func bgImage(forParent aClass: AnyClass, bundleName: String, _ imageName: String, _: UIControl.State = .normal) -> Self {
        guard let path = Bundle(for: aClass).path(forResource: bundleName, ofType: "bundle") else {
            return self
        }
        let image = UIImage(named: imageName, in: Bundle(path: path), compatibleWith: nil)
        setBackgroundImage(image, for: state)
        return self
    }
    
    // MARK: 2.12、设置背景图片(通过Bundle加载)
    /// 设置背景图片(通过Bundle加载)
    /// - Parameters:
    ///   - bundle: Bundle
    ///   - imageName: 图片的名字
    ///   - state: 状态
    /// - Returns: 返回自身
    @discardableResult
    func bgImage(in bundle: Bundle? = nil, _ imageName: String, _ state: UIControl.State = .normal) -> Self {
        let image = UIImage(named: imageName, in: bundle, compatibleWith: nil)
        setBackgroundImage(image, for: state)
        return self
    }
    
    // MARK: 2.13、设置背景图片(纯颜色的图片)
    /// 设置背景图片(纯颜色的图片)
    /// - Parameters:
    ///   - color: 背景色
    ///   - state: 状态
    /// - Returns: 返回自身
    @discardableResult
    func bgImage(_ color: UIColor, _ state: UIControl.State = .normal) -> Self {
        let image = UIImage.xj.image(color: color)
        setBackgroundImage(image, for: state)
        return self
    }
    
    // MARK: 2.14、按钮点击的变化
    /// 按钮点击的变化
    /// - Returns: 返回自身
    @discardableResult
    func confirmButton() -> Self {
        let normalImage = UIImage.xj.image(color: UIColor.hexStringColor(hexString: "#E54749"), size: CGSize(width: 10, height: 10), corners: .allCorners, radius: 4)?.resizableImage(withCapInsets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        let disableImg = UIImage.xj.image(color: UIColor.hexStringColor(hexString: "#E6E6E6"), size: CGSize(width: 10, height: 10), corners: .allCorners, radius: 4)?.resizableImage(withCapInsets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        setBackgroundImage(normalImage, for: .normal)
        setBackgroundImage(disableImg, for: .disabled)
        return self
    }
}

// MARK:- 三、UIButton 图片 与 title 位置关系
/// UIButton 图片与title位置关系 https://www.jianshu.com/p/0f34c1b52604
public extension XJExtension where Base: UIButton {
    
    /// 图片 和 title 的布局样式
    enum ImageTitleLayout {
        case imgTop
        case imgBottom
        case imgLeft
        case imgRight
    }
    
    // MARK: 3.1、设置图片和 title 的位置关系(提示：title和image要在设置布局关系之前设置)
    /// 设置图片和 title 的位置关系(提示：title和image要在设置布局关系之前设置)
    /// - Parameters:
    ///   - layout: 布局
    ///   - spacing: 间距
    /// - Returns: 返回自身
    @discardableResult
    func setImageTitleLayout(_ layout: ImageTitleLayout, spacing: CGFloat = 0) -> UIButton {
        switch layout {
        case .imgLeft:
            alignHorizontal(spacing: spacing, imageFirst: true)
        case .imgRight:
            alignHorizontal(spacing: spacing, imageFirst: false)
        case .imgTop:
            alignVertical(spacing: spacing, imageTop: true)
        case .imgBottom:
            alignVertical(spacing: spacing, imageTop: false)
        }
        return self.base
    }
    
    /// 水平方向
    /// - Parameters:
    ///   - spacing: 间距
    ///   - imageFirst: 图片是否优先
    private func alignHorizontal(spacing: CGFloat, imageFirst: Bool) {
        let edgeOffset = spacing / 2
        base.imageEdgeInsets = UIEdgeInsets(top: 0,
                                       left: -edgeOffset,
                                       bottom: 0,
                                       right: edgeOffset)
        base.titleEdgeInsets = UIEdgeInsets(top: 0,
                                       left: edgeOffset,
                                       bottom: 0,
                                       right: -edgeOffset)
        if !imageFirst {
            base.transform = CGAffineTransform(scaleX: -1, y: 1)
            base.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
            base.titleLabel?.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        base.contentEdgeInsets = UIEdgeInsets(top: 0, left: edgeOffset, bottom: 0, right: edgeOffset)
    }
    
    /// 垂直方向
    /// - Parameters:
    ///   - spacing: 间距
    ///   - imageTop: 图片是不是在顶部
    private func alignVertical(spacing: CGFloat, imageTop: Bool) {
        guard let imageSize = self.base.imageView?.image?.size,
              let text = self.base.titleLabel?.text,
              let font = self.base.titleLabel?.font
            else {
                return
        }
        let labelString = NSString(string: text)
        let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: font])
        
        let imageVerticalOffset = (titleSize.height + spacing) / 2
        let titleVerticalOffset = (imageSize.height + spacing) / 2
        let imageHorizontalOffset = (titleSize.width) / 2
        let titleHorizontalOffset = (imageSize.width) / 2
        let sign: CGFloat = imageTop ? 1 : -1
        
        base.imageEdgeInsets = UIEdgeInsets(top: -imageVerticalOffset * sign,
                                       left: imageHorizontalOffset,
                                       bottom: imageVerticalOffset * sign,
                                       right: -imageHorizontalOffset)
        base.titleEdgeInsets = UIEdgeInsets(top: titleVerticalOffset * sign,
                                       left: -titleHorizontalOffset,
                                       bottom: -titleVerticalOffset * sign,
                                       right: titleHorizontalOffset)
        // increase content height to avoid clipping
        let edgeOffset = (min(imageSize.height, titleSize.height) + spacing) / 2
        base.contentEdgeInsets = UIEdgeInsets(top: edgeOffset, left: 0, bottom: edgeOffset, right: 0)
    }
}

// MARK:- 六、Button扩大点击事件
private var XJUIButtonExpandSizeKey = "XJUIButtonExpandSizeKey"
public extension UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let buttonRect = self.xj.expandRect()
        if (buttonRect.equalTo(bounds)) {
            return super.point(inside: point, with: event)
        }else{
            return buttonRect.contains(point)
        }
    }
}

public extension XJExtension where Base: UIButton {

    // MARK: 6.1、扩大UIButton的点击区域，向四周扩展10像素的点击范围
    /// 扩大UIButton的点击区域，向四周扩展10像素的点击范围
    /// - Parameter size: 向四周扩展像素的点击范围
    func expandSize(size: CGFloat) {
        objc_setAssociatedObject(self.base, &XJUIButtonExpandSizeKey, size, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
    }

    fileprivate func expandRect() -> CGRect {
        let expandSize = objc_getAssociatedObject(self.base, &XJUIButtonExpandSizeKey)
        if (expandSize != nil) {
//            return CGRect(x: self.base.bounds.origin.x - (expandSize as! CGFloat), y: self.base.bounds.origin.y - (expandSize as! CGFloat), width: self.base.bounds.size.width + 2 * (expandSize as! CGFloat), height: self.base.bounds.size.height + 2 * (expandSize as! CGFloat))
            return CGRect(x: self.base.bounds.origin.x - (expandSize as! CGFloat), y: self.base.bounds.origin.y, width: self.base.bounds.size.width + (expandSize as! CGFloat), height: self.base.bounds.size.height)
        } else {
            return self.base.bounds
        }
    }
}
