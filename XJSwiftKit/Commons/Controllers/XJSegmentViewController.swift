//
//  XJSegmentViewController.swift
//  XJSwiftKit
//
//  Created by Mr.Yang on 2021/10/25.
//

import UIKit
import SnapKit

enum XJSegmentMode {
    case normal // 标题不可滚动，设置太多会导致显示不全
    case scroll // 标题可以滚动，可设置多个
}

class XJSegmentViewController: XJBaseViewController {
    
    /// 偏移量
    fileprivate var lastOffsetX: CGFloat = 0
    
    /// 标题数组
    fileprivate var titleArray: [String] = [String]()
    
    /// 控制器数组
    fileprivate var childControllers: [UIViewController] = [UIViewController]()
    
    /// 显示模式
    fileprivate var segmentMode: XJSegmentMode = .normal
    
    /// segmentView
    fileprivate lazy var segmentView: XJSegmentView = {
        let segment = XJSegmentView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 40),
                                    segmentMode: self.segmentMode)
        segment.backgroundColor = UIColor.white
        segment.delegate = self
        return segment
    }()
    
    /// scrollView
    fileprivate lazy var scrollView: XJBaseScrollView = {
        let scroll = XJBaseScrollView(frame: CGRect(x: 0, y: 40, width: self.view.width, height: KScreenH - KNavBarH - 40))
        scroll.isPagingEnabled = true
        scroll.delegate = self
        scroll.bounces = false
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()

    /// 便携初始化
    /// - Parameters:
    ///   - titleArray: 标题数组
    ///   - childControllers: 控制器数组
    convenience init(titleArray: [String],
                     childControllers: [UIViewController],
                     segmentMode: XJSegmentMode = .normal) {
        self.init()
        
        self.titleArray = titleArray
        self.childControllers = childControllers
        self.segmentMode = segmentMode
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(segmentView)
        segmentView.titleArray = titleArray
        view.addSubview(scrollView)
        
        addChildControllers()
    }
}

// MARK: - Add
extension XJSegmentViewController {
    
    /// 添加子类控制器
    func addChildControllers() {
        scrollView.contentSize = CGSize(width: CGFloat(childControllers.count) * self.view.width, height: scrollView.height)
        // 把控制器视图添加到scrollview上
        for i in 0..<childControllers.count {
            let controller = childControllers[i]
            controller.view.frame = CGRect(x: CGFloat(i) * scrollView.width, y: 0, width: scrollView.width, height: scrollView.height)
            self.addChild(controller)
            scrollView.addSubview(controller.view)
        }
    }
    
    /// segmentController添加到父类控制器
    /// - Parameter viewController: 父类控制器
    func addToParentController(viewController: UIViewController) {
        viewController.view.addSubview(self.view)
        viewController.addChild(self)
    }
}

// MARK: - UIScrollViewDelegate
extension XJSegmentViewController: UIScrollViewDelegate {
    
    /// 开始拖拽
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastOffsetX = scrollView.contentOffset.x
    }
    
    /// 滚动中
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.width)
        let scrollX = scrollView.contentOffset.x - scrollView.width * CGFloat(index)
        let pacentage = scrollX / scrollView.width
        
        // 向后滚动
        if scrollView.contentOffset.x > lastOffsetX {
            //print("向后---\(scrollView.contentOffset.x)---\(lastOffsetX)---\(index)")
            segmentView.selectViewScroll(pacentage: pacentage, index: index, direction: .next)
        } else {
            //print("向前---\(scrollView.contentOffset.x)---\(lastOffsetX)---\(index)")
            segmentView.selectViewScroll(pacentage: 1 - pacentage, index: index + 1, direction: .previous)
        }
    }
    
    /// 结束减速
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = (scrollView.contentOffset.x + scrollView.width * 0.5) / scrollView.width
        segmentView.scrollToIndex(Int(index))
    }
}

// MARK: - XJSegmentViewDelegate
extension XJSegmentViewController: XJSegmentViewDelegate {
 
    func selectButtonIndex(_ index: Int) {
        // 滚动到置顶界面
        scrollView.contentOffset = CGPoint(x: CGFloat(index) * scrollView.width, y: 0)
    }
}

// MARK: - ScrollView支持侧滑返回
class XJBaseScrollView: UIScrollView {
    
    /// 是否支持多手势触发，返回YES，则可以多个手势一起触发方法，返回NO则为互斥.
    /// 是否允许多个手势识别器共同识别，一个控件的手势识别后是否阻断手势识别继续向下传播，默认返回NO；如果为YES，
    /// 响应者链上层对象触发手势识别后，如果下层对象也添加了手势并成功识别也会继续执行，否则上层对象识别后则不再继续传播
    /// 一句话总结就是此方法返回YES时，手势事件会一直往下传递，不论当前层次是否对该事件进行响应。
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.isPanBackAction(gestureRecognizer: gestureRecognizer) { return true }
        return false
    }
    
    /// 判断是否是全屏的返回手势
    func isPanBackAction(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        /// 在最左边时候 && 是pan手势 && 手势往右拖
        if self.contentOffset.x == 0 {
            if gestureRecognizer == self.panGestureRecognizer {
                /// 根据速度获取拖动方向
                let velocity = self.panGestureRecognizer.velocity(in: self.panGestureRecognizer.view)
                /// 手势向右滑动
                if velocity.x > 0 {
                    return true
                }
            }
        }
        return false
    }
    
    /// 如果是全屏的左滑返回,那么ScrollView的左滑就没用了,返回NO,让ScrollView的左滑失效
    /// 不写此方法的话,左滑时,那个ScrollView上的子视图也会跟着左滑的
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.isPanBackAction(gestureRecognizer: gestureRecognizer) { return false }
        return true
    }
}
