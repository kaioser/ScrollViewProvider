//
//  CollectionViewCellProvider.swift
//  ScrollViewProvider
//
//  Created by 杨雄凯 on 2023/5/19.
//

import UIKit

public struct CollectionViewCellProvider {
    public var type: UICollectionViewCell.Type
    public var iden: String
    
    // tips: 一个模块内部的结构体必须手动实现init方法才能被外部初始化使用
    public init(type: UICollectionViewCell.Type, iden: String) {
        self.type = type
        self.iden = iden
    }
}

public struct CollectionViewHeaderFooterProvider {
    public enum Kind {
        case header
        case footer
    }
    
    var type: UICollectionReusableView.Type
    var iden: String
    var kind: Kind
    
    public init(type: UICollectionReusableView.Type, iden: String, kind: Kind) {
        self.type = type
        self.iden = iden
        self.kind = kind
    }
}
