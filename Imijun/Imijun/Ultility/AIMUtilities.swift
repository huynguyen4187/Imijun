//
//  AIMUtilities.swift
//  Imijun
//
//  Created by khoa.vt on 7/21/16.
//  Copyright © 2016 ARIS-VN. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import Foundation

public class AIMUtilities: NSObject {

    public class func inportData() -> Int {

//        do {
//            try NSFileManager.defaultManager().removeItemAtURL(Realm.Configuration.defaultConfiguration.fileURL!)
//        } catch {}

        let jsonFilePath = Bundle.main.path(forResource: "data", ofType: "json")
        let jsonData = NSData.init(contentsOfFile: jsonFilePath!)

        let personDicts: NSDictionary?
        do {
            personDicts = try JSONSerialization.jsonObject(with: jsonData! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
        }
        catch {
            print("There was an error reading the JSON file")
            return 1
        }

        var config = Realm.Configuration()

        // Use the default directory, but replace the filename with the username
        if config.fileURL?.lastPathComponent == "data.realm" {
            return 1
        }
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("data.realm")

        // Set this as the configuration used for the default Realm
        Realm.Configuration.defaultConfiguration = config

        let realm = try! Realm()
        realm.beginWrite()

        let patternArray = NSMutableArray()

        let patternArr = personDicts?.object(forKey: "pattern") as! NSArray
        for patternDict in patternArr {

            let pattern = AIMPattern()
            pattern.type = "\((patternDict as! NSDictionary).object(forKey: "type")!)"

            let pieceArray = (patternDict as! NSDictionary).object(forKey: "item") as! NSArray

            for pieceStr in pieceArray {
                let piece: AIMPiece = AIMPiece()
                piece.content = (pieceStr as? String)!

                realm.add(piece)

                pattern.imijunPattern.append(piece)
            }

            realm.add(pattern)
            patternArray.add(pattern)
        }

        let chapterArray = personDicts?.object(forKey: "chapter") as! NSArray
        for chapterDic in chapterArray {
            let chapterDictionary = chapterDic as! NSDictionary
            let chapter: AIMChapter = AIMChapter()
            chapter.index = "\(chapterDictionary.object(forKey: "index")!)"
            chapter.title = (chapterDictionary.object(forKey: "title") as? String)!
            chapter.chapterDescription = (chapterDictionary.object(forKey: "description") as? String)!

            let questionList = chapterDictionary.object(forKey: "question") as! NSArray
            for questionDic in questionList {
                let questionDictionary = questionDic as! NSDictionary
                let question: AIMQuestion = AIMQuestion()
                question.content = (questionDictionary.object(forKey: "content") as? String)!
                question.index = "\(questionDictionary.object(forKey: "index")!)"
                let patternType: Int = questionDictionary.object(forKey: "type") as! Int
                question.pattern = patternArray.object(at: patternType - 1) as? AIMPattern

                let hintArr = questionDictionary.object(forKey: "hints") as? NSArray
                for hintStr in hintArr! {
                    let piece: AIMPiece = AIMPiece()
                    piece.content = (hintStr as? String)!

                    realm.add(piece)

                    question.hints.append(piece)
                }

                let answerArr = questionDictionary.object(forKey: "answers") as? NSArray
                for answerStr in answerArr! {
                    let piece: AIMPiece = AIMPiece()
                    piece.content = (answerStr as? String)!

                    realm.add(piece)

                    question.answers.append(piece)
                }

                realm.add(question)

                chapter.questions.append(question)

            }

            realm.add(chapter)
        }

        do {
            try realm.commitWrite()
        }
        catch {
            return 1
        }

        return 0
    }

    public class func mathDistance(point1: CGPoint, point2: CGPoint) -> CGFloat {
        return sqrt((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y))
    }

    public class func delayTimeWhenTouchButton(wakeup: ((Bool) -> ())?) {
        // wait 0.5
        let delayTime = UInt32(AIMAppConstant.kTimeDelayWhenTouchButton * 1000000)
        usleep(delayTime)
        wakeup!(true)
    }

    public class func uppercaseFirstCharater(string: String) -> String {

        let first = string[string.startIndex]
        let other = string.dropFirst()
        return String(first).uppercased() + String(other)

    }

    public class func lowercaseFirstCharater(string: String) -> String {

        let first = string[string.startIndex]
        if first != "I" {
            let other = string.dropFirst()
            return String(first).lowercased() + String(other)
        }

        return string

    }

    public class func getTimeString() -> String {
        let japanCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        japanCalendar.timeZone = NSTimeZone(name: "Asia/Tokyo")! as TimeZone
        let requestedDateComponents: NSCalendar.Unit = [.year,
                                                        .month,
                                                        .day,
                                                        .hour,
                                                        .minute,
                                                        .second,
                                                        .weekday,
                                                        .weekdayOrdinal]

        let japanComponents = japanCalendar.components(requestedDateComponents, from: Date())

        let result = String(format: "%d%0.2d%0.2d\t%0.2d:%0.2d:%0.2d", japanComponents.year!, japanComponents.month!, japanComponents.day!, japanComponents.hour!, japanComponents.minute!, japanComponents.second!)

        return result

    }

    public class func getFileName() -> String {
        let japanCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        japanCalendar.timeZone = NSTimeZone(name: "Asia/Tokyo")! as TimeZone
        let requestedDateComponents: NSCalendar.Unit = [.year,
                                                        .month,
                                                        .day,
                                                        .hour,
                                                        .minute,
                                                        .second,
                                                        .weekday,
                                                        .weekdayOrdinal]

        let japanComponents = japanCalendar.components(requestedDateComponents, from: Date() )

        let result = String(format: "%d%0.2d%0.2d_%0.2d%0.2d%0.2d.csv", japanComponents.year!, japanComponents.month!, japanComponents.day!, japanComponents.hour!, japanComponents.minute!, japanComponents.second!)

        return result

    }

}
