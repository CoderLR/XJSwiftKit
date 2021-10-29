/**********************************************************
 *                    _  ____          __   _             *
 *          _ __   __| |/ ___|  ___ __/ /__| |_           *
 *         | '_  \/ _  |\___ \ / _ \_   _|_   _|          *
 *         | | | | (_) | ___) | (_) || |   | |_           *
 *         |_| |_|\____)|____/ \___/ /_/   \___|          *
 *                                                        *
 **********************************************************
 * Copyright 2020, xroom.net.                             *
 * All rights, including trade secret rights, reserved.   *
 **********************************************************/

/**********************************************************
 * XJCentralLog
 * Request/Socket 日志
 **********************************************************/

import UIKit
import Alamofire
import HandyJSON

let logCount: Int = 100

class XJCentralLog: NSObject {
    
    static var shared: XJCentralLog = XJCentralLog()
    
    public var udpDatas: [[Date: String]] = [[Date: String]]() {
        didSet {
            if udpDatas.count > logCount {
                udpDatas.remove(at: 0)
            }
        }
    }
    
    public var logDatas: [[Date: String]] = [[Date: String]]() {
        didSet {
            if logDatas.count > logCount {
                logDatas.remove(at: 0)
            }
        }
    }
    
    public var requestData: [[Date: AFDataResponse<Any>]] = [[Date: AFDataResponse<Any>]]() {
        didSet {
            if requestData.count > logCount {
                requestData.remove(at: 0)
            }
        }
    }
    
}

class XJCentralLogViewController: XJBaseViewController {
    
    lazy var textView: UITextView = {[unowned self] in
        let textView = UITextView(frame: self.view.bounds)
        textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        textView.isEditable = false // 是否可编辑
        textView.isSelectable = true // 是否可选
        textView.dataDetectorTypes = .link //只有网址加链接
        return textView
        }()
    
    private var type = 1
    
    /// 自定义初始化
    /// - Parameter type: 1 中控  2 http
    convenience init(type: Int){
        self.init(nibName: nil , bundle: nil)
        self.type = type
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil , bundle: nibBundleOrNil )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(textView)
         
        if type == 1 {
            self.title = "中控日志"
            self.showLogData()
        } else if type == 2 {
            self.title = "网络日志"
            self.showRequestData()
        } else if type == 3 {
            self.title = "UDP日志"
            self.showUdpLogData()
        }
    }
    
    /// UDP监听日志
    private func showUdpLogData() {
        var text = ""
        DispatchQueue.global().async {[weak self] in
            for dict in XJCentralLog.shared.udpDatas.reversed() {
                for (date, tempStr) in dict {
                    text.append("\n")
                    text.append("🕒: \(self?.getTimeString(date: date) ?? "")")
                    text.append("\n")
                    text.append(tempStr)
                    text.append("\n")
                }
            }
            DispatchQueue.main.async {[weak self] in
                self?.textView.text = text
            }
        }
    }
    
    /// 中控
    private func showLogData() {
        var text = ""
        DispatchQueue.global().async {[weak self] in
            for dict in XJCentralLog.shared.logDatas.reversed() {
                for (date, tempStr) in dict {
                    text.append("\n")
                    text.append("🕒: \(self?.getTimeString(date: date) ?? "")")
                    text.append("\n")
                    text.append(tempStr)
                    text.append("\n")
                }
            }
            DispatchQueue.main.async {[weak self] in
                self?.textView.text = text
            }
        }
    }
    
    /// 网络请求
    private func showRequestData() {
        var text = ""
        DispatchQueue.global().async {[weak self] in
            for dict in XJCentralLog.shared.requestData.reversed() {
                for (date, response) in dict {
                    let url = response.request?.url?.absoluteString ?? ""
                    let httpMethod = response.request?.httpMethod ?? ""
                    let httpBody = response.request?.httpBody ?? Data()
                    let bodyStr = String(data: httpBody, encoding: String.Encoding.utf8) ?? ""
                    let resultValue: [String: Any]?
                    switch response.result {
                        //如果返回成功则赋值给临时变量 data
                        case let .success(data):
                            resultValue = data as? [String : Any]; break
                        //如果返回失败则赋值给临时变量 error
                        case let .failure(error):
                            resultValue = ["errcode": error.responseCode ?? 1000,
                                        "errmsg": error.errorDescription ?? ""] as [String : Any]
                            break
                    }
                    
                    let resultValueStr = self?.dicValueString(resultValue) ?? ""
                    
                    text.append("\n" + "🕒: \(self?.getTimeString(date: date) ?? "")" + "\n")
                    text.append("\(httpMethod): \(url)" + "\n")
                    if !bodyStr.isEmpty { text.append("BodyStr: \(bodyStr)" + "\n")}
                    text.append("Request: \(resultValueStr)" + "\n")
                    if let error = response.error { text.append("Error: \(error)" + "\n")}
                }
            }
            DispatchQueue.main.async {[weak self] in
                self?.textView.text = text
            }
        }
    }
}

extension XJCentralLogViewController {
    
    private func dicValueString(_ dic:[String : Any]?) -> String?{
        guard let dic = dic else {return nil}
        let data = try? JSONSerialization.data(withJSONObject: dic, options: [])
        let str = String(data: data!, encoding: String.Encoding.utf8)
        return str
    }
    
    private func getTimeFormatForFileExtension() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStr = dateFormatter.string(from: Date())
        return dateStr
    }
    
    private func getTimeString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS"
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }
}
