//
//  UIView+Extensions.swift
//  Shukatsu
//
//  Created by Nguyễn Tiến Đạt on 4/28/16.
//  Copyright © 2016 Aris VN. All rights reserved.
//
import UIKit

extension UIView {

	func setBorderColorAndBorderWidth(borderWidth: CGFloat, color: UIColor) {

		self.layer.borderWidth = borderWidth
        self.layer.borderColor = color.cgColor
		self.clipsToBounds = true 
	}
    
    func animationToleftDelayAndToRightWhenFinish(contraint : NSLayoutConstraint) {
        contraint.constant = -self.frame.size.width
        UIView .animate(withDuration: 0.5, animations: {
            self.superview?.layoutIfNeeded()
        }, completion: { _ in
            contraint.constant = 0
            UIView .animate(withDuration: 0.5, animations: {
                self.superview?.layoutIfNeeded()
            })
        })
    }
}
