//
//  XJMineHeaderView.swift
//  XJSwiftKit
//
//  Created by xj on 2022/1/12.
//

import UIKit

class XJMineHeaderView: UIView {

    /// 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 加载UI
    func setupUI() {
        
    }
    
    // 布局UI
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }

}
