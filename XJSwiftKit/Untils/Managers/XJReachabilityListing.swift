//
//  XJReachabilityListing.swift
//  ShiJianYun
//
//  Created by Mr.Yang on 2021/10/13.
//

import Foundation
import Reachability

let Cellular = "3G/4G" //蜂窝网络
let Wifi = "wifi" //Wi-Fi网络
let UnReachable = "UnReachable"

enum XJNetStatus {
    case UnReachable
    case Cellular
    case Wifi
}

class XJReachabilityListing {
    
    // 单例
    static let share = XJReachabilityListing()
    
    // 网络监听对象
    private var reachability = Reachability()
    
    // 网络状态
    var netStatus: XJNetStatus = .UnReachable
    
    // block回调监听网络
    var netStatusBlock: ((_ status: XJNetStatus) -> ())?
    
    /// 初始化
    init() {
        //self.listen()
    }
    
    /// 执行监听
    func listen() {
        reachability?.whenReachable = {[weak self] reachability in
            guard let self = self else {  return }
            if reachability.connection == .wifi {
                self.netStatus = .Wifi
                print("log: Reachable via WiFi")
                
                if let netStatusBlock = self.netStatusBlock {
                    netStatusBlock(.Wifi)
                }
             
            } else {
                self.netStatus = .Cellular
                print("log: Reachable via 3G/4G")
                if let netStatusBlock = self.netStatusBlock {
                    netStatusBlock(.Cellular)
                }
            }
        }
        
        reachability?.whenUnreachable = {[weak self] _ in
            guard let self = self else {  return }
            self.netStatus = .UnReachable
            print("log: Reachable Not")
            if let netStatusBlock = self.netStatusBlock {
                netStatusBlock(.UnReachable)
            }
        }
    
        do {
            try reachability?.startNotifier()
        } catch {
            print("log: Unable to start notifier")
        }
    }
}


