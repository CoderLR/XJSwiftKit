//
//  AppDelegate.swift
//  ShiJianYun
//
//  Created by Mr.Yang on 2021/4/14.
//

import UIKit
import IQKeyboardManagerSwift
import CocoaLumberjack
import CoreTelephony

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var orientation: XJScreenOrientation = .portrait
    var mmVc: MMDrawerController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = initRootVC()
        window?.makeKeyAndVisible()
        
        initApp()

        return true
    }

    /// App初始化
    func initApp() {
        
        /// 沙盒路径
        print(NSHomeDirectory())
        
        configTableViewSectionHeader()
        
        /// 键盘
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "完成"
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        //IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.toolbarTintColor = Color_System
        
        /// 日志
        DDLog.add(DDOSLogger.sharedInstance)
        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.rollingFrequency = 60 * 60 * 24 // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
        
        /// 检测网络是否可用
        checkNetWork()
        
        /// 网络监听
        RL.listen()
        
        /// DB创建
        //DB.createTable(USER_TABLE_NAME)
        DB.createTable(SEARCH_TABLE_NAME)
    }
    
    /// 适配iOS15的sectionHeader
    func configTableViewSectionHeader() {
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
    }
    
    /// App初始化根控制器
    func initRootVC() -> UIViewController {
        
        let centerVc = XJTabBarViewController()
        let leftVc = XJHomeViewController(type: 0)

        mmVc = MMDrawerController(center: centerVc, leftDrawerViewController: leftVc)
        mmVc?.showsShadow = true
        mmVc?.maximumLeftDrawerWidth = KScreenW * 0.6
        mmVc?.openDrawerGestureModeMask = MMOpenDrawerGestureMode(rawValue: 0)
        mmVc?.closeDrawerGestureModeMask = .all
        mmVc?.setDrawerVisualStateBlock(MMDrawerVisualState.parallaxVisualStateBlock(withParallaxFactor: 2.0))
        return mmVc!
        //return centerVc
    }
    
    /// 在这里写支持的旋转方向，为了防止横屏方向，应用启动时候界面变为横屏模式
    @discardableResult
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        print("3---supportedInterfaceOrientationsFor----\(orientation)")
        if orientation == .portrait {
            return .portrait
        } else if orientation == .landscape {
            return .landscape
        } else if orientation == .allButUpsideDown {
            return .allButUpsideDown
        }
        return .portrait
    }
    
    /// 检查网络权限-触发网络权限弹窗
    func checkNetWork() {
        let cellulardata = CTCellularData()
        var isNoNetToNet: Bool = false
        cellulardata.cellularDataRestrictionDidUpdateNotifier = {(state) in
            switch state {
            case .notRestricted:
                print("start-notRestricted") // 不限制
                DispatchQueue.main.async {
                    self.perform(#selector(self.fetchProtocolVersionReq), with: nil, afterDelay: isNoNetToNet ? 1 : 0)
                }
                isNoNetToNet = false
                break
            case .restricted:
                //权限关闭的情况下 再次请求网络数据会弹出设置网络提示
                print("start-restricted") //限制
                self.perform(#selector(self.fetchProtocolVersionReq), on: .main, with: nil, waitUntilDone: true)
                isNoNetToNet = true
                break
            case .restrictedStateUnknown:
                print("restrictedStateUnknown")
                break
            default:
                break
            }
        }
    }
    
    /// 主线程执行
    @objc func fetchProtocolVersionReq() {
        print("----------------------")
    }
    
    /// 处理小组件点击事件
    @objc func widgetClickAction(_ schemeUrl: String) {
        
        guard let tabbarVc = self.mmVc?.centerViewController as? XJTabBarViewController else { return }
        
        if schemeUrl.contains("home") {
            tabbarVc.selectedIndex = 0
        } else if schemeUrl.contains("heart") {
            let heartVc = XJHeartViewController()
            tabbarVc.xj_presentViewController(viewController: heartVc, animationType: .spreadFromBottom, completion: nil)
        } else if schemeUrl.contains("mine") {
            tabbarVc.selectedIndex = 1
        }
    }
    
    /// AppDelegate
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("交互 = \(url)")
        self.perform(#selector(self.widgetClickAction(_:)), with: url.absoluteString, afterDelay: 0.2)
        return true
    }
    
    /// App注销活跃
    func applicationWillResignActive(_ application: UIApplication) {
        print(#function)
    }
    
    /// App变得活跃
    func applicationDidBecomeActive(_ application: UIApplication) {
        print(#function)
    }
    
    /// App进入后台
    func applicationDidEnterBackground(_ application: UIApplication) {
        print(#function)
    }

    /// App将进入前台
    func applicationWillEnterForeground(_ application: UIApplication) {
        print(#function)
    }
  
    /// App将要终止
    func applicationWillTerminate(_ application: UIApplication) {
        print(#function)
    }
    
    /// App内存警告
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        print(#function)
    }
}

