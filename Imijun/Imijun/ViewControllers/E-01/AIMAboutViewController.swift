//
//  AIMAboutViewController.swift
//  Imijun
//
//  Created by khoa.vt on 9/1/16.
//  Copyright © 2016 ARIS-VN. All rights reserved.
//

import UIKit

class AIMAboutViewController: UIViewController {

    @IBOutlet weak var backButton: AIMButtonCommon!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.view.bringSubviewToFront(self.backButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func backButtonPressed(_ sender: Any) {self.navigationController?.popViewController(animated: false)
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
