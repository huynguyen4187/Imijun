//
//  AIMDescriptionScreeenViewController.swift
//  Imijun
//
//  Created by Jonny Chinh Tran on 7/20/16.
//  Copyright © 2016 ARIS-VN. All rights reserved.
//

import UIKit

class AIMDescriptionScreeenViewController: AIMBaseViewController {

//    @IBOutlet weak var labelTitleChapter: UILabel!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var tvDescriptionWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var outletButtonStart: AIMButtonCommon!
    var currentChapter: AIMChapter?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        outletButtonStart.layer.borderColor = AIMAppConstant.kBorderButtonBlueColor.cgColor
        // config custom navigation view

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 30.0
        paragraphStyle.maximumLineHeight = 28.0
        paragraphStyle.minimumLineHeight = 28.0

        let ats: NSDictionary = [NSAttributedString.Key.font: self.tvDescription.font!, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        self.tvDescription.attributedText = NSAttributedString.init(string: (currentChapter?.chapterDescription)!, attributes: ats as? [NSAttributedString.Key: AnyObject])

        let titleString = currentChapter?.title.replacingOccurrences(of: "\n　", with: "", options: .literal)
        // let titleString = currentChapter?.title.stringByReplacingOccurrencesOfString("\n　", withString: "", options: NSString.CompareOptions.LiteralSearch, range: nil)
        self.navi.lbTitle.text = titleString

        self.navi.rightButton.isHidden = true
        self.navi.lbSubTitle.isHidden = true

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let width = self.tvDescription.requiredAttributeWidth()
        self.tvDescriptionWidthConstraint.constant = width
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        AIMLogManager.sharedInstance.record(screenName: Log.ScreenName.ChapterDescription.rawValue, actionName: Log.ActionName.Display.rawValue, objectName: self.navi.lbTitle.text!, objectType: Log.ObjectKind.Screen.rawValue, boxResult: "-", result: Log.Resutl.Success.rawValue, questionType: Log.ChapterType.AplicationQuestion.rawValue, chapterNumber: String(Int((currentChapter?.index)!)! % 8 + Int((currentChapter?.index)!)! / 8), questionNumber: "-")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func leftButtonTap(sender: Any) {
        super.leftButtonTap(sender: sender)
        
        AIMLogManager.sharedInstance.record(screenName: Log.ScreenName.ChapterDescription.rawValue, actionName: Log.ActionName.Tap.rawValue, objectName: Log.ObjectName.BackButton.rawValue, objectType: Log.ObjectKind.Button.rawValue, boxResult: "-", result: Log.Resutl.Success.rawValue, questionType: Log.ChapterType.AplicationQuestion.rawValue, chapterNumber: String(Int((currentChapter?.index)!)! % 8 + Int((currentChapter?.index)!)! / 8), questionNumber: "-")
    }
    
    @IBAction func btnStartLearning(_ sender: Any) {
        AIMLogManager.sharedInstance.record(screenName: Log.ScreenName.ChapterDescription.rawValue, actionName: Log.ActionName.Tap.rawValue, objectName: Log.ObjectName.DescriptionScreenStartLearning.rawValue, objectType: Log.ObjectKind.Button.rawValue, boxResult: "-", result: Log.Resutl.Success.rawValue, questionType: Log.ChapterType.AplicationQuestion.rawValue, chapterNumber: String(Int((currentChapter?.index)!)! % 8 + Int((currentChapter?.index)!)! / 8), questionNumber: "-")
        
        self.performSegue(withIdentifier: AIMAppConstant.kDescriptionQuestionAnswer, sender: currentChapter)
    }
    
    

    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == AIMAppConstant.kDescriptionQuestionAnswer) {
            if let viewController: AIMQuestionAnswerScreenViewController = segue.destination as? AIMQuestionAnswerScreenViewController {
                viewController.currentChapter = sender as? AIMChapter
                viewController.chapterType = Log.ChapterType.AplicationQuestion
            }
        }
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//        if (segue.identifier == AIMAppConstant.kDescriptionQuestionAnswer) {
//            if let viewController: AIMQuestionAnswerScreenViewController = segue.destinationViewController as? AIMQuestionAnswerScreenViewController {
//                viewController.currentChapter = sender as? AIMChapter
//                viewController.chapterType = Log.ChapterType.AplicationQuestion
//            }
//        }
//    }

}
