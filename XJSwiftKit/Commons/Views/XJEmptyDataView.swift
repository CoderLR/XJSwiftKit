//
//  XJEmptyDataView.swift
//  XJSwiftKit
//
//  Created by Mr.Yang on 2021/10/14.
//

import UIKit

class XJEmptyDataView: UIView {
    
    var bgImgView : UIImageView!
    var titleLabel : UILabel!
    
    convenience init(frame: CGRect, imgName: String, text: String) {
        self.init(frame: frame)
        
        self.backgroundColor = Color_FFFFFF_151515
        
        bgImgView = UIImageView(image: UIImage(named: imgName))
        self.addSubview(bgImgView)
        bgImgView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-bgImgView.height)
        }
        
        titleLabel = UILabel.xj.create(text: text, textColor: Color_666666_666666, font: 15)
        titleLabel.textAlignment = .center
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(bgImgView.snp.bottom).offset(32)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
   
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
