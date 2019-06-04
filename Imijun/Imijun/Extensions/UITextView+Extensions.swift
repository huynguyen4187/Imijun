//
//  UITextView+Extensions.swift
//  Shukatsu
//
//  Created by Đạt Nguyễn Tiến on 5/10/16.
//  Copyright © 2016 khoa.vt. All rights reserved.
//

import UIKit

extension UITextView {
    func requireWidth() -> CGFloat {
        let textView: UITextView = UITextView(frame: CGRect.init(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: frame.height))

        textView.font = font
        textView.text = text

        textView.sizeToFit()
        return textView.frame.width
    }

    func requiredAttributeWidth() -> CGFloat {
        let textView: UITextView = UITextView(frame: CGRect.init(x: 0, y: 0,  width: CGFloat.greatestFiniteMagnitude, height: frame.height))

        textView.font = font
        textView.attributedText = attributedText

        textView.sizeToFit()
        return textView.frame.width
    }

    func setSizeFont (sizeFont: CGFloat) {
        font = UIFont(name: font!.fontName, size: sizeFont)!
        sizeToFit()
    }

}
