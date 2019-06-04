//
//  AIMChapter.swift
//  Imijun
//
//  Created by khoa.vt on 7/21/16.
//  Copyright © ARIS-VN. All rights reserved.
//

import Foundation
import RealmSwift

class AIMChapter: Object {

// Specify properties to ignore (Realm won't persist these)

//  override static func ignoredProperties() -> [String] {
//    return []
//  }

    @objc dynamic var index = ""
    @objc dynamic var title = ""
    @objc dynamic var chapterDescription = ""
    let questions = List<AIMQuestion>()
}
