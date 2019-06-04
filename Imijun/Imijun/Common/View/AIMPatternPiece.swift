//
//  AIMPatternPiece.swift
//  Imijun
//
//  Created by khoa.vt on 7/25/16.
//  Copyright © 2016 ARIS-VN. All rights reserved.
//

import UIKit

@objc protocol AIMPatternPieceDelegate:NSObjectProtocol{
    @objc optional func hintCase2(sender: Any)
}

class AIMPatternPiece: UIView {

    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var bacgroundImage: UIImageView!
    @IBOutlet weak var buttonIdea: UIButton!
    
    var status: Bool = false
    var currentContent: String?
    var patternPiece: AIMPiece?
    var hintPiece: AIMPiece?
    var type: Int = -1
    var fixFrame: Int = 0
    weak var delegate: AIMPatternPieceDelegate?
    
    static let image = UIImage(named: "piece")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 40, bottom: 109, right: 45))
    
    static let image7 = UIImage(named: "piece_a")!.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 40, bottom: 109, right: 45))
    
    static let image8 = UIImage(named: "piece_b")!.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 40, bottom: 109, right: 45))
    
    static let imageGold = UIImage(named: "Image-1")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 40, bottom: 109, right: 45))
    static let image7Gold = UIImage(named: "Image-2")!.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 40, bottom: 109, right: 45))
    static let image8Gold = UIImage(named: "Image")!.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 40, bottom: 109, right: 45))


    class func loadFromNib (frame: CGRect, patternPiece: AIMPiece, hintPiece: AIMPiece, pieceType: Int) -> AIMPatternPiece {

        let x = UINib(
            nibName: "AIMPatternPiece",
            bundle: nil
            ).instantiate(withOwner: nil, options: nil)[0] as? AIMPatternPiece

        x!.patternPiece = patternPiece
        x!.hintPiece = hintPiece
        x!.contentLabel?.minimumScaleFactor = 0.5
        x!.frame = frame

        return x!
    }

    override init (frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setSelectedData(type: Int){
        self.type = type
        
        if type == 7 {
            bacgroundImage?.image = AIMPatternPiece.image7Gold
            //            bacgroundImage?.hidden = true
        }
        else if type == 8 {
            bacgroundImage?.image = AIMPatternPiece.image8Gold
            //            bacgroundImage?.hidden = true
            
        }
        else {
            bacgroundImage?.image = AIMPatternPiece.imageGold
        }
        
        //self.setContent(content: patternPiece!.content)
    }
    
    func setData(type: Int) {

        self.type = type

        if type == 7 {
            bacgroundImage?.image = AIMPatternPiece.image7
//            bacgroundImage?.hidden = true
        }
        else if type == 8 {
            bacgroundImage?.image = AIMPatternPiece.image8
//            bacgroundImage?.hidden = true

        }
        else {
            bacgroundImage?.image = AIMPatternPiece.image
        }

        self.setContent(content: patternPiece!.content)
    }

    func setContent(content: String) {
        if status == true {
            contentLabel.numberOfLines = 1
        }
        else {
            contentLabel.numberOfLines = 2
        }
        contentLabel?.text = content
        currentContent = content
    }

    func displayHintContent() {
        contentLabel.numberOfLines = 3
        contentLabel?.text = hintPiece?.content
        contentLabel?.textColor = AIMAppConstant.kHintTextGrayColor
    }

    func displayCurrentContent() {
        if status == true {
            contentLabel.numberOfLines = 1
        }
        else {
            contentLabel.numberOfLines = 2
        }
        contentLabel?.text = currentContent
        contentLabel?.textColor = AIMAppConstant.kBlackColor
    }

    func displayCurrentContentWhenFinishDrag() {
        contentLabel?.text = currentContent
        if status == true {
            contentLabel?.textColor = AIMAppConstant.kBlackColor
        } else {
            contentLabel?.textColor = AIMAppConstant.kHintTextGrayColor
        }
    }

    @IBAction func hintCase2(_ sender: Any) {
        self.delegate?.hintCase2!(sender: sender)
    }
}
