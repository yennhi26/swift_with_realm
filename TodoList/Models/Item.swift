//
//  Item.swift
//  TodoList
//
//  Created by Halo on 25/05/2021.
//

import Foundation
import RealmSwift

import RealmSwift
class TodoItem: Object {
  @objc dynamic var detail = ""
  @objc dynamic var status = 0
}
