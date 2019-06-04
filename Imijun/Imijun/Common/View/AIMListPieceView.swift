//
//  AIMListPieceView.swift
//  Imijun
//
//  Created by khoa.vt on 7/21/16.
//  Copyright © 2016 ARIS-VN. All rights reserved.
//

import UIKit
import RealmSwift

@objc protocol AIMListPieceViewDelegate: NSObjectProtocol {
    @objc optional func choosePieceView(touches: Set<UITouch>, pieceView: AIMPieceView)
    @objc optional func movedChoosePieceView(touches: Set<UITouch>, pieceView: AIMPieceView)
    @objc optional func endMovedChoosePieceView(touches: Set<UITouch>, pieceView: AIMPieceView)
    @objc optional func pressedEnglishHintButton()

}

class AIMListPieceView: UIView {

    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */

    @IBOutlet weak var englishHintButton: AIMButtonCommon!
    @IBOutlet weak var scrollView: UIScrollView!
    var answerList: List<AIMPiece>?
    var hintList: List<AIMPiece>?
    var pieceViewArray = NSMutableArray()
    var hintLabelArray = NSMutableArray()
    weak var delegate: AIMListPieceViewDelegate?

    class func loadFromNibWithBundle(bundle: Bundle? = nil) -> AIMListPieceView? {
        let x = UINib(
            nibName: "AIMListPieceView",
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? AIMListPieceView

        x!.englishHintButton.layer.borderColor = AIMAppConstant.kBorderButtonBlueColor.cgColor

        return x
    }

    override init (frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }

    func setData(answers: List<AIMPiece>, hints: List<AIMPiece>) {

        self.answerList = answers
        self.hintList = hints

        let answerArray = NSMutableArray()
        let indexArray = NSMutableArray()
        var i = 0
        for item in answers {
            if( item.content.trimmingCharacters(in: .whitespaces)).count > 0 {
            // if (item.content.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())).characters.count > 0 {
                answerArray.add(item)
                indexArray.add(i)
            }
            i = i + 1

        }

        var index: Int = 0
        var contentWidth: CGFloat = 0

        while answerArray.count > 0 {

            let indexRandom = Int(arc4random_uniform(UInt32(answerArray.count)))
//            print(indexRandom)

            let answer = answerArray[indexRandom] as! AIMPiece

            let answerView: AIMPieceView?

            answerView = AIMPieceView.loadFromNibWithIndex(patternIndex: indexArray[indexRandom] as! Int, index: index, hintIdex: index)
            answerView?.delegate = self
            self.scrollView.addSubview(answerView! as UIView)
            self.pieceViewArray.add(answerView!)

            answerView?.setData(piece: answer)
            contentWidth = contentWidth + CGFloat(AIMAppConstant.kAIMPieceViewHorizontalPadding)
//            answerView?.frame = CGRectMake(contentWidth, self.scrollView.frame.size.height / 2 - AIMAppConstant.kAIMPieceViewFrame.size.height / 2 - 20, (answerView?.frame.size.width)!, AIMAppConstant.kAIMPieceViewFrame.size.height)
            answerView?.frame = CGRect.init(x: contentWidth, y: self.scrollView.frame.size.height / 2 - AIMAppConstant.kAIMPieceViewFrame.size.height / 2 - 20, width: (answerView?.frame.size.width)!, height: AIMAppConstant.kAIMPieceViewFrame.size.height)

//            let textView = UITextView(frame: CGRectMake(contentWidth, self.scrollView.frame.size.height / 2 + 20, (answerView?.frame.size.width)!, AIMAppConstant.kAIMPieceViewFrame.size.height))
            let textView = UITextView(frame: CGRect.init(x:contentWidth, y: self.scrollView.frame.size.height / 2 + 20, width: (answerView?.frame.size.width)!,  height: AIMAppConstant.kAIMPieceViewFrame.size.height))
            textView.font = answerView?.contentLabel.font
            textView.isUserInteractionEnabled = false
            textView.text = hintList![indexArray[indexRandom] as! Int].content
            textView.isHidden = true
            textView.textAlignment = NSTextAlignment.center
            textView.textColor = AIMAppConstant.kHintTextGrayColor
            hintLabelArray.add(textView)
            self.scrollView.addSubview(textView)

            contentWidth = contentWidth + (answerView?.frame.size.width)!
            answerView?.isHidden = false
            index = index + 1

            answerArray.removeObject(at: indexRandom)
            indexArray.removeObject(at: indexRandom)

        }

        // self.scrollView.contentSize = CGSizeMake(contentWidth + CGFloat(AIMAppConstant.kAIMPieceViewHorizontalPadding), self.scrollView.frame.size.height)
        self.scrollView.contentSize = CGSize.init(width: contentWidth + CGFloat(AIMAppConstant.kAIMPieceViewHorizontalPadding), height: self.scrollView.frame.size.height)
    }

