//
//  YSShareView.swift
//  ShiJianYun
//
//  Created by xj on 2022/1/11.
//

import UIKit
import SnapKit

// MARK: - 显示模型
class YSShareInfo: NSObject {
    
    /// 分享类型
    enum YSShareType {
        case wechat // 微信
        case circle // 朋友圈
        case qq     // QQ
        case zore   // 空间
        case weibo  // 微博
        case link   // 链接
        case other  // 其他
    }
    
    // 图片名称
    var imageName: String = ""
    // 标题
    var title: String = ""
    // 分享类型
    var shareType: YSShareType = .wechat
    
    /// 获取显示数据
    /// - Returns: 返回要显示的数据
    class func getShareInfos(_ type: Int) -> [YSShareInfo] {
        var shareInfos: [YSShareInfo] = []
        for _ in 0..<6 {
            let info = YSShareInfo()
            if type == 0 {
                info.imageName = "icon_share_weixin"
                info.shareType = .wechat
                info.title = "微信"
            } else {
                info.imageName = "icon_share_circle"
                info.shareType = .circle
                info.title = "朋友圈"
            }
            shareInfos.append(info)
        }
        return shareInfos
    }
}

// MARK: - 分享视图
let KShareBgViewH = 240 + KHomeBarH

typealias YSShareBlock = ((_ type: YSShareInfo.YSShareType) -> ())

class YSShareView: UIView {
    
    /// 数据源
    var topShareInfos: [YSShareInfo] = []
    var bottomShareInfos: [YSShareInfo] = []
    
    /// scrollView高度
    var topShareH: CGFloat = KShareBgViewH - 80 - KHomeBarH
    
    /// 分享回调
    var clickBlock: YSShareBlock?
    
    /// 顶部scrollView
    fileprivate lazy var topScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    /// 底部scrollView
    fileprivate lazy var bottomScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    /// 背景view
    fileprivate lazy var bgView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: KScreenH, width: KScreenW, height: KShareBgViewH)
        view.backgroundColor = Color_FFFFFF_151515
        if filletScreen() {
            view.layer.cornerRadius = 5
            view.layer.masksToBounds = true
        }
        return view
    }()
    
    /// 标题
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = KDefaultFont
        label.textColor = Color_666666_666666
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        label.text = "分享至"
        return label
    }()
    
    /// 取消
    fileprivate lazy var cancleBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(Color_666666_666666, for: .normal)
        btn.titleLabel?.font = KLargeFont
        btn.addTarget(self, action: #selector(cancleBtnClick(_:)), for: .touchUpInside)
        return btn
    }()
    
    convenience init(topShareInfos: [YSShareInfo],
                     bottomShareInfos: [YSShareInfo]) {
        self.init(frame: .zero)
        
        self.topShareInfos = topShareInfos
        self.bottomShareInfos = bottomShareInfos

        self.frame = CGRect(x: 0, y: 0, width: KScreenW, height: KScreenH + KShareBgViewH)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        self.initGesture()
    }
    
    fileprivate override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show(_ clickBlock: @escaping YSShareBlock) {
        
        self.clickBlock = clickBlock
        
        showInView(UIApplication.shared.keyWindow!)
        
        addSubview(bgView)
        
        bgView.addSubview(titleLabel)
       
        bgView.addSubview(cancleBtn)
        
        self.topShareH *= 0.5
        bgView.addSubview(topScrollView)
        bgView.addSubview(bottomScrollView)
        
        addTopSubview()
        addBottomSubview()
     
        initSubviewFrame()
    }
    
    /// 添加顶部
    fileprivate func addTopSubview() {
        let buttonWH: CGFloat = self.topShareH
        for i in 0..<topShareInfos.count {
            let button = UIButton()
            button.tag = i
            button.setTitle(topShareInfos[i].title, for: .normal)
            button.setTitleColor(Color_666666_666666, for: .normal)
            button.titleLabel?.font = KSmallFont
            button.setImage(UIImage(named: topShareInfos[i].imageName), for: .normal)
            button.frame = CGRect(x: CGFloat(i) * buttonWH, y: 0, width: buttonWH, height: buttonWH)
            button.xj.setImageTitleLayout(.imgTop, spacing: 8)
            button.addTarget(self, action: #selector(topBtnClick(_:)), for: .touchUpInside)
            topScrollView.addSubview(button)
            topScrollView.contentSize = CGSize(width: buttonWH * CGFloat(topShareInfos.count), height: topScrollView.height)
        }
    }
    
    /// 添加底部
    fileprivate func addBottomSubview() {
        let buttonWH: CGFloat = self.topShareH
        for i in 0..<bottomShareInfos.count {
            let button = UIButton()
            button.tag = i
            button.setTitle(bottomShareInfos[i].title, for: .normal)
            button.setTitleColor(Color_666666_666666, for: .normal)
            button.titleLabel?.font = KSmallFont
            button.setImage(UIImage(named: bottomShareInfos[i].imageName), for: .normal)
            button.frame = CGRect(x: CGFloat(i) * buttonWH, y: 0, width: buttonWH, height: buttonWH)
            button.xj.setImageTitleLayout(.imgTop, spacing: 8)
            button.addTarget(self, action: #selector(bottomBtnClick(_:)), for: .touchUpInside)
            bottomScrollView.addSubview(button)
            bottomScrollView.contentSize = CGSize(width: buttonWH * CGFloat(bottomShareInfos.count), height: bottomScrollView.height)
        }
    }
    
    /// 设置子控件frame
    fileprivate func initSubviewFrame() {
        
        // 标题
        titleLabel.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        // 顶部
        topScrollView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(self.topShareH)
        }
        
        // 低部
        bottomScrollView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(topScrollView.snp.bottom)
            make.height.equalTo(self.topShareH)
        }
        
        // 取消
        cancleBtn.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-KHomeBarH)
        }
    }
}

// MARK: - Animation
extension YSShareView {
    
    //// 点击手势
    func initGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        tap.delegate = self
        self.addGestureRecognizer(tap)
    }
    
    /// 在view上添加视图
    func showInView(_ view: UIView) {
        UIView.animate(withDuration: 0.25, animations: {
            var point = self.center
            point.y -= KShareBgViewH
            self.center = point
        }, completion: nil)
        view.addSubview(self)
    }
    
    /// 消失
    func dismiss() {
        UIView.animate(withDuration: 0.25, animations: {
            var point = self.center
            point.y += KShareBgViewH
            self.center = point
        }, completion: {(finish) in
            self.removeFromSuperview()
        })
    }
}

// MARK: - Action
extension YSShareView {
    
    /// 点击
    @objc func tapGesture(_ gesture: UIGestureRecognizer) {
        self.dismiss()
    }
    
    /// 取消
    @objc func cancleBtnClick(_ btn: UIButton) {
        self.dismiss()
    }
    
    /// 顶部点击
    @objc func topBtnClick(_ btn: UIButton) {
        let topInfo = self.topShareInfos[btn.tag]
        if let clickBlock = self.clickBlock {
            clickBlock(topInfo.shareType)
        }
        self.dismiss()
    }
    
    /// 底部点击
    @objc func bottomBtnClick(_ btn: UIButton) {
        let topInfo = self.bottomShareInfos[btn.tag]
        if let clickBlock = self.clickBlock {
            clickBlock(topInfo.shareType)
        }
        self.dismiss()
    }
}

// MARK: - 点击子视图不响应父视图的事件
extension YSShareView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // 是self.bgView子视图
        if touch.view?.isDescendant(of: self.bgView) ?? false {
            return false
        }
        return true
    }
}
