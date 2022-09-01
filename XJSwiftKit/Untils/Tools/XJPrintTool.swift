//
//  YSPrint.swift
//  XJSwiftKit
//
//  Created by xj on 2021/10/21.
//

import Foundation

/// 网络请求打印
/// - Parameter msg: 打印的内容
/// - Parameter file: 文件路径
/// - Parameter line: 打印内容所在的 行
/// - Parameter fn: 打印内容的函数名
public func XJPrint(_ msg: Any...,
                    file: NSString = #file,
                    line: Int = #line,
                    fn: String = #function) {
    var msgStr = ""
    for element in msg {
        msgStr += "\(element)\n"
    }
    let prefix = "===start=====================🚀====================\n当前时间：\(Date.xj.currentTime())\n文件路径：\(file) \n函数名：\(fn) 第\(line)行\n打印内容：\n\(msgStr)===end=======================🤗===================="
    print(prefix)
    // 将内容同步写到文件中去（Caches文件夹下）
    let documentPath = FileManager.xj.appLogDirectory()
    let logURL = documentPath + "/Reqest_\(Date.xj.currentLogTime()).txt"
    appendText(fileURL: URL(string: logURL)!, string: "\(prefix)")
}

/// 中控打印
/// - Parameter msg: 打印的内容
/// - Parameter file: 文件路径
/// - Parameter line: 打印内容所在的 行
/// - Parameter fn: 打印内容的函数名
public func NDPrint(_ msg: Any...,
                    file: NSString = #file,
                    line: Int = #line,
                    fn: String = #function) {
    var msgStr = ""
    for element in msg {
        msgStr += "\(element)\n"
    }
    let prefix = "===start=====================📌====================\n当前时间：\(Date.xj.currentTime())\n文件路径：\(file) \n函数名：\(fn) 第\(line)行\n打印内容：\n\(msgStr)===end=======================😎===================="
    print(prefix)
    // 将内容同步写到文件中去（Caches文件夹下）
    let documentPath = FileManager.xj.appLogDirectory()
    let logURL = documentPath + "/Socket_\(Date.xj.currentLogTime()).txt"
    appendText(fileURL: URL(string: logURL)!, string: "\(prefix)")
}

/// 其他打印
/// - Parameter msg: 打印的内容
/// - Parameter file: 文件路径
/// - Parameter line: 打印内容所在的 行
/// - Parameter fn: 打印内容的函数名
public func outPrint(_ msg: Any...,
                    file: NSString = #file,
                    line: Int = #line,
                    fn: String = #function) {
    var msgStr = ""
    for element in msg {
        msgStr += "\(element)\n"
    }
    let prefix = "===start=====================🖨====================\n当前时间：\(Date.xj.currentTime())\n文件路径：\(file) \n调用函数：\(fn) 第\(line)行\n打印内容：\n\(msgStr)===end=======================😝===================="
    print(prefix)
    // 将内容同步写到文件中去（Caches文件夹下）
    let documentPath = FileManager.xj.appLogDirectory()
    let logURL = documentPath + "/Other_\(Date.xj.currentLogTime()).txt"
    appendText(fileURL: URL(string: logURL)!, string: "\(prefix)")
}

// 在文件末尾追加新内容
private func appendText(fileURL: URL, string: String) {
    do {
        // 如果文件不存在则新建一个
        FileManager.xj.createFile(filePath: fileURL.path)
        let fileHandle = try FileHandle(forWritingTo: fileURL)
        let stringToWrite = "\n" + string
        // 找到末尾位置并添加
        fileHandle.seekToEndOfFile()
        fileHandle.write(stringToWrite.data(using: String.Encoding.utf8)!)
        
    } catch let error as NSError {
        print("failed to append: \(error)")
    }
}
