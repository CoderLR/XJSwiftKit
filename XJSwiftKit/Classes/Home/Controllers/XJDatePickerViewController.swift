//
//  XJDatePickerViewController.swift
//  ShiJianYun
//
//  Created by xj on 2022/3/4.
//

import UIKit

class XJDatePickerViewController: XJBaseViewController {
    
    lazy var dateButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Color_System
        button.setTitle("当前选中日期：", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)

        button.addTarget(self, action: #selector(dateBtnClick(_:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "日期选择"
        
        self.view.addSubview(dateButton)
        dateButton.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(30)
            make.height.equalTo(40)
        }
    }
    
    /// 日期选择
    @objc func dateBtnClick(_ btn: UIButton) {
        
        YSDatePickerView(mode: .date, date: "2021-10-10",selectDateBlock: {[weak self] (date) in
            guard let self = self else { return }
            print("select:\(date)")
            let dateStr = "当前选中日期：\(date)"
            self.dateButton.setTitle(dateStr, for: .normal)
        }).show()
    }

}
