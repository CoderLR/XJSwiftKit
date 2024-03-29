//
//  XJWKWebViewController.swift
//  LeiFengHao
//
//  Created by xj on 2021/4/14.
//

import UIKit
import WebKit

class XJWKWebViewController: XJBaseViewController {
    
    /// webView
    lazy var webView: WKWebView = {
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
    fileprivate lazy var closebtn: UIButton = {
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
    var webUrl: String = ""
    /// 本地路径
    var pathUrl: String = ""
    
    /// 是否用html的title设置导航栏title
    var isDisplayWebTitle: Bool = true
    
    ///交互监听数组
    fileprivate var funcNames: [String] = []
    
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
    
    /// 初始化-远程url
    @objc convenience init(webUrl: String, isPushed: Bool = true) {
        self.init(nibName: nil, bundle: nil)
        self.webUrl = webUrl
        self.isPushed = isPushed
    }
    
    /// 初始化-本地url
    @objc convenience init(pathUrl: String, isPushed: Bool = true) {
        self.init(nibName: nil, bundle: nil)
        self.pathUrl = pathUrl
        self.isPushed = isPushed
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Color_FFFFFF_151515
  
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: leftbtn),
                                                  UIBarButtonItem(customView: closebtn)]
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: rightbtn)]
        
        /// 清缓存
        clearCache()
        
        // 初始化控制器没有指定url，交由子类去实现
        if webUrl.count <= 0 { setUpWebUrl() }
        if pathUrl.count <= 0 { setUpPathUrl() }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.view.addSubview(self.webView)
            self.webView.snp.makeConstraints({ (make) in
                make.left.right.top.equalToSuperview()
                make.bottom.equalToSuperview()
            })
            self.view.addSubview(self.progressView)
            
            /// 导航栏
            self.closebtn.isHidden = true

            /// 添加监听
            self.addObserver()
    
            /// 添加下拉刷新
            self.addRefreshHeader()
            
            /// 加载地址-远端
            if self.webUrl.count > 0 { self.loadWebUrl() }
            /// 加载地址-本地
            if self.pathUrl.count > 0 { self.loadPathUrl() }
            
        }
    }
    
    /// 如果初始化控制器没有指定url，子类重写该方法
    func setUpWebUrl() {
        // self.webUrl = "http://www.baidu.com"
    }
    
    /// 如果初始化控制器没有指定url，子类重写该方法
    func setUpPathUrl() {
        // self.pathUrl = ""
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
        
        if funcNames.count <= 0 { return }
        for funcName in funcNames {
            webView.configuration.userContentController.removeScriptMessageHandler(forName: funcName)
        }
    }
}

// MARK: - WebView
extension XJWKWebViewController {
    
    /// 加载webview-远端
    func loadWebUrl() {
        guard let urlStr: String = NSString.init(string: webUrl).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else {
            print("log: webview urlStr is null"); return
        }
        guard let webUrl = URL(string: urlStr) else {
            print("log: webview url is null"); return
        }
        webView.load(URLRequest(url: webUrl))
    }
    
    /// 加载webview-本地
    func loadPathUrl() {
        let localUrl = URL(fileURLWithPath: self.pathUrl)
        webView.load(URLRequest(url: localUrl))
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
        
        /// 添加交互监听，用户释放清理
        if !funcNames.contains(funcName) {
            self.funcNames.append(funcName)
        }
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
            if isDisplayWebTitle {
                self.title = self.webView.title
            }
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
        if self.webUrl.count > 0 { self.loadWebUrl() }
        if self.pathUrl.count > 0 { self.loadPathUrl() }
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
        let action = UIAlertAction(title: "确定", style: .default) { (action) in
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
