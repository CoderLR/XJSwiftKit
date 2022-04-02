//
//  XJUserInfo.swift
//  ShiJianYun
//
//  Created by Mr.Yang on 2021/4/14.
//

import UIKit
import HandyJSON

// MARK: - 用户信息
class XJUserInfo: NSObject, NSCoding, HandyJSON {
   
    var userId: String = ""
    var userName: String = ""
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.userId, forKey: "userId")
        aCoder.encode(self.userName, forKey: "userName")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.userId = aDecoder.decodeObject(forKey: "userId") as? String ?? ""
        self.userName = aDecoder.decodeObject(forKey: "userName") as? String ?? ""
    }
    
    required override init() {
        super.init()
    }// 偏好存储
}
