//
//  XJPhotosViewController.swift
//  ShiJianYun
//
//  Created by xj on 2022/3/4.
//

import UIKit

class XJPhotosViewController: XJBaseViewController {
    
    fileprivate var photoView: XJCirclePhotoListView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "图片选择"
        
        setupUI()
    }
    
    fileprivate func setupUI() {
        // 图片
        photoView = XJCirclePhotoListView(frame: CGRect (x: 0, y: 0, width: self.view.width, height: self.view.width))
        photoView.addBtnClickBlock = { [weak self]
            (imageArray) -> () in
            guard let self = self else { return }
            self.showImagePicker()
            self.selectPhotoBlock = { [weak self] (images, assets, isOriginal) in
                guard let self = self else { return }
                self.photoView.addPhotoViews(imageArray: images)
            }
        }
        photoView.imageViewClickBlock = {
            (imageArray, imageView) -> () in
            print("click imageView to broswer")
        }
        self.view.addSubview(photoView)
        
        

    }

}
