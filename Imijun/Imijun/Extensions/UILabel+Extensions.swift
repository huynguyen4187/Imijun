//
//  UILabel+Extensions.swift
//  Shukatsu
//
//  Created by Đạt Nguyễn Tiến on 5/10/16.
//  Copyright © 2016 khoa.vt. All rights reserved.
//

import UIKit

extension UILabel {
    func requireWidth() -> CGFloat {
        
        let label: UILabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: frame.height))
//        label.numberOfLines = 0
//        label.lineBreakMode = lineBreakMode
        label.font = font
        label.text = text

        label.sizeToFit()
        return label.frame.width
    }

    func requiredAttributeWidth() -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: frame.height))
        label.numberOfLines = 0
        label.lineBreakMode = lineBreakMode
        label.font = font
        label.attributedText = attributedText

        label.sizeToFit()
        return label.frame.width
    }

    func setSizeFont (sizeFont: CGFloat) {
        font = UIFont(name: font.fontName, size: sizeFont)!
        sizeToFit()
    }
    
}
