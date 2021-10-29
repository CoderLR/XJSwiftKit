//
//  XJNetDisconnectView.swift
//  XJSwiftKit
//
//  Created by Mr.Yang on 2021/10/14.
//

import UIKit

class XJNetDisconnectView: UIView {
    
    var bgImgView : UIImageView!
    var titleLabel : UILabel!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = Color_FFFFFF_151515
        
        bgImgView = UIImageView(image: UIImage(named: "icon_network_disconnect"))
        self.addSubview(bgImgView)
        bgImgView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-bgImgView.height)
        }
        
        titleLabel = UILabel.xj.create(text: "网络已断开链接~", textColor: Color_666666_666666, font: 15)
        titleLabel.textAlignment = .center
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(bgImgView.snp.bottom).offset(32)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
