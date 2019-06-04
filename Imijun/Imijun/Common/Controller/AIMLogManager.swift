//
//  AIMLogManager.swift
//  Imijun
//
//  Created by khoa.vt on 8/30/16.
//  Copyright © 2016 ARIS-VN. All rights reserved.
//

import UIKit

class AIMLogManager: NSObject {

    var content: String = ""
    private static var instance: AIMLogManager = AIMLogManager()

    class var sharedInstance: AIMLogManager {
//        struct Static {
//            static var onceToken: dispatch_once_t = 0
//            static var instance: AIMLogManager? = nil
//        }
//        
//        dispatch_once(&Static.onceToken) {
//            Static.instance = AIMLogManager()
//        }
        return instance
    }

    override init() {
        super.init()

    }

    func writeLogToFile() {

        if self.content == "" {
            return
        }

        DispatchQueue.main.async {
            let documents = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let filePath = documents.appendingPathComponent(UserDefaults.standard.object(forKey: "logFileName") as! String).path
            
            let fileManager = FileManager.default
            
            // Check if file exists, given its path
            
            if fileManager.fileExists(atPath: filePath) {
                print("File exists")
                
                var temp: String = "\n"
                temp.append(contentsOf: self.content)
                // temp.appendContentsOf(self.content)
                self.content = temp
                
                do {
                    let fileHandle = try FileHandle.init(forWritingTo: NSURL(fileURLWithPath: filePath) as URL)
                    let data = self.content.data(using: String.Encoding.utf8)!
                    fileHandle.seekToEndOfFile()
                    fileHandle.write(data)
                    fileHandle.closeFile()
                    self.content = ""
                }
                catch {
                    print("Can't open file")
                }
            } else {
                
                var temp: String = Log.columnTitle
                temp.append(contentsOf: "\n")
                // temp.appendContentsOf("\n")
                temp.append(contentsOf: self.content)
                // temp.appendContentsOf(self.content)
                
                self.content = temp
                do {
                    try self.content.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
                    self.content = ""
                } catch {
                    // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
                    print("can't write")
                }
            }
        }
        
//        dispatch_async(dispatch_get_main_queue()) { // 2
//
//            let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
//            let filePath = documents.URLByAppendingPathComponent(NSUserDefaults.standardUserDefaults().objectForKey("logFileName") as! String).path!
//
//            let fileManager = NSFileManager.defaultManager()
//
//            // Check if file exists, given its path
//
//            if fileManager.fileExistsAtPath(filePath) {
//                print("File exists")
//
//                var temp: String = "\n"
//                temp.appendContentsOf(self.content)
//                self.content = temp
//
//                do {
//                    let fileHandle = try NSFileHandle.init(forWritingToURL: NSURL(fileURLWithPath: filePath))
//                    let data = self.content.dataUsingEncoding(NSUTF8StringEncoding)!
//                    fileHandle.seekToEndOfFile()
//                    fileHandle.writeData(data)
//                    fileHandle.closeFile()
//                    self.content = ""
//                }
//                catch {
//                    print("Can't open file")
//                }
//            } else {
//
//                var temp: String = Log.columnTitle
//                temp.appendContentsOf("\n")
//                temp.appendContentsOf(self.content)
//                self.content = temp
//                do {
//                    try self.content.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding)
//                    self.content = ""
//                } catch {
//                    // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
//                    print("can't write")
//                }
//            }
//        }
    }

    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }

    func record(screenName: String, actionName: String, objectName: String, objectType: String, boxResult: String, result: String, questionType: String, chapterNumber: String, questionNumber: String) {

        if UserDefaults.standard.object(forKey: "logFileName") == nil {
            let filenName = AIMUtilities.getFileName()
            UserDefaults.standard.set(filenName, forKey: "logFileName")
            UserDefaults.standard.synchronize()

        }
        else {

            let documents = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let filePath = documents.appendingPathComponent(UserDefaults.standard.object(forKey: "logFileName") as! String).path

            if !FileManager.default.fileExists(atPath: filePath) && self.content == "" {

                let filenName = AIMUtilities.getFileName()
                UserDefaults.standard.set(filenName, forKey: "logFileName")
                UserDefaults.standard.synchronize()

            }

        }

        let record = AIMUtilities.getTimeString() + "\t" + screenName + "\t" + actionName + "\t" + objectName + "\t" + objectType + "\t" + boxResult + "\t" + result + "\t" + questionType + "\t" + chapterNumber + "\t" + questionNumber

        if self.content == "" {
            self.content.append(contentsOf: record)
            // self.content.appendContentsOf(record)
        }
        else {
            self.content.append(contentsOf: "\n" + record)
            // self.content.appendContentsOf("\n" + record)
        }

    }

}
