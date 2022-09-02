//
//  XJDatePickerViewController.swift
//  ShiJianYun
//
//  Created by xj on 2022/3/4.
//

import UIKit

class XJDatePickerViewController: XJBaseViewController {
    
    lazy var sexButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Color_System
        button.setTitle("选择性别：", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(sexBtnClick(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var dateButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Color_System
        button.setTitle("选择日期：", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(dateBtnClick(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var addressButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Color_System
        button.setTitle("选择地址：", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(addressBtnClick(_:)), for: .touchUpInside)
        return button
    }()
    
    var addressSelectIndexs: [NSNumber] = [0, 0, 0]
    var sexSelectIndex = 0
    var birthdaySelectDate: Date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "选择器"
        
        self.view.addSubview(dateButton)
        self.view.addSubview(sexButton)
        self.view.addSubview(addressButton)
        
        dateButton.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(40)
            make.top.equalToSuperview().offset(5)
        }
        
        sexButton.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(40)
            make.top.equalTo(self.dateButton.snp.bottom).offset(5)
        }
        
        addressButton.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(40)
            make.top.equalTo(self.sexButton.snp.bottom).offset(5)
        }
        
    }
}

// MARK: - Action
extension XJDatePickerViewController {
    
    /// 日期选择
    @objc func dateBtnClick(_ btn: UIButton) {
        selectBirthday()
    }
    
    /// 性别选择
    @objc func sexBtnClick(_ btn: UIButton) {
        selectSex()
    }
    
    /// 地址选择
    @objc func addressBtnClick(_ btn: UIButton) {
        selectAddress()
    }
    
    /// 性别选择
    func selectSex() {
        let pickerView = BRStringPickerView()
        pickerView.pickerMode = .componentSingle
        pickerView.title = "请选择性别"
        pickerView.dataSourceArr = ["男", "女"]
        pickerView.selectIndex = sexSelectIndex
        pickerView.resultModelBlock = {[weak self] resultModel in
            guard let self = self else { return }
            self.sexSelectIndex = resultModel?.index ?? 0
            print("\(resultModel?.index ?? 0)---\(resultModel?.value ?? "")")
            self.sexButton.setTitle("性别：\(self.sexSelectIndex == 0 ? "男" : "女")", for: .normal)
        }
        pickerView.show()
    }
    
    /// 出生日期选择
    func selectBirthday() {
        
        let pickerView = BRDatePickerView()
        pickerView.pickerMode = .YMD
        pickerView.title = "请选择年月日"
        pickerView.selectDate = self.birthdaySelectDate
        pickerView.minDate = NSDate.br_setYear(2018, month: 3, day: 10)
        pickerView.maxDate = NSDate.br_setYear(2025, month: 3, day: 10)
        pickerView.isAutoSelect = true
        pickerView.keyView = UIApplication.shared.keyWindow
        pickerView.resultBlock = {[weak self] (selectDate, selectValue) in
            guard let self = self else { return }
            if let selectDate = selectDate {
                self.birthdaySelectDate = selectDate
                
                let dateStr = selectDate.xj.toformatterTimeString()
                self.dateButton.setTitle("日期：\(dateStr)", for: .normal)
            }
            print("resultBlock = \(selectValue ?? "")")
        }
    
        /// 年份背景
        let yearLabel = UILabel(frame: CGRect(x: 0, y: 44, width: self.view.width, height: 216))
        yearLabel.autoresizingMask = .flexibleWidth
        yearLabel.backgroundColor = UIColor.clear
        yearLabel.textAlignment = .center
        yearLabel.textColor = UIColor.lightGray.withAlphaComponent(0.2)
        yearLabel.font = UIFont.boldSystemFont(ofSize: 100)
        let yearString = "\(self.birthdaySelectDate.xj.year)"
        yearLabel.text = yearString
        pickerView.alertView?.addSubview(yearLabel)
        
        pickerView.changeBlock = { (selectDate, selectValue) in
            //print("changeBlock = \(selectDate)----\(selectValue)")
            if let selectDate = selectDate {
                yearLabel.text = "\(selectDate.xj.year)"
            } else {
                yearLabel.text = ""
            }
        }
        
        let customStyle = BRPickerStyle()
        customStyle.pickerColor = UIColor.clear
        customStyle.selectRowTextColor = UIColor.lightGray
        customStyle.alertViewColor = UIColor.white
        pickerView.pickerStyle = customStyle
        
        pickerView.show()
    }
    
    /// 地址选择
    func selectAddress() {
        let pickerView = BRAddressPickerView()
        pickerView.pickerMode = .area
        pickerView.title = "请选择地区"
        pickerView.selectIndexs = self.addressSelectIndexs
        pickerView.isAutoSelect = true
        pickerView.resultBlock = { [weak self] (province, city, area) in
            guard let self = self else { return }
            
            self.addressSelectIndexs = [NSNumber(value: province?.index ?? 0), NSNumber(value: city?.index ?? 0), NSNumber(value: area?.index ?? 0)]
            print("\(province?.name ?? "")--\(city?.name ?? "")--\(area?.name ?? "")")
            self.addressButton.setTitle("地址：\(province?.name ?? "")-\(city?.name ?? "")-\(area?.name ?? "")", for: .normal)
        }
        pickerView.show()
    }
}
