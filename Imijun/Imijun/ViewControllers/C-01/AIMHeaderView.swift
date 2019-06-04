//
//  AIMHeaderView.swift
//  Imijun
//
//  Created by khoa.vt on 8/24/16.
//  Copyright © 2016 ARIS-VN. All rights reserved.
//

import UIKit

class AIMHeaderView: UITableViewHeaderFooterView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var marginRightContraint: NSLayoutConstraint!
    @IBOutlet weak var marginLeftContraint: NSLayoutConstraint!
    @IBOutlet weak var marginTop: NSLayoutConstraint!
    @IBOutlet weak var marginBottom: NSLayoutConstraint!
    
    override func awakeFromNib() {
        
        backgroundView = UIView()
        //backgroundView?.backgroundColor = UIColor.init(colorLiteralRed: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        backgroundView?.backgroundColor = UIColor.init(red: 229.0/255, green: 229.0/255, blue: 229.0/255, alpha: 1)
    }

}
