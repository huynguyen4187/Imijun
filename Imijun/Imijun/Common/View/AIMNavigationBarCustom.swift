//
//  AIMNavigationBarCustom.swift
//  Imijun
//
//  Created by Jonny Chinh Tran on 7/25/16.
//  Copyright © 2016 ARIS-VN. All rights reserved.
//

import UIKit

@objc protocol AIMNavigationBarCustomDelegate: NSObjectProtocol {
    @objc optional func leftButtonTap(sender: Any)
    @objc optional func rightButtonTap(sender: Any)
}

class AIMNavigationBarCustom: UIView {

    @IBOutlet weak var leftButton: AIMButtonCommon!
    @IBOutlet weak var rightButton: AIMButtonCommon!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubTitle: UILabel!
    
    weak var delegate: AIMNavigationBarCustomDelegate?
   
    @IBAction func leftButtonTap(_ sender: Any) {
         self.delegate?.leftButtonTap!(sender: sender)
    }
    
    @IBAction func rightButtonTap(_ sender: Any) {
        self.delegate?.rightButtonTap!(sender: sender)
    }
    
    
}

