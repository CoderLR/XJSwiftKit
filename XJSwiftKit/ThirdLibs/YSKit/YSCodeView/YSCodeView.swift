//
//  YSCodeView.swift
//  XJSwiftKit
//
//  Created by xj on 2022/1/11.
//

import UIKit

class YSCodeView: UIView {
    
    // 默认颜色
    let normalColor: UIColor = Color_666666_666666

    // 选中颜色
    let selectColor: UIColor = Color_System
    
    // 数字数量
    fileprivate var numCount: Int = 6
    
    // 字符串
    fileprivate var numStr: String = ""

    // 显示背景
    fileprivate var isDebug: Bool = false
    
    // 显示控件数组
    fileprivate var numLabelArray: [UILabel] = []
    
    // 输入框
    fileprivate var textfield = UITextField()
    
    // 输入完成回调
    var codeInputSuccessBlock: ((_ text: String) -> ())?
    
    /// 便捷初始化
    convenience init(frame: CGRect, numCount: Int) {
        self.init(frame: frame)
        
        self.numCount = numCount
        
        self.backgroundColor = UIColor.white
        
        setupUI()
    }
    
    /// 初始化
    fileprivate override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 加载UI
    fileprivate func setupUI() {
        
        textfield.delegate = self
        textfield.borderStyle = .none
        textfield.font = UIFont.systemFont(ofSize: 30)
        if !isDebug {
            textfield.textColor = UIColor.clear // 字体颜色
            textfield.backgroundColor = UIColor.clear // 背景颜色
            textfield.tintColor = UIColor.clear
        } else {
            textfield.textColor = UIColor.white // 字体颜色
            textfield.backgroundColor = UIColor.lightGray // 背景颜色
            textfield.tintColor = UIColor.orange
        }
        textfield.returnKeyType = .done // 发送按钮
        textfield.keyboardType = .numberPad
        textfield.addTarget(self, action: #selector(textfieldValueChange(_:)), for: .editingChanged)
        self.addSubview(textfield)
        
        for i in 0..<numCount {
            let label = UILabel()
            label.backgroundColor = UIColor.clear
            label.font = UIFont.systemFont(ofSize: 30)
            label.layer.masksToBounds = true
            label.textAlignment = .center
            label.layer.cornerRadius = 2
            label.layer.borderWidth = 1
            if i == 0 {
                label.layer.borderColor = selectColor.cgColor
            } else {
                label.layer.borderColor = normalColor.cgColor
            }
            self.addSubview(label)
            self.numLabelArray.append(label)
        }
    }
    
    /// 布局子控件
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.textfield.frame = self.bounds
        let numWH: CGFloat = self.height - 20
        let lrMargin: CGFloat = 40
        let midMargin = (self.width - 2 * lrMargin - CGFloat(numCount) * numWH) / CGFloat(numCount - 1)
        
        for i in 0..<numCount {
            let label = self.numLabelArray[i]
            label.size = CGSize(width: numWH, height: numWH)
            label.y = 10
            label.x = lrMargin + CGFloat(i) * (numWH + midMargin)
        }
    }
}

extension YSCodeView: UITextFieldDelegate {
    
    /// 输入框内容改变
    @objc func textfieldValueChange(_ textField: UITextField) {
        
        guard var text = textField.text else { return }
     
        if text.count < numStr.count {
            // 删除
            let Count = numStr.count - text.count
            let startIndex = text.count
            for i in startIndex..<(startIndex + Count) {
                let label = numLabelArray[i]
                label.text = ""
                label.layer.borderColor = selectColor.cgColor
                if i < numCount - 1 {
                    let nextLabel = numLabelArray[i + 1]
                    nextLabel.layer.borderColor = normalColor.cgColor
                }
            }
        } else {
            // 输入
            let count = text.count > numCount ? numCount : text.count
            for i in 0..<count {
                let label = numLabelArray[i]
                let range = NSMakeRange(i, 1)
                let str = text as NSString
                label.text = str.substring(with: range)
                label.layer.borderColor = normalColor.cgColor
                if i < numCount - 1 {
                    let nextLabel = numLabelArray[i + 1]
                    nextLabel.layer.borderColor = selectColor.cgColor
                }
            }
        }

        // 超出需要截取
        if text.count > numCount {
            text = String(text.prefix(numCount))
        }
        numStr = text
        
        // 输入完成回调
        if let codeInputSuccessBlock = codeInputSuccessBlock,
           text.count == numCount {
            codeInputSuccessBlock(text)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("---->\(textfield.text ?? "")  - \(range)  -  \(string)")
        
        guard let text = textField.text else { return true }
        
        // 删除
        if string.count == 0 {
            return true
        // 只能输入数字
        } else if YSRegexTool.validateNumber(string) {
            
            let ocString = NSString(string: text)
            let toBeString = ocString.replacingCharacters(in: range, with: string)

            if toBeString.count > numCount {
                let ocString = NSString(string: toBeString)
                textfield.text = ocString.substring(to: numCount)
            
                // 主动触发事件
                textfieldValueChange(textfield)

                // 移动光标到最后面
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    let position = self.textfield.endOfDocument
                    self.textfield.selectedTextRange = self.textfield.textRange(from: position, to: position)
                }
            
                return false
            }
            
            return true
        } else {
            return false
        }
    }
}
