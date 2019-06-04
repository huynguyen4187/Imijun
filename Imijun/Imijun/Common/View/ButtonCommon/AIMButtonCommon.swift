import UIKit

class AIMButtonCommon: UIButton {
    var btnSelected:Bool = false
    
    @IBInspectable var normalColor : UIColor = UIColor.white {
        didSet {
            layer.borderColor = normalColor.cgColor
            setTitleColor(normalColor, for: .normal)
            // setTitleColor(normalColor, forState: .Normal)
        }
    }
    
    @IBInspectable var highlightColor : UIColor = AIMAppConstant.kBlueColor {
        didSet {
            setTitleColor(highlightColor, for: .highlighted)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        //        //set up default layout
        layer.borderWidth = AIMAppConstant.kBorderWidthButton
        layer.borderColor = normalColor.cgColor
        setTitleColor(normalColor, for: UIControl.State.normal)
        setTitleColor(highlightColor, for: .highlighted)
        
//        setTitleColor(normalColor, forState: .Normal)
//        setTitleColor(highlightColor, forState: .Highlighted)
        
        isExclusiveTouch = true
        
        
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = normalColor
            } else {
                backgroundColor = UIColor.clear
            }
        }
    }
    
//    override var highlighted: Bool {
//        didSet {
//            if highlighted {
//                backgroundColor = normalColor
//            } else {
//                backgroundColor = UIColor.clearColor()
//            }
//        }
//    }
    
}
