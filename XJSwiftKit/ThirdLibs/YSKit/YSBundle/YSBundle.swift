//
//  YSBoundle.swift
//  LeiFengHao
//
//  Created by xj on 2022/6/24.
//

import UIKit

class YSBundle: NSObject {
    
    
    /// bundle路径
    /// - Returns: bundle路径
    class func bundlePath() -> String {
        return Bundle.main.path(forResource: "YSResource", ofType: "bundle") ?? ""
    }
    
    /// calendar路径
    /// - Returns: calendar路径
    class func calendarPath(_ path: String) -> String {
        return bundlePath() + "/" + "calendar/" + path
    }
    
    /// scan路径
    /// - Returns: scan路径
    class func scanPath(_ path: String) -> String {
        return bundlePath() + "/" + "scan/" + path
    }
    
    /// share路径
    /// - Returns: share路径
    class func sharePath(_ path: String) -> String {
        return bundlePath() + "/" + "share/" + path
    }
    
    /// refresh路径
    /// - Returns: refresh路径
    class func refreshWhitePath(_ path: String) -> String {
        return bundlePath() + "/refresh/" + "white/" + path
    }
    
    /// refresh路径
    /// - Returns: refresh路径
    class func refreshBlackPath(_ path: String) -> String {
        return bundlePath() + "/refresh/" + "black/" + path
    }
    
    /// sandbox路径
    /// - Returns: refresh路径
    class func sandboxPath(_ path: String) -> String {
        return bundlePath() + "/sandbox/" + path
    }
}
