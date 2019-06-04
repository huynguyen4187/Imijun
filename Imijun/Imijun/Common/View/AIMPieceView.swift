//
//  AIMPieceView.swift
//  Imijun
//
//  Created by khoa.vt on 7/21/16.
//  Copyright © 2016 ARIS-VN. All rights reserved.
//

import UIKit

@objc protocol AIMPieceViewDelegate: NSObjectProtocol {
    func tapAIMPieceView(touches: Set<UITouch>, pieceView: AIMPieceView)
    func movedAIMPieceView(touches: Set<UITouch>, pieceView: AIMPieceView)
    func endMovedAIMPieceView(touches: Set<UITouch>, pieceView: AIMPieceView)
}

class AIMPieceView: UIView {

    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */

    static let image = UIImage(named: "blue_piece2")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 35, bottom: AIMAppConstant.kAIMPieceViewFrame.size.height - 20, right: 143))
    var firstCenterPoint: CGPoint?
    var piece: AIMPiece?
    var patternIndex: Int = -1
    var index: Int = -1
    weak var delegate: AIMPieceViewDelegate?
    var hintIndex: Int = -1

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentBottomConstraint: NSLayoutConstraint!

    class func loadFromNibWithIndex(patternIndex: Int, index: Int, hintIdex: Int) -> AIMPieceView? {
        let x = UINib(
            nibName: "AIMPieceView",
            bundle: nil
            ).instantiate(withOwner: nil, options: nil)[0] as? AIMPieceView

        x!.patternIndex = patternIndex
        x!.index = index
        x!.hintIndex = hintIdex
        x!.isExclusiveTouch = true
        x!.backgroundImage.image = AIMPieceView.image
        return x
    }

    override init (frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.tapAIMPieceView(touches: touches, pieceView: self)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.movedAIMPieceView(touches: touches, pieceView: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.endMovedAIMPieceView(touches: touches, pieceView: self)
    }

    func setData(piece: AIMPiece) {

        self.contentLabel.text = AIMUtilities.lowercaseFirstCharater(string: String(piece.content))
        self.piece = piece
        var width = self.contentLabel.requireWidth()

        if width < 100 {
            width = 100
        }

        // self.frame = CGRectMake(0, 0, width + 70, self.frame.size.height)
        self.frame = CGRect.init(x: 0, y: 0, width: width + 70, height: self.frame.size.height)
    }

}
