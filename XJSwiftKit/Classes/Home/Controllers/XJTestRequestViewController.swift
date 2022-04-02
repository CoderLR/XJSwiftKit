//
//  XJTestRequestViewController.swift
//  ShiJianYun
//
//  Created by xj on 2022/3/4.
//

import UIKit

class XJTestRequestViewController: XJBaseViewController {
    
    lazy var reqButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Color_System
        button.setTitle("网络请求", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)

        button.addTarget(self, action: #selector(reqBtnClick(_:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "网络请求"
        
        self.view.addSubview(reqButton)
        reqButton.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(30)
            make.height.equalTo(40)
        }
    }
    
    /// 网络请求
    @objc func reqBtnClick(_ btn: UIButton) {
        
        REQ.getRequest(XJUserApi.getUserDetail("8488"), BaseEmptyModel.self) { (model, dict) in
            
        }
    }

}
