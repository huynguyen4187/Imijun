//
//  AIMTutorialViewController.swift
//  Imijun
//
//  Created by khoa.vt on 9/1/16.
//  Copyright © 2016 ARIS-VN. All rights reserved.
//

import UIKit

class AIMTutorialViewController: AIMBaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.navi.lbSubTitle.isHidden = true
        self.navi.rightButton.isHidden = true
        self.navi.lbTitle.text = AIMAppConstant.kTutorialTitle

        let imageView1: UIImageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 1024, height: 440))
        imageView1.image = UIImage(named: "Tutorial_1")
        self.scrollView.addSubview(imageView1)

        let imageView2: UIImageView = UIImageView(frame: CGRect.init(x:0, y: 440, width: 1024, height: 648))
        imageView2.image = UIImage(named: "Tutorial_2")
        self.scrollView.addSubview(imageView2)

        scrollView.contentSize = CGSize(width: 1024, height: 1088)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//        return UIInterfaceOrientationMask.Portrait
//    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
