//
//  XJTestBannerViewController.swift
//  XJSwiftKit
//
//  Created by Mr.Yang on 2021/10/29.
//

import UIKit
import FSPagerView

class XJTestBannerViewController: XJBaseViewController {
    
//    fileprivate let imageNames = ["1.jpg","2.jpg","3.jpg"]
    
    fileprivate let imageNames = [getUserCover("8488"), getUserCover("4817"), getUserCover("4816")]

    lazy var pagerView: FSPagerView = {
        let pager = FSPagerView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 240))
        pager.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        pager.delegate = self
        pager.dataSource = self
        pager.automaticSlidingInterval = 3 // 自动滚动
        pager.isInfinite = true // 无限循环
        //pager.itemSize = CGSize(width: self.view.width * 0.95, height: 240 * 0.95)
        //pager.interitemSpacing = self.view.width * 0.05
        pager.transformer = FSPagerViewTransformer(type: .cubic)
        return pager
    }()
    
    lazy var pageControl: FSPageControl = {
        let control = FSPageControl(frame: CGRect(x: 0, y: 215, width: self.view.width, height: 25))
        control.numberOfPages = imageNames.count
        control.contentHorizontalAlignment = .right
        control.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "轮播图"
        
        self.view.addSubview(pagerView)
        self.view.addSubview(pageControl)
    }
}

extension XJTestBannerViewController: FSPagerViewDataSource, FSPagerViewDelegate {
    
    /// FSPagerViewDataSource
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.imageNames.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        //cell.imageView?.image = UIImage(named: self.imageNames[index])
        cell.imageView?.setImage(url: self.imageNames[index], placeholder: "icon_launchImage_top")
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        cell.textLabel?.text = "\(index)的描述"
        return cell
    }
    
    /// FSPagerViewDelegate
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pageControl.currentPage = pagerView.currentIndex
    }
}

// 获取用户封面
func getUserCover(_ uid: String) -> String {
    // MD5加密
    let MD5Str = uid.xj.md5Encrypt()
    let MD5String = MD5Str as NSString
    // 截取字符串1
    let filepath1 = MD5String.substring(to: 2)
    // 截取字符串2
    let range = NSRange.init(location: 2, length: 2)
    let filepath2 = MD5String.substring(with: range)
    let urlStr_circleCover: String = "https://file.xroom.net/user/\(filepath1)/\(filepath2)/\(uid)/circle.jpg"
    return urlStr_circleCover
}
