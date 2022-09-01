//
//  YSAddAttributeLabel.swift
//  LeiFengHao
//
//  Created by xj on 2022/6/22.
//

import UIKit

class YSAttributeLabel: UIView {
    
    /// 高亮views
    fileprivate var hightlightViews: [UIView] = []
    
    /// 显示文本
    fileprivate lazy var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor.clear
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isUserInteractionEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: -5, right: -5)
        return textView
    }()
    
    /// 带属性文字
    fileprivate var attributedString: NSMutableAttributedString?
    
    /// 文字
    fileprivate var textString: String?
    
    /// 文字颜色
    fileprivate var textColor: UIColor?
    
    /// 文字背景颜色
    fileprivate var textBackgroundColor: UIColor?
    
    /// 文字大小
    fileprivate var fontSize: CGFloat?
    
    /// 高亮文字
    //var hightlightString: String?
    
    /// 高亮区域
    fileprivate var hightlightRanges: [NSRange]?
    
    /// 高亮文字颜色
    fileprivate var hightlightColor: UIColor?
    
    /// 高亮背景颜色
    fileprivate var hightlightBgColor: UIColor?
    
    /// 高亮点击事件
    var hlTapAction: ((NSRange) -> Void)?
    
    /// attributedString初始化
    /// - Parameters:
    ///   - attributedString: 带属性文字
    ///   - hlRanges: 高亮区域数组
    ///   - hlTapAction: 高亮区域触发事件
    convenience init(attributedString: NSMutableAttributedString,
                     hlRanges: [NSRange],
                     hlTapAction: ((NSRange) -> Void)? = nil) {
        self.init(frame: .zero)
        self.attributedString = attributedString
        self.hightlightRanges = hlRanges
        self.hlTapAction = hlTapAction
        self.textView.attributedText = attributedString
    }
    
    /// string初始化
    /// - Parameters:
    ///   - text: 显示文本
    ///   - fontSize: 文本字体大小
    ///   - textColor: 文本字体颜色
    ///   - hlRanges: 高亮区域数组
    ///   - hlColor: 高亮区域文字颜色
    ///   - hlBgColor: 高亮区域按下背景色
    ///   - hlTapAction: 高亮区域触发事件
    convenience init(text: String,
                     fontSize: CGFloat,
                     textColor: UIColor,
                     hlRanges: [NSRange],
                     hlColor: UIColor,
                     hlBgColor: UIColor,
                     hlTapAction: ((NSRange) -> Void)? = nil) {
        self.init(frame: .zero)
        
        self.textString = text
        self.fontSize = fontSize
        self.textColor = textColor

        self.hightlightRanges = hlRanges
        self.hightlightColor = hlColor
        self.hightlightBgColor = hlBgColor
        self.hlTapAction = hlTapAction
        
        let attr = self.initAttributedString()
        self.attributedString = attr
        self.textView.attributedText = attr
    }
    
    /// 获取带属性文字内容size
    /// - Returns: size
    
    
    /// 获取带属性文字内容size
    /// - Parameter width: textView显示的宽度
    /// - Returns: size
    func textBoundingSize(_ width: CGFloat) -> CGSize {
        print("self.width = \(self.width)")
        let size = self.attributedString?.boundingRect(with: CGSize(width: width - 10, height: CGFloat(MAXFLOAT)),
                                                      options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                       context: nil).size ?? CGSize.zero
        return size
    }
    
    /// 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 加载UI
    fileprivate func setupUI() {
        self.addSubview(self.textView)
        self.textView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    /// 根据属性生成带属性文字
    fileprivate func initAttributedString() -> NSMutableAttributedString {
        
        let content = self.textString ?? ""
        
        let attrStr = NSMutableAttributedString.init(string: content)
        
        // 添加文字颜色和字体
        attrStr.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: self.fontSize ?? 0),
                            NSAttributedString.Key.foregroundColor: self.textColor ?? UIColor.black], range: NSMakeRange(0, content.count))
        
        // 添加高亮文字颜色
        guard let hlRanges = self.hightlightRanges else { return attrStr }
        for hlRange in hlRanges {
            attrStr.addAttributes([NSAttributedString.Key.foregroundColor: self.hightlightColor ?? UIColor.black], range: hlRange)
        }
        
        return attrStr
    }
}

// MARK: - 捕捉点击区域并响应点击
extension YSAttributeLabel {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t: AnyObject in touches {
            let touch: UITouch = t as! UITouch
            let point = touch.location(in: self)
            print("point = \(point)")
            let textRange = self.textView.characterRange(at: point)
            print("textRange = \(String(describing: textRange))")
            
            self.textView.selectedTextRange = textRange
            /// 获取点击的range
            let range = self.textView.selectedRange
            print("selectedRange = \(range)")
            guard let hlRanges = self.hightlightRanges else { return }
            for hlRange in hlRanges {
                /// 当前点击range位置是否在高亮区域
                if NSLocationInRange(range.location, hlRange) {
                    self.textView.selectedRange = hlRange

                    let rectArray = self.textView.selectionRects(for: self.textView.selectedTextRange!)

                    for rect in rectArray {
                        let view = UIView(frame: rect.rect)
                        view.backgroundColor = self.hightlightBgColor!
                        view.layer.cornerRadius = 3;
                        view.layer.masksToBounds = true
                        self.insertSubview(view, at: 0)
                        self.hightlightViews.append(view)
                    }

                    /// 回调点击事件并跳出循环
                    if let hlTapAction = self.hlTapAction {
                        hlTapAction(hlRange)
                    }
                    break
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchesEnded(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.hightlightViews.count > 0 {
            for view in hightlightViews {
                view.removeFromSuperview()
            }
            self.hightlightViews.removeAll()
        }
    }
}
