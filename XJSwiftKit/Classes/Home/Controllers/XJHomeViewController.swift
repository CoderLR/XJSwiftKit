//
//  XJHomeViewController.swift
//  ShiJianYun
//
//  Created by Mr.Yang on 2021/4/14.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import ZLPhotoBrowser
import CocoaLumberjack

class XJHomeViewController: XJBaseViewController {
    
    let disposeBag = DisposeBag()
    var tableView: UITableView!
    let btnLeft = UIButton(type: .custom)
    
    // 类型
    var type: Int = 0
    
    // 配置抽屉
    var headerTitleColor: UIColor = .gray
    var separatorColor: UIColor = .lightGray
    var tableViewBgColor: UIColor = Color_F0F0F0_F0F0F0
    var cellColor: UIColor = .white
    var cellTitleColor: UIColor = .black

    // 数据源
    fileprivate var titles: [[String: Any]] = [
        ["title": "控制器",
         "data": [
                    ["网页":     "XJTestWebViewController"],
                    ["分段选择":  "XJTestSegmentController"],
                    ["搜索":     "XJTestSearchViewController"],
                    ["交互":     "XJTestInteractiveViewController"]
                 ]
        ],
                                            
        ["title": "工具",
         "data": [
                    ["沙盒":     "YSSandboxViewController"],
                    ["Ping网络": "XJPingViewController"],
                    ["日志":     "XJTestLogViewController"]
                 ]
        ],
        
        ["title": "媒体",
         "data": [
                    ["扫码":     "YSQRCodeViewController"],
                    ["选择相册":  "XJPhotosViewController"],
                    ["相机":     "XJCamera"]
                 ]
        ],
        
        ["title": "控件",
         "data": [
                    ["轮播图":    "XJTestBannerViewController"],
                    ["选择器":    "XJDatePickerViewController"],
                    ["文本输入":   "XJTestTextViewViewController"],
                    ["视频播放器": "XJTestVideoPlayerController"],
                    ["日历控件":   "XJTest2CalendarViewController"],
                    ["验证码框":   "XJCodeViewController"],
                    ["表情框":    "XJTestInputBarViewController"]
                 ]
        ],
        
        ["title": "背景",
         "data": [
                    ["空数据显示": "XJTestTableViewController"],
                    ["背景滚动":   "XJBgScrollViewController"]
                 ]
        ],
        
        ["title": "其他",
         "data": [
                    ["网络请求": "XJTestRequestViewController"],
                    ["横竖屏":   "XJTestLandspaceController"]
                 ]
        ]
    ]
    
    
    /// 初始化类型
    /// - Parameter type: 0 left 1 home
    convenience init(type: Int) {
        self.init()
        self.type = type
        
        if type == 1 {
            self.tableViewBgColor = Color_F0F0F0_F0F0F0
            self.separatorColor = .lightGray
            self.headerTitleColor = .gray
            self.cellColor = .white
            self.cellTitleColor = .black
        } else {
            self.tableViewBgColor = .black
            self.separatorColor = .white
            self.headerTitleColor = Color_System
            self.cellColor = .black
            self.cellTitleColor = .white
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /// 不要直接使用title，会导致tabbar顺序错乱
        self.navigationItem.title = "首页"
        
        if type == 0 {
            self.view.backgroundColor = UIColor.black
        }
        
        setupLeftItem()
        
        setupUI()
        
        observer()
    }
    
    fileprivate func setupUI() {
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.backgroundColor = self.tableViewBgColor
        // 适配ios11
        if #available(iOS 11.0, *) {
            
            tableView.estimatedSectionHeaderHeight = 0
            tableView.estimatedSectionFooterHeight = 0
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.tableFooterView = UIView()
        tableView.separatorColor = self.separatorColor
        self.view.addSubview(tableView)
        
        if type == 1 {
            tableView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        } else {
            tableView.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview().offset(KStatusBarH)
                make.bottom.equalToSuperview().offset(-KHomeBarH)
            }
        }
        
        if type == 0 { return }
        weak var weakSelf = self
        self.setRefreshHeader(tableView) {
            let vc = XJTestTransitionController()
            weakSelf?.presentVC(vc, animationType: .flipFromTop)
            weakSelf?.endRefreshHeader()
        }
    }
    
    /// 设置返回按钮
    fileprivate func setupLeftItem() {
        btnLeft.setImage(KNavOpenDrawerImage, for: .normal)
        btnLeft.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        btnLeft.addTarget(self, action: #selector(openBtnClick(_:)), for: .touchUpInside)
        btnLeft.tag = 0
        let backItem = UIBarButtonItem(customView: btnLeft)
        self.navigationItem.leftBarButtonItem = backItem
    }
    
    @objc fileprivate func openBtnClick(_ btn: UIButton) {
        if btn.tag == 0 {
            self.mm_drawerController.open(.left, animated: true, completion: nil)
        } else {
            self.mm_drawerController.closeDrawer(animated: true, completion: nil)
        }
    }
    
    override func pushVC(_ viewController: UIViewController, animated: Bool = true) {
        
        // 首页跳转
        if type == 1 {
            self.navigationController?.pushViewController(viewController, animated: animated)
            return
        }
        
        // 抽屉跳转
        self.mm_drawerController.closeDrawer(animated: true) { (_) in }
        guard let tabbarVc = self.mm_drawerController.centerViewController as? XJTabBarViewController else { return }
        let naVc = tabbarVc.selectedViewController as? XJNavigationViewController
        naVc?.pushViewController(viewController, animated: false)
        //self.mm_drawerController.present(viewController, animated: true)
    }
    
    /// 监听抽屉打开和关闭
    fileprivate func observer() {
        self.mm_drawerController.rx.observeWeakly(MMDrawerSide.self, "openSide").subscribe(onNext: {[weak self] (slider) in
            guard let self = self else { return }
            self.btnLeft.tag = slider?.rawValue ?? 0
            if self.btnLeft.tag == 0 {
                self.btnLeft.setImage(KNavOpenDrawerImage, for: .normal)
                self.statusBarstyle = .default
                
            } else {
                self.btnLeft.setImage(KNavCloseDrawerImage, for: .normal)
                self.statusBarstyle = .lightContent
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
    }
}

extension XJHomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count
    }
    
    // 返回每组个数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionData = titles[section]["data"] as? [[String: String]] else { return 0 }
        return sectionData.count
    }
    
    // 返回cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "UITableViewCell"
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
        cell.backgroundColor = self.cellColor
        cell.textLabel?.textColor = self.cellTitleColor
        let sectionData = titles[indexPath.section]["data"] as? [[String : String]]
        let dict = sectionData?[indexPath.row]
        cell.textLabel?.text = dict?.allKeys().first
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // 返回cell的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // 修复header子控件属性
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header =  view as? UITableViewHeaderFooterView
        header?.textLabel?.textColor = self.headerTitleColor
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
        
        let sectionData = titles[indexPath.section]["data"] as? [[String : String]]
        let dict = sectionData?[indexPath.row]
        guard let clsName = dict?.allValues().first else { return }
        
        if clsName == "XJCamera" {self.showCamera(); return}
        
        // 获取模块名
        guard let moduleName = Bundle.main.infoDictionary?["CFBundleName"] as? String else { return }
        // 生成类
        let cls: AnyClass? = NSClassFromString("\(moduleName).\(clsName)")
        // 如果不是 UIViewController类型,则return
        guard let clsType = cls as? UIViewController.Type else {  return }
        // 创建对象
        self.pushVC(clsType.init())
    }
}
