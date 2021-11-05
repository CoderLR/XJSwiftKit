//
//  XJTestTextViewViewController.swift
//  XJSwiftKit
//
//  Created by xj on 2021/11/5.
//

import UIKit

class XJTestTextViewViewController: XJBaseViewController {

    fileprivate lazy var textView: UITextView = {
        let frame = CGRect(x: 10, y: 10, width: self.view.width - 20, height: 240)
        let textView = UITextView.xj.create(frame: frame, bgColor: UIColor.white, placeholder: "请输入内容...", placeholderFont: 14, placeholderColor: Color_999999_999999, textColor: Color_333333_333333, tintColor: Color_System, font: 14, isEditable: true)
        
        textView.xj.setLayer(cornerRadius: 5, borderColor: Color_999999_999999, borderWidth: 0.5)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "TextView"
        
        self.view.addSubview(textView)
    }

}
