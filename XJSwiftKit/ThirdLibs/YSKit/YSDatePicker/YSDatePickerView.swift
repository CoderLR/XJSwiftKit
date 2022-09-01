//
//  YSDatePickerView.swift
//  LeiFengHao
//
//  Created by xj on 2021/10/19.
//

import UIKit

let KBgViewH = 240 + KHomeBarH

class YSDatePickerView: UIView {
    
    /// datePicker display mode
    public var mode: UIDatePicker.Mode = .date
    
    /// show setting date
    public var date: String = ""
    
    /// select date
    public var selectDate: String = ""
    
    /// formatter
    fileprivate var dateFormatter = DateFormatter()
    
    /// select callback
    public var selectDateBlock: ((_ date: String) -> ())?
    
    fileprivate lazy var bgView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: KScreenH, width: KScreenW, height: KBgViewH)
        view.backgroundColor = Color_FFFFFF_151515
        if filletScreen() {
            view.layer.cornerRadius = 5
            view.layer.masksToBounds = true
        }
        return view
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 60, y: 0, width: KScreenW - 120, height: 50)
        label.font = KLargeFont
        label.textColor = Color_666666_666666
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        label.text = "选择时间"
        return label
    }()
    
    fileprivate lazy var cancleBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(Color_666666_666666, for: .normal)
        btn.titleLabel?.font = KLargeFont
        btn.frame = CGRect(x: 0, y: 0, width: 60, height: 50)
        btn.addTarget(self, action: #selector(cancleBtnClick(_:)), for: .touchUpInside)
        return btn
    }()
    
    fileprivate lazy var sureBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(Color_System, for: .normal)
        btn.titleLabel?.font = KLargeFont
        btn.frame = CGRect(x: KScreenW - 60, y: 0, width: 60, height: 50)
        btn.addTarget(self, action: #selector(sureBtnClick(_:)), for: .touchUpInside)
        return btn
    }()
    
    fileprivate lazy var lineView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 50, width: KScreenW, height: 1)
        view.backgroundColor = Color_999999_999999
        return view
    }()
    
    fileprivate lazy var dataPicker: UIDatePicker = {
        let picker = UIDatePicker()
        /// 设置边框
        picker.layer.borderWidth = 1
        picker.layer.borderColor = Color_FFFFFF_151515.cgColor
        
        /// 设置颜色
        picker.setValue(Color_292A2D_DEDFDF, forKey: "textColor")
        
        picker.addTarget(self, action: #selector(dataPickerValueChange(_:)), for: .valueChanged)
        
        /// 设置模式
        picker.datePickerMode = self.mode
        
        /// 设置样式
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        
        /// 设置语言
        picker.locale = Locale(identifier: "zh_CN")
        
        /// 设置最大值
        //picker.maximumDate =
        /// 设置最小值
        //picker.minimumDate =
        
        /// 设置date
        if self.date == "" { self.date =  dateFormatter.string(from: Date())}
        if let setDate = dateFormatter.date(from: self.date) {
            picker.setDate(setDate, animated: false)
        }
        
        picker.frame = CGRect(x: 0, y: 50, width: KScreenW, height: KBgViewH - 50)
        
        return picker
    }()
    
    convenience init(mode: UIDatePicker.Mode,
                     date: String = "",
                     selectDateBlock: ((_ date: String) -> ())?) {
        self.init(frame: .zero)
        
        self.mode = mode
        self.date = date
        self.selectDateBlock = selectDateBlock
        
        if mode == .date {
            dateFormatter.dateFormat = "yyyy-MM-dd"
        } else if mode == .dateAndTime {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }

        self.frame = CGRect(x: 0, y: 0, width: KScreenW, height: KScreenH + KBgViewH)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        self.initGesture()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show() {
        showInView(UIApplication.shared.keyWindow!)
        
        addSubview(bgView)
        bgView.addSubview(cancleBtn)
        bgView.addSubview(titleLabel)
        bgView.addSubview(sureBtn)
        bgView.addSubview(dataPicker)
    }
}

// MARK: - Animation
extension YSDatePickerView {
    
    //// 点击手势
    func initGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        tap.delegate = self
        self.addGestureRecognizer(tap)
    }
    
    /// 在view上添加视图
    func showInView(_ view: UIView) {
        UIView.animate(withDuration: 0.25, animations: {
            var point = self.center
            point.y -= KBgViewH
            self.center = point
        }, completion: nil)
        view.addSubview(self)
    }
    
    /// 消失
    func dismiss() {
        UIView.animate(withDuration: 0.25, animations: {
            var point = self.center
            point.y += KBgViewH
            self.center = point
        }, completion: {(finish) in
            self.removeFromSuperview()
        })
    }
}

// MARK: - Action
extension YSDatePickerView {
    
    /// 点击
    @objc func tapGesture(_ gesture: UIGestureRecognizer) {
        self.dismiss()
    }
    
    /// 取消
    @objc func cancleBtnClick(_ btn: UIButton) {
        self.dismiss()
    }
    
    /// 确定
    @objc func sureBtnClick(_ btn: UIButton) {
        self.dismiss()
        
        let date = self.selectDate == "" ? self.date : self.selectDate
        if let selectDateBlock = selectDateBlock {
            selectDateBlock(date)
        }
    }
    
    /// 选择日期
    @objc func dataPickerValueChange(_ datePicker: UIDatePicker) {
        self.selectDate = self.dateFormatter.string(from: dataPicker.date)
    }
    
}

// MARK: - 点击子视图不响应父视图的事件
extension YSDatePickerView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // 是self.bgView子视图
        if touch.view?.isDescendant(of: self.bgView) ?? false {
            return false
        }
        return true
    }
}
