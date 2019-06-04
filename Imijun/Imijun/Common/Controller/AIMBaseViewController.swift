//
//  AIMBaseViewController.swift
//  Imijun
//
//  Created by Jonny Chinh Tran on 7/20/16.
//  Copyright © 2016 ARIS-VN. All rights reserved.
//

import UIKit

class AIMBaseViewController: UIViewController {
    let navi : AIMNavigationBarCustom = UINib(nibName: "AIMNavigationBarCustom", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AIMNavigationBarCustom

    override func viewDidLoad() {
        super.viewDidLoad()
        //add custom navigation view
        self.view.addSubview(navi)
        navi.delegate = self
        self.navi.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(navi)
        
        let constLeading = NSLayoutConstraint(item: self.navi, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        let constTrailing = NSLayoutConstraint(item: self.navi, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: self.navi, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
        
        self.view.addConstraint(constLeading)
        self.view.addConstraint(constTrailing)
        self.view.addConstraint(top)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return .lightContent
//    }
}


extension AIMBaseViewController : AIMNavigationBarCustomDelegate {
    func leftButtonTap(sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func rightButtonTap(sender: Any) {
        
    }
}
