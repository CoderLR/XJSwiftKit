//
//  UITabBarController+Extension.swift
//  ShiJianYun
//
//  Created by xj on 2022/3/16.
//

import Foundation

extension UITabBarController {

    private static let cacheKey = "tabBarIndex"

        public func cacheItemOrder(items: [UITabBarItem]) {
            UserDefaults.standard.set(
                [String: Int](uniqueKeysWithValues: items.enumerated().map { ($1.title ?? "", $0)}),
                forKey: UITabBarController.cacheKey
            )
        }

        public func restoreItemOrder() {
            guard let order = UserDefaults.standard.dictionary(forKey: UITabBarController.cacheKey) as? [String: Int] else {
                return
            }
            viewControllers?.sort { left, right in
                guard let leftIndex = left.title.flatMap({order[$0]}),
                      let rightIndex = right.title.flatMap({order[$0]}) else {
                    return false
                }
                return leftIndex < rightIndex
            }
        }
}
