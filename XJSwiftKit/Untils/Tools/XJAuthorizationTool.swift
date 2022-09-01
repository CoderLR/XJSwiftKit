//
//  XJAuthorizationTool.swift
//  LeiFengHao
//
//  Created by xj on 2022/6/1.
//

import UIKit
import Photos
import Contacts
import EventKit
import CoreTelephony
import HealthKit
import SwiftUI

enum XJAuthType: String {
    
    // MARK: - 隐私
    
    // 相机
    case camera = "相机"
    // 麦克风
    case microphone = "麦克风"
    // 照片
    case photo = "照片"
    // 位置
    case location = "位置"
    // 通讯录
    case addressbook = "通讯录"
    // 日历
    case event = "日历"
    // 备忘录
    case reminder = "备忘录"
    
    // MARK: - 其他
    
    // 网络
    case network = "网络"
    // 网络
    case localNetwork = "本地网络"
    // 健康
    case healthy = "健康"
    // 蓝牙 (在CBCentralManager代理里面监听)
    case bluetooth = "蓝牙"
}

private var _localNetworkCompletion: ((_ granted: Bool)->())?

// MARK: - 权限管理类
class XJAuthorizationTool: NSObject {
    
    // 定位管理类
    fileprivate static var locationManager = CLLocationManager()
    
    /// 检测权限是否开启
    /// - Parameter type: 隐私类型
    /// - Returns: 是否开启
    class func checkAuthorization(_ type: XJAuthType) -> Bool {
        var isStart: Bool = false
        switch type {
        case .camera:
            isStart = checkCamera()
        case .microphone:
            isStart = checkMicrophone()
        case .photo:
            isStart = checkPhoto()
        case .location:
            isStart = checkLocation()
        case .addressbook:
            isStart = checkAddressbook()
        case .event:
            isStart = checkEvent()
        case .reminder:
            isStart = checkReminder()
        case .network:
            isStart = checkNetwork()
        case .healthy:
            isStart = checkHealth()
        default:
            break
        }
        return isStart
    }
    
    class func requestAuthorization(_ type: XJAuthType) {
        switch type {
        case .camera:
            requestCamera()
        case .microphone:
            requestMicrophone()
        case .photo:
            requestPhoto()
        case .location:
            requestLocation()
        case .addressbook:
            requestAddressbook()
        case .event:
            requestEvent()
        case .reminder:
            requestReminder()
        case .network:
            requestNetwork()
        case .healthy:
            requestHealth()
        default:
            break
        }
    }
}

// MARK: - 权限请求
extension XJAuthorizationTool {
    
    /// 相机权限
    fileprivate class func requestCamera() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                print("授权成功")
            } else {
                print("授权失败")
            }
        }
    }
    
    /// 麦克风权限
    fileprivate class func requestMicrophone() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                print("授权成功")
            } else {
                print("授权失败")
            }
        }
    }
    
    /// 相册权限
    fileprivate class func requestPhoto() {
        PHPhotoLibrary.requestAuthorization { status in
            var granted = false
            if status == .authorized {
                granted = true
                print("授权成功")
            } else {
                print("授权失败")
            }
        }
    }
    
    /// 定位权限
    fileprivate class func requestLocation() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    /// 通讯录权限
    fileprivate class func requestAddressbook() {
        CNContactStore().requestAccess(for: .contacts) { granted, error in
            if error == nil {
                if granted {
                    print("授权成功")
                } else {
                    print("授权失败")
                }
            } else {
                
            }
        }
    }
    
    /// 日历权限
    fileprivate class func requestEvent() {
        EKEventStore().requestAccess(to: .event) { granted, error in
            if error == nil {
                if granted {
                    print("授权成功")
                } else {
                    print("授权失败")
                }
            } else {
                
            }
        }
    }
    
    /// 备忘录权限
    fileprivate class func requestReminder() {
        EKEventStore().requestAccess(to: .reminder) { granted, error in
            if error == nil {
                if granted {
                    print("授权成功")
                } else {
                    print("授权失败")
                }
            } else {
                
            }
        }
    }
    
    /// 联网权限
    fileprivate class func requestNetwork() {
        
    }
    
    /// 健康权限
    fileprivate class func requestHealth() {
        
        let shareObjectTypes: Set<HKSampleType> = [HKObjectType.quantityType(forIdentifier: .bodyMass)!,
                                                  HKObjectType.quantityType(forIdentifier: .height)!,
                                                  HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!]
        
        let readObjectTypes: Set<HKObjectType> = [HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
                                                  HKObjectType.characteristicType(forIdentifier: .biologicalSex)!,
                                                  HKObjectType.quantityType(forIdentifier: .stepCount)!]
        
        HKHealthStore().requestAuthorization(toShare: shareObjectTypes, read: readObjectTypes) { granted, error in
            if error == nil {
                if granted {
                    print("授权成功")
                } else {
                    print("授权失败")
                }
            } else {
                
            }
        }
    }
}

