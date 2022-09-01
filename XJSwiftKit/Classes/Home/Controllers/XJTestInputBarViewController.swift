//
//  XJTestInputBarViewController.swift
//  LeiFengHao
//
//  Created by xj on 2022/8/12.
//

import UIKit

class XJTestInputBarViewController: XJBaseViewController {
    
    // 富文本输入框
    let inputController: NDInputController = NDInputController()
    
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "富文本输入"

        label.font = UIFont.systemFont(ofSize: 30)
        label.text = "这里显示你输入的内容..."
        label.textColor = UIColor.black
        self.view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(30)
            make.height.equalTo(40)
        }
        
        inputController.view.frame = CGRect(x: 0, y: self.view.height - 49 - KHomeBarH, width: self.view.width, height: 49 + KHomeBarH)
        inputController.view.autoresizingMask = .flexibleTopMargin
        inputController.delegate = self
        
        inputController.type = 1
        addChild(inputController)
        view.addSubview(self.inputController.view)
        inputController.inputBar.placeholderText = "评论:"
        inputController.status = .status_Input
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func tapAction(_ gesture: UITapGestureRecognizer) {
        self.inputController.reset()
        self.view.endEditing(true)
    }

}
extension XJTestInputBarViewController: NDInputControllerDelegate {
    
    func inputController(_ inputController: NDInputController!, didChangeHeight height: CGFloat) {
        print("didChangeHeight height === \(height)")

//        var tableFrame: CGRect = self.view.frame
//        print("tableFrame111 = \(tableFrame)")
//        tableFrame.size.height = self.view.height - height
//        print("tableFrame222 = \(tableFrame)")

        var inputFrame = self.inputController.view.frame
        inputFrame.origin.y = self.view.height - height
        inputFrame.size.height = height
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.inputController.view.frame = inputFrame
        }) { finish in
          
        }
    }
    
    // 发现消息
    func inputController(_ inputController: NDInputController!, didSendMessage msg: String?) {
        guard let message = msg else { return }
        
        print("message = \(message)")
        
        let attr = NDEmojiAttributedString.formatMessageString(with: message, withTextFont: self.label.font)
        self.label.attributedText = attr
    }
    
    
    func inputController(_ inputController: NDInputController!, didSelect cell: NDInputMoreCell!) {
        print("didSelect cell === \(cell!)")
    }
}

// 点击子视图不响应父视图的事件
extension XJTestInputBarViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // 是inputController.view子视图
        if touch.view?.isDescendant(of: self.inputController.view) ?? false {
            return false
        }
        return true
    }
}
