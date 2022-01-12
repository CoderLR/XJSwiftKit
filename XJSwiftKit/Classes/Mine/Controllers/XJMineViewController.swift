//
//  XJMineViewController.swift
//  XJSwiftKit
//
//  Created by Mr.Yang on 2021/4/14.
//

import UIKit

class XJMineViewController: XJBaseViewController {
    
    /// tableView
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.separatorStyle = .none
        // 适配ios11
        if #available(iOS 11.0, *) {
            
            tableView.estimatedSectionHeaderHeight = 0
            tableView.estimatedSectionFooterHeight = 0
            tableView.contentInsetAdjustmentBehavior = .never
        }
        return tableView
    }()
    
    /// headerView
    lazy var headerView: XJMineHeaderView = {
        let header = XJMineHeaderView(frame: CGRect(x: 0, y: 0, width: KScreenW, height: 200))
        return header
    }()
    
    /// 数据源
    var mineModels: [[XJMineModel]] = XJMineModel.getMineModels()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.fd_prefersNavigationBarHidden = true
        self.title = "我的"
        
        steupUI()
    }
    
    func steupUI() {
        self.view.addSubview(tableView)
        tableView.tableHeaderView = headerView
    }

}

// MARK: - UITableViewDelegate
extension XJMineViewController: UITableViewDelegate, UITableViewDataSource {
    
    // 返回组数
    func numberOfSections(in tableView: UITableView) -> Int {
        return mineModels.count
    }
    
    // 返回每组个数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mineModels[section].count
    }
    
    // 返回cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = XJMineCell.tableViewCell(tableView: tableView)
        cell.mineModel = mineModels[indexPath.section][indexPath.row]
        return cell
    }
    
    // 返回cell的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // 点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // 返回header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    // 返回header高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    // 返回footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    // 返回footer高度
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

