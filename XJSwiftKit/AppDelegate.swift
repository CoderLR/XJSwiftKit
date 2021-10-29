//
//  AppDelegate.swift
//  XJSwiftKit
//
//  Created by Mr.Yang on 2021/4/14.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var orientation: XJScreenOrientation = .portrait

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = XJTabBarViewController()
        window?.makeKeyAndVisible()
        
        initApp()

        return true
    }

    /// App初始化
    func initApp() {
        
        print(NSHomeDirectory())
        
        /// 键盘
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "完成"
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        //IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.toolbarTintColor = Color_System
        
        /// 网络监听
        RL.listen()
        
        /// DB创建
        //DB.createTable(USER_TABLE_NAME)
        DB.createTable(SEARCH_TABLE_NAME)
    }
    
    /// 在这里写支持的旋转方向，为了防止横屏方向，应用启动时候界面变为横屏模式
    @discardableResult
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        //print("3---supportedInterfaceOrientationsFor")
        if orientation == .portrait {
            return .portrait
        } else if orientation == .landscape {
            return .landscape
        } else if orientation == .allButUpsideDown {
            return .allButUpsideDown
        }
        return .portrait
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

