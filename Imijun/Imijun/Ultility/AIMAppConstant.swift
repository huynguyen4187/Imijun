//
//  AIMAppConstant.swift
//  Imijun
//
//  Created by Jonny Chinh Tran on 7/20/16.
//  Copyright © 2016 ARIS-VN. All rights reserved.
//

import Foundation
import UIKit

enum PatternType: Int {
    case One = 1
    case Two = 2
    case Three = 3
    case For = 4
    case Five = 5
    case Six = 6
}

struct Log {

    static let columnTitle = "操作日\t操作時間\t操作画面\t操作名\t操作対象\t操作対象種別\t操作結果対称\t操作結果\t基本・応用\t章\t問題No"
    enum ScreenName: String {
        case FirstScreen = "タイトル"
        case ChooseChapter = "問題選択"
        case ChapterDescription = "場面説明"
        case AnswerAndQuestion = "問題・回答"
        case LearningAndUse = "学習方法と使い方"
        case About = "アプリについて"
    }

    enum ActionName: String {
        case Display = "表示"
        case Tap = "タップ"
        case Drag = "移動"
    }

    enum ObjectName: String {
        case Top = "トップ"
        case FirstScreenStartLearning = "学習をはじめる"
        case LearningAndUse = "学習方法と使い方"
        case About = "アプリについて"
        case DescriptionScreenStartLearning = "学習開始"
        case ChooseQuestion = "問題選択"
        case JapaneseHintButton = "日本語ヒント"
        case EnglishHintButton = "英単語ヒント"
        case SkipButton = "スキップ"
        case BackButton = "戻る"
        case NextButton = "次へ"
        case CloseButton = "終了"
        case ImijunBox = "意味順BOX"// record when finish question
    }

    enum ObjectKind: String {
        case Screen = "画面"
        case Button = "ボタン"
        case Piece = "ピース"
        case ImijunBox = "意味順BOX"// record when finish question
    }

    enum Resutl: String {
        case Success = "成功"
        case Discontinuity = "中断"
        case Right = "正解"
        case Wrong = "不正解"
    }

    enum ChapterType: String {
        case BasicQuestion = "基本"
        case AplicationQuestion = "応用"
    }
}

class AIMAppConstant {
    // Color
    static let kWhiteColor: UIColor = .white
    static let kBlueColor: UIColor = UIColor(red: 26 / 255.0, green: 132 / 255.0, blue: 181 / 255.0, alpha: 1.0)
    static let kClearColor: UIColor = .clear
    static let kBlackColor: UIColor = .black
    static let kGrayColor: UIColor = UIColor(red: 229 / 255.0, green: 229 / 255.0, blue: 229 / 255.0, alpha: 1.0)
    static let kBorderButtonBlueColor: UIColor = UIColor(red: 0 / 255.0, green: 158 / 255.0, blue: 240 / 255.0, alpha: 1.0)
    static let kHintTextGrayColor: UIColor = UIColor(red: 210 / 255.0, green: 210 / 255.0, blue: 210 / 255.0, alpha: 1.0)
    // Width
    static let kBorderWidthButton: CGFloat = 1.0

    // Segue
    static let kMainChoiceQuestion = "Main_ChoiceQuestion"
    static let kChoiceQuestionDescription = "ChoiceQuestion_Description"
    static let kDescriptionQuestionAnswer = "Description_QuestionAnswer"
    static let kQuestionAnswerScreen = "AnswerQuestion_Screen"

    // font name
    static let kFontName = "Hiragino Sans W3"

    // delay time when touch button
    static let kDelayTime = 0.5

    // Number row table chapter
    static let kTablechapterImijunBook = 7
    static let kTablechapterExternalFile = 7

    // Identifier cell
    static let kChapterCell = "ChapterCell"

    // AIMPieceView frame
    static let kAIMPieceViewFrame = CGRect.init(x: 0, y:0, width: 176, height: 82)

    // AIMPieceView padding
    static let kAIMPieceViewHorizontalPadding = 35.0

    // pattern data
    static let kPatternUIData = NSArray.init(objects: ["row": 2, "column": 5, "listPieceType": [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]],
                                             ["row": 2, "column": 5, "listPieceType": [1, 3, 1, 1, 1, 1, 4, 1, 1, 1]],
                                             ["row": 1, "column": 5, "listPieceType": [1, 1, 1, 1, 1]],
                                             ["row": 1, "column": 6, "listPieceType": [2, 2, 2, 2, 2, 2]],
                                             ["row": 2, "column": 6, "listPieceType": [2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2]],
                                             ["row": 2, "column": 5, "listPieceType": [1, 1, 1, 1, 1, 5]],
        ["row": 2, "column": 6, "listPieceType": [2, 2, 7, 8, 2, 2, 2, 2, 9, 2, 2]],
        ["row": 2, "column": 6, "listPieceType": [2, 2, 9, 2, 2, 2, 2, 7, 8, 2, 2]],
        ["row": 2, "column": 6, "listPieceType": [2, 2, 7, 8, 2, 2, 2, 2, 7, 8, 2, 2]],

        ["row": 2, "column": 6, "listPieceType": [2, 3, 7, 8, 2, 2, 2, 4, 9, 2, 2]],
        ["row": 2, "column": 6, "listPieceType": [2, 3, 9, 2, 2, 2, 4, 7, 8, 2, 2]],
        ["row": 2, "column": 6, "listPieceType": [2, 3, 7, 8, 2, 2, 2, 4, 7, 8, 2, 2]],

        ["row": 1, "column": 6, "listPieceType": [2, 2, 7, 8, 2, 2]],
        ["row": 1, "column": 7, "listPieceType": [6, 6, 6, 6, 6, 6, 6]],

        ["row": 2, "column": 7, "listPieceType": [6, 6, 6, 7, 8, 6, 6, 6, 6, 6, 9, 6, 6]],
        ["row": 2, "column": 7, "listPieceType": [6, 6, 6, 9, 6, 6, 6, 6, 6, 7, 8, 6, 6]],
        ["row": 2, "column": 7, "listPieceType": [6, 6, 6, 7, 8, 6, 6, 6, 6, 6, 7, 8, 6, 6]],

        ["row": 2, "column": 6, "listPieceType": [2, 2, 2, 2, 2, 2, 5]])

    // pattern piece width
    static let kPiece1Width = 191
    static let kPiece2Width = 191
    static let kPiece3Width = 405
    static let kPiece4Width = 136
    static let kPiece5Width = 136
    static let kPieceHeigh = 99
    
    static let kPatternLeftMargin = 35
    static let kPatternTextLeftMargin = 50
    static let kPatternListViewWidth = 804

    static let kPatternCoverSpace = 39

    static let kPatternTopSpace = 190

    // match radian
    static let kMatchRadian = 90.0

    // name label next/skip/close
    static let kSkip = "スキップ"
    static let kNext = "次へ"
    static let kClose = "終了"

    // delay time when touch button
    static let kTimeDelayWhenTouchButton = 0.5

    static let kBlurAnimationDuration = 0.2

    static let kExpandPieceAnimationDuration = 0.3

    // tutorial screen title
    static let kTutorialTitle = "学習方法と使い方"
    
    static let kSoundCorrect = Bundle.main.path(forResource: "1_correct", ofType: "mp3")
    static let kSoundFailure = Bundle.main.path(forResource: "2_failure", ofType: "mp3")
    static let kSoundComplete = Bundle.main.path(forResource: "3_complete", ofType: "mp3")
    static let kSoundFinish = Bundle.main.path(forResource: "Liam", ofType: "mp3")
    
}
