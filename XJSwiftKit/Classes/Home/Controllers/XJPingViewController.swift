//
//  XJPingViewController.swift
//  ShiJianYun
//
//  Created by xj on 2022/3/17.
//

import UIKit

class XJPingViewController: XJBaseViewController {
    
    /// ping
    fileprivate var pingServices: YSPingServices?
    
    /// 输入框
    fileprivate lazy var textfield: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .bezel
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.textColor = UIColor.black // 字体颜色
        tf.text = "baidu.com"
        tf.placeholder = "baidu.com" // placeholder内容
        tf.backgroundColor = UIColor.white // 背景颜色
        tf.tintColor = UIColor.purple
        tf.returnKeyType = .done // 发送按钮
        return tf
    }()
    
    /// 按钮
    fileprivate lazy var pingBtn: UIButton = {
        let button = UIButton()
        button.tag = 0
        button.backgroundColor = UIColor.red
        button.setTitle("ping", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(pingBtnClick(_:)), for: .touchUpInside)
        return button
    }()
    
    /// 文本显示
    fileprivate lazy var textView: UITextView = {
        let frame = CGRect(x: 10, y: 40, width: self.view.width - 20, height: 240)
        let textView = UITextView.xj.create(frame: CGRect.zero,
                                            bgColor: UIColor.white,
                                            placeholder: "请输入内容...",
                                            placeholderFont: 14,
                                            placeholderColor: Color_999999_999999,
                                            textColor: Color_333333_333333,
                                            tintColor: Color_System,
                                            font: 14,
                                            isEditable: true)
        textView.isUserInteractionEnabled = false
        //textView.xj.setLayer(cornerRadius: 5, borderColor: Color_999999_999999, borderWidth: 0.5)
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Ping"
        self.view.backgroundColor = UIColor.black
        
        setupUI()
    }
    
    fileprivate func setupUI() {
        self.view.addSubview(textfield)
        self.view.addSubview(pingBtn)
        self.view.addSubview(textView)
        
        textfield.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(20)
            make.height.equalTo(40)
            make.right.equalTo(-100)
        }
        pingBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.left.equalTo(textfield.snp.right).offset(10)
            make.centerY.equalTo(textfield.snp.centerY)
            make.top.equalTo(20)
        }
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.bottom.right.equalTo(-10)
            make.top.equalTo(textfield.snp.bottom).offset(10)
        }
    }
}

// MARK: - ACTION
extension XJPingViewController {
    
    /// 按钮点击
    @objc fileprivate func pingBtnClick(_ btn: UIButton) {
        self.view.endEditing(true)
        
        if btn.tag == 0 {
            btn.setTitle("Stop", for: .normal)
            btn.tag = 1
            
            pingServices = YSPingServices.startPingAddress(textfield.text, callbackHandler: { [weak self] (pingItem, pingItems) in
                guard let self = self else { return }
                if pingItem?.status != .finished {
                    
                    guard let desc =  pingItem?.description else { return }
                    self.appendText(text: desc)
                    
                } else {
                    guard let desc = YSPingItem.statistics(withPingItems: pingItems) else { return }
                    self.appendText(text: desc)
                    btn.setTitle("Ping", for: .normal)
                    btn.tag = 0
                    self.pingServices = nil
                }
            })
            
        } else {
            pingServices?.cancel()
        }
    }
    
    /// 字符串拼接
    fileprivate func appendText(text: String) {
        if text.count == 0 { return }
        if self.textView.text.count == 0 {
            self.textView.text = text
        } else {
            self.textView.text = "\(self.textView.text!)\n\(text)"
            self.textView.scrollRangeToVisible(NSMakeRange(self.textView.text.count, 0))
        }
    }
}
