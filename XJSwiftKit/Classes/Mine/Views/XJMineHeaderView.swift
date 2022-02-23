//
//  XJMineHeaderView.swift
//  XJSwiftKit
//
//  Created by xj on 2022/1/12.
//

import UIKit

class XJMineHeaderView: UIView {
    
    // 头像
    lazy var iconView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "icon_mine_header_placeholder")
        img.contentMode = .scaleAspectFit
        img.backgroundColor = UIColor.clear
        return img
    }()
    
    /// 标题
    lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "HEJJY"
        lb.font = UIFont.systemFont(ofSize: 17)
        lb.textColor = Color_333333_333333
        lb.backgroundColor = UIColor.clear
        lb.textAlignment = .left
        return lb
    }()
    
    /// 标题
    lazy var subTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "账号：LR_326629321"
        lb.font = UIFont.systemFont(ofSize: 15)
        lb.textColor = Color_666666_666666
        lb.backgroundColor = UIColor.clear
        lb.textAlignment = .left
        return lb
    }()
    
    /// 指示图片
    lazy var arrowImgView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "icon_mine_arrow")
        img.contentMode = .scaleAspectFit
        img.backgroundColor = UIColor.clear
        img.isUserInteractionEnabled = true
        return img
    }()

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
    fileprivate func setupUI() {
        self.addSubview(iconView)
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
        self.addSubview(arrowImgView)
        
        iconView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 60, height: 60))
            make.left.equalTo(20)
            make.bottom.equalToSuperview().offset(-40)
        }

        arrowImgView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 25, height: 25))
            make.right.equalTo(-15)
            make.centerY.equalTo(iconView.snp.centerY)
        }

        titleLabel.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.left.equalTo(iconView.snp.right).offset(20)
            make.right.equalTo(arrowImgView.snp.left).offset(-20)
            make.top.equalTo(iconView.snp.top)
        }

        subTitleLabel.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.left.equalTo(iconView.snp.right).offset(20)
            make.right.equalTo(arrowImgView.snp.left).offset(-20)
            make.top.equalTo(titleLabel.snp.bottom)
        }
    }
    
    // 布局UI
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
