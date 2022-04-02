//
//  XJSearchViewController.swift
//  ShiJianYun
//
//  Created by Mr.Yang on 2021/10/27.
//

import UIKit
import SnapKit

class XJSearchViewController: XJBaseViewController {
    
    /// 搜索框
    fileprivate var searchTextField: UITextField!

    /// 历史搜索
    fileprivate var historyView: XJSearchView!
    
    /// 搜索历史数据
    fileprivate var historyInfos: [YSSearchHistoryInfo] = []
    
    /// 执行搜索
    var callSearchBlock: ((UITextField) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 查询数据库
        historyInfos = self.queryTable()
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let leftImgView = UIImageView(image: UIImage(named: "icon_nav_search"))
        leftView.addSubview(leftImgView)
        leftImgView.size = CGSize(width: 20, height: 20)
        leftImgView.center = leftView.center
        
        searchTextField = UITextField.xj.create(bgColor: Color_F0F0F0_F0F0F0,
                                                    borderStyle: .none,
                                                    placeholder: "请输入搜索内容",
                                                    textColor: Color_333333_333333,
                                                    tintColor: Color_System, font: 14,
                                                    isSecureTextEntry: false,
                                                    clearButtonMode: .whileEditing)
        searchTextField.delegate = self
        searchTextField.layer.borderColor = Color_F0F0F0_F0F0F0.cgColor
        searchTextField.layer.borderWidth = 0.5
        searchTextField.layer.cornerRadius = 15
        searchTextField.layer.masksToBounds = true
        searchTextField.returnKeyType = .search
        searchTextField.leftViewMode = .always
        searchTextField.leftView = leftView
        self.navigationItem.titleView = searchTextField
        
        searchTextField.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.width.equalTo(KScreenW - 2 * 40)
        }
        
        /// 数据库没有数据直接返回
        if historyInfos.count <= 0 { return }
        historyView = XJSearchView(frame: self.view.bounds, historyInfos: historyInfos)
        historyView.clearSearchHistory = { [weak self] in
            guard let self = self else { return }
            print("clear")
        
            // 清空数据库
            if self.deleteTable() {
                self.historyInfos.removeAll()
                self.historyView.removeFromSuperview()
            }
        }
        historyView.didSelectItem = { [weak self] historyInfo in
            guard let self = self else { return }
            print("click--\(historyInfo.timeInterval)--\(historyInfo.content)")
            
            // 显示新的搜索内容
            self.searchTextField.text = historyInfo.content
            
            // 更新数据库
            self.updateTable(content: historyInfo.content)
            
            // 执行搜索
            if let callSearchBlock = self.callSearchBlock {
                callSearchBlock(self.searchTextField)
            }
        }
        self.view.addSubview(historyView)
        historyView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UITextFieldDelegate
extension XJSearchViewController: UITextFieldDelegate {
    /// 点击键盘搜索
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        // 插入数据库
        self.insertTable(content: textField.text ?? "")
        
        if let callSearchBlock = callSearchBlock {
            callSearchBlock(textField)
        }
        return true
    }
}

// MARK: - DB Action
extension XJSearchViewController {
    /// 插入表
    func insertTable(content: String) {
        
        var isContain = false
        for info in self.historyInfos {
            if info.content == content {
                isContain = true; break
            }
        }
        if isContain { return }
        
        let historyInfo = YSSearchHistoryInfo()
        historyInfo.timeInterval = "\(Date().timeIntervalSince1970.xj.int64)"
        historyInfo.content = content
        DB.insertTable(SEARCH_TABLE_NAME, dbInfo: historyInfo)
    }
    
    /// 更新表
    func updateTable(content: String) {
        let historyInfo = YSSearchHistoryInfo()
        historyInfo.timeInterval = "\(Date().timeIntervalSince1970.xj.int64)"
        historyInfo.content = content
        DB.updateTable(SEARCH_TABLE_NAME, dbInfo: historyInfo, column: SEARCH_COLUMN_CONTENT, columnValue: content)
    }

    /// 查询表
    func queryTable() -> [YSSearchHistoryInfo] {
        let historyInfos = DB.queryTable(SEARCH_TABLE_NAME, column: SEARCH_COLUMN_TIME , dbInfo: YSSearchHistoryInfo.self)
        guard let searchInfos = historyInfos else { return [] }
        var infos: [YSSearchHistoryInfo] = []
        for info in searchInfos {
            guard let obj = info as? YSSearchHistoryInfo else { continue }
            print("\(obj.timeInterval)---\(obj.content)")
            infos.append(obj)
        }
        return infos
    }
    
    /// 删除表
    func deleteTable() -> Bool {
        return DB.deleteAllTable(SEARCH_TABLE_NAME)
    }
}

// MARK: - 搜索历史存储
class YSSearchHistoryInfo: NSObject, YSDbProtocol {

    var timeInterval: String = ""
    var content: String = ""
    
    /// 从DB读取数据模型
    static func getDbInfo(_ tableName: String, _ resultSet: FMResultSet) -> Any? {
        let dbInfo = YSSearchHistoryInfo()
        dbInfo.timeInterval = resultSet.string(forColumn: SEARCH_COLUMN_TIME) ?? ""
        dbInfo.content = resultSet.string(forColumn: SEARCH_COLUMN_CONTENT) ?? ""
        return dbInfo
    }

    /// 获取字段和值
    func getInfoKeyValues() -> (keys: [String]?, values: [String]?) {
        var keyArray = [String]()
        var valueArray = [String]()

        keyArray.append(SEARCH_COLUMN_TIME)
        valueArray.append(DB.toSqlValue(value: self.timeInterval))

        keyArray.append(SEARCH_COLUMN_CONTENT)
        valueArray.append(DB.toSqlValue(value: self.content))

        return (keyArray, valueArray)
    }
}
