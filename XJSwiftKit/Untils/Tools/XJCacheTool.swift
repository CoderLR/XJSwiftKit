//
//  XJCacheTool.swift
//  XJSwiftKit
//
//  Created by Mr.Yang on 2021/10/14.
//

import Foundation
import WebKit

class XJCacheTool {
    
    class func clearWebcache() {
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), completionHandler: { (records) in
            for record in records{
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {
                })
            }
        })
    }
}