    func reRender() {

        var contentWidth: CGFloat = 0

        var index: Int = 0

        for item in self.pieceViewArray {
            let answerView = item as? AIMPieceView
            answerView?.hintIndex = index
            if answerView?.isHidden == false {

                contentWidth = contentWidth + CGFloat(AIMAppConstant.kAIMPieceViewHorizontalPadding)
                UIImageView.animate(withDuration: 0.5, animations: {
//                    answerView?.frame = CGRectMake(contentWidth, self.scrollView.frame.size.height / 2 - AIMAppConstant.kAIMPieceViewFrame.size.height / 2 - 20, (answerView?.frame.size.width)!, AIMAppConstant.kAIMPieceViewFrame.size.height)
                    
                    answerView?.frame = CGRect.init(x: contentWidth, y: self.scrollView.frame.size.height / 2 - AIMAppConstant.kAIMPieceViewFrame.size.height / 2 - 20, width: (answerView?.frame.size.width)!, height: AIMAppConstant.kAIMPieceViewFrame.size.height)
                    
                    }, completion: nil)

                let textView = hintLabelArray[index] as! UITextView
//                textView.frame = CGRectMake(contentWidth, self.scrollView.frame.size.height / 2 + 20, (answerView?.frame.size.width)!, AIMAppConstant.kAIMPieceViewFrame.size.height)
                textView.frame = CGRect.init(x: contentWidth, y: self.scrollView.frame.size.height / 2 + 20, width: (answerView?.frame.size.width)!, height: AIMAppConstant.kAIMPieceViewFrame.size.height)

                contentWidth = contentWidth + (answerView?.frame.size.width)!

            }

            index = index + 1
        }

        // self.scrollView.contentSize = CGSizeMake(contentWidth + CGFloat(AIMAppConstant.kAIMPieceViewHorizontalPadding), self.scrollView.frame.size.height)
        self.scrollView.contentSize = CGSize.init(width: contentWidth + CGFloat(AIMAppConstant.kAIMPieceViewHorizontalPadding), height: self.scrollView.frame.size.height)
    }

    func removePiece(pieceView: AIMPieceView) {
        self.pieceViewArray.remove(pieceView)
        pieceView.removeFromSuperview()

        let textView = hintLabelArray[pieceView.hintIndex] as! UITextView
        hintLabelArray.remove(textView)

        textView.removeFromSuperview()

    }

    func countPieceAnswer() -> Int {

        return self.pieceViewArray.count
    }

    func hideAnwserView() {

        var frame = self.frame

        frame.origin.y = frame.origin.y + self.scrollView.frame.size.height - 10

        self.frame = frame

        self.englishHintButton.layer.borderColor = AIMAppConstant.kGrayColor.cgColor
        // self.englishHintButton.setTitleColor(AIMAppConstant.kGrayColor, forState: UIControl.State.Normal)
        self.englishHintButton.setTitleColor(AIMAppConstant.kGrayColor, for: .normal)
        self.englishHintButton.isUserInteractionEnabled = false

    }

    func showHint(show: Bool) {
        for item in hintLabelArray {
            let textView = item as! UITextView
            textView.isHidden = !show
        }
    }

    @IBAction func btnShowEnglishHint(_ sender: Any) {
        if englishHintButton.btnSelected {
            return
        }
        englishHintButton.btnSelected = true
        
        print("hint");
        
        self.showHint(show: true)
        self.delegate?.pressedEnglishHintButton!()
    }
    
    
    @IBAction func showEnglishTextPattern(_ sender: Any) {
        if !englishHintButton.btnSelected {
        return
        }
        englishHintButton.btnSelected = false
        
        self.showHint(show: false)
    }
    
    
}

extension AIMListPieceView: AIMPieceViewDelegate {

    func tapAIMPieceView(touches: Set<UITouch>, pieceView: AIMPieceView) {
        self.scrollView.isUserInteractionEnabled = false
        self.scrollView.isScrollEnabled = false
        self.delegate?.choosePieceView!(touches: touches, pieceView: pieceView)
    }

    func movedAIMPieceView(touches: Set<UITouch>, pieceView: AIMPieceView) {
        self.delegate?.movedChoosePieceView!(touches: touches, pieceView: pieceView)
    }

    func endMovedAIMPieceView(touches: Set<UITouch>, pieceView: AIMPieceView) {

        self.delegate?.endMovedChoosePieceView!(touches: touches, pieceView: pieceView)
        self.scrollView.isUserInteractionEnabled = true
        self.scrollView.isScrollEnabled = true
    }
}
