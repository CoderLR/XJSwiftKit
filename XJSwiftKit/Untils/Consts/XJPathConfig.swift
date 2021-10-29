//
//  XJPathConfig.swift
//  XJSwiftKit
//
//  Created by Mr.Yang on 2021/10/15.
//

import Foundation

// MARK: - 配置路径

/// API
let XJControlUrl = "https://cc.xroom.net"
let XJApiUrl = "https://api.xroom.net"
let XJAccountUrl = "https://account.xroom.net"
let XJFileUrl = "https://file.xroom.net/"


/// Archiver
let FDP = FileManager.xj.DocumnetsDirectory()
let FCP = FileManager.xj.CachesDirectory()
let KUserInfoPath = FDP + "/userInfo"


/// Download
func downloadPath() -> String {
    let path = FCP + "/" + "download"
    FileManager.xj.createFolder(folderPath: path)
    return path
}
