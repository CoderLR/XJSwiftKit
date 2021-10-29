//
//  XJTestLandspaceController.swift
//  XJSwiftKit
//
//  Created by Mr.Yang on 2021/10/26.
//

import UIKit
import SnapKit
import RxSwift

class XJTestLandspaceController: XJBaseViewController {

    let disposeBag = DisposeBag()
    var closeBtn: UIButton!
    var landscapeBtn: UIButton!
    var portraitBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.rotateLandscapeOrientation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.rotatePortraitOrientation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "横屏"
        self.view.backgroundColor = UIColor.white
        
        closeBtn = UIButton.xj.create(bgColor: UIColor.red, title: "关闭", titleColor: UIColor.white, font: 16)
        self.view.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 80, height: 40))
            make.left.equalTo(100)
            make.top.equalTo(100)
        }
        closeBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.dismissVC()
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        
        landscapeBtn = UIButton.xj.create(bgColor: UIColor.red, title: "横屏", titleColor: UIColor.white, font: 16)
        self.view.addSubview(landscapeBtn)
        landscapeBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 80, height: 40))
            make.left.equalTo(100)
            make.top.equalTo(closeBtn.snp.bottom).offset(20)
        }
        landscapeBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.rotateLandscapeOrientation()
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        portraitBtn = UIButton.xj.create(bgColor: UIColor.red, title: "竖屏", titleColor: UIColor.white, font: 16)
        self.view.addSubview(portraitBtn)
        portraitBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 80, height: 40))
            make.left.equalTo(100)
            make.top.equalTo(landscapeBtn.snp.bottom).offset(20)
        }
        portraitBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.rotatePortraitOrientation()
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        print("viewWillLayoutSubviews-\(self.view.frame)")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print("viewWillTransition-\(self.view.frame)")
        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

}
