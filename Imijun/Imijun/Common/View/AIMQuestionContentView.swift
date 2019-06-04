//
//  AIMQuestionContentView.swift
//  Imijun
//
//  Created by khoa.vt on 7/25/16.
//  Copyright © 2016 ARIS-VN. All rights reserved.
//

import UIKit
@objc protocol AIMQuestionContentViewDelegate: NSObjectProtocol {
    func finishAtCurrentQuestion()
    func endDragPiece(piece: AIMPieceView, patternPieceIndex: Int)
    func pressedHintButton()
    func pressedEnglishHintButton()
}
class AIMQuestionContentView: UIView, AIMPatternPieceDelegate,AIMSoundManagerDelgate {
    
    var volumn:UIImageView?
    
    var backgroundViewHint:[UIView] = []
    var backgroundHide:[UIView] = []
    // PatternView frame
    // static let kPatternViewFrame = CGRectMake(0, 121, 1024, 301)
    static let kPatternViewFrame = CGRect.init(x: 0, y: 121, width:  1024, height:  301)

    // AnswerView frame
    static let kAnswerViewFrame = CGRect.init(x:0, y: 422, width:  1024, height:  245)

    static let imagex = UIImage(named: "piece9")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 55, bottom: 124, right: 60))
    static let image = UIImage(named: "blue_piece")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 40, bottom: 109, right: 45))
    static let image7 = UIImage(named: "blue_piece_a")!.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 40, bottom: 109, right: 45))
    static let image8 = UIImage(named: "blue_piece_b")!.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 40, bottom: 109, right: 45))

    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */

    @IBOutlet weak var outletButtonShowHint: AIMButtonCommon!
    @IBOutlet weak var labelQuestion: UILabel!
    
    weak var delegate: AIMQuestionContentViewDelegate?
    
    var currentSelectPieceView: AIMPieceView?
    var question: AIMQuestion?
    var listPieceView: AIMListPieceView?
    
    var listPatternPieceView: NSMutableArray = NSMutableArray()
    var listPatternPieceView2 : NSMutableArray = NSMutableArray()
    var centerfirtPoint: CGPoint?
    var currentSelectPieceViewOnScrollview: AIMPieceView?
    var deflowered: Bool = false
    var standardPatternWidth: CGFloat = 0
    var treasureImageView:UIImageView?
    var status : Bool = false
    
