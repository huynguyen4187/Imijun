//
//  AIMQuestionAnswerScreenViewController.swift
//  Imijun
//
//  Created by Jonny Chinh Tran on 7/20/16.
//  Copyright © 2016 ARIS-VN. All rights reserved.
//

import UIKit

class AIMQuestionAnswerScreenViewController: AIMBaseViewController {

    @IBOutlet weak var lbStaticTileOnQuestionView: UILabel!
    let previuosFrame = CGRect.init(x:-1024, y:108, width: 1024, height: 702)
    let currentFrame = CGRect.init(x:0, y:108,  width:1024,height:  702)
    let nextFrame = CGRect.init(x:1124, y:108, width:1024,height:  702)

    var currentChapter: AIMChapter?
    var currentPositionQuestion: NSInteger = 0
    var chapterType: Log.ChapterType?

    var currentQuestionContentView: AIMQuestionContentView?
    var soundManager:SoundManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        // config custom navigation view
        
        self.soundManager = SoundManager()
        
        let titleString = currentChapter?.title.replacingOccurrences(of: "\n　", with: "", options: .literal)
//        let titleString = currentChapter?.title.stringByReplacingOccurrencesOfString("\n　", withString: "", options: NSString.CompareOptions.LiteralSearch, range: nil)
        self.navi.lbTitle.text = titleString
        self.setDataOnGuiWhenSwitchQuestion(indexQuestion: currentPositionQuestion)
        lbStaticTileOnQuestionView.setBorderColorAndBorderWidth(borderWidth: AIMAppConstant.kBorderWidthButton, color: AIMAppConstant.kBlackColor)
        // Do any additional setup after loading the view.

        let questionContentView = AIMQuestionContentView.loadFromNib()
        questionContentView?.frame = currentFrame
        questionContentView?.delegate = self
        questionContentView!.setData(question: (self.currentChapter?.questions[self.currentPositionQuestion])!)
        questionContentView?.soundManager = self.soundManager
        
        self.view.addSubview(questionContentView!)
        
        self.currentQuestionContentView = questionContentView

