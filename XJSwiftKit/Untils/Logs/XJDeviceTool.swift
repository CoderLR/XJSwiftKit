//
//  NDDevice.swift
//  iOS-Education
//
//  Created by Mr.Yang on 2021/6/11.
//  Copyright © 2021 魏延龙. All rights reserved.
//

import UIKit

public struct XJDeviceTool {
    //MARK: -  获取设备类型
    //deviceType设备类型获取地址https://www.theiphonewiki.com/wiki/Models

    private static let deviceType: String = "User-Agent"
  
    public static let deviceInfo: [String: String] = {
        if let info = Bundle.main.infoDictionary {
            let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
            let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"

            let osNameVersion: String = {
                let version = ProcessInfo.processInfo.operatingSystemVersion
                let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"

                let osName: String = {
                    #if os(iOS)
                        return "iOS"
                    #elseif os(watchOS)
                        return "watchOS"
                    #elseif os(tvOS)
                        return "tvOS"
                    #elseif os(macOS)
                        return "OS X"
                    #elseif os(Linux)
                        return "Linux"
                    #else
                        return "Unknown"
                    #endif
                }()

                return "\(osName) \(versionString)"
            }()

            let deviceVersion: String = {
                return getDevieceType()
            }()

            return [deviceType: "\(deviceVersion) (\(osNameVersion); version:\(appVersion); build:\(appBuild))"]
        }

        return [deviceType :"Unknown"]
    }()


