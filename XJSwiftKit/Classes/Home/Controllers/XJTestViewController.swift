//
//  XJTestViewController.swift
//  XJSwiftKit
//
//  Created by Mr.Yang on 2021/10/25.
//

import UIKit
import SnapKit

class XJTestViewController: XJBaseViewController {
    
    var titleName: String = String()
    
    var titleLabel = UILabel()
//    fileprivate lazy var titleLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 20)
//        label.textColor = UIColor.red
//        label.textAlignment = .center
//        label.text = self.titleName
//        return label
//    }()
    
    convenience init(titleName: String) {
        self.init()
        self.titleName = titleName
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.randomColor

        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = UIColor.red
        titleLabel.textAlignment = .center
        titleLabel.text = self.titleName
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
