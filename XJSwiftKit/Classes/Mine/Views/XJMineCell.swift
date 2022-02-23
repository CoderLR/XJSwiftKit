//
//  XJMineCell.swift
//  XJSwiftKit
//
//  Created by xj on 2022/1/12.
//

import UIKit
import SnapKit

class XJMineCell: UITableViewCell {
    
    /// 头像
    lazy var iconImgView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.backgroundColor = UIColor.clear
        img.isUserInteractionEnabled = true
        return img
    }()
    
    /// 标题
    lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 17)
        lb.textColor = Color_333333_333333
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
    
    // 模型
    var mineModel: XJMineModel? {
        didSet {
            iconImgView.image = UIImage(named: mineModel?.imageName ?? "")
            self.titleLabel.text = mineModel?.title
        }
    }

    // 类方法初始化
    class func tableViewCell(tableView: UITableView) -> XJMineCell {
        let reuseIdentifier = "XJMineCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = XJMineCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
        }
        return cell as! XJMineCell
    }
    
    // 实例初始化
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //self.selectionStyle = .none
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 加载UI
    fileprivate func setupUI() {
        contentView.addSubview(iconImgView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowImgView)
        
        iconImgView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 25, height: 25))
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        arrowImgView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 25, height: 25))
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.left.equalTo(iconImgView.snp.right).offset(15)
            make.right.equalTo(arrowImgView.snp.left).offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    // 布局子控件
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }

}
