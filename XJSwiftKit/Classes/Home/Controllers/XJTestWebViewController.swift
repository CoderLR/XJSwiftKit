//
//  XJTestWebViewController.swift
//  ShiJianYun
//
//  Created by Mr.Yang on 2021/10/14.
//

import UIKit

class XJTestWebViewController: XJWKWebViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fd_interactivePopDisabled = true

        self.shareActionBlock = {
            YSShareView(topShareInfos: YSShareInfo.getShareInfos(0),
                        bottomShareInfos: YSShareInfo.getShareInfos(1)).show { (type) in
                if type == .wechat {
                    print("分享到微信")
                } else if type == .circle {
                    print("分享到朋友圈")
                }
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeRotate(noti:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    
    // 屏幕旋转时调用
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        let width = size.width
        let height = size.height
        print("player---viewWillTransition \(width)   \(height)")
    }
    override func setUpWebUrl() {
        self.webUrl = "https://www.jianshu.com/u/d648df870a79"
    }
    
    // 大小屏幕切换（iOS16锁定屏幕时不会调用，重力感应会调用）
    @objc func changeRotate(noti : Notification) {
        print("player---changeRotate-----\(UIDevice.current.orientation.rawValue)")
        print("\(UIDevice.current)")
        print("object = \(String(describing: noti.object))")
        print("userInfo = \(String(describing: noti.userInfo))")
    }
}
