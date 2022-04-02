//
//  XJTestCalendarViewController.swift
//  ShiJianYun
//
//  Created by xj on 2021/11/1.
//

import UIKit

class XJTestCalendarViewController: XJBaseViewController {
    
    lazy var calendarSeriesView: YSCalendarSeriesView = {
        let calendar = YSCalendarSeriesView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: KCalendarSeriesViewH))
        return calendar
    }()

    lazy var calendarPageView: YSCalendarPageView = {
        let calendar = YSCalendarPageView(frame: CGRect(x: 20, y: 20, width: KCalendarViewW, height: KCalendarPageViewH))
        return calendar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "日历控件"

        print("\(KCalendarPageViewH)")
        self.view.addSubview(calendarPageView)
        calendarPageView.dateSelectChangeBlock = { model in
            print("------------\(model.year)-\(model.month)-\(model.day)-------------")
            print("------------\(model.chineseYear)-\(model.chineseMonth)-\(model.chineseDay)-------------")
        }
    }

}
