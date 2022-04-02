//
//  XJWKWebViewController.swift
//  ShiJianYun
//
//  Created by Mr.Yang on 2021/4/14.
//

import UIKit
import WebKit

class XJWKWebViewController: XJBaseViewController {
    
    /// webView
    fileprivate lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.selectionGranularity = WKSelectionGranularity(rawValue: 1)!
        let webView = WKWebView(frame: CGRect.zero, configuration: config)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.scrollView.showsVerticalScrollIndicator = false
        return webView
    }()
    
    /// 进度条
    fileprivate lazy var progressView: UIView = {
        let progress = UIView(frame: CGRect(x: 0, y: 0, width: KScreenW, height: 2.0))
        progress.backgroundColor = Color_System
        return progress
    }()
    
    /// 返回
    fileprivate lazy var leftbtn: UIButton = {
        let button = UIButton.xj.create(bgColor: UIColor.clear, imageName: "icon_nav_back")
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        return button
    }()
    
    /// 关闭
    fileprivate var closebtn: UIButton = {
        let button = UIButton.xj.create(bgColor: UIColor.clear, imageName: "icon_nav_close")
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return button
    }()
 
    /// 分享
    fileprivate lazy var rightbtn: UIButton = {
        let button = UIButton.xj.create(bgColor: UIColor.clear, imageName: "icon_nav_share")
        button.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        return button
    }()
    
    /// url
    fileprivate var webUrl: String = ""
    
    /// 控制器弹出方式
    fileprivate var isPushed: Bool = true
    
    /// 控制进度条动画
    fileprivate let barAnimationDuration: CGFloat = 0.27
    fileprivate let fadeAnimationDuration: CGFloat = 0.27
    fileprivate let fadeOutDuration: CGFloat = 0.1
    
    /// 接收JS的调用
    fileprivate var didReceiveJSCallMessage: ((String, Any) -> ())?
    
    /// 分享
    var shareActionBlock: (() -> Void)?
    
    /// 初始化
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
        
        self.view.backgroundColor = Color_FFFFFF_151515
        
        /// webview
        self.view.addSubview(webView)
        webView.snp.makeConstraints({ (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview()
        })
        
        /// 进度条
        self.view.addSubview(progressView)
        
        /// 导航栏
        closebtn.isHidden = !self.webView.canGoBack
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: leftbtn),
                                                  UIBarButtonItem(customView: closebtn)]
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: rightbtn)]
        
        /// 清缓存
        clearCache()
        
        /// 加载地址
        loadWebUrl()
        
        /// 添加监听
        addObserver()
        
        /// 添加下拉刷新
        addRefreshHeader()
    }
    
    deinit {
        removeObserver()
        webView.uiDelegate = nil
        webView.navigationDelegate = nil
    }
    
    /// 清除缓存
    private func clearCache() {
        XJCacheTool.clearWebcache()
    }
    
    /// KVO监听
    private func addObserver() {
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
    }
    
    /// 移除监听
    private func removeObserver() {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.removeObserver(self, forKeyPath: "title")
    }
}

// MARK: - WebView
extension XJWKWebViewController {
    
    /// 加载webview
    func loadWebUrl() {
        let encode_str:String = NSString.init(string: webUrl).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        if webUrl.contains(XJApiUrl ){
            let localUrl = encode_str + "&lang=" + (XJLocalizedTool.localeIsChinese() ? "zh-CN" : "en-US")
            webView.load(URLRequest(url: URL(string: localUrl)!))
        }else{
            webView.load(URLRequest(url: URL(string: encode_str)!))
        }
    }
    
    /// 下拉刷新
    private func addRefreshHeader() {
        weak var weakSelf = self
        self.setRefreshHeader(webView.scrollView) {
            weakSelf?.reloadWebView()
        }
    }
    
    /// 刷新webview
    func reloadWebView() {
        webView.reload()
    }
    
    // MARK: - 交互

    /// JS调用原生
    /// - Parameter：
    ///   - funcName: 原生方法名
    ///   - callBack: JS传来的参数
    /// JS调用方式：funcName
    func jsCallNative(_ funcName: String, callBack: ((String, Any) -> ())?) {
        /*
         </script>
         　　var message = {
         　　　　'method': 'hello',
         　　　　'param1': 'dada',
         　　　};
         　　window.webkit.messageHandlers.funcName.postMessage(message);
         　　<script>
        */
        self.didReceiveJSCallMessage = callBack
        webView.configuration.userContentController.add(self, name: funcName)
    }
    
    /// 原生调用JS
    /// - Parameters:
    ///   - funcName: JS方法名
    ///   - params: 传给JS的参数
    func callJSFunc(_ funcName: String, params: [String: String]) {
        /*
         　　</script>
         　　　function funcName(data) {
         　　　　var obj = eval(data);
         　　　　alert(obj.name);
         　　　}
         　　<script>
         */
        
        var paramsStr = "{"
        for elem in params {
            let key = elem.key
            let value = elem.value
            paramsStr.append(String(format: "'%@': '%@'", key, value))
            paramsStr.append(", ")
        }
        var paramsStr2 = paramsStr.dropLast(2)
        paramsStr2.append("}")
        
        let callJSStr = funcName + "(" + paramsStr2 + ")"
        
        /// 调用jS方法
        webView.evaluateJavaScript(callJSStr) { (obj, error) in
            
        }
    }
}

// MARK: - Action
extension XJWKWebViewController {
    
    /// 关闭
    @objc func closeAction() {
        
        if webView.isLoading { webView.stopLoading() }
        
        if isPushed {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    /// 返回
    @objc func backAction() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            closeAction()
        }
        // 判断是否显示关闭按钮
        closebtn.isHidden = !webView.canGoBack
    }
    
    /// 分享
    @objc func shareAction() {
        if let shareActionBlock = shareActionBlock {
            shareActionBlock()
        }
    }
    
    /// H5返回按钮
    func hideH5BackBtn(_ backMeg: String = "close"){
        let str = "document.getElementsByClassName(\"\(backMeg)\")[0].style.display='none'"
        webView.evaluateJavaScript(str) {[weak self] (any, error) in
            guard let self = self else { return }
            self.popVC()
        }
    }
    
    /// KVO监听加载进度
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            setProgress(progress: CGFloat(webView.estimatedProgress), animated: true)
        } else if (keyPath == "title") {
            self.title = self.webView.title
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    /// 进度条动画
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
    
    /// H5交互信息
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("message.name",message.name)
        print("message.body", message.body)
        if let didReceiveJSCallMessage = didReceiveJSCallMessage {
            didReceiveJSCallMessage(message.name, message.body)
        }
    }
    
    /// 进程终止
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        self.loadWebUrl()
    }
    
    /// 在发送请求之前，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("webview request: \(navigationAction.request.url?.absoluteString ?? "")")
        decisionHandler(.allow)
    }
    
    /// 在收到响应后，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("webview response: \(navigationResponse.response.url?.absoluteString ?? "")")
        decisionHandler(.allow)
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
    
    /// 警告框 alert
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        print("runJavaScriptAlertPanelWithMessage:" ,message)
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { (action) in
            completionHandler()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    /// 确认框
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        print("runJavaScriptConfirmPanelWithMessage:",message)
        completionHandler(true)
    }
    
    /// 输入框
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        completionHandler(nil)
    }
}
