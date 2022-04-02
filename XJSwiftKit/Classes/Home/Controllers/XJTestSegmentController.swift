//
//  XJTestSegmentController.swift
//  ShiJianYun
//
//  Created by Mr.Yang on 2021/10/25.
//

import UIKit

class XJTestSegmentController: XJBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "SegmentVc"
        
        setupUI()
    }
    
    fileprivate func setupUI() {
        
        let titleArray = ["OC", "Swift", "C++", "Java", "JavaScript", "sqile"]
        var childControllers : [UIViewController] = [UIViewController]()
        
        for i in 0..<titleArray.count {
            let controller = XJTestViewController(titleName: titleArray[i])
            childControllers.append(controller)
        }
        
        let segmentVc = XJSegmentViewController(titleArray: titleArray,
                                            childControllers: childControllers,
                                            segmentMode: .scroll)
        segmentVc.addToParentController(viewController: self)
    }
}
