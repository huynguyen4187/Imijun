//
//  AIMQuestionChoiceScreenViewController.swift
//  Imijun
//
//  Created by Jonny Chinh Tran on 7/20/16.
//  Copyright © 2016 ARIS-VN. All rights reserved.
//

import UIKit
import RealmSwift

enum TagTable: Int {
    case TableImijun = 1
    case TableExternalData = 2
}

class AIMQuestionChoiceScreenViewController: AIMBaseViewController {
    @IBOutlet weak var tableChapterOnBookImijun: UITableView!
    @IBOutlet weak var tableViewChapterOnFileWord: UITableView!
    var chapterList: Results<AIMChapter>?

    override func viewDidLoad() {
        super.viewDidLoad()

        chapterList = AIMDataController.getChapterList()
        tableChapterOnBookImijun.reloadData()
        tableViewChapterOnFileWord.reloadData()

        tableChapterOnBookImijun.isExclusiveTouch = true
        tableViewChapterOnFileWord.isExclusiveTouch = true

        // config custom navigation view
        self.navi.lbTitle.text = "問題選択"
        self.navi.rightButton.isHidden = true
        self.navi.lbSubTitle.isHidden = true

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.isUserInteractionEnabled = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AIMLogManager.sharedInstance.record(screenName: Log.ScreenName.ChooseChapter.rawValue, actionName: Log.ActionName.Display.rawValue, objectName: Log.ObjectName.ChooseQuestion.rawValue, objectType: Log.ObjectKind.Screen.rawValue, boxResult: "-", result: Log.Resutl.Success.rawValue, questionType: "-", chapterNumber: "-", questionNumber: "-")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func leftButtonTap(sender: Any) {
        super.leftButtonTap(sender: sender)
        
        AIMLogManager.sharedInstance.record(screenName: Log.ScreenName.ChooseChapter.rawValue, actionName: Log.ActionName.Tap.rawValue, objectName: Log.ObjectName.BackButton.rawValue, objectType: Log.ObjectKind.Button.rawValue, boxResult: "-", result: Log.Resutl.Success.rawValue, questionType: "-", chapterNumber: "-", questionNumber: "-")
    }
    

    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == AIMAppConstant.kChoiceQuestionDescription) {
            if let viewController: AIMDescriptionScreeenViewController = segue.destination as? AIMDescriptionScreeenViewController {
                viewController.currentChapter = sender as? AIMChapter
            }
        }
        else {
            if let viewController: AIMQuestionAnswerScreenViewController = segue.destination as? AIMQuestionAnswerScreenViewController {
                viewController.currentChapter = sender as? AIMChapter
                viewController.chapterType = Log.ChapterType.BasicQuestion
            }
        }
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//
//        if (segue.identifier == AIMAppConstant.kChoiceQuestionDescription) {
//            if let viewController: AIMDescriptionScreeenViewController = segue.destinationViewController as? AIMDescriptionScreeenViewController {
//                viewController.currentChapter = sender as? AIMChapter
//            }
//        }
//        else {
//            if let viewController: AIMQuestionAnswerScreenViewController = segue.destinationViewController as? AIMQuestionAnswerScreenViewController {
//                viewController.currentChapter = sender as? AIMChapter
//                viewController.chapterType = Log.ChapterType.BasicQuestion
//            }
//        }
//    }
}

// MARK: - table delegate
extension AIMQuestionChoiceScreenViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / CGFloat(AIMAppConstant.kTablechapterImijunBook + 1)
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.frame.size.height / CGFloat(AIMAppConstant.kTablechapterImijunBook + 1)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.isUserInteractionEnabled = false
        
        let cell: AIMChapterCell = tableView.cellForRow(at: indexPath as IndexPath) as! AIMChapterCell
        
        var questionType = Log.ChapterType.AplicationQuestion
        if (tableView == tableChapterOnBookImijun) {
            
            questionType = Log.ChapterType.BasicQuestion
        }
        
        let titleString = cell.lbTitleChapter.text!.replacingOccurrences(of: "\n　", with: "", options: .literal)
        AIMLogManager.sharedInstance.record(screenName: Log.ScreenName.ChooseChapter.rawValue, actionName: Log.ActionName.Tap.rawValue, objectName: cell.lbIndexChapter.text! + " " + titleString + " [開始]", objectType: Log.ObjectKind.Button.rawValue, boxResult: "-", result: Log.Resutl.Success.rawValue, questionType: questionType.rawValue, chapterNumber: "-", questionNumber: "-")
        
        cell.chooseChapter()
    }
    
}

// MARK: - table datasource
extension AIMQuestionChoiceScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = AIMAppConstant.kChapterCell
        
        var cell: AIMChapterCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? AIMChapterCell
        
        if cell == nil {
            tableView.register(UINib(nibName: "AIMChapterCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? AIMChapterCell
        }
        if tableView.tag == TagTable.TableImijun.rawValue {
            
            cell.marginLeftContraint.constant = 5.0
            cell.marginRightContraint.constant = 2.5
            
            cell.setData(chapter: self.chapterList![indexPath.row] as AIMChapter, index: indexPath.row + 1)
            cell.gotoDescriptionPage = {
                obj in
                self.performSegue(withIdentifier: AIMAppConstant.kQuestionAnswerScreen, sender: obj)
            }
        } else {
            cell.marginLeftContraint.constant = 2.5
            cell.marginRightContraint.constant = 5.0
            
            cell.setData(chapter: self.chapterList![indexPath.row + AIMAppConstant.kTablechapterImijunBook] as AIMChapter, index: indexPath.row + 1)
            
            cell.gotoDescriptionPage = {
                obj in
                self.performSegue(withIdentifier: AIMAppConstant.kChoiceQuestionDescription, sender: obj)
            }
            
        }
        cell.marginTop.constant = 2.5
        cell.marginBottom.constant = 2.5
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView: AIMHeaderView! = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AIMHeaderView") as? AIMHeaderView
        if headerView == nil {
            tableView.register(UINib(nibName: "AIMHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "AIMHeaderView")
            headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AIMHeaderView") as? AIMHeaderView
        }
        
        //        headerView.frame = CGRectMake(0, 0, 512, 87.75)
        
        if tableView == tableChapterOnBookImijun {
            headerView.label.text = "基本問題"
            headerView.marginLeftContraint.constant = 2.5
            headerView.marginRightContraint.constant = 5.0
        }
        else {
            headerView.label.text = "応用問題"
            headerView.marginLeftContraint.constant = 5.0
            headerView.marginRightContraint.constant = 2.5
        }
        
        headerView.marginTop.constant = 2.5
        headerView.marginBottom.constant = 2.5
        
        return headerView
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if tableView.tag == TagTable.TableImijun.rawValue {
            return AIMAppConstant.kTablechapterImijunBook
        } else {
            return AIMAppConstant.kTablechapterExternalFile
        }
    }

}
