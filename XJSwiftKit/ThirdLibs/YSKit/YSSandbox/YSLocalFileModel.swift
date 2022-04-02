//
//  YSLocalFileModel.swift
//  ShiJianYun
//
//  Created by xj on 2022/3/2.
//

import UIKit
/*
     public static let type:
     public static let size:
     public static let modificationDate:
     public static let referenceCount:
     public static let deviceIdentifier:
     public static let ownerAccountName:
     public static let groupOwnerAccountName:
     public static let posixPermissions:
     public static let systemNumber:
     public static let systemFileNumber:
     public static let extensionHidden:
     public static let hfsCreatorCode:
     public static let hfsTypeCode:
     public static let immutable:
     public static let appendOnly:
     public static let creationDate:
     public static let ownerAccountID:
     public static let groupOwnerAccountID:
     public static let busy:
     public static let protectionKey:
     public static let systemSize:
     public static let systemFreeSize:
     public static let systemNodes:
     public static let systemFreeNodes:
 */

// MARK: - 本地文件类型
enum YSLocalFileType {
    case folder // 文件夹
    case video  // 视频
    case music  // 音乐
    case txt    // 文稿
    case doc    // word
    case ppt    // 幻灯片
    case xls    // 表格
    case plist  // plist文件
    case db     // 数据库文件
    case other   // 其他
}

// MARK: - 本地文件模型
class YSLocalFileModel: NSObject {

    var path: String = ""
    var fileName: String = ""
    var type: YSLocalFileType = .other
    var size: String = ""
    var creaeDate: String = ""
    var modifyDate: String = ""

    convenience init(path: String) {
        self.init()
        self.path = path
    }
    
    
    /// 获取沙盒路径下的所有文件
    /// - Returns: 返回路径下文件列表
    func getLocalFiles() -> [YSLocalFileModel] {
        var fileModels: [YSLocalFileModel] = []

        let searchFiles: [String] = FileManager.xj.shallowSearchAllFiles(folderPath: path) ?? []
        print("searchFiles = \(searchFiles)")
        
        for file in searchFiles {
            let filePath = path + "/" + file
            let attributes = FileManager.xj.fileAttributes(path: filePath)!

            print("--------------\(file)----------")
            print("文件类型：\(attributes[FileAttributeKey.type]!)")
            print("文件大小：\(attributes[FileAttributeKey.size]!)")
            print("创建时间：\(attributes[FileAttributeKey.creationDate]!)")
            print("修改时间：\(attributes[FileAttributeKey.modificationDate]!)")

            let model: YSLocalFileModel = YSLocalFileModel()
            model.path = path
            model.fileName = file

            let typeStr = attributes[FileAttributeKey.type] as? String ?? ""
            if typeStr == "NSFileTypeDirectory" {
                model.type = .folder
            } else if typeStr == "NSFileTypeRegular" {
                let last = file as NSString
                print("last = \(last.lastPathComponent)  \(last.pathExtension)")
                model.type = YSLocalFileModel.getFileType(pathExt: last.pathExtension)
            }
            
            let crDate = attributes[FileAttributeKey.creationDate] as? NSDate as Date?
            model.creaeDate = crDate?.xj.toformatterTimeString() ?? ""
            
            let moDate = attributes[FileAttributeKey.modificationDate] as? NSDate as Date?
            model.modifyDate = moDate?.xj.toformatterTimeString() ?? ""
            
            let fileSize = attributes[FileAttributeKey.size] as? UInt64 ?? 0
            model.size = FileManager.xj.covertUInt64ToString(with: fileSize)

            fileModels.append(model)
        }

        return fileModels
    }
    
    /// 根据文件后缀获取文件类型
    fileprivate class func getFileType(pathExt: String) -> YSLocalFileType {
        var type: YSLocalFileType = .other
        switch pathExt.lowercased() {
        case "mp4", "avi":
            type = .video
        case "mp3":
            type = .music
        case "txt":
            type = .txt
        case "doc", "docx":
            type = .doc
        case "xls", "xlsx":
            type = .xls
        case "ppt", "pptx":
            type = .ppt
        case "plist":
            type = .plist
        case "db":
            type = .db
        default:
            type = .other
        }
        return type
    }
    
    required override init()  {
        
    }
}
