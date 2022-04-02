//
//  XJCodeViewController.swift
//  ShiJianYun
//
//  Created by xj on 2022/1/11.
//

import UIKit

class XJCodeViewController: XJBaseViewController {

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.black
        label.text = "请输入6位验证码"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "验证码"
        
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(70)
            make.height.equalTo(30)
            make.left.equalTo(40)
            make.right.equalTo(-40)
        }
        
        let codeView = YSCodeView(frame: CGRect(x: 0, y: 100, width: KScreenW, height: 60), numCount: 6)
        codeView.codeInputSuccessBlock = { text in
            print("text = \(text)")
        }
        self.view.addSubview(codeView)
    }
    

}
