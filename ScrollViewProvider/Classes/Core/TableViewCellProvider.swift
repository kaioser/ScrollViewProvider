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
