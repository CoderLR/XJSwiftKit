//
//  XJBaseViewController.swift
//  XJSwiftKit
//
//  Created by Mr.Yang on 2021/4/14.
//

import UIKit
import Photos
import ZLPhotoBrowser

// MARK: - App运行状态
public enum XJAppRunStatus {
    case Active
    case inActive
    case background
    case foreground
}

// MARK: - 屏幕旋转方向
public enum XJScreenOrientation {
    case portrait
    case landscape
    case allButUpsideDown
}

class XJBaseViewController: UIViewController {

    /// 当前网络状态
    var netStatus: XJNetStatus = .UnReachable
    
    /// 上下拉刷新
    var refreshScrollView: UIScrollView?
    
    /// 断网显示
    lazy var disconnectView: XJNetDisconnectView = {
        let disconnect = XJNetDisconnectView(frame: self.view.bounds)
        disconnect.isHidden = true
        return disconnect
    }()
    
    /// 空白页面显示
    lazy var emptyDataView: XJEmptyDataView = {
        let empty = XJEmptyDataView(frame: self.view.bounds,
                                         imgName: "icon_empty_data",
                                         text: "暂时没有数据~")
        empty.isHidden = true
        return empty
    }()
    
    /// 选择相册
    @objc public var selectPhotoBlock: ( ([UIImage], [PHAsset], Bool) -> Void )?
    
    /// 拍摄回调
    @objc public var takePhotoBlock: ( (UIImage?, URL?) -> Void )?
    
    /// 设备方向
    @objc public var deviceOrientationBlock: ((UIDeviceOrientation) -> Void)?
    
    /// App是否活跃
    public var appRunStatusBlock: ((XJAppRunStatus) -> Void)?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 隐藏指示器
        self.dismissHUD()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // 默认背景色
        self.view.backgroundColor = Color_FFFFFF_151515
    
        // 返回
        self.setupBackItem()
        
        // 断网View
        self.view.addSubview(disconnectView)
        
        // 空白视图
        self.view.addSubview(emptyDataView)
        
        // 监听网络状态
        RL.netStatusBlock = {[weak self] (status: XJNetStatus) in
            guard let self = self else { return }
            self.netStatus = status
            self.netWorkChange(status)
        }
    }
    
    /// 设置返回按钮
    fileprivate func setupBackItem() {
        if self.navigationController?.children.count ?? 0 <= 1 { return }
        let btnLeft = UIButton(type: .custom)
        btnLeft.setImage(KNavBackImage, for: .normal)
        btnLeft.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        btnLeft.addTarget(self, action: #selector(backBtnClick(_:)), for: .touchUpInside)
        let backItem = UIBarButtonItem(customView: btnLeft)
        self.navigationItem.leftBarButtonItem = backItem
    }
    
    deinit {
        print("\(self.classForCoder) -- dealloc")
    }
}

