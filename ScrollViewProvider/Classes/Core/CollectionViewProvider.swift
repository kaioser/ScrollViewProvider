//
//  CollectionViewProvider.swift
//  ScrollViewProvider
//
//  Created by 杨雄凯 on 2023/5/19.
//

import UIKit
import SnapKit

// MARK: - 方法声明 + 默认实现

public protocol CollectionViewProvider where Self: ScrollViewProvider & UICollectionViewDelegate & UICollectionViewDataSource {
    
    /// 提供collectionView初始化时的布局模型（只执行一次）
    /// - Returns: 布局
    func collectionViewInitLayout() -> UICollectionViewLayout
    
    /// 提供需要注册的cell（内部会进行注册）
    /// - Returns: cell类型集合
    func collectionViewCells() -> [CollectionViewCellProvider]
    
    /// 提供需要注册的sectionHeader和sectionFooter（内部会进行注册），默认为空
    /// - Returns: header和footer集合
    func collectionViewHeaderFooter() -> [CollectionViewHeaderFooterProvider]
}

public extension CollectionViewProvider {
    func collectionViewHeaderFooter() -> [CollectionViewHeaderFooterProvider] { [] }
}

// MARK: - 可供外部调用

public extension CollectionViewProvider {
    
    /// 当前collectionView
    var collectionView: UICollectionView {
        if let c = collection { return c }
        fatalError("请在viewDidLoad中执行initializeCollectionView方法")
    }
    
    /// 初始化collectionView（遵守协议者写在viewDidLoad中）
    /// - Parameter additionWay: 布局方式
    func initializeCollectionView() {
        if isRootView {
            // 本身根视图就是UICollectionView的情况，直接啥也不做，相当于没有遵守此协议
            return
        }
        
        let c: UICollectionView = allocView()
        
        let cells = collectionViewCells()//registerCellClasses(in: t)
        cells.forEach { c.register($0.type, forCellWithReuseIdentifier: $0.iden) }
        
        let headerFooters = collectionViewHeaderFooter()
        headerFooters.forEach {
            let kind = $0.kind == .header ? UICollectionElementKindSectionHeader : UICollectionElementKindSectionFooter
            c.register($0.type, forSupplementaryViewOfKind: kind, withReuseIdentifier: $0.iden)
        }
        
        let fatherView = scrollViewSuperview()
        fatherView.addSubview(c)
        if let f = scrollViewFrame() {
            c.frame = f
        } else {
            c.snp.makeConstraints { make in
                make.edges.equalTo(scrollViewEdgeInsets())
            }
        }
    }
}

// MARK: - 私有方法

private extension CollectionViewProvider {
    
    var isRootView: Bool {
        if let _ = self as? UICollectionViewController {
            return true
        }
        return false
    }
    
    var collection: UICollectionView? {
        if let self = self as? UICollectionViewController {
            // 本身根视图就是collectionView了，直接return
            return self.collectionView
        }
        
        return scrollViewSuperview().viewWithTag(kCollectionViewTag) as? UICollectionView
    }
    
    func allocView() -> UICollectionView {
        let v = UICollectionView(frame: .zero, collectionViewLayout: collectionViewInitLayout())
        v.delegate = self
        v.dataSource = self
        v.tag = kCollectionViewTag
        return v
    }
}

private let kCollectionViewTag: Int = 931031
