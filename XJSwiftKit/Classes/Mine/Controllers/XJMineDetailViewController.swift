//
//  XJMineDetailViewController.swift
//  ShiJianYun
//
//  Created by xj on 2022/3/14.
//

import UIKit

class XJMineDetailViewController: XJBaseViewController {
    
    var titleName: String = ""

    convenience init(_ title: String) {
        self.init(nibName: nil, bundle: nil)
        self.titleName = title
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = titleName
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
