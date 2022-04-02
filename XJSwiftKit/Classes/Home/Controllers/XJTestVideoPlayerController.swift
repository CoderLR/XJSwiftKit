//
//  XJTestVideoPlayerController.swift
//  ShiJianYun
//
//  Created by Mr.Yang on 2021/10/26.
//

import UIKit

class XJTestVideoPlayerController: XJBaseViewController {
    
    var playerView: XJVideoPlayerView?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("1----viewDidLoad")
        let url = "https://www.apple.com/105/media/us/iphone-x/2017/01df5b43-28e4-4848-bf20-490c34a926a7/films/feature/iphone-x-feature-tpl-cc-us-20170912_1280x720h.mp4"
        self.playerView = XJVideoPlayerView(frame: self.setPlayerFrame(), assetURL: url)
        self.view.addSubview(self.playerView!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("2----viewDidLayoutSubviews")
        self.playerView?.frame = self.setPlayerFrame()
    }
    
    func setPlayerFrame() -> CGRect {
        let x = 0
        let y = 0
        let w = self.view.frame.width
        let h = w * 9 / 16
        return CGRect(x: CGFloat(x), y: CGFloat(y), width: w, height: h)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

}
