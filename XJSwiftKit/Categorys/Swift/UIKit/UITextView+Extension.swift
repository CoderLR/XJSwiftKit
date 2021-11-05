//
//  UITextView+Extension.swift
//  XJSwiftKit
//
//  Created by Mr.Yang on 2021/10/19.
//

import Foundation

// MARK: 提示：如果你想对textView.text直接赋值。请在设置属性之前进行，否则影响计算
// MARK:- 一、基本的扩展 (使用runtime添加属性)
public extension UITextView {
    
    // MARK: 1.1、设置占位符
    /// 设置占位符
    var placeholder: String? {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.placeholder, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            initPlaceholder(placeholder!)
        }
        get {
            return objc_getAssociatedObject(self, UITextView.RuntimeKey.placeholder) as? String
        }
    }
    
    // MARK: 1.2、默认文本字体的大小
    /// 默认文本字体的大小
    var placeholdFont: UIFont? {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.placeholdFont, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if self.placeholderLabel != nil {
                self.placeholderLabel?.font = placeholdFont
            }
        }
        get {
            return objc_getAssociatedObject(self, UITextView.RuntimeKey.placeholdFont) as? UIFont == nil ? UIFont.systemFont(ofSize: 13) : objc_getAssociatedObject(self, UITextView.RuntimeKey.placeholdFont) as? UIFont
        }
    }
    
    // MARK: 1.3、默认文本的颜色
    /// 默认文本的颜色
    var placeholdColor: UIColor? {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.placeholdColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if self.placeholderLabel != nil {
                self.placeholderLabel?.textColor = placeholdColor
            }
        }
        get {
            return objc_getAssociatedObject(self, UITextView.RuntimeKey.placeholdColor) as? UIColor == nil ? UIColor.lightGray : objc_getAssociatedObject(self, UITextView.RuntimeKey.placeholdColor) as? UIColor
        }
    }
    
    // MARK: 1.4、设置 默认文本的Origin
    /// 设置 默认文本的Origin
    var placeholderOrigin: CGPoint? {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.placeholderOrigin, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if self.placeholderLabel != nil && placeholderOrigin != nil {
                self.placeholderLabel?.frame.origin = placeholderOrigin!
            }
        }
        get {
            return objc_getAssociatedObject(self, UITextView.RuntimeKey.placeholderOrigin) as? CGPoint == nil ? CGPoint(x: 7, y: 7) : objc_getAssociatedObject(self, UITextView.RuntimeKey.placeholderOrigin) as? CGPoint
        }
    }
}

// MARK:- fileprivate 私有的内容
extension UITextView {
    
    fileprivate struct RuntimeKey {
        static let placeholder: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDEL".hashValue)
        static let placeholderLabel: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDELABEL".hashValue)
        static let placeholdFont: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDFONT".hashValue)
        static let placeholdColor: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDCOLOR".hashValue)
        static let placeholderOrigin: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDERORIGIN".hashValue)
        // ...其他Key声明
    }
    
    /// 默认文本
    fileprivate var placeholderLabel: UILabel? {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.placeholderLabel, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, UITextView.RuntimeKey.placeholderLabel) as? UILabel
        }
    }
    
    /// 占位符
    /// - Parameter placeholder: 占位符
    fileprivate func initPlaceholder(_ placeholder: String) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(_:)), name: UITextView.textDidChangeNotification, object: self)
        let label = UILabel()
        let width = self.width - placeholderOrigin!.x * 2 - 1
        let rect = placeholder.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : self.placeholdFont!], context: nil)
        label.frame = CGRect(x: placeholderOrigin!.x + 1, y: placeholderOrigin!.y, width: width, height: rect.size.height + 8)
        label.font = self.placeholdFont
        label.text = placeholder
        label.numberOfLines = 0
        // label.lineBreakMode = .byWordWrapping
        label.textColor = self.placeholdColor
        // label.backgroundColor = .randomColor
        self.placeholderLabel = label
        addSubview(self.placeholderLabel!)
        placeholderLabel?.isHidden = self.text.count > 0 ? true : false
    }
    
    /// 动态监听
    /// - Parameter notification: 动态监听
    @objc fileprivate func textChange(_ notification: Notification) {
        let textView = notification.object as! UITextView
        if placeholder != nil {
            placeholderLabel?.isHidden = true
            self.placeholderLabel?.isHidden = !(textView.text.count == 0)
        }
    }
}

// MARK:- 二、文本链接的扩展
public extension XJExtension where Base: UITextView {
    
