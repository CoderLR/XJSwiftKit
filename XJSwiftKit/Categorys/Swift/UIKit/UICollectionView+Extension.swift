//
//  UICollectionView+Extension.swift
//  ShiJianYun
//
//  Created by Mr.Yang on 2021/10/19.
//

import Foundation

// MARK: - Create
public extension XJExtension where Base: UICollectionView {
    
    /// UICollectionView创建
    /// - Parameters:
    ///   - bgColor: 背景颜色
    ///   - layout: 布局
    /// - Returns: UICollectionView
    static func create(bgColor: UIColor = UIColor.white,
                              layout: UICollectionViewFlowLayout) -> UICollectionView {
        let collectionView = UICollectionView()
        collectionView.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        return collectionView
    }
}

// MARK:- 二、滚动和注册
public extension XJExtension where Base: UICollectionView {
    
    // MARK: 2.1、是否滚动到顶部
    /// 是否滚动到顶部
    /// - Parameter animated: 是否要动画
    func scrollToTop(animated: Bool) {
        base.setContentOffset(CGPoint(x: 0, y: 0), animated: animated)
    }
    
    // MARK: 2.2、是否滚动到底部
    /// 是否滚动到底部
    /// - Parameter animated: 是否要动画
    func scrollToBottom(animated: Bool) {
        let y = base.contentSize.height - base.frame.size.height
        if y < 0 { return }
        base.setContentOffset(CGPoint(x: 0, y: y), animated: animated)
    }
    
    // MARK: 2.3、滚动到什么位置（CGPoint）
    /// 滚动到什么位置（CGPoint）
    /// - Parameter animated: 是否要动画
    func scrollToOffset(offsetX: CGFloat = 0, offsetY: CGFloat = 0, animated: Bool) {
        base.setContentOffset(CGPoint(x: offsetX, y: offsetY), animated: animated)
    }
    
    // MARK: 2.4、注册自定义cell
    /// 注册自定义cell
    /// - Parameter cellClass: UICollectionViewCell类型
    func register(cellClass: UICollectionViewCell.Type) {
        base.register(cellClass.self, forCellWithReuseIdentifier: cellClass.className)
    }
    
    // MARK: 2.5、注册Xib自定义cell
    /// 注册Xib自定义cell
    /// - Parameter nib: nib description
    func register(nib: UINib) {
        base.register(nib, forCellWithReuseIdentifier: nib.className)
    }
    
    // MARK: 2.6、创建UICollectionViewCell(注册后使用该方法)
    /// 创建UICollectionViewCell(注册后使用该方法)
    /// - Parameters:
    ///   - cellType: UICollectionViewCell类型
    ///   - indexPath: indexPath description
    /// - Returns: 返回UICollectionViewCell类型
    func dequeueReusableCell<T: UICollectionViewCell>(cellType: T.Type, cellForRowAt indexPath: IndexPath) -> T {
        return base.dequeueReusableCell(withReuseIdentifier: cellType.className, for: indexPath) as! T
    }
    
    // MARK: 2.7、注册自定义: Section 的Header或者Footer
    /// 注册自定义: Section 的Header或者Footer
    /// - Parameters:
    ///   - reusableView: UICollectionReusableView类
    ///   - elementKind: elementKind： header：UICollectionView.elementKindSectionHeader  还是 footer：UICollectionView.elementKindSectionFooter
    func registerCollectionReusableView(reusableView: UICollectionReusableView.Type, forSupplementaryViewOfKind elementKind: String) {
        base.register(reusableView.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: reusableView.className)
    }
    
    // MARK: 2.8、创建Section 的Header或者Footer(注册后使用该方法)
    /// 创建Section 的Header或者Footer(注册后使用该方法)
    /// - Parameters:
    ///   - reusableView: UICollectionReusableView类
    ///   - collectionView: collectionView
    ///   - elementKind:  header：UICollectionView.elementKindSectionHeader  还是 footer：UICollectionView.elementKindSectionFooter
    ///   - indexPath: indexPath description
    /// - Returns: 返回UICollectionReusableView类型
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(reusableView: T.Type, in collectionView: UICollectionView, ofKind elementKind: String, for indexPath: IndexPath) -> T {
        return collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: reusableView.className, for: indexPath) as! T
    }
}