// MARK: - Back
extension XJBaseViewController {
    // 返回
    @objc func backBtnClick(_ button: UIButton) {
        /// 横屏下要先进行转换竖屏操作
        if UIApplication.shared.statusBarOrientation != .portrait { self.rotatePortraitOrientation() }
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Observers
extension XJBaseViewController {
    // 监听系统通知
    func addNotify() {
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange(notify:)), name: UIDevice.orientationDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(becomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(resignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(enterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(enterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    // 移除系统通知
    func removeNotify() {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 监听屏幕方向
    @objc fileprivate func orientationDidChange(notify: Notification) {
        guard let device = notify.object as? UIDevice else { return }
        print("notify = \(device.orientation.rawValue)")
        if let deviceOrientationBlock = self.deviceOrientationBlock {
            deviceOrientationBlock(device.orientation)
        }
    }
    
    /// 监听App变活跃
    @objc fileprivate func becomeActive() {
        if let appRunStatusBlock = self.appRunStatusBlock {
            appRunStatusBlock(.Active)
        }
    }
    
    /// 监听App不活跃
    @objc fileprivate func resignActive() {
        if let appRunStatusBlock = self.appRunStatusBlock {
            appRunStatusBlock(.inActive)
        }
    }
    
    /// 监听App进入前台
    @objc fileprivate func enterForeground() {
        if let appRunStatusBlock = self.appRunStatusBlock {
            appRunStatusBlock(.foreground)
        }
    }
    
    /// 监听App进入后台
    @objc fileprivate func enterBackground() {
        if let appRunStatusBlock = self.appRunStatusBlock {
            appRunStatusBlock(.background)
        }
    }
}

// MARK: - Transition
extension XJBaseViewController {
    
    /// 系统默认push控制器
    func pushVC(_ viewController: UIViewController, animated: Bool = true) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    /// 系统默认present控制器
    func presentVC(_ viewController: UIViewController, animated: Bool = true) {
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: animated, completion: nil)
    }
    
    /// push转场动画
    /// - Parameters:
    ///   - viewController: 跳转控制器
    ///   - animationType: 转场动画类型
    func pushVC(_ viewController: UIViewController, animationType: WXSTransitionAnimationType) {
        //self.navigationController?.wxs_pushViewController(viewController, animationType: animationType)
        
        self.navigationController?.wxs_pushViewController(viewController, makeTransition: { (transition) in
            transition?.animationType = animationType
            transition?.backGestureEnable = false
            transition?.autoShowAndHideNavBar = false
        })
    }
    
    /// present转场动画
    /// - Parameters:
    ///   - viewController: 跳转控制器
    ///   - animationType: 转场动画类型
    func presentVC(_ viewController: UIViewController, animationType: WXSTransitionAnimationType) {
        //self.wxs_present(viewController, animationType: animationType) {}
        self.wxs_present(viewController) { (transition) in
            transition?.animationType = animationType
            transition?.backGestureEnable = false
            transition?.autoShowAndHideNavBar = false
        } completion: { }
    }
    
    /// pop控制器
    func popVC(animated: Bool = true) {
        /// 横屏下要先进行转换竖屏操作
        if UIApplication.shared.statusBarOrientation != .portrait { self.rotatePortraitOrientation() }
        self.navigationController?.popViewController(animated: animated)
    }
    
    /// dismiss控制器
    func dismissVC(animated: Bool = true) {
        /// 横屏下要先进行转换竖屏操作
        if UIApplication.shared.statusBarOrientation != .portrait { self.rotatePortraitOrientation() }
        self.dismiss(animated: animated, completion: nil)
    }
}

// MARK: - Refresh
extension XJBaseViewController {
    
    /// 下拉刷新
    func setRefreshHeader(_ scrollView: UIScrollView, ignoredContentInsetTop: CGFloat = 0, refreshBlock: (() -> ())?) {
        self.refreshScrollView = scrollView
        let refreshHeader = YSRefreshHeader.init {
            if let refreshBlock = refreshBlock { refreshBlock() }
        }
        refreshHeader.lastUpdatedTimeLabel?.isHidden = true
        refreshHeader.stateLabel?.textColor = Color_999999_999999
        refreshHeader.ignoredScrollViewContentInsetTop = ignoredContentInsetTop
        scrollView.mj_header = refreshHeader
    }
    
    /// 下拉刷新完成
    func endRefreshHeader() {
        self.refreshScrollView?.mj_header?.endRefreshing()
    }
    
    /// 上拉刷新
    func setRefreshFooter(_ scrollView: UIScrollView, refreshBlock: (() -> ())?) {
        self.refreshScrollView = scrollView
        let refreshFooter = MJRefreshBackNormalFooter.init {
            if let refreshBlock = refreshBlock { refreshBlock() }
        }
        scrollView.mj_footer = refreshFooter
    }
    
    /// 上拉刷新完成
    func endRefreshFooter() {
        self.refreshScrollView?.mj_footer?.endRefreshing()
    }
    
    /// 上拉刷新完成没有更多数据
    func endRefreshFooterNoMoreData() {
        self.refreshScrollView?.mj_footer?.endRefreshingWithNoMoreData()
    }
}

// MARK: - NetWork
extension XJBaseViewController {
    
    func showDisconnectView(_ isHidden: Bool) {
        disconnectView.isHidden = isHidden
        if isHidden == false { self.view.bringSubviewToFront(disconnectView) }
    }
    
    fileprivate func netWorkChange(_ status: XJNetStatus) {
        if status == .UnReachable {
            self.showDisconnectView(false)
            print("网络已断开连接")
        } else {
            self.showDisconnectView(true)
        }
    }
}

// MARK: - HUD
extension XJBaseViewController {
    
    /// 显示指示器
    /// - Parameter text: 显示文字
    func showHUD(_ text: String = "") {
        if Thread.current != Thread.main {
            DispatchQueue.main.async {
                YSActivityIndicatorView.showHUD(self.view, text: text)
                return;
            }
        }
        YSActivityIndicatorView.showHUD(self.view, text: text)
    }
    
    /// 隐藏指示器
    func dismissHUD() {
        if Thread.current != Thread.main {
            DispatchQueue.main.async {
                YSActivityIndicatorView.dismissHUD(self.view)
                return;
            }
        }
        YSActivityIndicatorView.dismissHUD(self.view)
    }
    
    /// 显示文字
    /// - Parameter text: 显示文字
    func showText(_ text: String) {
        if Thread.current != Thread.main {
            DispatchQueue.main.async {
                MBProgressHUD.showText(text: text)
                return;
            }
        }
        MBProgressHUD.showText(text: text)
    }
    
    /// 显示成功
    /// - Parameter text: 显示文字
    func showSuccess(_ text: String = "") {
        if Thread.current != Thread.main {
            DispatchQueue.main.async {
                MBProgressHUD.showSuccess(text: text)
                return;
            }
        }
        MBProgressHUD.showSuccess(text: text)
    }
    
    /// 显示失败
    /// - Parameter text: 显示文字
    func showFail(_ text: String = "") {
        if Thread.current != Thread.main {
            DispatchQueue.main.async {
                MBProgressHUD.showFail(text: text)
                return;
            }
        }
    }
}

// MARK: - emptyData
extension XJBaseViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        self.emptyDataView.isHidden = false
        return self.emptyDataView
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 0
    }
    
    /// 显示空白视图 - 默认隐藏
    /// - Parameter isHidden: 是否隐藏
    func showEmptyDataView(_ isHidden: Bool) {
        emptyDataView.isHidden = isHidden
        if isHidden == false { self.view.bringSubviewToFront(emptyDataView) }
    }
}

// MARK: - Rotate Screen
extension XJBaseViewController {
    
    /*
     0.判断当前屏幕方向
     UIApplication.shared.statusBarOrientation，不建议使用UIDevice.current.orientation
     1.从竖屏跳转横屏
     preferredInterfaceOrientationForPresentation = .landscapeRight or .landscapeLeft
     2.控制器内执行旋转
     shouldAutorotate = true
     supportedInterfaceOrientations = .allButUpsideDown or .all
     */
    
    /// 旋转到横屏
    func rotateLandscapeOrientation() {
        print("1---Landscape---click----\(UIApplication.shared.statusBarOrientation.rawValue)")
        if UIApplication.shared.statusBarOrientation != .portrait { return }
        print("1---rotateLandscapeOrientation")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.orientation = .landscape
        appDelegate.application(UIApplication.shared, supportedInterfaceOrientationsFor: view.window)
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
    
    /// 旋转到竖屏
    func rotatePortraitOrientation() {
        print("2---Portrait---click----\(UIApplication.shared.statusBarOrientation.rawValue)")
        if UIApplication.shared.statusBarOrientation == .portrait { return }
        print("2---rotatePortraitOrientation")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.orientation = .portrait
        appDelegate.application(UIApplication.shared, supportedInterfaceOrientationsFor: view.window)
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
}

// MARK: - Photo And Camera
extension XJBaseViewController {
    
    /// 选择相册图片
    func showImagePicker() {
        let config = ZLPhotoConfiguration.default()

        // You can first determine whether the asset is allowed to be selected.
        config.canSelectAsset = { (asset) -> Bool in
            return true
        }
        
        config.noAuthorityCallback = { (type) in
            switch type {
            case .library:
                debugPrint("No library authority")
            case .camera:
                debugPrint("No camera authority")
            case .microphone:
                debugPrint("No microphone authority")
            }
        }
        
        let ac = ZLPhotoPreviewSheet(selectedAssets: [])
        ac.selectImageBlock = { [weak self] (images, assets, isOriginal) in
            guard let self = self else { return }
            if let selectPhotoBlock = self.selectPhotoBlock {
                selectPhotoBlock(images, assets, isOriginal)
            }
            debugPrint("\(images)   \(assets)   \(isOriginal)")
        }
        ac.cancelBlock = {
            debugPrint("cancel select")
        }
        ac.selectImageRequestErrorBlock = { (errorAssets, errorIndexs) in
            debugPrint("fetch error assets: \(errorAssets), error indexs: \(errorIndexs)")
        }
        ac.showPhotoLibrary(sender: self)
    }
    
    /// 浏览本地图片和网络图片
    @objc func previewLocalAndNetImage(_ datas: [Any], index: Int = 0) {
        if datas.count == 0 { return }
        let vc = ZLImagePreviewController(datas: datas, index: index, showSelectBtn: false) { (url) -> ZLURLType in
            return .image
        } urlImageLoader: { (url, imageView, progress, loadFinish) in
            imageView.kf.setImage(with: url) { (receivedSize, totalSize) in
                let percentage = (CGFloat(receivedSize) / CGFloat(totalSize))
                debugPrint("\(percentage)")
                progress(percentage)
            } completionHandler: { (_) in
                loadFinish()
            }
        }
        
        vc.doneBlock = { (datas) in
            debugPrint(datas)
        }
        
        vc.modalPresentationStyle = .fullScreen
        self.showDetailViewController(vc, sender: nil)
    }
    
    /// 相机拍照
    @objc func showCamera() {
        let camera = ZLCustomCamera()
        camera.modalPresentationStyle = .fullScreen
        camera.takeDoneBlock = { [weak self] (image, videoUrl) in
            guard let self = self else { return }
            if let takePhotoBlock = self.takePhotoBlock {
                takePhotoBlock(image, videoUrl)
            }
        }
        self.showDetailViewController(camera, sender: nil)
    }
}
