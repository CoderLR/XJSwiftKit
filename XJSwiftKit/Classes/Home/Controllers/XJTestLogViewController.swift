//
//  XJTestLogViewController.swift
//  XJSwiftKit
//
//  Created by xj on 2022/9/19.
//

import UIKit
import CocoaLumberjack

// NSHomeDirectory() + "/Library/Caches/Logs"
class XJTestLogViewController: XJBaseViewController {
    
    lazy var logButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Color_System
        button.setTitle("Log日志", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(logBtnClick(_:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "日志"
        
        self.view.addSubview(logButton)
        logButton.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(40)
            make.top.equalToSuperview().offset(20)
        }
        
        for i in 0..<10 {
            DDLogVerbose("Verbose---\(i)")
            DDLogDebug("Debug---\(i)")
            DDLogInfo("Info---\(i)")
            DDLogWarn("Warn---\(i)")
            DDLogError("Error---\(i)")
        }
    }
    

    /// 日志
    @objc func logBtnClick(_ btn: UIButton) {
        let sandboxVc = YSSandboxViewController(localPath: FileManager.xj.homeDirectory() + "/Library/Caches/Logs", lastPath: "Log")
        self.pushVC(sandboxVc)
    }

}