//    var animationPiece: UIImageView!
//    var animationAnswerCorrectQuestion: UIImageView!
    
    
    var soundManager:SoundManager?

    func audioPlayerDidFinishPlaying() {
        volumn?.removeFromSuperview()
    }
    
    class func loadFromNib() -> AIMQuestionContentView? {
        let x = UINib(
            nibName: "AIMQuestionContentView",
            bundle: nil
            ).instantiate(withOwner: nil, options: nil)[0] as? AIMQuestionContentView
        x!.labelQuestion.setBorderColorAndBorderWidth(borderWidth: AIMAppConstant.kBorderWidthButton, color: AIMAppConstant.kBlackColor)
        x!.outletButtonShowHint.layer.borderColor = AIMAppConstant.kBorderButtonBlueColor.cgColor
        
        return x
    }

    override init (frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setData(question: AIMQuestion) {
        self.question = question
        labelQuestion.text = "  " + question.content
        self.initAIMListPieceView(question: self.question!)
        self.initPatterView(pattern: (self.question?.pattern)!)
        
        if self.currentSelectPieceView == nil {
            self.currentSelectPieceView = AIMPieceView.loadFromNibWithIndex(patternIndex: 0, index: 0, hintIdex: 0)!
            self.addSubview(self.currentSelectPieceView!)
            self.currentSelectPieceView!.isHidden = true
            self.currentSelectPieceView!.backgroundImage.image = AIMQuestionContentView.image
            self.currentSelectPieceView?.contentTopConstraint.constant = 10
            self.currentSelectPieceView?.contentBottomConstraint.constant = 10
            self.currentSelectPieceView?.contentLabel.numberOfLines = 2
        }
    }
    
    
    
    
    
    func hintCase2(sender: Any) {
        
        let btn = sender as! UIButton
        btn.isSelected = !btn.isSelected
        for item in listPatternPieceView {
                    if  (item as! AIMPatternPiece).buttonIdea != btn {
                        (item as! AIMPatternPiece).buttonIdea.isSelected = false
                        if (item as! AIMPatternPiece).bacgroundImage?.image == AIMQuestionContentView.image7 {
                            (item as! AIMPatternPiece).bacgroundImage?.image = AIMQuestionContentView.image7
                        }else if (item as! AIMPatternPiece).bacgroundImage?.image == AIMQuestionContentView.image8 {
                            (item as! AIMPatternPiece).bacgroundImage?.image = AIMQuestionContentView.image8
                        }else if (item as! AIMPatternPiece).bacgroundImage?.image == AIMQuestionContentView.image {
                            (item as! AIMPatternPiece).bacgroundImage?.image = AIMQuestionContentView.image
                        }else {
                            (item as! AIMPatternPiece).setData(type: (btn.superview as! AIMPatternPiece).type)
                        }
                    }else{
                        continue
                    }
        }

        if btn.isSelected {
            (btn.superview as! AIMPatternPiece).buttonIdea.isSelected = true
            (btn.superview as! AIMPatternPiece).setSelectedData(type: (btn.superview as! AIMPatternPiece).type)
            self.initPatterView2(pattern: ((self.question?.pattern)!))
            for item in backgroundHide {
                item.isHidden = true
            }
            
            self.backgroundHide[btn.tag].isHidden = false
            
        }else{
            (btn.superview as! AIMPatternPiece).buttonIdea.isSelected = false
            (btn.superview as! AIMPatternPiece).setData(type: (btn.superview as! AIMPatternPiece).type)
            for item in listPatternPieceView2 {
                (item as! UIView).removeFromSuperview()
            }
           
            for item in backgroundViewHint{
                item.backgroundColor = UIColor.white
            }
            self.backgroundHide[btn.tag].isHidden = true
        }
    }

    @IBAction func btnShowHint(_ sender: Any) {
        if outletButtonShowHint.btnSelected {
            return
        }
        outletButtonShowHint.btnSelected = true
        
        for item in self.listPatternPieceView {
            let patternPiece = item as! AIMPatternPiece
            
            patternPiece.displayHintContent()
        }
        
        self.delegate?.pressedHintButton()
        print("hint");
    }
    
    

    @IBAction func showTextPattern(sender: Any) {
        
        if !outletButtonShowHint.btnSelected {
            return
        }
        outletButtonShowHint.btnSelected = false
        
        for item in self.listPatternPieceView {
            let patternPiece = item as! AIMPatternPiece

            if ((self.checkFinish()) == true) {
                patternPiece.displayCurrentContentWhenFinishDrag()
            } else {
                patternPiece.displayCurrentContent()
            }
        }
    }

    private func initAIMListPieceView(question: AIMQuestion) {
        self.listPieceView = AIMListPieceView.loadFromNibWithBundle(bundle: nil)
        self.listPieceView?.delegate = self
        self.listPieceView?.frame = AIMQuestionContentView.kAnswerViewFrame
        self.listPieceView?.setData(answers: (self.question!.answers), hints: (self.question?.hints)!)
        self.addSubview(listPieceView!)
    }

    private func initPatterView(pattern: AIMPattern) {

        let patternUIData = AIMAppConstant.kPatternUIData.object(at: Int(pattern.type)! - 1) as! NSDictionary
        
//        let row = patternUIData.objectForKey("row") as! Int
        
        let column = patternUIData.object(forKey: "column") as! Int
        let lisPatternPiece = patternUIData.object(forKey: "listPieceType") as! NSArray
        var i = 0
        for item in lisPatternPiece {
            let pieceType = item as! Int
            var frame = CGRect.zero
            var pieceViewWidth: CGFloat = 0
            switch pieceType {
            case 1, 3, 4:
                pieceViewWidth = CGFloat(AIMAppConstant.kPiece1Width)
                break
            case 2, 7, 8:
                pieceViewWidth = CGFloat(AIMAppConstant.kPiece2Width)
                break
            case 5:
                pieceViewWidth = CGFloat(AIMAppConstant.kPiece3Width)
                break
            default:
                pieceViewWidth = CGFloat(AIMAppConstant.kPiece1Width)
            }

            self.standardPatternWidth = pieceViewWidth

            var x: CGFloat = 0.0
            if i % column == 0 {
                x = CGFloat(AIMAppConstant.kPatternLeftMargin) + CGFloat(i) * pieceViewWidth + 150
            }
            else {

                x = 150 + CGFloat(AIMAppConstant.kPatternLeftMargin) + CGFloat(i) * (pieceViewWidth - CGFloat(AIMAppConstant.kPatternCoverSpace))
            }

            
//            frame = CGRectMake(x, CGFloat(i / column) * CGFloat(AIMAppConstant.kPieceHeigh) + CGFloat(AIMAppConstant.kPatternTopSpace), pieceViewWidth, CGFloat(AIMAppConstant.kPieceHeigh))
            
            frame = CGRect.init(x: x,y: CGFloat(i / column) * CGFloat(AIMAppConstant.kPieceHeigh) + CGFloat(AIMAppConstant.kPatternTopSpace), width: pieceViewWidth, height:  CGFloat(AIMAppConstant.kPieceHeigh))
            
            
            let pieceView = AIMPatternPiece.loadFromNib(frame: frame, patternPiece: pattern.imijunPattern[i], hintPiece: (question?.hints[i])!, pieceType: pieceType)
            pieceView.setData(type: pieceType)
            pieceView.buttonIdea.tag = i
            pieceView.delegate = self
            
           
            
            listPatternPieceView.add(pieceView)
            self.addSubview(pieceView)
            

            i = i + 1
        }

        
//        let dotImageView = UIImageView.init(frame: CGRectMake(self.frame.size.width - CGFloat(2 * AIMAppConstant.kPatternLeftMargin), CGFloat(i / column) * CGFloat(AIMAppConstant.kPieceHeigh) + CGFloat(AIMAppConstant.kPatternTopSpace) - 30, 30, 30))
        let dotImageView = UIImageView.init(frame: CGRect.init(x: self.frame.size.width - CGFloat(2 * AIMAppConstant.kPatternLeftMargin), y: CGFloat(i / column) * CGFloat(AIMAppConstant.kPieceHeigh) + CGFloat(AIMAppConstant.kPatternTopSpace) - 30, width:  30, height:  30))
        dotImageView.image = UIImage(named: "dot")
        self.addSubview(dotImageView)
        
        //let do treasureImageView
        treasureImageView = UIImageView.init(frame:CGRect(x:39, y: CGFloat(i / column) * CGFloat(AIMAppConstant.kPieceHeigh) + CGFloat(AIMAppConstant.kPatternTopSpace) - 109  , width: 109, height: 109))
        treasureImageView!.image = UIImage(named: "box")
        let tapTreasure = UITapGestureRecognizer(target: self, action: #selector(tapUnbox(tapGestureRecognizer:)))
        treasureImageView!.addGestureRecognizer(tapTreasure)
        treasureImageView!.isUserInteractionEnabled = true
        self.addSubview(treasureImageView!)
    }

    
    
    private func initPatterView2(pattern: AIMPattern) {

        let patternUIData = AIMAppConstant.kPatternUIData.object(at: Int(pattern.type)! - 1) as! NSDictionary

        //        let row = patternUIData.objectForKey("row") as! Int

        let column = patternUIData.object(forKey: "column") as! Int
        let lisPatternPiece = patternUIData.object(forKey: "listPieceType") as! NSArray
        var i = 0
        for item in lisPatternPiece {
            let pieceType = item as! Int
            var frame = CGRect.zero
            var pieceViewWidth: CGFloat = 0
            switch pieceType {
            case 1, 3, 4:
                pieceViewWidth = CGFloat(AIMAppConstant.kPiece1Width)
                break
            case 2, 7, 8:
                pieceViewWidth = CGFloat(AIMAppConstant.kPiece2Width)
                break
            case 5:
                pieceViewWidth = CGFloat(AIMAppConstant.kPiece3Width)
                break
            default:
                pieceViewWidth = CGFloat(AIMAppConstant.kPiece1Width)
            }

            self.standardPatternWidth = pieceViewWidth

            var x: CGFloat = 0.0
            if i % column == 0 {
                x = CGFloat(AIMAppConstant.kPatternLeftMargin) + CGFloat(i) * pieceViewWidth + 150
            }
            else {

                x = 150 + CGFloat(AIMAppConstant.kPatternLeftMargin) + CGFloat(i) * (pieceViewWidth - CGFloat(AIMAppConstant.kPatternCoverSpace))
            }


            //            frame = CGRectMake(x, CGFloat(i / column) * CGFloat(AIMAppConstant.kPieceHeigh) + CGFloat(AIMAppConstant.kPatternTopSpace), pieceViewWidth, CGFloat(AIMAppConstant.kPieceHeigh))

            frame = CGRect.init(x: x,y: CGFloat(i / column) * CGFloat(AIMAppConstant.kPieceHeigh) + CGFloat(AIMAppConstant.kPatternTopSpace) + 109, width: pieceViewWidth, height:  CGFloat(AIMAppConstant.kPieceHeigh))

            let pieceView = AIMPatternPiece.loadFromNib(frame: frame, patternPiece: pattern.imijunPattern[i], hintPiece: (question?.hints[i])!, pieceType: pieceType)
            
            pieceView.setData(type: pieceType)
            
            
            //backgroundView
            let frame1 = CGRect.init(x: x - 6 ,y: CGFloat(i / column) * CGFloat(AIMAppConstant.kPieceHeigh) + CGFloat(AIMAppConstant.kPatternTopSpace) + 105, width: pieceViewWidth  + 8 , height:  CGFloat(AIMAppConstant.kPieceHeigh) + 10)
            let backgroundView = UIView(frame: frame1)
            backgroundView.backgroundColor = UIColor(hexString: "F8E89E")
            self.addSubview(backgroundView)
            backgroundViewHint.append(backgroundView)
            
            //backgroundHide
            let framehide = CGRect.init(x: x  ,y: CGFloat(i / column) * CGFloat(AIMAppConstant.kPieceHeigh) + CGFloat(AIMAppConstant.kPatternTopSpace) + 99, width: 150, height:  6 )
            let backgroundhide = UIView(frame: framehide)
            backgroundhide.backgroundColor = UIColor(hexString: "F8E89E")
            self.addSubview(backgroundhide)
            backgroundhide.isHidden = true
            
            backgroundHide.append(backgroundhide)
            
            
            //add pieceview
            listPatternPieceView2.add(pieceView)
            pieceView.buttonIdea.tag = i
            self.addSubview(pieceView)

            i = i + 1
        }
    }
    @objc func tapUnbox(tapGestureRecognizer: UITapGestureRecognizer){
        treasureImageView!.image = UIImage(named: "unbox")
        
    }
    
    func checkFinish() -> Bool {
        if self.listPieceView!.countPieceAnswer() > 0 {
            return false
        }
        return true
    }

    func cancelTouch() {
        self.showTextPattern(sender: "" as AnyObject)
        if centerfirtPoint == nil {
            return
        }
        // when go to UIApplicationWillResignActiveNotification then set value like drag piece is wrong
        self.listPieceView?.isUserInteractionEnabled = false
        self.currentSelectPieceView!.center = self.centerfirtPoint!
        self.currentSelectPieceView!.transform = CGAffineTransform(scaleX: 1, y: 1);
        self.currentSelectPieceView?.isHidden = true
        if ((self.checkFinish()) == false) {
            self.currentSelectPieceViewOnScrollview!.isHidden = false
        }
        self.listPieceView?.isUserInteractionEnabled = true
        self.currentSelectPieceView!.transform =   CGAffineTransform.identity  //CGAffineTransformIdentity
        self.listPieceView!.scrollView.isUserInteractionEnabled = true
        self.listPieceView!.scrollView.isScrollEnabled = true
        centerfirtPoint = nil
    }
}

extension AIMQuestionContentView: AIMListPieceViewDelegate {

    func choosePieceView(touches: Set<UITouch>, pieceView: AIMPieceView) {

        self.currentSelectPieceView?.patternIndex = pieceView.patternIndex
        self.currentSelectPieceView?.index = pieceView.index
        self.currentSelectPieceView?.hintIndex = pieceView.hintIndex

        self.currentSelectPieceView!.piece = pieceView.piece
        self.currentSelectPieceView!.contentLabel.text = pieceView.contentLabel.text

        let firtPoint: CGPoint = touches.first!.location(in: self)

        centerfirtPoint = (pieceView.superview?.convert(pieceView.center, to: self))!

        self.currentSelectPieceView!.firstCenterPoint = firtPoint

        let patternPieceView = listPatternPieceView[pieceView.patternIndex] as! AIMPatternPiece

        self.currentSelectPieceView?.center = firtPoint
        // zoom in
//        self.currentSelectPieceView!.frame = CGRectMake(self.currentSelectPieceView!.frame.origin.x, self.currentSelectPieceView!.frame.origin.y, patternPieceView.frame.size.width, patternPieceView.frame.size.height)
        self.currentSelectPieceView!.frame = CGRect.init(x: self.currentSelectPieceView!.frame.origin.x , y: self.currentSelectPieceView!.frame.origin.y ,  width: patternPieceView.frame.size.width, height: patternPieceView.frame.size.height)
        pieceView.isHidden = true
        self.currentSelectPieceView!.isHidden = false

        self.bringSubviewToFront(self.currentSelectPieceView!)

        self.currentSelectPieceViewOnScrollview = pieceView
    }

    func movedChoosePieceView(touches: Set<UITouch>, pieceView: AIMPieceView) {

        let tmpPoint = touches.first!.location(in: self)

        let x = tmpPoint.x - (self.currentSelectPieceView?.firstCenterPoint!.x)!

        let y = tmpPoint.y - (self.currentSelectPieceView?.firstCenterPoint!.y)!

        self.currentSelectPieceView!.center = CGPoint(x: centerfirtPoint!.x + x, y: centerfirtPoint!.y + y)

    }

    func endMovedChoosePieceView(touches: Set<UITouch>, pieceView: AIMPieceView) {
        print(pieceView.patternIndex)
        let patternPieceView = listPatternPieceView[pieceView.patternIndex] as! AIMPatternPiece

        let d = AIMUtilities.mathDistance(point1: patternPieceView.center, point2: (self.currentSelectPieceView?.center)!)

        // drag piece correct
        if d <= CGFloat(AIMAppConstant.kMatchRadian) {
            patternPieceView.status = true
            self.listPieceView?.reRender()
            self.listPieceView?.isUserInteractionEnabled = false
            self.listPieceView?.isUserInteractionEnabled = true
            
            
            UIView.animate(withDuration: 0.3 , animations: {
                self.currentSelectPieceView?.center = patternPieceView.center
                }, completion: { (finished) in
                    if patternPieceView.type == 7 {
                        patternPieceView.bacgroundImage?.image = AIMQuestionContentView.image7
                    }
                    else if patternPieceView.type == 8 {
                        patternPieceView.bacgroundImage?.image = AIMQuestionContentView.image8
                    }
                    else {
                        patternPieceView.bacgroundImage?.image = AIMQuestionContentView.image
                    }
                    patternPieceView.setContent(content: (pieceView.piece?.content)!)
                    self.currentSelectPieceView?.isHidden = true
                    
                    patternPieceView.superview?.bringSubviewToFront(patternPieceView)
                    self.currentSelectPieceView!.transform = CGAffineTransform.identity
                    
                    self.listPieceView?.removePiece(pieceView: pieceView)
                    
                    self.delegate?.endDragPiece(piece: self.currentSelectPieceView!, patternPieceIndex: (self.currentSelectPieceView?.patternIndex)!)
                    
                    patternPieceView.buttonIdea.isEnabled = false
                    
                    
                    
                    self.soundManager?.playAudio(path: AIMAppConstant.kSoundCorrect)
                    
                    if ((self.checkFinish()) == true) {
                        for item in self.listPatternPieceView {
                            
                            let patternPiece = item as! AIMPatternPiece
                            patternPiece.displayCurrentContentWhenFinishDrag()
                            
                        }
                        self.delegate?.finishAtCurrentQuestion()                        
                    }
                    
                    self.centerfirtPoint = nil
                    self.animationPieceFixed(patternPice: patternPieceView)
            })

        } else {

            var patternIndex: Int = -1
            var index: Int = 0
            for item in listPatternPieceView {
                
                let patternItem = item as! AIMPatternPiece
                let d = AIMUtilities.mathDistance(point1: patternItem.center, point2: (self.currentSelectPieceView?.center)!)
                
                if d <= CGFloat(AIMAppConstant.kMatchRadian) {

                    patternIndex = index
                    break
                }
                
                index = index + 1
            }
            if abs(patternPieceView.center.y - self.currentSelectPieceView!.center.y) <= self.currentSelectPieceView!.frame.size.height {
                self.soundManager?.playAudio(path: AIMAppConstant.kSoundFailure)
            }
            
            self.delegate?.endDragPiece(piece: self.currentSelectPieceView!, patternPieceIndex: patternIndex)

            // drag piece is wrong
            self.listPieceView?.isUserInteractionEnabled = false
            // return first position
            UIView.animate(withDuration: AIMAppConstant.kDelayTime, animations: {
                self.currentSelectPieceView!.center = self.centerfirtPoint!
                self.currentSelectPieceView!.transform = CGAffineTransform(scaleX: pieceView.frame.size.width / patternPieceView.frame.size.width, y: pieceView.frame.size.height / patternPieceView.frame.size.height);
            }) { _ in
                self.centerfirtPoint = nil
                self.currentSelectPieceView?.isHidden = true
                pieceView.isHidden = false
                self.listPieceView?.isUserInteractionEnabled = true
                self.currentSelectPieceView!.transform = CGAffineTransform.identity
            }

        }
    }

    func pressedEnglishHintButton() {
        self.delegate?.pressedEnglishHintButton()
    }

    func expandPieceWidth(currentPatternPiece: AIMPatternPiece) {

        if deflowered {
            var patternViewsWidth: CGFloat = CGFloat(AIMAppConstant.kPatternLeftMargin) + CGFloat(AIMAppConstant.kPatternCoverSpace)
            // var unfixedPatternViewsWidth: CGFloat = 0
            var numberPatternPieceCorrented: Int = 0

            if ((self.checkFinish()) == true) {
                for item in self.listPatternPieceView {
                    let patternPiece = item as! AIMPatternPiece

                    if patternPiece.status {
                        numberPatternPieceCorrented = numberPatternPieceCorrented + 1
                    }

                    let width = patternPiece.contentLabel.requireWidth() + 2 * CGFloat(AIMAppConstant.kPatternTextLeftMargin)

                    if width > patternPiece.frame.size.width {
                        patternPiece.fixFrame = 0
                        // unfixedPatternViewsWidth = unfixedPatternViewsWidth + width

//                        patternPiece.frame = CGRectMake(patternViewsWidth - CGFloat(AIMAppConstant.kPatternCoverSpace), patternPiece.frame.origin.y, patternPiece.frame.size.width, patternPiece.frame.size.height)
                        patternPiece.frame = CGRect.init(x:patternViewsWidth - CGFloat(AIMAppConstant.kPatternCoverSpace), y:patternPiece.frame.origin.y, width: patternPiece.frame.size.width, height: patternPiece.frame.size.height)
                    }
                    else if width < patternPiece.frame.size.width {
                        patternPiece.frame = CGRect.init(x: patternViewsWidth - CGFloat(AIMAppConstant.kPatternCoverSpace), y: patternPiece.frame.origin.y, width: width, height: patternPiece.frame.size.height)
                        patternPiece.fixFrame = 0
                    }
                    else {
                        patternPiece.fixFrame = 0
                        patternPiece.frame = CGRect.init(x: patternViewsWidth - CGFloat(AIMAppConstant.kPatternCoverSpace), y: patternPiece.frame.origin.y, width: patternPiece.frame.size.width, height: patternPiece.frame.size.height)
                    }

                    patternViewsWidth = patternViewsWidth + patternPiece.frame.size.width - CGFloat(AIMAppConstant.kPatternCoverSpace)
                }
            }
            else {
                for item in self.listPatternPieceView {
                    let patternPiece = item as! AIMPatternPiece
                    if patternPiece.status {
                        numberPatternPieceCorrented = numberPatternPieceCorrented + 1
                        let width = patternPiece.contentLabel.requireWidth() + 2 * CGFloat(AIMAppConstant.kPatternTextLeftMargin)

                        if width > patternPiece.frame.size.width {
                            patternPiece.fixFrame = -1
                            // unfixedPatternViewsWidth = unfixedPatternViewsWidth + width

//                            patternPiece.frame = CGRectMake(patternViewsWidth - CGFloat(AIMAppConstant.kPatternCoverSpace), patternPiece.frame.origin.y, patternPiece.frame.size.width, patternPiece.frame.size.height)
                            patternPiece.frame = CGRect.init(x: patternViewsWidth - CGFloat(AIMAppConstant.kPatternCoverSpace), y: patternPiece.frame.origin.y, width:  patternPiece.frame.size.width, height: patternPiece.frame.size.height)
                        }
                        else if width < patternPiece.frame.size.width {
                            patternPiece.frame = CGRect.init(x: patternViewsWidth - CGFloat(AIMAppConstant.kPatternCoverSpace), y: patternPiece.frame.origin.y, width: width, height: patternPiece.frame.size.height)
                            patternPiece.fixFrame = 0
                        }
                        else {
                            patternPiece.fixFrame = 0
//                            patternPiece.frame = CGRectMake(patternViewsWidth - CGFloat(AIMAppConstant.kPatternCoverSpace), patternPiece.frame.origin.y, patternPiece.frame.size.width, patternPiece.frame.size.height)
                            patternPiece.frame = CGRect.init(x: patternViewsWidth - CGFloat(AIMAppConstant.kPatternCoverSpace), y: patternPiece.frame.origin.y, width: patternPiece.frame.size.width, height:  patternPiece.frame.size.height)
                        }
                    }
                    else {
                        patternPiece.frame = CGRect.init(x: patternViewsWidth - CGFloat(AIMAppConstant.kPatternCoverSpace), y: patternPiece.frame.origin.y, width: patternPiece.frame.size.width, height: patternPiece.frame.size.height)
                    }

                    patternViewsWidth = patternViewsWidth + patternPiece.frame.size.width - CGFloat(AIMAppConstant.kPatternCoverSpace)
                }
            }

            // -----------------------------------------------------------------------------------------------------------------------------------------------------------

            var sumWidth: CGFloat = CGFloat(AIMAppConstant.kPatternLeftMargin)

            for item in self.listPatternPieceView {
                let patternPiece = item as! AIMPatternPiece
                if patternPiece.fixFrame == -1 {
                    let width = patternPiece.contentLabel.requireWidth() + 2 * CGFloat(AIMAppConstant.kPatternTextLeftMargin)
                    if patternViewsWidth + (width - patternPiece.frame.size.width) <= CGFloat(AIMAppConstant.kPatternListViewWidth) {
                        patternViewsWidth = patternViewsWidth + (width - patternPiece.frame.size.width)
                        patternPiece.frame = CGRect.init(x: sumWidth , y: patternPiece.frame.origin.y, width:  width, height: patternPiece.frame.size.height)
                        patternPiece.fixFrame = 0
                    }
                    else {
                        patternPiece.frame = CGRect.init(x: sumWidth , y: patternPiece.frame.origin.y, width: CGFloat(AIMAppConstant.kPatternListViewWidth) - patternViewsWidth + patternPiece.frame.size.width, height: patternPiece.frame.size.height)
                    }
                }
                else {
                    patternPiece.frame = CGRect.init(x: sumWidth , y: patternPiece.frame.origin.y, width: patternPiece.frame.size.width, height: patternPiece.frame.size.height)
                }

                sumWidth = sumWidth + patternPiece.frame.size.width - CGFloat(AIMAppConstant.kPatternCoverSpace)

            }

            sumWidth = sumWidth + CGFloat(AIMAppConstant.kPatternCoverSpace) - CGFloat(AIMAppConstant.kPatternLeftMargin)

            if sumWidth < CGFloat(AIMAppConstant.kPatternListViewWidth) {
                var x: CGFloat = CGFloat(AIMAppConstant.kPatternLeftMargin + 150)
                let xWidth: CGFloat = (CGFloat(AIMAppConstant.kPatternListViewWidth) - sumWidth) / CGFloat(numberPatternPieceCorrented)
                for item in self.listPatternPieceView {
                    let patternPiece = item as! AIMPatternPiece
                    if patternPiece.status {
                        patternPiece.frame = CGRect.init(x: x, y: patternPiece.frame.origin.y, width: patternPiece.frame.size.width + xWidth, height: patternPiece.frame.size.height)
                    }
                    else {
                        patternPiece.frame = CGRect.init(x: x, y: patternPiece.frame.origin.y, width: patternPiece.frame.size.width, height: patternPiece.frame.size.height)
                    }

                    x = x + patternPiece.frame.size.width - CGFloat(AIMAppConstant.kPatternCoverSpace)

                }
            }

        }
        else {
            deflowered = true
        }
    }

    func animationPieceFixed(patternPice: AIMPatternPiece) {

        self.isUserInteractionEnabled = false

        let rect = CGRect.init(x: 0, y:0,  width: patternPice.frame.size.width + 15, height: patternPice.frame.size.height + 15)

        let animationPiece: UIImageView! = UIImageView(frame: rect)
        animationPiece.image = AIMQuestionContentView.imagex
        animationPiece.backgroundColor = UIColor.clear
        self.addSubview(animationPiece)
        animationPiece.isHidden = true
        
        animationPiece.center = patternPice.center
        self.bringSubviewToFront(animationPiece)
        animationPiece.alpha = 0.0
        animationPiece.isHidden = false
        
        UIView.animate(withDuration: AIMAppConstant.kBlurAnimationDuration, animations: {
            animationPiece.alpha = 1.0
        }) { (finished) in
            UIView.animate(withDuration: AIMAppConstant.kBlurAnimationDuration, animations: {
                animationPiece.alpha = 0.0
            }) { (finished) in
                UIView.animate(withDuration: AIMAppConstant.kBlurAnimationDuration, animations: {
                    animationPiece.alpha = 1.0
                }) { (finished) in
                    UIView.animate(withDuration: AIMAppConstant.kBlurAnimationDuration, animations: {
                        animationPiece.alpha = 0.0
                    }) { (finished) in
                        animationPiece.removeFromSuperview()
                        
                        UIView.animate(withDuration: AIMAppConstant.kExpandPieceAnimationDuration, animations: {
                            self.expandPieceWidth(currentPatternPiece: patternPice)
                            }, completion: { (finished) in
                                
                                if self.checkFinish() {
                                    for item in self.listPatternPieceView2 {
                                        (item as! UIView).removeFromSuperview()
                                    }
                                    for item in self.listPatternPieceView{
                                       (item as! AIMPatternPiece).buttonIdea.isHidden = true
                                    }
                                    for item in self.backgroundHide {
                                        item.isHidden = true
                                    }
                                    for item in self.backgroundViewHint {
                                        item.isHidden = true
                                    }
                                    UIView.animate(withDuration: 0.5, animations: {
                                        self.listPieceView?.hideAnwserView()
                                        }, completion: { (finished) in
                                            let animationAnswerCorrectQuestion: UIImageView! = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 275, height: 275))
                                            animationAnswerCorrectQuestion.center = self.center
                                            var images: [UIImage] = []
                                            for i in 1...21 {
                                                images.append(UIImage(named: "checkbox\(i)")!)
                                            }
                                            animationAnswerCorrectQuestion.image = UIImage(named: "checkbox21")
                                            animationAnswerCorrectQuestion.animationImages = images
                                            animationAnswerCorrectQuestion.animationDuration = 1.0
                                            animationAnswerCorrectQuestion.animationRepeatCount = 1
                                            
                                            self.addSubview(animationAnswerCorrectQuestion)
                                            
                                            self.bringSubviewToFront(animationAnswerCorrectQuestion)
                                            animationAnswerCorrectQuestion.isHidden = false
                                            self.soundManager?.playAudio(path: AIMAppConstant.kSoundComplete)
                                            animationAnswerCorrectQuestion.startAnimating()
                                            let volumnPlay = UIImage(named: "speaker")
                                            self.volumn = UIImageView(image: volumnPlay)
                                            self.volumn!.frame = CGRect(x: 1000, y: 300, width: 100, height: 100)
                                            self.superview?.addSubview(self.volumn!)
                                            
                                            
                                            
                                            self.bringSubviewToFront(self.volumn!)
                                            self.soundManager?.delegate = self
                                            self.soundManager?.playAudio(path: AIMAppConstant.kSoundCorrect)
                                            
                                            
                                            
                                    })
                                    
                                }
                                
                                self.isUserInteractionEnabled = true
                        })
                    }
                }
                
            }
        }
        
    }
    
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
