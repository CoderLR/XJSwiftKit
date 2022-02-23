//
//  XJTestTableViewController.swift
//  XJSwiftKit
//
//  Created by Mr.Yang on 2021/10/14.
//

import UIKit

class XJTestTableViewController: XJBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "空数据"
        
        setupUI()
    }
}

extension XJTestTableViewController {
    
    fileprivate func setupUI() {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.separatorStyle = .none
        // 适配ios11
        if #available(iOS 11.0, *) {
            
            tableView.estimatedSectionHeaderHeight = 0
            tableView.estimatedSectionFooterHeight = 0
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        
        weak var weakSelf = self
        self.setRefreshHeader(tableView) {
            weakSelf?.endRefreshHeader()
        }
    }
}

extension XJTestTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    // 返回每组个数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    // 返回cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    // 返回cell的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // 点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