        AIMLogManager.sharedInstance.record(screenName: Log.ScreenName.AnswerAndQuestion.rawValue, actionName: Log.ActionName.Display.rawValue, objectName: (self.currentChapter?.questions[currentPositionQuestion].content)!, objectType: Log.ObjectKind.Screen.rawValue, boxResult: "-", result: Log.Resutl.Success.rawValue, questionType: (chapterType?.rawValue)!, chapterNumber: String(Int((currentChapter?.index)!)! % 8 + Int((currentChapter?.index)!)! / 8), questionNumber: (currentChapter?.questions[currentPositionQuestion].index)!)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(AIMQuestionAnswerScreenViewController.cancelTouch), name: UIApplication.willResignActiveNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.bringSubviewToFront(currentQuestionContentView!)
    }

    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - action button tap
    override func rightButtonTap(sender: Any) {
        self.soundManager?.stop()
        if self.navi.rightButton.titleLabel?.text == AIMAppConstant.kNext || self.navi.rightButton.titleLabel?.text == AIMAppConstant.kSkip {
            
            var objectName = Log.ObjectName.SkipButton.rawValue
            if self.navi.rightButton.titleLabel?.text == AIMAppConstant.kNext {
                objectName = Log.ObjectName.NextButton.rawValue
            }
            AIMLogManager.sharedInstance.record(screenName: Log.ScreenName.AnswerAndQuestion.rawValue, actionName: Log.ActionName.Tap.rawValue, objectName: objectName, objectType: Log.ObjectKind.Button.rawValue, boxResult: "-", result: Log.Resutl.Success.rawValue, questionType: (chapterType?.rawValue)!, chapterNumber: String(Int((currentChapter?.index)!)! % 8 + Int((currentChapter?.index)!)! / 8), questionNumber: (currentChapter?.questions[currentPositionQuestion].index)!)
            
            currentPositionQuestion = currentPositionQuestion + 1
            self.setDataOnGuiWhenSwitchQuestion(indexQuestion: currentPositionQuestion)
            
            AIMLogManager.sharedInstance.record(screenName: Log.ScreenName.AnswerAndQuestion.rawValue, actionName: Log.ActionName.Display.rawValue, objectName: (self.currentChapter?.questions[currentPositionQuestion].content)!, objectType: Log.ObjectKind.Screen.rawValue, boxResult: "-", result: Log.Resutl.Success.rawValue, questionType: (chapterType?.rawValue)!, chapterNumber: String(Int((currentChapter?.index)!)! % 8 + Int((currentChapter?.index)!)! / 8), questionNumber: (currentChapter?.questions[currentPositionQuestion].index)!)
            
        } else {
            
            AIMLogManager.sharedInstance.record(screenName: Log.ScreenName.AnswerAndQuestion.rawValue, actionName: Log.ActionName.Tap.rawValue, objectName: Log.ObjectName.CloseButton.rawValue, objectType: Log.ObjectKind.Button.rawValue, boxResult: "-", result: Log.Resutl.Success.rawValue, questionType: (chapterType?.rawValue)!, chapterNumber: String(Int((currentChapter?.index)!)! % 8 + Int((currentChapter?.index)!)! / 8), questionNumber: (currentChapter?.questions[currentPositionQuestion].index)!)
            
            for vc in (self.navigationController?.viewControllers)! {
                if vc is AIMQuestionChoiceScreenViewController  {
                    self.navigationController?.popToViewController(vc, animated: true)
                    break
                }
            }
            
        }
    }
    
    
    override func leftButtonTap(sender: Any) {
        self.soundManager?.stop()
        
        AIMLogManager.sharedInstance.record(screenName: Log.ScreenName.AnswerAndQuestion.rawValue, actionName: Log.ActionName.Tap.rawValue, objectName: Log.ObjectName.BackButton.rawValue, objectType: Log.ObjectKind.Button.rawValue, boxResult: "-", result: Log.Resutl.Success.rawValue, questionType: (chapterType?.rawValue)!, chapterNumber: String(Int((currentChapter?.index)!)! % 8 + Int((currentChapter?.index)!)! / 8), questionNumber: (currentChapter?.questions[currentPositionQuestion].index)!)
        
        if currentPositionQuestion == 0 {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            currentPositionQuestion = currentPositionQuestion - 1
            self.navi.lbSubTitle.text = "Question " + String(Int((currentChapter?.index)!)! % 8 + Int((currentChapter?.index)!)! / 8) + "-" + (currentChapter?.questions[currentPositionQuestion].index)!
            self.switchPreviousQuestionAnimation(question: (self.currentChapter?.questions[currentPositionQuestion])!)
            AIMLogManager.sharedInstance.record(screenName: Log.ScreenName.AnswerAndQuestion.rawValue, actionName: Log.ActionName.Display.rawValue, objectName: (self.currentChapter?.questions[currentPositionQuestion].content)!, objectType: Log.ObjectKind.Screen.rawValue, boxResult: "-", result: Log.Resutl.Success.rawValue, questionType: (chapterType?.rawValue)!, chapterNumber: String(Int((currentChapter?.index)!)! % 8 + Int((currentChapter?.index)!)! / 8), questionNumber: (currentChapter?.questions[currentPositionQuestion].index)!)
        }
    }
  

    // MARK: - set date when switch question
    func setDataOnGuiWhenSwitchQuestion(indexQuestion: NSInteger) {
//        if indexQuestion >= (currentChapter?.questions.count)! - 1 {
//            self.navi.rightButton.setTitle(AIMAppConstant.kClose, forState: .Normal)
//        }

        self.navi.lbSubTitle.text = "Question " + String(Int((currentChapter?.index)!)! % 8 + Int((currentChapter?.index)!)! / 8) + "-" + (currentChapter?.questions[indexQuestion].index)!

        if indexQuestion > 0 {
            self.switchQuestionAnimation(question: (self.currentChapter?.questions[indexQuestion])!)
        }

    }

    func switchQuestionAnimation(question: AIMQuestion) {
        let questionContentView = AIMQuestionContentView.loadFromNib()
        questionContentView?.delegate = self
        questionContentView?.frame = nextFrame
        questionContentView!.setData(question: question)
        questionContentView?.soundManager = self.soundManager
        self.view.addSubview(questionContentView!)
        self.view.bringSubviewToFront(questionContentView!)
        if currentPositionQuestion >= (currentChapter?.questions.count)! - 1 {
            self.navi.rightButton.setTitle(AIMAppConstant.kClose, for: .normal)
            // self.navi.rightButton.setTitle(AIMAppConstant.kClose, forState: .Normal)
        } else {
            self.navi.rightButton.setTitle(AIMAppConstant.kSkip, for: .normal)
            // self.navi.rightButton.setTitle(AIMAppConstant.kSkip, forState: .Normal)
        }

        UIView.animate(withDuration: 0.5, animations: {
            self.currentQuestionContentView?.frame = self.previuosFrame
            questionContentView?.frame = self.currentFrame
        }) { (finish) in
            self.currentQuestionContentView?.removeFromSuperview()
            self.currentQuestionContentView = questionContentView

        }
    }

    func switchPreviousQuestionAnimation(question: AIMQuestion) {
        let questionContentView = AIMQuestionContentView.loadFromNib()
        questionContentView?.delegate = self
        questionContentView?.frame = previuosFrame
        questionContentView!.setData(question: question)
        questionContentView?.soundManager = self.soundManager
        self.view.addSubview(questionContentView!)
        self.view.bringSubviewToFront(questionContentView!)

        self.navi.rightButton.setTitle(AIMAppConstant.kSkip, for: .normal)

        UIView.animate(withDuration: 0.5, animations: {
            self.currentQuestionContentView?.frame = self.nextFrame
            questionContentView?.frame = self.currentFrame
        }) { (finish) in
            self.currentQuestionContentView?.removeFromSuperview()
            self.currentQuestionContentView = questionContentView

        }
    }

    @objc func cancelTouch() {
        self.currentQuestionContentView?.listPieceView?.showHint(show: false)
        self.currentQuestionContentView?.cancelTouch()
    }
}

