//
//  XJHomeViewController.swift
//  XJSwiftKit
//
//  Created by Mr.Yang on 2021/4/14.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import ZLPhotoBrowser

class XJHomeViewController: XJBaseViewController {
    
    var tableView: UITableView!
    
    fileprivate var titles: [String] = ["WebView",
                                        "EmptyView",
                                        "ScanQR",
                                        "Banner",
                                        "Request",
                                        "DatePicker",
                                        "ShowMessage",
                                        "SegmentVc",
                                        "Photos",
                                        "Camera",
                                        "VideoPlayer",
                                        "Landspce",
                                        "searchVc",
                                        "PageCalendar",
                                        "SeriesCalendar"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "首页"
        
        setupUI()
        
        let a: String? = nil
        let b: String? = "haha"
        let c = a ?? b
    }
    
    func setupUI() {
        tableView = UITableView(frame: self.view.bounds, style: .plain)
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
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        weak var weakSelf = self
        self.setRefreshHeader(tableView) {
            let vc = XJTestTransitionController()
            weakSelf?.pushVC(vc, animationType: .sysPushFromBottom)
            weakSelf?.endRefreshHeader()
        }
    }
}

extension XJHomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // 返回每组个数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    // 返回cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "UITableViewCell"
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
        cell.textLabel?.text = titles[indexPath.row]
        return cell
    }
    
    // 返回cell的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // 点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let url = "https://www.cnblogs.com/yang-shuai/"
            let webVc = XJTestWebViewController(webUrl: url)
            self.pushVC(webVc)
        } else if indexPath.row == 1 {
            let tableVc = XJTestTableViewController()
            self.pushVC(tableVc)
        } else if indexPath.row == 2 {
            let qrVc = YSQRCodeViewController()
            self.pushVC(qrVc)
        } else if indexPath.row == 3 {
            let banner = XJTestBannerViewController()
            self.pushVC(banner)
        } else if indexPath.row == 4 {
            REQ.getRequest(XJUserApi.getUserDetail("8488"), BaseEmptyModel.self) { (model, dict) in
            }
        } else if indexPath.row == 5 {
            YSDatePickerView(mode: .date, date: "2021-10-10",selectDateBlock: { (date) in
                print("select:\(date)")
            }).show()
        } else if indexPath.row == 6 {
            self.showText("Show Some Message!")
        } else if indexPath.row == 7 {
            let sgVc = XJTestSegmentController()
            self.pushVC(sgVc)
        } else if indexPath.row == 8 {
            self.showImagePicker()
        } else if indexPath.row == 9 {
            self.showCamera()
        } else if indexPath.row == 10 {
            let playerVc = XJTestVideoPlayerController()
            self.pushVC(playerVc)
        } else if indexPath.row == 11 {
            let landspaceVc = XJTestLandspaceController()
            self.presentVC(landspaceVc)
        } else if indexPath.row == 12 {
            let searchVc = XJTestSearchViewController()
            self.pushVC(searchVc)
        } else if indexPath.row == 13 {
            let calendarVc = XJTestCalendarViewController()
            self.pushVC(calendarVc)
        } else if indexPath.row == 14 {
            let calendarVc = XJTestCalendarViewController2()
            self.pushVC(calendarVc)
        }
    }
}
