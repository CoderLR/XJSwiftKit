//
//  UIView+Extension.swift
//  ShiJianYun
//
//  Created by Mr.Yang on 2021/10/13.
//

import UIKit

extension UIView: XJCompatible {}

// MARK: - Create
public extension XJExtension where Base: UIView {

    /// UIView创建
    /// - Parameters: - bgColor: 背景颜色
    /// - Returns: UIView
    static func create(bgColor: UIColor = UIColor.white,
                    cornerRadius: CGFloat? = nil,
                    borderColor: UIColor? = nil,
                    borderWidth: CGFloat? = nil) -> Base {
        let view = Base()
        view.backgroundColor = bgColor
        if let cornerRadius = cornerRadius {
            view.layer.cornerRadius = cornerRadius
            view.layer.masksToBounds = true
        }
        if let borderColor = borderColor {
            view.layer.borderColor = borderColor.cgColor
        }
        if let borderWidth = borderWidth {
            view.layer.borderWidth = borderWidth
        }
        return view
    }
    
    
    /// 设置圆角和边框
    /// - Parameters:
    ///   - cornerRadius: 圆角半径
    ///   - borderColor: 边框颜色
    ///   - borderWidth: 边框宽度
    /// - Returns: view
    @discardableResult
    func setLayer(cornerRadius: CGFloat? = nil,
                    borderColor: UIColor? = nil,
                    borderWidth: CGFloat? = nil) -> Base {
        if let cornerRadius = cornerRadius {
            self.base.layer.cornerRadius = cornerRadius
            self.base.layer.masksToBounds = true
        }
        if let borderColor = borderColor {
            self.base.layer.borderColor = borderColor.cgColor
        }
        if let borderWidth = borderWidth {
            self.base.layer.borderWidth = borderWidth
        }
        return self.base
    }
}

// MARK:- 四、继承于 UIView 视图的 平面、3D 旋转 以及 缩放
/**
 从m11到m44定义的含义如下：
 m11：x轴方向进行缩放
 m12：和m21一起决定z轴的旋转
 m13:和m31一起决定y轴的旋转
 m14:
 m21:和m12一起决定z轴的旋转
 m22:y轴方向进行缩放
 m23:和m32一起决定x轴的旋转
 m24:
 m31:和m13一起决定y轴的旋转
 m32:和m23一起决定x轴的旋转
 m33:z轴方向进行缩放
 m34:透视效果m34= -1/D，D越小，透视效果越明显，必须在有旋转效果的前提下，才会看到透视效果
 m41:x轴方向进行平移
 m42:y轴方向进行平移
 m43:z轴方向进行平移
 m44:初始为1
 */
extension XJExtension where Base: UIView {
    
    // MARK: 4.1、平面旋转
    /// 平面旋转
    /// - Parameters:
    ///   - angle: 旋转多少度
    ///   - isInverted: 顺时针还是逆时针，默认是顺时针
    public func setRotation(_ angle: CGFloat, isInverted: Bool = false) {
        self.base.transform = isInverted ? CGAffineTransform(rotationAngle: angle).inverted() : CGAffineTransform(rotationAngle: angle)
    }
    
    // MARK: 4.2、沿X轴方向旋转多少度(3D旋转)
    /// 沿X轴方向旋转多少度(3D旋转)
    /// - Parameter angle: 旋转角度，angle参数是旋转的角度，为弧度制 0-2π
    public func set3DRotationX(_ angle: CGFloat) {
        // 初始化3D变换,获取默认值
        //var transform = CATransform3DIdentity
        // 透视 1/ -D，D越小，透视效果越明显，必须在有旋转效果的前提下，才会看到透视效果
        // 当我们有垂直于z轴的旋转分量时，设置m34的值可以增加透视效果，也可以理解为景深效果
        // transform.m34 = 1.0 / -1000.0
        // 空间旋转，x，y，z决定了旋转围绕的中轴，取值为 (-1,1) 之间
        //transform = CATransform3DRotate(transform, angle, 1.0, 0.0, 0.0)
        //self.base.layer.transform = transform
        self.base.layer.transform = CATransform3DMakeRotation(angle, 1.0, 0.0, 0.0)
    }
    
    // MARK: 4.3、沿 Y 轴方向旋转多少度(3D旋转)
    /// 沿 Y 轴方向旋转多少度
    /// - Parameter angle: 旋转角度，angle参数是旋转的角度，为弧度制 0-2π
    public func set3DRotationY(_ angle: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, angle, 0.0, 1.0, 0.0)
        self.base.layer.transform = transform
    }
    
    // MARK: 4.4、沿 Z 轴方向旋转多少度(3D旋转)
    /// 沿 Z 轴方向旋转多少度
    /// - Parameter angle: 旋转角度，angle参数是旋转的角度，为弧度制 0-2π
    public func set3DRotationZ(_ angle: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, angle, 0.0, 0.0, 1.0)
        self.base.layer.transform = transform
    }
    
    // MARK: 4.5、沿 X、Y、Z 轴方向同时旋转多少度(3D旋转)
    /// 沿 X、Y、Z 轴方向同时旋转多少度(3D旋转)
    /// - Parameters:
    ///   - xAngle: x 轴的角度，旋转的角度，为弧度制 0-2π
    ///   - yAngle: y 轴的角度，旋转的角度，为弧度制 0-2π
    ///   - zAngle: z 轴的角度，旋转的角度，为弧度制 0-2π
    public func setRotation(xAngle: CGFloat, yAngle: CGFloat, zAngle: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, xAngle, 1.0, 0.0, 0.0)
        transform = CATransform3DRotate(transform, yAngle, 0.0, 1.0, 0.0)
        transform = CATransform3DRotate(transform, zAngle, 0.0, 0.0, 1.0)
        self.base.layer.transform = transform
    }
    
    // MARK: 4.6、设置 x,y 缩放
    /// 设置 x,y 缩放
    /// - Parameters:
    ///   - x: x 放大的倍数
    ///   - y: y 放大的倍数
    public func setScale(x: CGFloat, y: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DScale(transform, x, y, 1)
        self.base.layer.transform = transform
    }
}

