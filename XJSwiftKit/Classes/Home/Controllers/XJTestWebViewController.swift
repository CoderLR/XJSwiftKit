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
    }
}
