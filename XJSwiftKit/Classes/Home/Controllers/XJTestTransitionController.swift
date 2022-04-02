//
//  XJTestTransitionController.swift
//  ShiJianYun
//
//  Created by Mr.Yang on 2021/10/22.
//

import UIKit
import SnapKit

class XJTestTransitionController: XJBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "转场"

        let imageView = UIImageView.xj.create(bgColor: UIColor.white, imgName: "icon_launchImage_top")
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>) {
        self.popVC()
    }
}
