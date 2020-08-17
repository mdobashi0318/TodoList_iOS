//
//  ToDoListPresenter.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2020/08/17.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation
import RealmSwift


final class ToDoListPresenter {
    
    var model: Results<ToDoModel>?
    
    func fetchToDoList(success: @escaping()->(), failure: @escaping (String?)->()) {
        model = ToDoModel.allFindToDo()
        if model == nil {
            failure("エラーが発生しました")
            return
            
        }
        success()
    }
    
    
}
