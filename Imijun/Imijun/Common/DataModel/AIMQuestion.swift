//
//  AIMQuestion.swift
//  Imijun
//
//  Created by khoa.vt on 7/21/16.
//  Copyright © 2016 ARIS-VN. All rights reserved.
//

import Foundation
import RealmSwift

class AIMQuestion: Object {

// Specify properties to ignore (Realm won't persist these)

//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    @objc dynamic var index = ""
    @objc dynamic var content = ""
    @objc dynamic var pattern: AIMPattern?
    let hints = List<AIMPiece> ()
    let answers = List<AIMPiece> ()
}
