//
//  AIMChapterCell.swift
//  Imijun
//
//  Created by Jonny Chinh Tran on 7/21/16.
//  Copyright © 2016 ARIS-VN. All rights reserved.
//

import UIKit

class AIMChapterCell: UITableViewCell {
    @IBOutlet weak var lbIndexChapter: UILabel!
    @IBOutlet weak var lbTitleChapter: UILabel!
    @IBOutlet weak var lbNumberQuestion: UILabel!
    @IBOutlet weak var btnStart: AIMButtonCommon!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var marginRightContraint: NSLayoutConstraint!
    @IBOutlet weak var marginLeftContraint: NSLayoutConstraint!
    @IBOutlet weak var marginTop: NSLayoutConstraint!
    @IBOutlet weak var marginBottom: NSLayoutConstraint!

    var myChapter: AIMChapter?
    var gotoDescriptionPage: ((AIMChapter?) -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        btnStart.layer.borderColor = AIMAppConstant.kBorderButtonBlueColor.cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // MARK: action button tap
 

    @IBAction func btnStart(_ sender: Any) {
        self.chooseChapter()
    }
    
    func chooseChapter() {
        DispatchQueue.main.async {
            self.btnStart.isHighlighted = true
        }
        
//        dispatch_async(dispatch_get_main_queue()) { // 2
//            self.btnStart.highlighted = true
//        }

        let delayInSeconds = 0.15
        
//        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC))) // 1
//        dispatch_after(popTime, dispatch_get_main_queue()) { // 2
//            self.btnStart.highlighted = false
//            self.gotoDescriptionPage!(self.myChapter)
//        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
            self.btnStart.isHighlighted = false
             self.gotoDescriptionPage!(self.myChapter)
        }
        
    }

    func setData(chapter: AIMChapter, index: Int) {
        lbTitleChapter.text = chapter.title
        lbNumberQuestion.text = "全" + String(chapter.questions.count) + "問"
        lbIndexChapter.text = "第" + String(index) + "章"
        self.myChapter = chapter
    }
}
