//
//  TodoRegisterPresenter.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2020/08/18.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation

class TodoRegisterPresenter {
    
    var model: ToDoModel?
    
    
    func findTodo(todoId: String, createTime: String, success: @escaping()->(), failure: @escaping (String?)->()) {
        self.model = ToDoModel.findToDo(todoId: todoId, createTime: createTime)
        
        if model == nil {
            failure("ToDoが見つかりませんでした")
            return
        }
        
        success()
    }
    
    
    func addTodo(addValue: ToDoModel, success: @escaping()->(), failure: @escaping (String?)->()) {
        ToDoModel.addToDo(addValue: addValue) { error in
            
            if let _error = error {
                failure(_error)
                return
            }
            
            success()
        }
    }
    
    
    func updateTodo(updateTodo: ToDoModel, success: @escaping()->(), failure: @escaping (String?)->()) {
        ToDoModel.updateToDo(updateValue: updateTodo) { error in
            if let _error = error {
                failure(_error)
                return
            }
            
            success()
        }
    }
    
}
