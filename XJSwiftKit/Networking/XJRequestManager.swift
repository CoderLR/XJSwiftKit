//
//  XJRequestManager.swift
//  macOS-Education
//
//  Created by Mr.Yang on 2021/7/1.
//

import UIKit
import HandyJSON
import Alamofire

// MARK: Init
public class XJRequestManager {
    
    /// 创建单例
    static let share = XJRequestManager()
    
    /// 当前控制器
    var topViewController: UIViewController?
    
    /// 初始化
    init() {}
}

// MARK: Get and Post
extension XJRequestManager {
    /// GET请求->返回模型
    /// - Parameters:
    ///   - r: 遵守RequestProtocol
    ///   - mapType: 模型遵守HandyJSON协议
    ///   - header: 请求头
    ///   - encoding: 请求参数格式化 默认URLEncoding
    ///   - completionHandler: 成功返回
    @discardableResult
    func getRequest<T: RequestProtocol, F: HandyJSON>(_ r: T,
                                                      _ mapType: F.Type?,
                                                      header: HTTPHeaders = HTTPHeaders(),
                                                      encoding: ParameterEncoding = URLEncoding.default,
                                                      completionHandler: @escaping (F?, [String: Any]?) -> Void)
                                                        -> DataRequest {
        print("🖨get-> \(r.urlStr)")
        if r.isShowHUD { showHUD() }
        return AF.request(r.urlStr, method: HTTPMethod.get, parameters: r.parameters, encoding: encoding, headers: header)
        .responseJSON { (response) in
            if r.isShowHUD { self.dismissHUD() } // 隐藏指示器
            switch response.result {
                //如果返回成功则赋值给临时变量 data
                case let .success(data):
                    print("🖨resp-> \(data)")
                    guard let json = data as? [String : Any] else { return }
                    let jsonModel = JSONDeserializer<BaseResponse<F>>.deserializeFrom(dict: json)
                    // 错误提示
                    self.showSuccessError(errCode: jsonModel?.errcode, errMsg: jsonModel?.errmsg)
                    completionHandler(jsonModel?.data, json)
                    break
                //如果返回失败则赋值给临时变量 error
                case let .failure(error):
                    print("respError = \(error)")
                    let dict = ["errcode": error.responseCode ?? 1000,
                                "errmsg": error.errorDescription ?? ""] as [String : Any]
                    // 错误提示
                    self.showFailureError(errCode: error.responseCode, errMsg: error.errorDescription)
                    completionHandler(nil, dict)
                    break
            }
        }
    }
    
    /// GET请求->返回模型数组
    /// - Parameters:
    ///   - r: 遵守RequestProtocol
    ///   - mapType: 模型遵守HandyJSON协议
    ///   - header: 请求头
    ///   - encoding: 请求参数格式化 默认URLEncoding
    ///   - completionHandler: 成功返回
    @discardableResult
    func getRequestArray<T: RequestProtocol, F: HandyJSON>(_ r: T,
                                                           _ mapType: F.Type?,
                                                           header: HTTPHeaders = HTTPHeaders(),
                                                           encoding: ParameterEncoding = URLEncoding.default,
                                                           completionHandler: @escaping ([F?]?, [String: Any]?) -> Void)
                                                            -> DataRequest {
        print("🖨get-> \(r.urlStr)")
        if r.isShowHUD { showHUD() }
        return AF.request(r.urlStr, method: HTTPMethod.get, parameters: r.parameters, encoding: encoding, headers: header)
        .responseJSON { (response) in
            if r.isShowHUD { self.dismissHUD() } // 隐藏指示器
            switch response.result {
                //如果返回成功则赋值给临时变量 data
                case let .success(data):
                    print("🖨resp-> \(data)")
                    guard let json = data as? [String : Any] else { return }
                    let jsonModel = JSONDeserializer<BaseArrayResponse<F>>.deserializeFrom(dict: json)
                    // 错误提示
                    self.showSuccessError(errCode: jsonModel?.errcode, errMsg: jsonModel?.errmsg)
                    completionHandler(jsonModel?.data, json)
                    break
                //如果返回失败则赋值给临时变量 error
                case let .failure(error):
                    print("respError = \(error)")
                    let dict = ["errcode": error.responseCode ?? 1000,
                                "errmsg": error.errorDescription ?? ""] as [String : Any]
                    // 错误提示
                    self.showFailureError(errCode: error.responseCode, errMsg: error.errorDescription)
                    completionHandler(nil, dict)
                    break
            }
        }
    }
    
