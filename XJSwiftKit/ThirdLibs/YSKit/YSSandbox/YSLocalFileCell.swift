//
//  YSLocalFileCell.swift
//  ShiJianYun
//
//  Created by xj on 2022/3/2.
//

import UIKit

class YSLocalFileCell: UITableViewCell {

    /// 图片
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
    
    /// 大小
    lazy var sizeLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = Color_666666_666666
        lb.backgroundColor = UIColor.clear
        lb.textAlignment = .right
        return lb
    }()
    
    /// 日期
    lazy var dateLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.textColor = Color_666666_666666
        lb.backgroundColor = UIColor.clear
        lb.textAlignment = .left
        return lb
    }()
    
    // 模型
    var fileModel: YSLocalFileModel? {
        didSet {
            self.iconImgView.image = UIImage(named: getImageName(fileModel!.type))
            self.titleLabel.text = fileModel?.fileName
            self.dateLabel.text = fileModel?.creaeDate
            self.sizeLabel.text = fileModel?.size
            
            if fileModel?.type == .folder {
                self.sizeLabel.isHidden = true
            } else {
                self.sizeLabel.isHidden = false
            }
        }
    }

    // 类方法初始化
    class func tableViewCell(tableView: UITableView) -> YSLocalFileCell {
        let reuseIdentifier = "YSLocalFileCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = YSLocalFileCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
        }
        return cell as! YSLocalFileCell
    }
    
    // 实例初始化
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 加载UI
    fileprivate func setupUI() {
        contentView.addSubview(iconImgView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(sizeLabel)
        
        iconImgView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 50, height: 50))
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.height.equalTo(25)
            make.left.equalTo(iconImgView.snp.right).offset(15)
            make.right.equalToSuperview().offset(-25)
            make.centerY.equalToSuperview().offset(-15)
        }
        
        sizeLabel.snp.makeConstraints { (make) in
            make.height.equalTo(25)
            make.right.equalToSuperview().offset(-25)
            make.centerY.equalToSuperview().offset(15)
            make.width.equalTo(100)
        }
        
        dateLabel.snp.makeConstraints { (make) in
            make.height.equalTo(25)
            make.left.equalTo(iconImgView.snp.right).offset(15)
            make.right.equalTo(sizeLabel.snp.left).offset(-25)
            make.centerY.equalToSuperview().offset(15)
        }
    }
    
    // 布局子控件
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    /// 获取图片名
    fileprivate func getImageName(_ type: YSLocalFileType) -> String {
        var imgName: String = ""
        switch type {
        case .db:
            imgName = "icon_file_db"
        case .folder:
            imgName = "icon_file_folder"
        case .txt:
            imgName = "icon_file_txt"
        default:
            imgName = "icon_file_other"
        }
        return imgName
    }

}
