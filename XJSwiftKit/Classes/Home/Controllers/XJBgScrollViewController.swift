//
//  XJBgScrollViewController.swift
//  ShiJianYun
//
//  Created by xj on 2022/2/23.
//

import UIKit

class XJBgScrollViewController: XJBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "滚动容器"
        
        self.setBgScrollView()
        
        setupUI()
    }
    
    fileprivate func setupUI() {
        var startY: CGFloat = 0
        let height: CGFloat = 100
        for _ in 0..<10 {
            let view = UIView.xj.create(bgColor: UIColor.randomColor)
            self.bgScrollView.addSubview(view)
            view.frame = CGRect(x: 0, y: startY, width: self.view.width, height: height)
            startY = view.bottom
            
            print("startY = \(startY)")
        }
        
        self.setBgContentSize(CGSize(width: self.view.width, height: startY + KHomeBarH))
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