extension AIMQuestionAnswerScreenViewController: AIMQuestionContentViewDelegate {
    func finishAtCurrentQuestion() {

        AIMLogManager.sharedInstance.record(screenName: Log.ScreenName.AnswerAndQuestion.rawValue, actionName: Log.ActionName.Display.rawValue, objectName: Log.ObjectName.ImijunBox.rawValue, objectType: Log.ObjectKind.ImijunBox.rawValue, boxResult: "-", result: Log.Resutl.Right.rawValue, questionType: (chapterType?.rawValue)!, chapterNumber: String(Int((currentChapter?.index)!)! % 8 + Int((currentChapter?.index)!)! / 8), questionNumber: (currentChapter?.questions[currentPositionQuestion].index)!)

        if currentPositionQuestion >= (currentChapter?.questions.count)! - 1 {
            self.navi.rightButton.setTitle(AIMAppConstant.kClose, for: .normal)
        } else {
            self.navi.rightButton.setTitle(AIMAppConstant.kNext, for: .normal)
        }
    }

    func endDragPiece(piece: AIMPieceView, patternPieceIndex: Int) {

        var result: Log.Resutl?
        let boxResult: String?

        if patternPieceIndex == -1 {
            result = Log.Resutl.Discontinuity
            boxResult = "-"

        }
        else if patternPieceIndex == piece.patternIndex {
            result = Log.Resutl.Right
            boxResult = "BOX" + String(piece.patternIndex + 1)

        }
        else {
            result = Log.Resutl.Wrong
            boxResult = "BOX" + String(patternPieceIndex + 1)
        }

        AIMLogManager.sharedInstance.record(screenName: Log.ScreenName.AnswerAndQuestion.rawValue, actionName: Log.ActionName.Drag.rawValue, objectName: piece.contentLabel.text!, objectType: Log.ObjectKind.Piece.rawValue + String(piece.index + 1), boxResult: boxResult!, result: (result?.rawValue)!, questionType: (chapterType?.rawValue)!, chapterNumber: String(Int((currentChapter?.index)!)! % 8 + Int((currentChapter?.index)!)! / 8), questionNumber: (currentChapter?.questions[currentPositionQuestion].index)!)

    }

    func pressedHintButton() {
        AIMLogManager.sharedInstance.record(screenName: Log.ScreenName.AnswerAndQuestion.rawValue, actionName: Log.ActionName.Tap.rawValue, objectName: Log.ObjectName.JapaneseHintButton.rawValue, objectType: Log.ObjectKind.Button.rawValue, boxResult: "-", result: Log.Resutl.Success.rawValue, questionType: (chapterType?.rawValue)!, chapterNumber: String(Int((currentChapter?.index)!)! % 8 + Int((currentChapter?.index)!)! / 8), questionNumber: (currentChapter?.questions[currentPositionQuestion].index)!)
    }

    func pressedEnglishHintButton() {
        AIMLogManager.sharedInstance.record(screenName: Log.ScreenName.AnswerAndQuestion.rawValue, actionName: Log.ActionName.Tap.rawValue, objectName: Log.ObjectName.EnglishHintButton.rawValue, objectType: Log.ObjectKind.Button.rawValue, boxResult: "-", result: Log.Resutl.Success.rawValue, questionType: (chapterType?.rawValue)!, chapterNumber: String(Int((currentChapter?.index)!)! % 8 + Int((currentChapter?.index)!)! / 8), questionNumber: (currentChapter?.questions[currentPositionQuestion].index)!)
    }

}
