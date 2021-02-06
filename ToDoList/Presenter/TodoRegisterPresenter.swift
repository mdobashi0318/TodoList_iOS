//
//  TodoRegisterPresenter.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2020/08/18.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation

final class TodoRegisterPresenter {
    
    /// ToDoModel
    var model: ToDoModel?
    
    
    
    /// ToDoを１件検索
    /// - Parameters:
    ///   - todoId: todoId
    ///   - createTime: 作成時間
    ///   - success: 検索成功時
    ///   - failure: 検索失敗時
    func findTodo(todoId: String?, createTime: String?, success: ()->(), failure: (String?)->()) {
        
        guard let _todoId = todoId else {
            failure("ToDoが見つかりませんでした")
            return
        }

        self.model = ToDoModel.findToDo(todoId: _todoId, createTime: createTime)
        
        if model == nil {
            failure("ToDoが見つかりませんでした")
            return
        }
        
        success()
    }
    
    
    
    /// ToDoの追加をする
    /// - Parameters:
    ///   - addValue: 追加するToDoの値
    ///   - success: 追加成功時のクロージャ
    ///   - failure: 追加失敗時のクロージャ
    func addTodo(addValue: ToDoModel, success: ()->(), failure: (String?)->()) {
        switch ToDoModel.addToDo(addValue: addValue) {
        case .success:
            success()
        case .failure:
            failure("追加に失敗しました")
        }
    }
    
    
    
    /// ToDoの更新をする
    /// - Parameters:
    ///   - addValue: 更新するToDoの値
    ///   - success: 更新成功時のクロージャ
    ///   - failure: 更新失敗時のクロージャ
    func updateTodo(updateTodo: ToDoModel, success: ()->(), failure: (String?)->()) {
        switch ToDoModel.updateToDo(updateValue: updateTodo) {
        case .success:
            success()
        case .failure:
            failure("更新に失敗しました")
        }
    }
}
