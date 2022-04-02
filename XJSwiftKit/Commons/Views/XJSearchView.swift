//
//  XJSearchView.swift
//  ShiJianYun
//
//  Created by Mr.Yang on 2021/10/27.
//

import UIKit

class XJSearchView: UIView {
    
    var collectionView: UICollectionView!
    var titleLabel: UILabel!
    var clearBtn: UIButton!
    
    /// 清空回调
    var clearSearchHistory: (() -> Void)?
    
    /// cell点击
    var didSelectItem: ((YSSearchHistoryInfo) -> Void)?

    /// 搜索历史数据
    var historyInfos: [YSSearchHistoryInfo] = [] {
        didSet {
            if self.collectionView != nil {
                self.collectionView.reloadData()
            }
        }
    }
    
    /// 初始化
    convenience init(frame: CGRect, historyInfos: [YSSearchHistoryInfo]) {
        self.init(frame: frame)
        
        self.historyInfos = historyInfos
        
        setupUI()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 加载UI
    fileprivate func setupUI() {
        
        titleLabel = UILabel.xj.create(bgColor: UIColor.clear,
                          text: "搜索历史",
                          textColor: Color_333333_333333,
                          font: 15,
                          textAlignment: .left,
                          numberOfLines: 1)
        titleLabel.sizeToFit()
        titleLabel.centerY = 25
        titleLabel.x = 10
        self.addSubview(titleLabel)
        
        clearBtn = UIButton.xj.create(bgColor: UIColor.clear, imageName: "icon_search_delete")
        clearBtn.addTarget(self, action: #selector(clearBtnClick(_:)), for: .touchUpInside)
        clearBtn.size = CGSize(width: 20, height: 20)
        clearBtn.centerY = titleLabel.centerY
        clearBtn.x = self.width - clearBtn.width - 10
        self.addSubview(clearBtn)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 50, width: self.width, height: self.height - 50), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        // 适配ios11
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        collectionView.register(XJSearchCell.self, forCellWithReuseIdentifier: "XJSearchCell")
        self.addSubview(collectionView)
    }
    
    /// 清空按钮点击
    @objc func clearBtnClick(_ button: UIButton) {
        if let clearSearchHistory = clearSearchHistory {
            clearSearchHistory()
        }
    }
}

extension XJSearchView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // 返回cell个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return historyInfos.count
    }
    
    // 返回cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "XJSearchCell", for: indexPath) as! XJSearchCell
        cell.historyInfo = self.historyInfos[indexPath.item]
        return cell
    }
    
    // 点击cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let historyInfo = self.historyInfos[indexPath.item]
        if let didSelectItem = didSelectItem {
            didSelectItem(historyInfo)
        }
    }
    
    // 定义每个Cell的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let historyInfo = self.historyInfos[indexPath.item]
        let size = CGSize(width: collectionView.width - 20, height: CGFloat(MAXFLOAT))
        let textSize = YSContentSizeTool.textStringSize(string: historyInfo.content, size: size, font: UIFont.systemFont(ofSize: 15))
        //print("textSize = \(textSize)")
        return CGSize(width: textSize.width + 25, height: textSize.height + 10)
    }
    
    // 定义每个Section的四边间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    // 这个是两行cell之间的间距（上下行cell的间距）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // 两个cell之间的间距（同一行的cell的间距）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

class XJSearchCell: UICollectionViewCell {
    
    var titleLabel: UILabel!
    
    var historyInfo: YSSearchHistoryInfo? {
        didSet {
            self.titleLabel.text = historyInfo?.content ?? ""
        }
    }
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = Color_F0F0F0_F0F0F0
        self.layer.cornerRadius = self.height * 0.5
        self.layer.masksToBounds = true
        
        titleLabel = UILabel.xj.create(bgColor: UIColor.clear,
                          textColor: Color_System,
                          font: 15,
                          textAlignment: .center,
                          numberOfLines: 1)
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
