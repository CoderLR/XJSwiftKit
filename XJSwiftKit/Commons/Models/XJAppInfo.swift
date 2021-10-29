//
//  XJAppInfo.swift
//  XJSwiftKit
//
//  Created by Mr.Yang on 2021/10/15.
//

import UIKit

// MARK: - 管理数据存储
class XJAppInfo: NSObject {
    
    // 单例
    static let share = XJAppInfo()
    
    /// 偏好存储
    var token: String {
        set {
            UD.set(newValue, forKey: "token")
            UD.synchronize()
        }
        get {
            return UD.object(forKey: "token") as? String ?? ""
        }
    }
    
    /// 归档存储
    var userInfo: XJUserInfo {
        set {
            self.archiver(object: newValue, file: KUserInfoPath)
        }
        
        get {
            return self.unarchiver(file: KUserInfoPath) as? XJUserInfo ?? XJUserInfo()
        }
    }
    
    /// 归档
    /// - Parameters:
    ///   - object: 归档对象
    ///   - file: 归档路径
    func archiver(object: Any?, file: String) {
        guard let archiverObj = object else { return }
        NSKeyedArchiver.archiveRootObject(archiverObj, toFile: file)
    }
    
    /// 解档
    /// - Parameter file: 解档路径
    /// - Returns: 解档对象
    func unarchiver(file: String) -> Any? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: file)
    }
    
    
    /// 删除归档
    /// - Parameter file: 归档路径
    func removeArchiver(file: String) {
        do {
            try FM.removeItem(atPath: file)
        } catch {}
    }
    
    /// 清空数据
    fileprivate func clearAppData() {
        UD.removeObject(forKey: "token")
        removeArchiver(file: KUserInfoPath)
    }

}