// MARK: - 权限检查
extension XJAuthorizationTool {
    
    // 检查摄像头和麦克风权限
    class func cameraAndmicrophone() -> Bool {
        return checkCamera() && checkMicrophone()
    }
    
    /// 相机权限
    fileprivate class func checkCamera() -> Bool {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus != .restricted && authStatus != .denied {
            return true
        } else {
            return false
        }
    }
    
    /// 麦克风权限
    fileprivate class func checkMicrophone() -> Bool {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        if authStatus != .restricted && authStatus != .denied {
            return true
        } else {
            return false
        }
    }
    
    /// 相册权限
    fileprivate class func checkPhoto() -> Bool {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        if authStatus != .restricted && authStatus != .denied {
            return true
        } else {
            return false
        }
    }
    
    /// 定位权限
    fileprivate class func checkLocation() -> Bool {
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus != .restricted && authStatus != .denied && authStatus != .notDetermined {
            return true
        } else {
            return false
        }
    }
    
    /// 通讯录权限
    fileprivate class func checkAddressbook() -> Bool {
        let authStatus = CNContactStore.authorizationStatus(for: .contacts)
        if authStatus != .restricted && authStatus != .denied {
            return true
        } else {
            return false
        }
    }

    /// 日历权限
    fileprivate class func checkEvent() -> Bool {
        let authStatus = EKEventStore.authorizationStatus(for: .event)
        if authStatus != .restricted && authStatus != .denied {
            return true
        } else {
            return false
        }
    }
    
    /// 备忘录权限
    fileprivate class func checkReminder() -> Bool {
        let authStatus = EKEventStore.authorizationStatus(for: .reminder)
        if authStatus != .restricted && authStatus != .denied {
            return true
        } else {
            return false
        }
    }
    
    /// 健康权限
    fileprivate class func checkHealth() -> Bool {
        let healthStore = HKHealthStore()
        let hkObjectType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!
        let authStatus = healthStore.authorizationStatus(for: hkObjectType)
        if authStatus != .sharingDenied {
            return true
        } else {
            return false
        }
    }
    
    /// 联网权限
    fileprivate class func checkNetwork() -> Bool {
        let cellularData = CTCellularData()
        let authStatus = cellularData.restrictedState
        if authStatus != .restricted {
            return true
        } else {
            return false
        }
    }
    
    /// 请求本地网络权限
    /*
    func checkLocalNetwork(completion: @escaping ((_ granted: Bool)->())) {
        if #available(iOS 14, *) {
            _localNetworkCompletion = completion
            // 回调
            let browseCallback: DNSServiceBrowseReply = { (_, flags, _, errorCode, name, regtype, domain, context) in
                DispatchQueue.main.async {
                    _localNetworkCompletion?(errorCode != kDNSServiceErr_PolicyDenied)
                }
            }
            DispatchQueue.global().async {
                var browseRef: DNSServiceRef?
                /// info.plist配置Bonjour services “_me-transferdata._tcp”
                DNSServiceBrowse(&browseRef, 0, 0, "_me-transferdata._tcp", nil, browseCallback, nil)
                DNSServiceProcessResult(browseRef);
                DNSServiceRefDeallocate(browseRef);
            }
        } else {
            DispatchQueue.main.async {
                completion(true)
            }
        }
    }*/
}