    public static func getDevieceType() -> String {
        var systemInfo = utsname()
        
        uname(&systemInfo)
        
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let deviceString = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        let deviceType = [
                    //iPhone(手机)
                    "iPhone3,1"    :"iPhone 4",
                    "iPhone3,2"    :"iPhone 4",
                    "iPhone3,3"    :"iPhone 4",
                    "iPhone4,1"    :"iPhone 4S",
                    "iPhone5,1"    :"iPhone 5",
                    "iPhone5,2"    :"iPhone 5 (GSM+CDMA)",
                    "iPhone5,3"    :"iPhone 5c (GSM)",
                    "iPhone5,4"    :"iPhone 5c (GSM+CDMA)",
                    "iPhone6,1"    :"iPhone 5s (GSM)",
                    "iPhone6,2"    :"iPhone 5s (GSM+CDMA)",
                    "iPhone7,1"    :"iPhone 6 Plus",
                    "iPhone7,2"    :"iPhone 6",
                    "iPhone8,1"    :"iPhone 6s",
                    "iPhone8,2"    :"iPhone 6s Plus",
                    "iPhone8,4"    :"iPhone SE",
                    "iPhone9,1"    :"iPhone 7",
                    "iPhone9,2"    :"iPhone 7 Plus",
                    "iPhone9,3"    :"iPhone 7",
                    "iPhone9,4"    :"iPhone 7 Plus",
                    "iPhone10,1"   :"iPhone_8",
                    "iPhone10,4"   :"iPhone_8",
                    "iPhone10,2"   :"iPhone_8_Plus",
                    "iPhone10,5"   :"iPhone_8_Plus",
                    "iPhone10,3"   :"iPhone X",
                    "iPhone10,6"   :"iPhone X",
                    "iPhone11,8"   :"iPhone XR",
                    "iPhone11,2"   :"iPhone XS",
                    "iPhone11,6"   :"iPhone XS Max",
                    "iPhone11,4"   :"iPhone XS Max",
                    "iPhone12,1"   :"iPhone 11",
                    "iPhone12,3"   :"iPhone 11 Pro",
                    "iPhone12,5"   :"iPhone 11 Pro Max",
                    "iPhone12,8"   :"iPhone SE2",
                    "iPhone13,1"   :"iPhone 12 mini",
                    "iPhone13,2"   :"iPhone 12",
                    "iPhone13,3"   :"iPhone 12 Pro",
                    "iPhone13,4"   :"iPhone 12 Pro Max",
                    //iPod
                    "iPod1,1"      :"iPod Touch 1G",
                    "iPod2,1"      :"iPod Touch 2G",
                    "iPod3,1"      :"iPod Touch 3G",
                    "iPod4,1"      :"iPod Touch 4G",
                    "iPod5,1"      :"iPod Touch (5 Gen)",
                    "iPod7,1"      :"iPod touch (6th generation)",
                    "iPod9,1"      :"iPod touch (7th generation)",
                    //iPad
                    "iPad1,1"      :"iPad",
                    "iPad1,2"      :"iPad 3G",
                    "iPad2,1"      :"iPad 2 (WiFi)",
                    "iPad2,2"      :"iPad 2",
                    "iPad2,3"      :"iPad 2 (CDMA)",
                    "iPad2,4"      :"iPad 2",
                    "iPad2,5"      :"iPad Mini (WiFi)",
                    "iPad2,6"      :"iPad Mini",
                    "iPad2,7"      :"iPad Mini (GSM+CDMA)",
                    "iPad3,1"      :"iPad 3 (WiFi)",
                    "iPad3,2"      :"iPad 3 (GSM+CDMA)",
                    "iPad3,3"      :"iPad 3",
                    "iPad3,4"      :"iPad 4 (WiFi)",
                    "iPad3,5"      :"iPad 4",
                    "iPad3,6"      :"iPad 4 (GSM+CDMA)",
                    "iPad4,1"      :"iPad Air (WiFi)",
                    "iPad4,2"      :"iPad Air (Cellular)",
                    "iPad4,4"      :"iPad Mini 2 (WiFi)",
                    "iPad4,5"      :"iPad Mini 2 (Cellular)",
                    "iPad4,6"      :"iPad Mini 2",
                    "iPad4,7"      :"iPad Mini 3",
                    "iPad4,8"      :"iPad Mini 3",
                    "iPad4,9"      :"iPad Mini 3",
                    "iPad5,1"      :"iPad Mini 4 (WiFi)",
                    "iPad5,2"      :"iPad Mini 4 (LTE)",
                    "iPad5,3"      :"iPad Air 2",
                    "iPad5,4"      :"iPad Air 2",
                    "iPad6,3"      :"iPad Pro 9.7",
                    "iPad6,4"      :"iPad Pro 9.7",
                    "iPad6,7"      :"iPad Pro 12.9",
                    "iPad6,8"      :"iPad Pro 12.9",
                    "iPad6,11"     :"iPad 5",
                    "iPad6,12"     :"iPad 5",
                    "iPad7,1"      :"iPad Pro 12.9-2",
                    "iPad7,2"      :"iPad Pro 12.9-2",
                    "iPad7,3"      :"iPad Pro 10.5",
                    "iPad7,4"      :"iPad Pro 10.5",
                    "iPad7,5"      :"iPad 6",
                    "iPad7,6"      :"iPad 6",
                    "iPad7,11"     :"iPad 7",
                    "iPad7,12"     :"iPad 7",
                    "iPad8,1"      :"iPad Pro 11",
                    "iPad8,2"      :"iPad Pro 11",
                    "iPad8,3"      :"iPad Pro 11",
                    "iPad8,4"      :"iPad Pro 11",
                    "iPad8,5"      :"iPad Pro 12.9-3",
                    "iPad8,6"      :"iPad Pro 12.9-3",
                    "iPad8,7"      :"iPad Pro 12.9-3",
                    "iPad8,8"      :"iPad Pro 12.9-3",
                    "iPad8,9"      :"iPad Pro 11-2",
                    "iPad8,10"     :"iPad Pro 11-2",
                    "iPad8,11"     :"iPad Pro 12.9-4",
                    "iPad8,12"     :"iPad Pro 12.9-4",
                    "iPad11,1"     :"iPad Mini 5",
                    "iPad11,2"     :"iPad Mini 5",
                    "iPad11,3"     :"iPad Air 3",
                    "iPad11,4"     :"iPad Air 3",
                    "iPad11,6"     :"iPad 8",
                    "iPad11,7"     :"iPad 8",
                    "iPad13,1"     :"iPad Air 4",
                    "iPad13,2"     :"iPad Air 4",
                    "iPad13,4"     :"iPad Pro 11-3",
                    "iPad13,5"     :"iPad Pro 11-3",
                    "iPad13,6"     :"iPad Pro 11-3",
                    "iPad13,7"     :"iPad Pro 11-3",
                    "iPad13,8"     :"iPad Pro 12.9-5",
                    "iPad13,9"     :"iPad Pro 12.9-5",
                    "iPad13,10"    :"iPad Pro 12.9-5",
                    "iPad13,11"    :"iPad Pro 12.9-5"]
        
        
        if deviceString.hasPrefix("x86") {
            return "iPhone模拟器"
        } else {
            if let deviceTypeString = deviceType[deviceString] {
                return deviceTypeString
            }
        }

        return "iPhone新机型"
    }
}


