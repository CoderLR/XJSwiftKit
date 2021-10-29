//
//  XJWKWebViewController.swift
//  XJSwiftKit
//
//  Created by Mr.Yang on 2021/4/14.
//

import UIKit
import WebKit

class XJWKWebViewController: XJBaseViewController {
    
    var webView = WKWebView()
    var leftbtn = UIButton()
    var closebtn = UIButton()
    var rightbtn = UIButton()
    var webUrl: String = ""
    private var isPushed: Bool = true
    
    private lazy var progressView: UIView = {
        let progress = UIView(frame: CGRect(x: 0, y: 0, width: KScreenW, height: 2.0))
        progress.backgroundColor = Color_System
        return progress
    }()
    
    // 控制进度条动画
    private let barAnimationDuration: CGFloat = 0.27
    private let fadeAnimationDuration: CGFloat = 0.27
    private let fadeOutDuration: CGFloat = 0.1
    
    @objc convenience init(webUrl: String, isPushed: Bool = true) {
        self.init(nibName: nil, bundle: nil)
        self.webUrl = webUrl
        self.isPushed = isPushed
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.configuration.userContentController.add(self, name: "postlog")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "postlog")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.fd_interactivePopDisabled = true
        self.view.backgroundColor = Color_FFFFFF_151515
        
        setupWebview()
        setupNavBar()
        clearCache()
        loadWebUrl()
        addObserver()
        addRefreshHeader()
    }
    
    func setupNavBar() {
        
        leftbtn = UIButton.xj.create(bgColor: UIColor.clear, imageName: "icon_nav_back")
        leftbtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        closebtn = UIButton.xj.create(bgColor: UIColor.clear, imageName: "icon_nav_close")
        closebtn.isHidden = !webView.canGoBack
        closebtn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        self.view.addSubview(closebtn)
        
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: leftbtn),
                                                  UIBarButtonItem(customView: closebtn)]
        
        rightbtn = UIButton.xj.create(bgColor: UIColor.clear, imageName: "icon_nav_share")
        rightbtn.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: rightbtn)]
    }
    
    deinit {
        removeObserver()
        webView.uiDelegate = nil
        webView.navigationDelegate = nil
    }
    
    private func clearCache() {
        XJCacheTool.clearWebcache()
    }
    
    private func addObserver() {
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
    }
    
    private func removeObserver() {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.removeObserver(self, forKeyPath: "title")
    }
    
    func loadWebUrl() {
        let encode_str:String = NSString.init(string: webUrl).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        if webUrl.contains(XJApiUrl ){
            let localUrl = encode_str + "&lang=" + (XJLocalizedTool.localeIsChinese() ? "zh-CN" : "en-US")
            webView.load(URLRequest(url: URL(string: localUrl)!))
        }else{
            webView.load(URLRequest(url: URL(string: encode_str)!))
        }
    }
    
    private func addRefreshHeader() {
        weak var weakSelf = self
        self.setRefreshHeader(webView.scrollView) {
            weakSelf?.reloadWebView()
        }
    }
    
    func reloadWebView() {
        webView.reload()
    }
}

// MARK: - UI
extension XJWKWebViewController {
    
    func setupWebview() {
        // webView
        let config = WKWebViewConfiguration()
        config.selectionGranularity = WKSelectionGranularity(rawValue: 1)!
        webView = WKWebView(frame: CGRect.zero, configuration: config)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(webView)
        
        webView.snp.makeConstraints({ (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview()
        })
        
        self.view.addSubview(progressView)
    }
}

// MARK: - Action
extension XJWKWebViewController {
    
    @objc func closeAction() {
        
        if webView.isLoading { webView.stopLoading() }
        
        if isPushed {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @objc func backAction() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            closeAction()
        }
        // 判断是否显示关闭按钮
        closebtn.isHidden = !webView.canGoBack
    }
    
    @objc func shareAction() {
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            setProgress(progress: CGFloat(webView.estimatedProgress), animated: true)
        } else if (keyPath == "title") {
            self.title = self.webView.title
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func hideH5BackBtn(_ backMeg: String = "close"){
        let str = "document.getElementsByClassName(\"\(backMeg)\")[0].style.display='none'"
        webView.evaluateJavaScript(str) { (any, error) in }
    }
    
    // 进度条动画
    func setProgress(progress: CGFloat, animated: Bool) {
        let isGrowing = progress > 0.0
        UIView.animate(withDuration: (isGrowing && animated) ? TimeInterval(barAnimationDuration) : 0.0, delay: 0, options: .curveEaseInOut, animations: {
            
            var frame = self.progressView.frame
            frame.size.width = progress * self.view.size.width
            self.progressView.frame = frame
            
        }, completion: nil)
        
        if progress >= 1.0 {
            UIView.animate(withDuration: animated ? TimeInterval(fadeAnimationDuration) : 0.0, delay: TimeInterval(fadeOutDuration), options: .curveEaseInOut, animations: {
                self.progressView.alpha = 0.0
            }) { (completed) in
                var frame = self.progressView.frame
                frame.size.width = 0
                self.progressView.frame = frame
            }
        } else {
            UIView.animate(withDuration: animated ? TimeInterval(fadeAnimationDuration) : 0.0, delay: 0, options: .curveEaseInOut, animations: {
                self.progressView.alpha = 1.0
            }, completion: nil)
        }
    }
}

// MARK: WKNavigationDelegate
extension XJWKWebViewController: WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        self.loadWebUrl()
    }
    
    /// 开始加载
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("webView didStartProvisionalNavigation:")
        
    }
    
    /// 加载失败
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("webView didFailProvisionalNavigation:")
        self.endRefreshHeader()
    }
    
    /// 加载完成
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("webView didFinish:")
        self.endRefreshHeader()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("webView didFail:")
    }
    
    /// 显示H5的alert
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        print("runJavaScriptAlertPanelWithMessage:" ,message)
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { (action) in
            completionHandler()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    /// 显示H5的alert
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        print("runJavaScriptConfirmPanelWithMessage:",message)
        completionHandler(true)
    }
}
