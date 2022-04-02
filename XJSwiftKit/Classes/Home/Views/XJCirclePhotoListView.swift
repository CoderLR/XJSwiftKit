//
//  XJCirclePhotoListView.swift
//  ShiJianYun
//
//  Created by xj on 2022/3/4.
//

import UIKit

class XJCirclePhotoListView: UIView {
    
    var addBtnClickBlock: ((_ imageArray: [UIImage]) -> ())?
    var imageViewClickBlock: ((_ imageArray: [UIImage], _ currentImgView: XJCirclePhotoView) -> ())?
    
    var addBtn: UIButton!
    
    var viewArray: [UIView] = []

    /// 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 加载UI
    func setupUI() {
        addBtn = UIButton()
        addBtn.backgroundColor = UIColor.gray
        addBtn.setBackgroundImage(UIImage(named: "icon_photos_add"), for: .normal)
        addBtn.addTarget(self, action: #selector(addBtnClick(_:)), for: .touchUpInside)
        self.addSubview(addBtn)
        self.viewArray.append(addBtn)
    }
    
    // 根据选择的图片数组创建视图
    func addPhotoViews(imageArray: [UIImage]) {
        for image in imageArray {
            let imageView = XJCirclePhotoView(frame: CGRect.zero)
            weak var weakSelf = self
            imageView.closeBtnClickBlock = {
                imageV -> () in
                weakSelf?.closeBtnClick(imageV)
            }
            imageView.imageClickBlock = {
                (imageV) -> () in
                weakSelf?.imageViewClick(imageV)
            }
            imageView.image = image
            self.addSubview(imageView)
            self.viewArray.append(imageView)
        }
    }
    
    // 布局UI
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.exchangeView()
        
        let colume: Int = 3
        let margin: CGFloat  = 10
        let count: Int = self.viewArray.count
        
        let allMargin: CGFloat = 4 * margin
        let imgWH : CGFloat = (self.width - allMargin) / 3
        
        self.addBtn.isHidden = count > 9 ? true : false
        
        for i in 0..<count {
            let view = self.viewArray[i]
            view.tag = i
            let col: Int = i % colume
            let row: Int = i / colume
            
            view.width = imgWH
            view.height = imgWH
            
            if (view.x == margin && view.y == margin) {
                view.x = margin + CGFloat(col) * (imgWH + margin)
                view.y = margin + CGFloat(row) * (imgWH + margin)
            } else {
                UIView.animate(withDuration: 0.25) {
                    view.x = margin + CGFloat(col) * (imgWH + margin)
                    view.y = margin + CGFloat(row) * (imgWH + margin)
                }
            }
        }
    }
    
    // 把+始终放到最后
    func exchangeView() {
        for view in self.viewArray {
            if view.isKind(of: UIButton.self) {
                self.viewArray.remove(view)
                break
            }
        }
        self.viewArray.append(self.addBtn)
    }
    
    // 获取选选择的图片
    func photoImages() -> [UIImage] {
        var imageArray: [UIImage] = []
        for view in self.viewArray {
            if view.isKind(of: XJCirclePhotoView.self) {
                let imageView = view as! XJCirclePhotoView
                guard let image = imageView.image else { break }
                imageArray.append(image)
            }
        }
        return imageArray
    }

}

extension XJCirclePhotoListView {
    // 关闭按钮点击
    @objc func addBtnClick(_ btn: UIButton) {
        if let clickBlock = self.addBtnClickBlock {
            let imageArray = self.photoImages()
            clickBlock(imageArray)
        }
    }
    
    // 图片点击
    func imageViewClick(_ imageView: XJCirclePhotoView) {
        print("tag = \(imageView.tag)")
        if let imageViewClickBlock = self.imageViewClickBlock {
            let imageArray = self.photoImages()
            imageViewClickBlock(imageArray, imageView)
        }
    }
    
    // 关闭按钮点击
    func closeBtnClick(_ imageView: XJCirclePhotoView) {
        UIView.animate(withDuration: 0.25, animations: {
            imageView.alpha = 0
        }) { (finished) in
            self.viewArray.remove(imageView)
            imageView.removeFromSuperview()
        }
    }
}
