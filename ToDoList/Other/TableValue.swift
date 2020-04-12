//
//  TableValue.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2020/04/09.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation

struct TableValue {
    let id: String
    let title:String
    let date:String
    let detail:String
    let createTime:String?
    
    init(id:String, title:String, todoDate:String, detail: String, createTime: String? = nil) {
        self.id = id
        self.title = title
        self.date = todoDate
        self.detail = detail
        self.createTime = createTime
    }
}