    /// POST请求->返回模型
    /// - Parameters:
    ///   - r: 遵守RequestProtocol
    ///   - mapType: 模型遵守HandyJSON协议
    ///   - header: 请求头
    ///   - encoding: 请求参数格式化 默认URLEncoding
    ///   - completionHandler: 成功返回
    @discardableResult
    func postRequest<T: RequestProtocol, F: HandyJSON>(_ r: T,
                                                       _ mapType: F.Type?,
                                                       header: HTTPHeaders = HTTPHeaders(),
                                                       encoding: ParameterEncoding = URLEncoding.default,
                                                       completionHandler: @escaping (F?, [String: Any]?) -> Void)
                                                        -> DataRequest {
        print("🖨post-> \(r.urlStr)\n🖨body-> \(r.parameters ?? [:])")
        if r.isShowHUD { showHUD() }
        return AF.request(r.urlStr, method: HTTPMethod.post, parameters: r.parameters, encoding: encoding, headers: header)
        .responseJSON { (response) in
            if r.isShowHUD { self.dismissHUD() } // 隐藏指示器
            switch response.result {
                // 如果返回成功则赋值给临时变量 data
                case let .success(data):
                    print("🖨resp-> \(data)")
                    guard let json = data as? [String : Any] else { return }
                    let jsonModel = JSONDeserializer<BaseResponse<F>>.deserializeFrom(dict: json)
                    // 错误提示
                    self.showSuccessError(errCode: jsonModel?.errcode, errMsg: jsonModel?.errmsg)
                    completionHandler(jsonModel?.data, json)
                    break
                // 如果返回失败则赋值给临时变量error
                case let .failure(error):
                    print("respError = \(error)")
                    let dict = ["errcode": error.responseCode ?? 1000,
                                "errmsg": error.errorDescription ?? ""] as [String : Any]
                    // 错误提示
                    self.showFailureError(errCode: error.responseCode, errMsg: error.errorDescription)
                    completionHandler(nil, dict)
                    break
            }
        }
    }
    
    /// POST请求->返回模型数组
    /// - Parameters:
    ///   - r: 遵守RequestProtocol
    ///   - mapType: 模型遵守HandyJSON协议
    ///   - header: 请求头
    ///   - encoding: 请求参数格式化 默认URLEncoding
    ///   - completionHandler: 成功返回
    @discardableResult
    func postRequestArray<T: RequestProtocol, F: HandyJSON>(_ r: T,
                                                            _ mapType: F.Type?,
                                                            header: HTTPHeaders = HTTPHeaders(),
                                                            encoding: ParameterEncoding = URLEncoding.default,
                                                            completionHandler: @escaping ([F?]?, [String: Any]?) -> Void)
                                                            -> DataRequest {
        print("🖨post-> \(r.urlStr)\n🖨body-> \(r.parameters ?? [:])")
        if r.isShowHUD { showHUD() }
        return AF.request(r.urlStr, method: HTTPMethod.post, parameters: r.parameters, encoding: encoding, headers: header)
        .responseJSON { (response) in
            if r.isShowHUD { self.dismissHUD() } // 隐藏指示器
            switch response.result {
                // 如果返回成功则赋值给临时变量 data
                case let .success(data):
                    print("🖨resp-> \(data)")
                    guard let json = data as? [String : Any] else { return }
                    let jsonModel = JSONDeserializer<BaseArrayResponse<F>>.deserializeFrom(dict: json)
                    // 错误提示
                    self.showSuccessError(errCode: jsonModel?.errcode, errMsg: jsonModel?.errmsg)
                    completionHandler(jsonModel?.data, json)
                    break
                // 如果返回失败则赋值给临时变量error
                case let .failure(error):
                    print("respError = \(error)")
                    let dict = ["errcode": error.responseCode ?? 1000,
                                "errmsg": error.errorDescription ?? ""] as [String : Any]
                    // 错误提示
                    self.showFailureError(errCode: error.responseCode, errMsg: error.errorDescription)
                    completionHandler(nil, dict)
                    break
            }
        }
    }
}

