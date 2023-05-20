//
//  ScrollViewProvider.swift
//  ScrollViewProvider
//
//  Created by 杨雄凯 on 2023/5/19.
//

import UIKit

// 不建议直接遵守使用，应该使用它的子协议
public protocol ScrollViewProvider {
    
    /// 提供ScrollView的父视图
    func scrollViewSuperview() -> UIView
    
    /// 提供外边距，默认zero，与scrollViewFrame互斥，实现其中一个就好，优先级比scrollViewFrame低
    func scrollViewEdgeInsets() -> UIEdgeInsets
    
    /// 提供frame，默认nil，与scrollViewEdgeInsets互斥，实现其中一个就好，优先级比scrollViewEdgeInsets高
    func scrollViewFrame() -> CGRect?
}

public extension ScrollViewProvider {
    
    func scrollViewEdgeInsets() -> UIEdgeInsets { .zero }
    
    func scrollViewFrame() -> CGRect? { nil }
}

public extension ScrollViewProvider where Self: UIViewController {
    func scrollViewSuperview() -> UIView { view }
}

public extension ScrollViewProvider where Self: UITableViewCell {
    func scrollViewSuperview() -> UIView { contentView }
}

public extension ScrollViewProvider where Self: UICollectionViewCell {
    func scrollViewSuperview() -> UIView { contentView }
}
