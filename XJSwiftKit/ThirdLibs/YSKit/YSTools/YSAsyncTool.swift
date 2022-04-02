//
//  YSAsyncTool.swift
//  ShiJianYun
//
//  Created by Mr.Yang on 2021/10/21.
//

import Foundation

// 事件闭包
public typealias YSTask = () -> Void

// MARK:- 延迟事件
public struct YSAsyncTool {
    // MARK: 1.1、异步做一些任务
    /// 异步做一些任务
    /// - Parameter YSTask: 任务
    @discardableResult
    public static func async(_ YSTask: @escaping YSTask) -> DispatchWorkItem {
        return _asyncDelay(0, YSTask)
    }
    
    // MARK: 1.2、异步做任务后回到主线程做任务
    /// 异步做任务后回到主线程做任务
    /// - Parameters:
    ///   - YSTask: 异步任务
    ///   - mainJKTask: 主线程任务
    @discardableResult
    public static func async(_ YSTask: @escaping YSTask,
                             _ mainJKTask: @escaping YSTask) -> DispatchWorkItem{
        return _asyncDelay(0, YSTask, mainJKTask)
    }
    
    // MARK: 1.3、异步延迟(子线程执行任务)
    /// 异步延迟(子线程执行任务)
    /// - Parameter seconds: 延迟秒数
    /// - Parameter YSTask: 延迟的block
    @discardableResult
    public static func asyncDelay(_ seconds: Double,
                                  _ YSTask: @escaping YSTask) -> DispatchWorkItem {
        return _asyncDelay(seconds, YSTask)
    }
    
    // MARK: 1.4、异步延迟回到主线程(子线程执行任务，然后回到主线程执行任务)
    /// 异步延迟回到主线程(子线程执行任务，然后回到主线程执行任务)
    /// - Parameter seconds: 延迟秒数
    /// - Parameter YSTask: 延迟的block
    /// - Parameter mainJKTask: 延迟的主线程block
    @discardableResult
    public static func asyncDelay(_ seconds: Double,
                                  _ YSTask: @escaping YSTask,
                                  _ mainJKTask: @escaping YSTask) -> DispatchWorkItem {
        return _asyncDelay(seconds, YSTask, mainJKTask)
    }
}

// MARK:- 私有的方法
extension YSAsyncTool {
    
    /// 延迟任务
    /// - Parameters:
    ///   - seconds: 延迟时间
    ///   - YSTask: 任务
    ///   - mainJKTask: 任务
    /// - Returns: DispatchWorkItem
    fileprivate static func _asyncDelay(_ seconds: Double,
                                        _ YSTask: @escaping YSTask,
                                        _ mainJKTask: YSTask? = nil) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: YSTask)
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + seconds,
                                          execute: item)
        if let main = mainJKTask {
            item.notify(queue: DispatchQueue.main, execute: main)
        }
        return item
    }
}
