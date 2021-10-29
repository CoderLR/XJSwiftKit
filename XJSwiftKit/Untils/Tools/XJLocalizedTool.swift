//
//  XJLocalizedTool.swift
//  XJSwiftKit
//
//  Created by Mr.Yang on 2021/4/14.
//

import UIKit

class XJLocalizedTool {
    
    class func getString(_ keyStr: String) -> String {
        return NSLocalizedString(keyStr, comment: "")
    }
    
    /// 判断手机语言是不是中文
    class func localeIsChinese() -> Bool {
        if let lang = Locale.preferredLanguages.first {
            return lang.hasPrefix("zh") ? true : false ;
        } else {
            return false
        }
    }
}
