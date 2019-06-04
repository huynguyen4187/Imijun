//
//  AIMDataController.swift
//  Imijun
//
//  Created by Jonny Chinh Tran on 7/21/16.
//  Copyright © 2016 ARIS-VN. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

public class AIMDataController: NSObject {

    class func getChapterList()->Results<AIMChapter>{
        
        var config = Realm.Configuration()
        
        // Use the default directory, but replace the filename with the username
        let filemanager = FileManager.default
        let documentsPath : AnyObject = NSSearchPathForDirectoriesInDomains(.libraryDirectory,.userDomainMask,true).last! as AnyObject
        let dataFilePath:NSString = documentsPath.appending("/data.realm") as NSString
        if(!filemanager.fileExists(atPath: dataFilePath as String)){
            let fileForCopy = Bundle.main.path(forResource: "data",ofType:"realm")
            do{
                try filemanager.copyItem(atPath: fileForCopy!, toPath: dataFilePath as String)
            }catch{
                
            }
        }
        config.fileURL = NSURL.init(string: dataFilePath as String) as URL?
        // Set this as the configuration used for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        let realm = try! Realm()
        let chapterList = realm.objects(AIMChapter.self)
        return chapterList
    }
}