// MARK: Download And Upload
extension XJRequestManager {
    /// 文件上传
    /// - Parameters:
    ///   - r: 遵守UploadProtocol
    ///   - mapType: 模型遵守HandyJSON协议
    ///   - completionHandler: 回调
    ///   - progressHandler: 上传进度
    func uploadFile<T: UploadProtocol, F: HandyJSON>(_ r: T,
                                                     _ mapType: F.Type?,
                                                     completionHandler: @escaping (F?, [String:Any]?) -> Void,
                                                     progressHandler: @escaping (CGFloat) -> Void ) {
    
        print("upload url = \(r.urlStr)")
        print("upload models = \(r.uploadModels)")
        
        AF.upload(multipartFormData: { (formData) in
            
            // 上传单个文件
            if r.uploadModels.count == 1 {
                let uploadModel = r.uploadModels[0]
                if uploadModel.type == .path {
                    guard let updata = try? Data(contentsOf: URL(fileURLWithPath: uploadModel.path ?? "")) else { return }
                    formData.append(updata, withName: uploadModel.key ?? "", fileName: uploadModel.filename, mimeType: "multipart/form-data")
                } else if uploadModel.type == .data {
                    guard let fileData = uploadModel.value else { return }
                    formData.append(fileData, withName: uploadModel.key ?? "", fileName: uploadModel.filename, mimeType: "multipart/form-data")
                }
            // 上传多个文件，type必须统一
            } else if r.uploadModels.count > 1 {
                for uploadModel in r.uploadModels {
                    if uploadModel.type == .path {
                        guard let updata = try? Data(contentsOf: URL(fileURLWithPath: uploadModel.path ?? "")) else { return }
                        formData.append(updata, withName: uploadModel.key ?? "", fileName: uploadModel.filename, mimeType: "multipart/form-data")
                    } else if uploadModel.type == .data {
                        guard let fileData = uploadModel.value else { return }
                        formData.append(fileData, withName: uploadModel.key ?? "", fileName: uploadModel.filename, mimeType: "multipart/form-data")
                    }
                }
            }
            
        }, to: r.urlStr).responseJSON { (response) in
            switch response.result {
            case let .success(data):
                print("requestSuccess = \(data)")
                if let json = data as? [String : Any] {
                    let jsonModel = JSONDeserializer<BaseResponse<F>>.deserializeFrom(dict: json)
                    completionHandler(jsonModel?.data, json)
                }
                break

            case let .failure(error):
                print("requestError = \(error)")
                let dict = ["errcode": error.responseCode ?? 1000,
                            "errmsg": error.errorDescription ?? ""] as [String : Any]
                completionHandler(nil, dict)
                break
            }
        }.uploadProgress { (progress) in
            print("upload progress \(progress.fractionCompleted)")
            progressHandler(CGFloat(progress.fractionCompleted))
        }
    }
    
    // MARK: 下载相关
    
    /// 文件下载
    /// - Parameters:
    ///   - downloadUrl: 文件路径
    ///   - destinationUrl: 目标路径
    ///   - completionHandler: 下载完成回调
    ///   - progressHandler: 下载进度回调
    func downloadFile(downloadUrl: String,
                      destinationUrl: String,
                      completionHandler: @escaping (DownloadModel?) -> Void,
                      progressHandler: @escaping (CGFloat) -> Void,
                      errorHandler: ((Data?) -> Void)? = nil) -> DownloadRequest? {
        
        // 下载路径
        guard let urlEncode = downloadUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
        guard let downloadURL = URL(string: urlEncode) else { return nil }
        let downloadURLRequest = URLRequest(url: downloadURL)
        
        // 目标路径
        let destinationURL = URL(fileURLWithPath: destinationUrl)
        //self.destinationPath = destinationUrl
        
        let downloadRequest = AF.download(downloadURLRequest) { (_, _) -> (destinationURL: URL, options: DownloadRequest.Options) in
            return (destinationURL, [.createIntermediateDirectories, .removePreviousFile])
        }.responseData { (response) in
            switch response.result {
            case let .success(data):
                print("requestSuccess = \(destinationUrl)")
                let downModel = DownloadModel()
                downModel.path = destinationUrl // 下载文件路径
                downModel.data = data // 下载文件二进制
                completionHandler(downModel)
                break

            case let .failure(error):
                print("requestError = \(error)")
                // 暂时不确定下载失败，downloadRequest.resumeData是否有值
                if let errorHandler = errorHandler {
                    errorHandler(response.resumeData)
                }
                break
            }
        }.downloadProgress { (progress) in
            //print("download progress \(progress.fractionCompleted)")
            progressHandler(CGFloat(progress.fractionCompleted))
        }
        
        downloadRequest.destinationUrl = destinationUrl
        return downloadRequest
    }
    
