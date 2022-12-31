//
//  UIFont+.swift
//  OnandOff
//
//  Created by SangWoo's MacBook on 2022/12/31.
//

import UIKit

extension UIFont {
    enum Family: String {
        case Bold, Regular
    }
    
    static func notoSans(size: CGFloat = 14, family: Family = .Regular) -> UIFont {
        return UIFont(name: "NotoSans-\(family)", size: size) ?? UIFont()
    }
}
