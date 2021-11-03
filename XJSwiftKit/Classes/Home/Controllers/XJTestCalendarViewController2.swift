//
//  XJTestCalendarViewController2.swift
//  XJSwiftKit
//
//  Created by xj on 2021/11/3.
//

import UIKit

class XJTestCalendarViewController2: XJBaseViewController {
    
    lazy var calendarSeriesView: YSCalendarSeriesView = {
        let calendar = YSCalendarSeriesView(frame: CGRect(x: 20, y: 20, width: KCalendarViewW, height: KCalendarSeriesViewH))
        return calendar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "日历控件"

        print("\(KCalendarSeriesViewH)")
        self.view.addSubview(calendarSeriesView)
        calendarSeriesView.dateSelectChangeBlock = { model in
            print("------------\(model.year)-\(model.month)-\(model.day)-------------")
            print("------------\(model.chineseYear)-\(model.chineseMonth)-\(model.chineseDay)-------------")
        }
    }

}
