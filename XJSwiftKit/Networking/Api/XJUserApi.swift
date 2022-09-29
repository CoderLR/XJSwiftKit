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

    var parameters: [String : Any]? {
        let token: String = "a5e9b11506da4472bd44fafd033783b88ffb0275"
        switch self {
        case let .getUserDetail(uid):
            return ["uid": uid,
                    "token": token]
            
        case .getUserThirdMessage(_):
            return ["tpuid_2": "o9_9fwXiPHp4f7HQnyQ6Wl2Xdv0M",
                    "token": token]
            
        default:
            return ["token": token,
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
