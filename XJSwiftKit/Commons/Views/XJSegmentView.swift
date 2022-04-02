//
//  XJSegmentView.swift
//  ShiJianYun
//
//  Created by Mr.Yang on 2021/10/25.
//

import UIKit

enum XJScrollDirection {
    case previous
    case next
}

protocol XJSegmentViewDelegate: class {
    func selectButtonIndex(_ index: Int)
}

class XJSegmentView: UIView {
    /// 默认颜色
    let kNormalColor: UIColor = UIColor.black
    
    /// 选中颜色
    let kSelectColor: UIColor = Color_System
    
    /// 显示模式
    var segmentMode: XJSegmentMode = .normal
    
    /// 标题间距
    let margin: CGFloat = 30
    
    /// 提起颜色RGB
    fileprivate var kNormalRGB: (CGFloat, CGFloat, CGFloat) {
        return kNormalColor.colorToRGB()
    }
    /// 提起颜色RGB
    fileprivate var kSelectRGB: (CGFloat, CGFloat, CGFloat) {
        return kSelectColor.colorToRGB()
    }
    
    fileprivate lazy var buttonArray: [UIButton] = [UIButton]()
    fileprivate var currentBtn: UIButton = UIButton()
    fileprivate var lastBtn: UIButton = UIButton()
    
    /// 点击按钮回调
    weak var delegate: XJSegmentViewDelegate?
    
