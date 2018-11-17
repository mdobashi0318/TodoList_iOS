//
//  TodoArray.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/11/11.
//  Copyright © 2018 m.dobashi. All rights reserved.
//

import Foundation
import UIKit

class TodoArray: NSObject {
    var id:String?
    var todoDate:String?
    var toDoName:String?
    var toDo:String?
    
    
    init(id:String, todoDate:String, toDoName: String, toDo:String) {
        self.id = id
        self.todoDate = todoDate
        self.toDoName = toDoName
        self.toDo = toDo
    }
    
    
}
