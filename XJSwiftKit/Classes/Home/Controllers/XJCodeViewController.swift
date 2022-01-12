//
//  XJCodeViewController.swift
//  XJSwiftKit
//
//  Created by xj on 2022/1/11.
//

import UIKit

class XJCodeViewController: XJBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "验证码"
        12345678
        let codeView = YSCodeView(frame: CGRect(x: 0, y: 100, width: KScreenW, height: 60), numCount: 6)
        codeView.codeInputSuccessBlock = { text in
            print("text = \(text)")
        }
        self.view.addSubview(codeView)
    }
    

}