    /// 重写set方法添加按钮
    var titleArray: [String] = [String]()  {
        didSet {
            addButtons()
        }
    }
    /// 底线
    fileprivate lazy var lineView: UIView = {
        let line = UIView(frame: CGRect(x: 0, y: self.height - 0.5, width: self.width, height: 0.5))
        line.backgroundColor = UIColor.lightGray
        return line
    }()
    /// 选中线
    fileprivate lazy var selectView: UIView = {
        let line = UIView(frame: CGRect(x: 0, y: self.height - 3, width: 30, height: 2))
        line.backgroundColor = kSelectColor
        return line
    }()
    /// scrollView
    fileprivate lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: self.bounds)
        scroll.showsHorizontalScrollIndicator = false
        scroll.bounces = false
        return scroll
    }()
    
    convenience init(frame: CGRect, segmentMode: XJSegmentMode) {
        self.init(frame: frame)
        
        self.segmentMode = segmentMode
        
        addSubview(scrollView)
        addSubview(lineView)
        scrollView.addSubview(selectView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Add
extension XJSegmentView {
    /// 添加子控件
    func addButtons() {
        let width = self.width / CGFloat(titleArray.count)
        for i in 0..<titleArray.count {
            let button = UIButton()
            button.tag = i
            button.setTitle(titleArray[i], for: .normal)
            button.setTitleColor(kNormalColor, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            button.addTarget(self, action: #selector(titleBtnClick(_: )), for: .touchUpInside)
            
            if segmentMode == .scroll {
                button.sizeToFit()
                button.centerY = self.height * 0.5
                button.x = currentBtn.frame.maxX + margin
                scrollView.addSubview(button)
                buttonArray.append(button)
                currentBtn = button
            } else if segmentMode == .normal {
                button.size = CGSize(width: width, height: self.height)
                button.x = CGFloat(i) * width
                scrollView.addSubview(button)
                buttonArray.append(button)
                currentBtn = button
            }
            
            if i == 0 { // 默认选中
                button.setTitleColor(kSelectColor, for: .normal)
                selectView.width = currentBtn.width
                selectView.centerX = currentBtn.centerX
                lastBtn = button
            }
        }
        
        // 设置scrollview的滚动范围
        if segmentMode == .scroll {
            scrollView.contentSize = CGSize(width: currentBtn.frame.maxX + margin, height: self.height)
        }
    }
}

// MARK: - 逻辑选择
extension XJSegmentView {
    
    /// 按钮点击
    @objc func titleBtnClick(_ btn: UIButton)  {
        
        if btn.isEqual(lastBtn) { return }
        lastBtn.setTitleColor(kNormalColor, for: .normal)
        btn.setTitleColor(kSelectColor, for: .normal)
        lastBtn = btn
        
        UIView.animate(withDuration: 0.25) {
            self.selectView.width = btn.width
            self.selectView.centerX = btn.centerX
        }
    
        scrollToViewMiddle(btn)

        if let delegate = self.delegate {
            delegate.selectButtonIndex(btn.tag)
        }
    }
    
    /// 滚动到view中间
    /// - Parameter button: 显示的button
    func scrollToViewMiddle(_ button: UIButton) {
        if segmentMode == .normal { return }
        let offsetX = button.centerX - self.width * 0.5
        if offsetX >= 0 {
            if button.centerX + self.width * 0.5 >= self.scrollView.contentSize.width {
                scrollView.setContentOffset(CGPoint(x: scrollView.contentSize.width - self.width, y: 0), animated: true)
            } else {
                scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
            }
        } else {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }

    /// 滚动内容设置标题
    /// - Parameter index: 滚动的位置
    func scrollToIndex(_ index: Int)  {
        let button = buttonArray[index]
        if button .isEqual(lastBtn) { return }
        
        lastBtn.setTitleColor(kNormalColor, for: .normal)
        button.setTitleColor(kSelectColor, for: .normal)
        lastBtn = button
        
        UIView.animate(withDuration: 0.25) {
            self.selectView.width = button.width
            self.selectView.centerX = button.centerX
        }
        
        scrollToViewMiddle(button)
    }
    
    /// 渐变滚动进度动画
    /// - Parameters:
    ///   - pacentage: 百分比
    ///   - index: 当前title位置
    ///   - direction: 滚动方向
    func selectViewScroll(pacentage: CGFloat, index: Int, direction: XJScrollDirection) {
        if (pacentage == 0) { return }
        
        let colorDelta = (kSelectRGB.0 - kNormalRGB.0, kSelectRGB.1 - kNormalRGB.1, kSelectRGB.2 - kNormalRGB.2)
       
        // 向后移动
        if direction == .next {
            if index < 0 { return }
            if index > self.buttonArray.count - 2 { return }
            
            let current = buttonArray[index]
            let next = buttonArray[index + 1]
            let distance = next.centerX - current.centerX
            
            // 设置位置
            selectView.width = (next.width - current.width) * pacentage + current.width;
            selectView.centerX = current.centerX + distance * pacentage;
            
            // 用元组设置渐变颜色
            let currentColor = UIColor(r: kSelectRGB.0 - colorDelta.0 * pacentage, g: kSelectRGB.1 - colorDelta.1 * pacentage, b: kSelectRGB.2 - colorDelta.2 * pacentage)
            
            let nextColor = UIColor(r: kNormalRGB.0 + colorDelta.0 * pacentage, g: kNormalRGB.1 + colorDelta.1 * pacentage, b: kNormalRGB.2 + colorDelta.2 * pacentage)
            
            current.setTitleColor(currentColor, for: .normal)
            next.setTitleColor(nextColor, for: .normal)
            
        } else if direction == .previous {
            if index < 1 { return }
            if index > self.buttonArray.count - 1 { return }
            
            let current = self.buttonArray[index];
            let before = self.buttonArray[index - 1];
            let distance = current.centerX - before.centerX;
            
            // 设置位置
            self.selectView.width = (before.width - current.width) * pacentage + current.width;
            self.selectView.centerX = current.centerX - distance * pacentage;
            
            // 用元组设置渐变颜色
            let currentColor = UIColor(r: kSelectRGB.0 - colorDelta.0 * pacentage, g: kSelectRGB.1 - colorDelta.1 * pacentage, b: kSelectRGB.2 - colorDelta.2 * pacentage)
            
            let beforeColor = UIColor(r: kNormalRGB.0 + colorDelta.0 * pacentage, g: kNormalRGB.1 + colorDelta.1 * pacentage, b: kNormalRGB.2 + colorDelta.2 * pacentage)
            
            current.setTitleColor(currentColor, for: .normal)
            before.setTitleColor(beforeColor, for: .normal)
        }
    }
}
