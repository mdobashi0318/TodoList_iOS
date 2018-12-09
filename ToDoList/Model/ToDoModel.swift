//
//  RealmManager.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/09/26.
//  Copyright © 2018 m.dobashi. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoModel:Object {
    @objc dynamic var id:String = ""
    @objc dynamic var todoDate:String?
    @objc dynamic var toDoName:String = ""
    @objc dynamic var toDo:String = ""
    
    
    // idをプライマリキーに設定
    /*
    override static func primaryKey() -> String? {
        return "id"
    }
     */
    
}
