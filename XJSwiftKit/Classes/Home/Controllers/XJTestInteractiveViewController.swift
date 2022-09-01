//
//  XJTestInteractiveViewController.swift
//  LightingRoom
//
//  Created by apple on 2022/5/30.
//

import UIKit

class XJTestInteractiveViewController: XJWKWebViewController {
    
    // 调用JS
    lazy var callJSBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.red
        btn.setTitle("原生调用JS", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.addTarget(self, action: #selector(callJSBtnClick(_:)), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "JS交互"
        self.isDisplayWebTitle = false
        self.navigationItem.rightBarButtonItems = []
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.view.addSubview(self.callJSBtn)
            self.view.bringSubviewToFront(self.callJSBtn)
            self.callJSBtn.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: 200, height: 50))
                make.centerY.equalToSuperview()
                make.left.equalTo(10)
            }
        }
        
        // 原生注册方法,JS调用
        self.jsCallNative("JSCallNative") { [weak self] (name, body) in
            
            self?.showAlert(body: body)
        }
    }
    
    func showAlert(body: Any) {
        let msgBody = body as? [String: String]
        let name = msgBody?["name"] ?? ""
        let age = msgBody?["age"] ?? ""
        print("name = \(name)")
        print("age = \(age)")
        let alert = UIAlertController.alertView(title: "提示", message: "name = " + name + " age = " + age, sureTtile: "确定")
        self.present(alert, animated: false, completion: nil)
    }
    
    /// 网页地址
    override func setUpPathUrl() {
        self.pathUrl = Bundle.main.path(forResource: "interactive", ofType: ".html") ?? ""
    }

    // 原生调用JS
    @objc func callJSBtnClick(_ btn: UIButton) {
        let params = ["name": "zhangsan", "age": "18"]
        self.callJSFunc("nativeCallJS", params: params)
    }
}
