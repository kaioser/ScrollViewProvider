//
//  TableViewCellProvider.swift
//  ScrollViewProvider
//
//  Created by 杨雄凯 on 2023/5/19.
//

import UIKit

public struct TableViewCellProvider {
    public var type: UITableViewCell.Type
    public var iden: String
    
    // tips: 一个模块内部的结构体必须手动实现init方法才能被外部初始化使用
    public init(type: UITableViewCell.Type, iden: String) {
        self.type = type
        self.iden = iden
    }
}

public struct TableViewSectionHeaderFooterProvider {
    var type: UITableViewHeaderFooterView.Type
    var iden: String
    
    public init(type: UITableViewHeaderFooterView.Type, iden: String) {
        self.type = type
        self.iden = iden
    }
}
