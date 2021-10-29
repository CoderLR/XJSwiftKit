//
//  YSActivityIndicatorView.swift
//  XJSwiftKit
//
//  Created by Mr.Yang on 2021/10/20.
//

import UIKit
import NVActivityIndicatorView
import SnapKit

class YSActivityIndicatorView: UIView {
    
    private var activityIndicator: NVActivityIndicatorView!
    private var titleLabel: UILabel!
    
    convenience init(frame: CGRect = .zero,
                     text: String = "loading...",
                     color: UIColor = Color_System,
                     type: NVActivityIndicatorType = .ballDoubleBounce,
                     padding: CGFloat = 10) {
        self.init(frame: frame)
        
        activityIndicator = NVActivityIndicatorView(frame: .zero, type: type, color: color, padding: padding)
        self.addSubview(activityIndicator)
        
        titleLabel = UILabel.xj.create(bgColor: UIColor.clear ,text: text, textColor: color, font: 14)
        self.addSubview(titleLabel)
        
        activityIndicator.snp.makeConstraints { (make) in
            make.width.height.equalTo(70)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-25)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(20)
            make.top.equalTo(activityIndicator.snp.bottom)
        }
        
        self.startAnimating()
    }
    
    /// 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension YSActivityIndicatorView {
    
    internal class func showAdded(to view: UIView, animated: Bool) {
        let activityView = YSActivityIndicatorView(text: "loading")
        view.addSubview(activityView)
        activityView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    internal class func hide(for view: UIView, animated: Bool) {
        for subView in view.subviews {
            if subView.isKind(of: YSActivityIndicatorView.self) {
                let activityView = subView as? YSActivityIndicatorView
                activityView?.stopAnimating()
            }
        }
    }
    
    private func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    private func stopAnimating() {
        activityIndicator.stopAnimating()
        self.removeFromSuperview()
    }
}
