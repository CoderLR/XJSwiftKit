//
//  XJMineModel.swift
//  ShiJianYun
//
//  Created by xj on 2022/1/12.
//

import UIKit

class XJMineModel: NSObject {
    
    enum XJMineType {
        case normal
        case pay
        case store
        case circle
        case card
        case emotion
        case setting
    }
    
    // 图片名
    var imageName: String = ""
    
    // 标题
    var title: String = ""
    
    // 是否显示箭头
    var isArrow: Bool = true
    
    // 类型
    var type: XJMineType = .normal
    
    
    /// 获取数据源
    class func getMineModels() -> [[XJMineModel]] {
        let pay = XJMineModel()
        pay.imageName = "icon_mine_pay"
        pay.title = "支付"
        pay.type = .pay
        
        let store = XJMineModel()
        store.imageName = "icon_mine_store"
        store.title = "收藏"
        store.type = .store
        
        let circle = XJMineModel()
        circle.imageName = "icon_mine_circle"
        circle.title = "朋友圈"
        circle.type = .circle
        
        let card = XJMineModel()
        card.imageName = "icon_mine_card"
        card.title = "卡包"
        card.type = .card
        
        let emotion = XJMineModel()
        emotion.imageName = "icon_mine_emotion"
        emotion.title = "表情"
        emotion.type = .emotion
        
        let setting = XJMineModel()
        setting.imageName = "icon_mine_seeting"
        setting.title = "设置"
        setting.type = .setting
        
        return [[pay], [store, circle, card, emotion], [setting]]
    }
}
