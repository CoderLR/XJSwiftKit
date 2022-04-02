//
//  XJCirclePhotoView.swift
//  ShiJianYun
//
//  Created by xj on 2022/3/4.
//

import UIKit

class XJCirclePhotoView: UIImageView {
    
    var closeBtnClickBlock: ((_ imageView: XJCirclePhotoView) -> ())?
    var imageClickBlock: ((_ imageView: XJCirclePhotoView) -> ())?
    
    var closeBtn: UIButton!

    /// 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.isUserInteractionEnabled = true
        self.contentMode = .scaleAspectFill
        self.layer.masksToBounds = true
        
        setupUI()
        
        addGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        self.addGestureRecognizer(tap)
    }
    
    // 加载UI
    func setupUI() {
        closeBtn = UIButton()
        closeBtn.backgroundColor = UIColor.clear
        closeBtn.setImage(UIImage(named: "icon_photos_delete"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeBtnClick(_:)), for: .touchUpInside)
        self.addSubview(closeBtn)
    }
    
    // 布局UI
    override func layoutSubviews() {
        super.layoutSubviews()
        
        closeBtn.size = closeBtn.currentImage?.size ?? CGSize.zero
        closeBtn.x = self.width - closeBtn.width
    }
    

}

extension XJCirclePhotoView {
    // imageView点击
    @objc func tapGesture(_ gesture: UITapGestureRecognizer) {
        if let clickBlock = self.imageClickBlock {
            clickBlock(self)
        }
    }

    // 关闭按钮点击
    @objc func closeBtnClick(_ btn: UIButton) {
        if let clickBlock = self.closeBtnClickBlock {
            clickBlock(self)
        }
    }
}
