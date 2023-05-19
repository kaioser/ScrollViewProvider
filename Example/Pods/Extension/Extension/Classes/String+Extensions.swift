//
//  String+Extensions.swift
//  XKExtension
//
//  Created by 杨雄凯 on 2023/3/21.
//

public extension String {
    
    /// url编码
    var urlEscaped: String {
        self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}
