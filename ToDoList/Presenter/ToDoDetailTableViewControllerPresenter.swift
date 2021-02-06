//
//  ToDoDetailTableViewControllerPresenter.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2020/08/30.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation

final class ToDoDetailTableViewControllerPresenter {
    
    /// ToDoModel
    var model: ToDoModel?
    
    /// ToDoを１件検索
    /// - Parameters:
    ///   - todoId: todoId
    ///   - createTime: 作成時間
    ///   - success: 検索成功時
    ///   - failure: 検索失敗時
    func findTodo(todoId: String?, createTime: String?, success: ()->(), failure:  (String?)->()) {
        
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
    
    
    
    /// ToDoを１件削除
    /// - Parameters:
    ///   - todoId: todoId
    ///   - createTime: 作成時間
    ///   - success: 検索成功時
    ///   - failure: 検索失敗時
    func deleteTodo(todoId: String?, createTime: String?, success: ()->(), failure: (String?)->()) {
        switch ToDoModel.deleteToDo(todoId: todoId!, createTime: createTime) {
        case .success:
            success()
        case .failure:
            failure("削除に失敗しました")
        }
    }
    
}
