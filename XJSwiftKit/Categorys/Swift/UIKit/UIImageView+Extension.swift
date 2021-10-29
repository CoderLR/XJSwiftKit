//
//  UIImageView+Extension.swift
//  XJSwiftKit
//
//  Created by Mr.Yang on 2021/10/18.
//

import Foundation
import Kingfisher

// MARK:- 一、加载 gif
public extension XJExtension where Base: UIImageView {
    
    /// UIImageView创建
    /// - Parameters:
    ///   - bgColor: 背景颜色
    ///   - imgName: 图片名
    /// - Returns: UIImageView
    static func create(bgColor: UIColor = UIColor.white,
                         imgName: String? = nil) -> UIView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = bgColor
        if let imgName = imgName {
            imageView.image = UIImage(named: imgName)
        }
        return imageView
    }
    
    // MARK: 1.1、加载本地的gif图片
    /// 加载本地的gif图片
    /// - Parameter name: 图片的名字
    func loadGif(name: String) {
        DispatchQueue.global().async {
            let image = UIImage.xj.gif(name: name)
            DispatchQueue.main.async {
                self.base.image = image
            }
        }
    }
    
    // MARK: 1.2、加载 asset 里面的图片
    /// 加载 asset 里面的图片
    /// - Parameter asset: asset 里面的图片名字
    @available(iOS 9.0, *)
    func loadGif(asset: String) {
        DispatchQueue.global().async {
            let image = UIImage.xj.gif(asset: asset)
            DispatchQueue.main.async {
                self.base.image = image
            }
        }
    }
    
    // MARK: 1.3、加载网络 url 的 gif 图片
    /// 加载网络 url 的 gif 图片
    /// - Parameter url: gif图片的网络地址
    @available(iOS 9.0, *)
    func loadGif(url: String) {
        DispatchQueue.global().async {
            let image = UIImage.xj.gif(url: url)
            DispatchQueue.main.async {
                self.base.image = image
            }
        }
    }
}

// MARK: - Load networkImage
extension UIImageView {
    
    /// 加载图片
    /// - Parameters:
    ///   - url: 图片路径
    ///   - options: 选择策略
    func setImage(url: String, options: KingfisherOptionsInfo? = nil) {
        
        
        let placeholderImg = UIImage(named: "")
        var optionInfo: KingfisherOptionsInfo = []
        if let options = options {
            optionInfo = options
        } else {
            optionInfo = [.cacheOriginalImage,
                          .processor(DefaultImageProcessor.default),
                          .transition(ImageTransition.fade(0.5))]
        }
        
        //self.kf.indicatorType = .activity // 显示菊花
        self.kf.setImage(with: URL(string: url),
                         placeholder: placeholderImg,
                         options: optionInfo)
    }
    
    
    /// 加载图片
    /// - Parameters:
    ///   - url: 图片路径
    ///   - placeholder: 占位图
    ///   - options: 选择策略
    func setImage(url: String, placeholder: String, options: KingfisherOptionsInfo? = nil) {
        
        
        let placeholderImg = UIImage(named: placeholder)
        var optionInfo: KingfisherOptionsInfo = []
        if let options = options {
            optionInfo = options
        } else {
            optionInfo = [.cacheOriginalImage,
                          .processor(DefaultImageProcessor.default),
                          .transition(ImageTransition.fade(0.5))]
        }
        
        //self.kf.indicatorType = .activity // 显示菊花
        self.kf.setImage(with: URL(string: url),
                         placeholder: placeholderImg,
                         options: optionInfo,
                         progressBlock: { receivedSize, totalSize in
                            //let progress = CGFloat(receivedSize / totalSize)
                         },completionHandler: { result in
                            
                        })
    }
    
    /// 加载图片
    /// - Parameters:
    ///   - url: 图片路径
    ///   - placeholder: 占位图
    ///   - options: 选择策略
    ///   - progressBlock: 加载进度
    func setImage(url: String, placeholder: String, options: KingfisherOptionsInfo? = nil, progressBlock: ((CGFloat) -> ())?) {
        
        let placeholderImg = UIImage(named: placeholder)
        var optionInfo: KingfisherOptionsInfo = []
        if let options = options {
            optionInfo = options
        } else {
            optionInfo = [.cacheOriginalImage,
                          .processor(DefaultImageProcessor.default),
                          .transition(ImageTransition.fade(0.5))]
        }
        
        //self.kf.indicatorType = .activity // 显示菊花
        self.kf.setImage(with: URL(string: url),
                         placeholder: placeholderImg,
                         options: optionInfo,
                         progressBlock: { receivedSize, totalSize in
                            let progress = CGFloat(receivedSize / totalSize)
                            if let progressBlock = progressBlock {
                                progressBlock(progress)
                            }
                         },completionHandler: { result in
                            
                        })
    }
}
