//
//  AIMMainScreenViewController.swift
//  Imijun
//
//  Created by Jonny Chinh Tran on 7/20/16.
//  Copyright © 2016 ARIS-VN. All rights reserved.
//

import UIKit

enum TagButton: Int {
    case StartLearning = 1
    case LearningAndUse = 2
    case About = 3
}

class AIMMainScreenViewController: AIMBaseViewController {

    @IBOutlet weak var btnStartLearning: AIMButtonCommon!
    @IBOutlet weak var btnLearningAndUse: AIMButtonCommon!
    @IBOutlet weak var btnAbout: AIMButtonCommon!
    @IBOutlet weak var splashScreenImageView: UIImageView!

    var gotoAboutScreen: Bool = false

    override func viewDidLoad() {
//        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.btnStartLearning.isExclusiveTouch = true;
        self.btnLearningAndUse.isExclusiveTouch = true;
        self.btnAbout.isExclusiveTouch = true;
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        AIMLogManager.sharedInstance.record(screenName: Log.ScreenName.FirstScreen.rawValue, actionName: Log.ActionName.Display.rawValue, objectName: Log.ObjectName.Top.rawValue, objectType: Log.ObjectKind.Screen.rawValue, boxResult: "-", result: Log.Resutl.Success.rawValue, questionType: "-", chapterNumber: "-", questionNumber: "-")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if gotoAboutScreen {
            gotoAboutScreen = false
            UIView.animate(withDuration: 1.5, animations: {
                self.splashScreenImageView.alpha = 0
            }) { (finish) in
                self.splashScreenImageView.isHidden = true
            }
        }
        else {
            if !self.splashScreenImageView.isHidden {

                let delayInSeconds = 1.5
                DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
                    UIView.animate(withDuration: 1.5, animations: {
                        self.splashScreenImageView.alpha = 0
                    }) { (finish) in
                        self.splashScreenImageView.isHidden = true
                    }
                }
                
            }
        }

    }

    override func viewDidDisappear(_ animated: Bool) {
        if gotoAboutScreen {
            self.splashScreenImageView.image = UIImage(named: "About_Screen")
            self.splashScreenImageView.alpha = 1.0
            self.splashScreenImageView.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: action button tap
    @IBAction func btnStartLearning(sender: AnyObject) {

        AIMLogManager.sharedInstance.record(screenName: Log.ScreenName.FirstScreen.rawValue, actionName: Log.ActionName.Tap.rawValue, objectName: Log.ObjectName.FirstScreenStartLearning.rawValue, objectType: Log.ObjectKind.Button.rawValue, boxResult: "-", result: Log.Resutl.Success.rawValue, questionType: "-", chapterNumber: "-", questionNumber: "-")

        self.performSegue(withIdentifier: AIMAppConstant.kMainChoiceQuestion, sender: sender)

    }

    @IBAction func btnLearningAndUse(sender: AnyObject) {

    }

    @IBAction func btnAbout(sender: AnyObject) {

        gotoAboutScreen = true

    }

}