// MARK:- 六、自定义链式编程
public extension UIView {
    // MARK: 6.1、设置 tag 值
    /// 设置 tag 值
    /// - Parameter tag: 值
    /// - Returns: 返回自身
    @discardableResult
    func tag(_ tag: Int) -> Self {
        self.tag = tag
        return self
    }
    
    // MARK: 6.2、设置圆角
    /// 设置圆角
    /// - Parameter cornerRadius: 圆角
    /// - Returns: 返回自身
    @discardableResult
    func corner(_ cornerRadius: CGFloat) -> Self {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        return self
    }
    
    // MARK: 6.3、图片的模式
    /// 图片的模式
    /// - Parameter mode: 模式
    /// - Returns: 返回图片的模式
    @discardableResult
    func contentMode(_ mode: UIView.ContentMode) -> Self {
        contentMode = mode
        return self
    }
    
    // MARK: 6.4、设置背景色
    /// 设置背景色
    /// - Parameter color: 颜色
    /// - Returns: 返回自身
    @discardableResult
    func backgroundColor(_ color: UIColor) -> Self {
        backgroundColor = color
        return self
    }
    
    // MARK: 6.5、设置十六进制颜色
    /// 设置十六进制颜色
    /// - Parameter hex: 十六进制颜色
    /// - Returns: 返回自身
    @discardableResult
    func backgroundColor(_ hex: String) -> Self {
        backgroundColor = UIColor.hexStringColor(hexString: hex)
        return self
    }
    
    // MARK: 6.6、设置 frame
    /// 设置 frame
    /// - Parameter frame: frame
    /// - Returns: 返回自身
    @discardableResult
    func frame(_ frame: CGRect) -> Self {
        self.frame = frame
        return self
    }
    
    // MARK: 6.7、被添加到某个视图上
    /// 被添加到某个视图上
    /// - Parameter superView: 父视图
    /// - Returns: 返回自身
    @discardableResult
    func addTo(_ superView: UIView) -> Self {
        superView.addSubview(self)
        return self
    }
    
    // MARK: 6.8、设置是否支持触摸
    /// 设置是否支持触摸
    /// - Parameter isUserInteractionEnabled: 是否支持触摸
    /// - Returns: 返回自身
    @discardableResult
    func isUserInteractionEnabled(_ isUserInteractionEnabled: Bool) -> Self {
        self.isUserInteractionEnabled = isUserInteractionEnabled
        return self
    }
    
    // MARK: 6.9、设置是否隐藏
    /// 设置是否隐藏
    /// - Parameter isHidden: 是否隐藏
    /// - Returns: 返回自身
    @discardableResult
    func isHidden(_ isHidden: Bool) -> Self {
        self.isHidden = isHidden
        return self
    }
    
    // MARK: 6.10、设置透明度
    /// 设置透明度
    /// - Parameter alpha: 透明度
    /// - Returns: 返回自身
    @discardableResult
    func alpha(_ alpha: CGFloat) -> Self {
        self.alpha = alpha
        return self
    }
    
    // MARK: 6.11、设置tintColor
    /// 设置tintColor
    /// - Parameter tintColor: tintColor description
    /// - Returns: 返回自身
    @discardableResult
    func tintColor(_ tintColor: UIColor) -> Self {
        self.tintColor = tintColor
        return self
    }
}

// MARK: - 坐标
extension UIView {
    
    /// 横坐标
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newValue) {
            var rect = self.frame
            rect.origin.x = newValue
            self.frame = rect
        }
    }
    
    /// 纵坐标
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(newValue) {
            var rect = self.frame
            rect.origin.y = newValue
            self.frame = rect
        }
    }
    
    /// 顶端间距
    var top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(newValue) {
            var rect = self.frame
            rect.origin.y = newValue
            self.frame = rect
        }
    }
    
    /// 底端间距
    var bottom: CGFloat {
        get {
            return (self.frame.origin.y + self.frame.size.height)
        }
        set(newValue) {
            var rect = self.frame
            rect.origin.y = (newValue - self.frame.size.height)
            self.frame = rect
        }
    }
    
    /// 宽度
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set(newValue) {
            var rect = self.frame
            rect.size.width = newValue
            self.frame = rect
        }
    }
    
    /// 高度
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set(newValue)
        {
            var rect = self.frame
            rect.size.height = newValue
            self.frame = rect
        }
    }
    
    /// Size
    var size: CGSize {
        get {
            return self.frame.size
        }
        set {
            var rect = self.frame
            rect.size = newValue
            self.frame = rect
        }
    }
    
    /// centerX
    var centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            var center = self.center
            center.x = newValue
            self.center = center
        }
    }
    
    /// centerY
    var centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            var center = self.center
            center.y = newValue
            self.center = center
        }
    }
}
