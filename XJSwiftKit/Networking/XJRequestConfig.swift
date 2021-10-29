//
//  XJRequestBaseModel.swift
//  XJSwiftKit
//
//  Created by Mr.Yang on 2021/10/15.
//

import Foundation
import HandyJSON

let RESAULTCODE = "errcode"
let ERRORMSG = "errmsg"
let SUCCESSCODE = 0

// MARK: - Enum
/// 上传方式
enum UploadType {
    case data // 二进制
    case path // 路径
}

// MARK: - Protocol
/// 请求协议
protocol RequestProtocol {
    var urlStr: String { get } // 请求的路径
    var parameters: [String: Any]? { get } // 参数
    var isShowHUD: Bool { get } // 指示器
}

/// 上传协议
protocol UploadProtocol {
    var urlStr: String { get } // 请求的路径
    var parameters: [String: Any]? { get } // 参数
    var uploadModels: [UploadModel] { get } // 上传数据模型
    var isShowHUD: Bool{ get } // 指示器
}


// MARK: - Model
/// 转模型：data对应的是字典
class BaseResponse<T: HandyJSON>: HandyJSON {
    var errcode: Int?   // 错误码
    var errmsg: String? // 错误信息
    var data: T?        // 实体数据
    
    public required init() {}
}

/// 转模型：data对应的是数组
class BaseArrayResponse<T: HandyJSON>: HandyJSON {
    var errcode: Int?   // 错误码
    var errmsg: String? // 错误信息
    var data: [T?]?     // 实体数据
    
    public required init() {}
}

/// 空模型：只获取json数据
class BaseEmptyModel: HandyJSON {
    public required init() {}
}

/// 上传数据模型
class UploadModel {
    var filename: String = ""       // 上传文件名：filename.txt
    var type: UploadType = .data    // 上传文件类型, 默认data上传
    var key: String?                // avstar file file[]
    var value: Data?                // 上传文件数据
    var path: String?               // 上传文件路径
}

/// 下载数据模型
class DownloadModel {
    var url: String?    // 下载地址
    var path: String?   // 下载存储位置
    var data: Data?     // 下载二进制数据
}

// MARK: - Error
/// 获取errorCode 出错返回-1
func resCode(_ resDict: [String: Any]?) -> Int {
    guard let dict = resDict else { return -1 }
    let code = dict[RESAULTCODE] as? Int ?? -1
    return code
}

/// 获取errorMsg 出错返回空
func resMsg(_ resDict: [String: Any]?) -> String {
    guard let dict = resDict else { return "" }
    let msg = dict[ERRORMSG] as? String ?? ""
    return msg
}
