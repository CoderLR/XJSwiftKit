//
//  XJLeftViewController.swift
//  ShiJianYun
//
//  Created by xj on 2022/3/29.
//

import UIKit

class XJLeftViewController: XJBaseViewController {
    
    var tableView: UITableView!
    
    fileprivate var titles: [[String: Any]] = [
                                                ["title": "控制器", "data": ["网页", "分段选择", "搜索"]],
                                                ["title": "工具", "data": ["沙盒", "Ping网络"]],
                                                ["title": "媒体", "data": ["扫码", "选择相册", "相机"]],
                                                ["title": "控件", "data": ["轮播图", "日期选择", "文本输入", "视频播放器", "日历控件", "验证码框"]],
                                                ["title": "背景", "data": ["空数据显示", "背景滚动"]],
                                                ["title": "其他", "data": ["网络请求", "横竖屏"]]
                                              ]

    override func viewDidLoad() {
        super.viewDidLoad()

        /// 不要直接使用title，会导致tabbar顺序错乱
        self.navigationItem.title = "首页"
        
        self.view.backgroundColor = UIColor.black
        
        setupUI()
    }
    
    fileprivate func setupUI() {
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        // 适配ios11
        if #available(iOS 11.0, *) {
            
            tableView.estimatedSectionHeaderHeight = 0
            tableView.estimatedSectionFooterHeight = 0
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.white
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(KStatusBarH)
            make.bottom.equalToSuperview().offset(-KHomeBarH)
        }
    }
    
    override func pushVC(_ viewController: UIViewController, animated: Bool = true) {
        
        self.mm_drawerController.closeDrawer(animated: false) { (_) in
            guard let tabbarVc = self.mm_drawerController.centerViewController as? XJTabBarViewController else { return }
            let naVc = tabbarVc.selectedViewController as? XJNavigationViewController
            naVc?.pushViewController(viewController, animated: true)
        }
    }
}

extension XJLeftViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count
    }
    
    // 返回每组个数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionData = titles[section]["data"] as? [String] else { return 0 }
        return sectionData.count
    }
    
    // 返回cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "UITableViewCell"
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
        let sectionData = titles[indexPath.section]["data"] as? [String]
        cell.textLabel?.text = sectionData?[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = UIColor.black
        cell.textLabel?.textColor = UIColor.white
        cell.tintColor = UIColor.white
        return cell
    }
    
    // 返回cell的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let title = titles[section]["title"] as? String else { return "" }
        return title
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    // 点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let webVc = XJTestWebViewController(webUrl: "https://www.cnblogs.com/yang-shuai/")
                self.pushVC(webVc)
            } else if indexPath.row == 1 {
                let sgVc = XJTestSegmentController()
                self.pushVC(sgVc)
            } else if indexPath.row == 2 {
                let searchVc = XJTestSearchViewController()
                self.pushVC(searchVc)
            }
            
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let sandboxVc = YSSandboxViewController(FileManager.xj.homeDirectory(), lastPath: "SandBox")
                self.pushVC(sandboxVc)
            } else if indexPath.row == 1 {
                let pingVc = XJPingViewController()
                self.pushVC(pingVc)
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let qrVc = YSQRCodeViewController()
                self.pushVC(qrVc)
            } else if indexPath.row == 1 {
                let photoVc = XJPhotosViewController()
                self.pushVC(photoVc)
            } else if indexPath.row == 2 {
                self.showCamera()
            }
        } else if indexPath.section == 3 {
            if indexPath.row == 0 {
                let banner = XJTestBannerViewController()
                self.pushVC(banner)
            } else if indexPath.row == 1 {
                let datePickerVc = XJDatePickerViewController()
                self.pushVC(datePickerVc)
            } else if indexPath.row == 2 {
                let textVc = XJTestTextViewViewController()
                self.pushVC(textVc)
            } else if indexPath.row == 3 {
                let playerVc = XJTestVideoPlayerController()
                self.pushVC(playerVc)
            } else if indexPath.row == 4 {
                let calendarVc = XJTest2CalendarViewController()
                self.pushVC(calendarVc)
            } else if indexPath.row == 5 {
                let codeVc = XJCodeViewController()
                self.pushVC(codeVc)
            }
        } else if indexPath.section == 4 {
            if indexPath.row == 0 {
                let tableVc = XJTestTableViewController()
                self.pushVC(tableVc)
            } else if indexPath.row == 1 {
                let scrollVc = XJBgScrollViewController()
                self.pushVC(scrollVc)
            }
        } else if indexPath.section == 5 {
            if indexPath.row == 0 {
                let reqVc = XJTestRequestViewController()
                self.pushVC(reqVc)
            } else if indexPath.row == 1 {
                let landspaceVc = XJTestLandspaceController()
                self.presentVC(landspaceVc)
            }
        }
    }
}