    /// 取消下载
    /// - Parameters:
    ///   - downloadRequest: DownloadRequest对象
    ///   - completionHandler: 已下载进度
    func cancleDownload(_ downloadRequest: DownloadRequest?) {
        downloadRequest?.cancel()
    }
    
    /// 取消所有下载
    ///   - downloadRequest: DownloadRequest对象数组
    func cancleAllDownload(_ downloadRequests: [DownloadRequest]) {
        for downloadRequest in downloadRequests {
            downloadRequest.cancel()
        }
    }
    
    /// 暂停下载
    /// - Parameter downloadRequest: DownloadRequest对象
    func suspendDownload(_ downloadRequest: DownloadRequest?) {
        downloadRequest?.suspend()
    }
    
    /// 暂停所有下载
    /// - Parameter downloadRequest: DownloadRequest对象数组
    func suspendAllDownload(_ downloadRequests: [DownloadRequest]) {
        for downloadRequest in downloadRequests {
            downloadRequest.suspend()
        }
    }
    
    /// 暂停所有下载任务
    func suspendAllDownloadTask() {
        AF.session.getAllTasks { (tasks) in
            for task in tasks {
                if task.isKind(of: URLSessionDownloadTask.self) {
                    task.suspend()
                }
            }
        }
    }
    
    /// 恢复下载
    ///   - downloadRequest: 一DownloadRequest对象
    func resumeDownload(_ downloadRequest: DownloadRequest?) {
        downloadRequest?.resume()
    }
        
    /// 恢复所有下载
    /// - Parameter downloadRequest: DownloadRequest对象数组
    func resumeAllDownload(_ downloadRequests: [DownloadRequest]) {
        for downloadRequest in downloadRequests {
            downloadRequest.resume()
        }
    }
    
    /// 恢复所有下载任务
    func resumeAllDownloadTask() {
        AF.session.getAllTasks { (tasks) in
            for task in tasks {
                if task.isKind(of: URLSessionDownloadTask.self) {
                    task.resume()
                }
            }
        }
    }
    
    // MARK: 取消任务
    
    /// 取消所有任务（请求、上传、下载）
    func cancleAllTask() {
        AF.cancelAllRequests()
        /*
        AF.session.getAllTasks { (tasks) in
            for task in tasks {
                task.cancel()
            }
        }
        */
    }
    
    /// 取消所有请求任务
    func cancleAllRequestTask() {
        AF.session.getAllTasks { (tasks) in
            for task in tasks {
                if task.isKind(of: URLSessionDataTask.self) {
                    task.cancel()
                }
            }
        }
    }
    
    /// 取消所有上传任务
    func cancleAllUploadTask() {
        AF.session.getAllTasks { (tasks) in
            for task in tasks {
                if task.isKind(of: URLSessionUploadTask.self) {
                    task.cancel()
                }
            }
        }
    }
    
    /// 取消所有下载任务
    func cancleAllDownloadTask() {
        AF.session.getAllTasks { (tasks) in
            for task in tasks {
                if task.isKind(of: URLSessionDownloadTask.self) {
                    task.cancel()
                }
            }
        }
    }
}

// MARK: 模型转换
extension XJRequestManager {
    
    /// json->模型
    /// - Parameters:
    ///   - mapType: 转换模型类型
    ///   - json: json
    /// - Returns: 模型
    func jsonToModel<F: HandyJSON>(_ mapType: F.Type, json: [String: Any]?) -> F? {
        let model = JSONDeserializer<BaseResponse<F>>.deserializeFrom(dict: json)
        return model?.data
    }
    
    /// json->基础模型
    /// - Parameters:
    ///   - mapType: 转换模型类型
    ///   - json: json
    /// - Returns: 基础模型(F、errorcode、errormsg)
    func jsonToBaseModel<F: HandyJSON>(_ mapType: F.Type, json: [String: Any]?) -> BaseResponse<F>? {
        let model = JSONDeserializer<BaseResponse<F>>.deserializeFrom(dict: json)
        return model
    }
    
    
    /// data转字典
    /// - Parameter data: data
    /// - Returns: 字典数据
    func dataToDict(data: Data) -> Dictionary<String, Any>? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let dict = json as? Dictionary<String, Any>
            return dict
        } catch _ {
            return nil
        }
    }
}

// MARK: - destinationUrl
fileprivate var destinationUrlKey: String = "destinationUrl"
extension DownloadRequest {
     var destinationUrl: String? {
        set {
             objc_setAssociatedObject(self, &destinationUrlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, &destinationUrlKey)) as? String
        }
    }
}
