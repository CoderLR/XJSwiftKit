//
//  XJUserApi.swift
//  macOS-Education
//
//  Created by Mr.Yang on 2021/8/20.
//

import Foundation

enum XJUserApi {
    // 获取用户详情
    case getUserDetail(_ uid: String)
    case getUserThirdMessage(_ tpuid_2: String)
    case getAll
}
// publicinfo
extension XJUserApi: RequestProtocol {
    var urlStr: String {
        switch self {
        case .getUserDetail(_):
//            return XJAccountUrl + "/v1/users/publicinfo"
            return XJAccountUrl + "/v1/oauth2/userinfo"
        case .getUserThirdMessage(_):
            return XJAccountUrl + "/v1/users/thirdinfo"
//            return XJAccountUrl + "/v1/oauth2/userinfo"
        case .getAll:
            return XJAccountUrl + "/v1/users/limit/1/page/20"
            
        }
    }
//    1f67d3118a333df2ecb0d68173c2f93d1dcfe778
    var parameters: [String : Any]? {
        switch self {
        case let .getUserDetail(uid):
            return ["uid": uid,
                    "token": "1f67d3118a333df2ecb0d68173c2f93d1dcfe778"]
            
        case .getUserThirdMessage(_):
            return ["tpuid_2": "o9_9fwXiPHp4f7HQnyQ6Wl2Xdv0M",
                    "token": "1f67d3118a333df2ecb0d68173c2f93d1dcfe778"]
            
        default:
            return ["token": "1f67d3118a333df2ecb0d68173c2f93d1dcfe778",
                    "loginid": "4817"]
        }
    }
    
    var isShowHUD: Bool {
        switch self {
        case .getUserDetail(_):
            return true
            
        default: return true
        }
        
    }
}
