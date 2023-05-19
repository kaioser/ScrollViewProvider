//
//  UIColor+Extensions.swift
//  XKExtension
//
//  Created by 杨雄凯 on 2023/3/21.
//

public extension UIColor {
    
    /// 获取随机色
    static func random(_ alpha: CGFloat = 0.4) -> UIColor {
        return UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 0.4)
    }
}