    // MARK: 2.0、添加链接文本（链接为空时则表示普通文本）
    /// UITextView
    /// - Parameters:
    ///   - bgColor: 背景颜色
    ///   - placeholder: 占位符
    ///   - placeholderFont: 占位符字体
    ///   - placeholderColor: 占位符颜色
    ///   - textColor: 文字颜色
    ///   - tintColor: 光标颜色
    ///   - font: 字体大小
    ///   - isEditable: 是否可用编辑
    /// - Returns: UITextView
    static func create(frame: CGRect,
                       bgColor: UIColor = UIColor.white,
                       placeholder: String? = nil,
                       placeholderFont: CGFloat = 14,
                       placeholderColor: UIColor = UIColor.lightGray,
                       textColor: UIColor = Color_333333_333333,
                       tintColor: UIColor = Color_System,
                       font: CGFloat = 14,
                       isEditable: Bool = true) -> UITextView {
        let textview = UITextView(frame: frame)
        textview.backgroundColor = bgColor
        // placeholder内容
        if let placeholder = placeholder {
            textview.placeholder = placeholder
            textview.placeholdFont = UIFont.systemFont(ofSize: placeholderFont)
            textview.placeholdColor = placeholderColor
        }
        // 是否可用编辑
        textview.isEditable = isEditable
        textview.textColor = textColor // 字体颜色
        textview.tintColor = tintColor // 光标颜色
        textview.font = UIFont.systemFont(ofSize: font) // 字体大小
        return textview
    }
    
    // MARK: 2.1、添加链接文本（链接为空时则表示普通文本）
    /// 添加链接文本（链接为空时则表示普通文本）
    /// - Parameters:
    ///   - string: 文本
    ///   - withURLString: 链接
    func appendLinkString(string: String, font: UIFont, withURLString: String = "") {
        // 原来的文本内容
        let attrString: NSMutableAttributedString = NSMutableAttributedString()
        attrString.append(self.base.attributedText)
        
        // 新增的文本内容（使用默认设置的字体样式）
        let attrs = [NSAttributedString.Key.font: font]
        let appendString = NSMutableAttributedString(string: string, attributes:attrs)
        // 判断是否是链接文字
        if withURLString != "" {
            let range:NSRange = NSMakeRange(0, appendString.length)
            appendString.beginEditing()
            appendString.addAttribute(NSAttributedString.Key.link, value:withURLString, range:range)
            appendString.endEditing()
        }
        // 合并新的文本
        attrString.append(appendString)
        // 设置合并后的文本
        self.base.attributedText = attrString
    }
    
    // MARK: 2.2、转换特殊符号标签字段
    /// 转换特殊符号标签字段
    func resolveHashTags() {
        let nsText: NSString = self.base.text! as NSString
        // 使用默认设置的字体样式
        let attrs = [NSAttributedString.Key.font : self.base.font!]
        let attrString = NSMutableAttributedString(string: nsText as String, attributes:attrs)
        
        //用来记录遍历字符串的索引位置
        var bookmark = 0
        //用于拆分的特殊符号
        let charactersSet = CharacterSet(charactersIn: "@#")
        
        //先将字符串按空格和分隔符拆分
        let sentences: [String] = self.base.text.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        
        for sentence in sentences {
            // 如果是url链接则跳过
            if !(sentence as String).xj.verifyUrl() {
                // 再按特殊符号拆分
                let words: [String] = sentence.components(separatedBy: charactersSet)
                var bookmark2 = bookmark
                for i in 0..<words.count {
                    let word = words[i]
                    let keyword = chopOffNonAlphaNumericCharacters(word as String)
                    if keyword != "" && i > 0 {
                        // 使用自定义的scheme来表示各种特殊链接，比如：mention:hangge
                        // 使得这些字段会变蓝色且可点击
                        // 匹配的范围
                        let remainingRangeLength = min((nsText.length - bookmark2 + 1), word.count + 2)
                        let remainingRange = NSRange(location: bookmark2 - 1, length: remainingRangeLength)
                        // print(keyword, bookmark2, remainingRangeLength)
                        // 获取转码后的关键字，用于url里的值
                        //（确保链接的正确性，比如url链接直接用中文就会有问题）
                        let encodeKeyword = keyword.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                        // 匹配@某人
                        var matchRange = nsText.range(of: "@\(keyword)", options: .literal, range: remainingRange)
                        attrString.addAttribute(NSAttributedString.Key.link, value: "test1:\(encodeKeyword)", range: matchRange)
                        // 匹配#话题#
                        matchRange = nsText.range(of: "#\(keyword)#", options: .literal, range:remainingRange)
                        attrString.addAttribute(NSAttributedString.Key.link, value: "test2:\(encodeKeyword)", range: matchRange)
                        // attrString.addAttributes([NSAttributedString.Key.link : "test2:\(encodeKeyword)"], range: matchRange)
                    }
                    // 移动坐标索引记录
                    bookmark2 += word.count + 1
                }
            }
            // 移动坐标索引记录
            bookmark += sentence.count + 1
        }
        // print(nsText.length, bookmark)
        // 最终赋值
        self.base.attributedText = attrString
    }
    
    /// 过滤部多余的非数字和字符的部分
    /// - Parameter text: @hangge.123 -> @hangge
    /// - Returns: 返回过滤后的字符串
    private func chopOffNonAlphaNumericCharacters(_ text: String) -> String {
        let nonAlphaNumericCharacters = CharacterSet.alphanumerics.inverted
        let characterArray = text.components(separatedBy: nonAlphaNumericCharacters)
        return characterArray[0]
    }
}
