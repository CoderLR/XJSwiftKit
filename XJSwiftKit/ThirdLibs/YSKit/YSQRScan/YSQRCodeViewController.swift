//
//  YSQRCodeViewController.swift
//  XJSwiftKit
//
//  Created by Mr.Yang on 2021/10/21.
//

import UIKit

class YSQRCodeViewController: XJBaseViewController {
    
    typealias YSQRCodeScanBlock = ((_ isAvaild: Bool, _ url: String) -> ())
    
    /// 回调
    var qrCodeScanBlock: YSQRCodeScanBlock?
    
    /// 管理类
    fileprivate let manager = SGQRCodeManager()
    fileprivate var isSelectedFlashlightBtn: Bool = false
    
    /// 扫描视图
    lazy var scanView: SGQRCodeScanView = {
        let view = SGQRCodeScanView(frame: self.view.bounds)
        return view
    }()
    
    /// 提示label
    lazy var promptLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.frame = CGRect(x: 0, y: 0.73 * self.view.height, width: self.view.width, height: 25)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.white.withAlphaComponent(0.6)
        label.text = "将二维码/条码放入框内, 即可自动扫描"
        return label
    }()
    
    /// 闪光灯
    lazy var flashlightBtn: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0.5 * (self.view.width - 30), y: 0.6 * self.view.height, width: 30, height: 30)
        button.setBackgroundImage(UIImage(named: "qrcode_image_open"), for: .normal)
        button.setBackgroundImage(UIImage(named: "qrcode_image_close"), for: .selected)
        button.addTarget(self, action: #selector(flashlightBtnClick(_:)), for: .touchUpInside)
        return button
    }()
    
    /// 返回
    lazy var backBtn: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 15, y: KStatusBarH + 6, width: 32, height: 32)
        button.setBackgroundImage(UIImage(named: "qrcode_image_back"), for: .normal)
        button.addTarget(self, action: #selector(navBackBtnClick(_:)), for: .touchUpInside)
        return button
    }()
    
    /// 相册
    lazy var albumBtn: UIButton = {
        let button = UIButton()
        button.setTitle("相册", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.6), for: .normal)
        button.frame = CGRect(x: self.view.width - 50 - 15, y: KStatusBarH + 6, width: 50, height: 32)
        button.addTarget(self, action: #selector(albumBtnClick(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        manager.startRunningWith(before: nil, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.scanView.addTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.scanView.removeTimer()
        self.removeFlashlightBtn()
        // 在主线程执行会卡主线程造成延时
        DispatchQueue.global().async {
            self.manager.stopRunning()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.fd_prefersNavigationBarHidden = true
        
        setupQRCodeScan()
        view.addSubview(scanView)
        view.addSubview(promptLabel)
        view.addSubview(backBtn)
        view.addSubview(albumBtn)
    }

    deinit {
        self.removeScanningView()
    }
}

// MARK: - Scan
extension YSQRCodeViewController {
    
    /// 加载扫码view
    func setupQRCodeScan() {
        if !manager.isCameraDeviceRearAvailable() { return }
        
        manager.openLog = true
        manager.brightness = true
        
        manager.scan(with: self) { [weak self] (manager, result) in
            guard let self = self else { return }
            guard let url = result else {
                print("log: unrecognized qrcode")
                return
            }
            
            // 在主线程执行会卡主线程造成延时
            DispatchQueue.global().async {
                self.manager.stopRunning()
            }
            //manager?.playSoundName("")
            print("log: scan reslut = \(url)")
            if url.hasPrefix("http") {
                if let qrCodeScanBlock = self.qrCodeScanBlock {
                    qrCodeScanBlock(true, url)
                }
            } else {
                if let qrCodeScanBlock = self.qrCodeScanBlock {
                    qrCodeScanBlock(false, url)
                }
            }
        }
        
        manager.scan { [weak self] (manager, brightness) in
            guard let self = self else { return }
            if brightness < -1 {
                self.view.addSubview(self.flashlightBtn)
            } else {
                if !self.isSelectedFlashlightBtn {
                    self.removeFlashlightBtn()
                }
            }
        }
    }
    
    /// 移除扫码view
    fileprivate func removeScanningView() {
        self.scanView.removeTimer()
        self.scanView.removeFromSuperview()
    }
    
    /// 移除闪光灯按钮
    fileprivate func removeFlashlightBtn() {
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0.2) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.manager.turnOffFlashlight()
                self.isSelectedFlashlightBtn = false
                self.flashlightBtn.isSelected = false
                self.flashlightBtn.removeFromSuperview()
            }
        }
    }
    
    /// 闪光灯点击
    @objc func flashlightBtnClick(_ button: UIButton) {
        if button.isSelected == false {
            manager.turnOnFlashlight()
            self.isSelectedFlashlightBtn = true
            button.isSelected = true
        } else {
            self.removeFlashlightBtn()
        }
    }
    
    /// 返回按钮点击
    @objc func navBackBtnClick(_ button: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// 相册按钮点击
    @objc func albumBtnClick(_ button: UIButton) {
        
        manager.read { [weak self] (manager, result) in
            guard let self = self else { return }
            
            guard let url = result else {
                // 未识别到
                print("log: unrecognized qrcode")
                return;
            }
            print("log: scan reslut = \(url)")
            if url.hasPrefix("http") {
                if let qrCodeScanBlock = self.qrCodeScanBlock {
                    qrCodeScanBlock(true, url)
                }
            } else {
                if let qrCodeScanBlock = self.qrCodeScanBlock {
                    qrCodeScanBlock(false, url)
                }
            }
        }
        
        if manager.albumAuthorization  { scanView.removeTimer() }
        manager.albumDidCancel { [weak self] (manager) in
            guard let self = self else { return }
            self.scanView.addTimer()
        }
    }
}
