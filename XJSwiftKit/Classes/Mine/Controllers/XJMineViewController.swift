//
//  XJMineViewController.swift
//  ShiJianYun
//
//  Created by Mr.Yang on 2021/4/14.
//

import UIKit

//class XJMineViewController: XJBaseViewController {
//
//    /// tableView
//    lazy var tableView: UITableView = {
//        let tableView = UITableView(frame: self.view.bounds, style: .grouped)
//        tableView.delegate = self
//        tableView.dataSource = self
//        //tableView.separatorStyle = .none
//        // 适配ios11
//        if #available(iOS 11.0, *) {
//
//            tableView.estimatedSectionHeaderHeight = 0
//            tableView.estimatedSectionFooterHeight = 0
//            tableView.contentInsetAdjustmentBehavior = .never
//        }
//        return tableView
//    }()
//
//    /// headerView
//    lazy var headerView: XJMineHeaderView = {
//        //let header = XJMineHeaderView(frame: CGRect(x: 0, y: 0, width: KScreenW, height: 200))
//        let header = XJMineHeaderView(frame: CGRect(x: 0, y: -200, width: KScreenW, height: 200))
//        return header
//    }()
//
//    /// 数据源
//    var mineModels: [[XJMineModel]] = XJMineModel.getMineModels()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.fd_prefersNavigationBarHidden = true
//        self.title = "我的"
//
//        setupUI()
//    }
//
//    fileprivate func setupUI() {
//        self.view.addSubview(tableView)
//        //tableView.tableHeaderView = headerView
//
//        tableView.contentInset = UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0)
//
//        tableView.addSubview(headerView)
//
//        self.setRefreshHeader(tableView, ignoredContentInsetTop: 200 - KStatusBarH) { [weak self] in
//            print("下拉刷新")
//            guard let self = self else { return }
//            DispatchQueue.global().asyncAfter(deadline: .now() + 2)  {
//                self.endRefreshHeader()
//            }
//        }
//
//        if let mjHeader = self.tableView.mj_header {
//            self.tableView.bringSubviewToFront(mjHeader)
//        }
//    }
//
//}
//
//// MARK: - UIScrollViewDelegate
//extension XJMineViewController: UIScrollViewDelegate {
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
////        print("offsetY = \(offsetY)")
//        let height = offsetY >= -200 ? 200 : -offsetY
//
//
//        self.headerView.frame = CGRect(x: 0, y: -height, width: KScreenW, height: height)
//    }
//}




import UIKit

let KMineHeaderH: CGFloat = 136 + KStatusBarH

class XJMineViewController: XJBaseViewController {
    
    /// tableView
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.backgroundColor = UIColor.clear
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
        //let header = XJMineHeaderView(frame: CGRect(x: 0, y: 0, width: KScreenW, height: 200))
        let header = XJMineHeaderView(frame: CGRect(x: 0, y: 0, width: KScreenW, height: KMineHeaderH))
        return header
    }()
    
    /// 数据源
    var mineModels: [[XJMineModel]] = XJMineModel.getMineModels()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fd_prefersNavigationBarHidden = true
        
        /// 不要直接使用title，会导致tabbar顺序错乱
        self.navigationItem.title = "我的"

        setupUI()
    }
    
    /// 避免侧滑返回刷新控件显示
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setRefresh(false)
    }
    
    /// 避免侧滑返回刷新控件显示
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setRefresh(true)
    }
    
    fileprivate func setupUI() {
        self.view.addSubview(tableView)
        tableView.tableHeaderView = headerView
    }
    
    /// 设置header
    fileprivate func setRefresh(_ dissmiss: Bool) {
        if dissmiss {
            self.setRefreshHeader(tableView, ignoredContentInsetTop: 0) { [weak self] in
                print("下拉刷新")
                guard let self = self else { return }

                DispatchQueue.global().asyncAfter(deadline: .now() + 1)  {
                    self.endRefreshHeader()
                }
            }
        } else {
            self.setRefreshHeader(tableView, ignoredContentInsetTop: (filletScreen() == true ? -KStatusBarH : 0)) { [weak self] in
                print("下拉刷新")
                guard let self = self else { return }

                DispatchQueue.global().asyncAfter(deadline: .now() + 1)  {
                    self.endRefreshHeader()
                }
            }
        }
        
        if let mjHeader = self.tableView.mj_header {
            self.tableView.bringSubviewToFront(mjHeader)
        }
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
        
        let model: XJMineModel = self.mineModels[indexPath.section][indexPath.row]
        let detailVc = XJMineDetailViewController(model.title)
        self.pushVC(detailVc)
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

