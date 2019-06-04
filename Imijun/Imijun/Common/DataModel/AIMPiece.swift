//
//  AIMPiece.swift
//  Imijun
//
//  Created by khoa.vt on 7/21/16.
//  Copyright © 2016 ARIS-VN. All rights reserved.
//

import Foundation
import RealmSwift

class AIMPiece: Object {

// Specify properties to ignore (Realm won't persist these)

//  override static func ignoredProperties() -> [String] {
//    return []
//  }

    @objc dynamic var content = ""

}
