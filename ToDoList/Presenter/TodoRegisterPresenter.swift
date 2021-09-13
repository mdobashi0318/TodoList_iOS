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
    private(set) var model: ToDoModel?

    /// ToDoを１件検索
    /// - Parameters:
    ///   - todoId: todoId
    ///   - createTime: 作成時間
    ///   - success: 検索成功時
    ///   - failure: 検索失敗時
    func findTodo(todoId: String?, createTime: String?, success: () -> Void, failure: (String) -> Void) {
        guard let _todoId = todoId else {
            failure(R.string.message.noTodoError())
            return
        }
        self.model = ToDoModel.find(todoId: _todoId, createTime: createTime)

        if model == nil {
            failure(R.string.message.noTodoError())
            return
        }
        success()
    }

    /// ToDoの追加をする
    /// - Parameters:
    ///   - addValue: 追加するToDoの値
    ///   - success: 追加成功時のクロージャ
    ///   - failure: 追加失敗時のクロージャ
    func addTodo(addValue: ToDoModel, success: () -> Void, failure: (String) -> Void) {
        switch ToDoModel.add(addValue: addValue) {
        case .success:
            success()
        case .failure(let error):
            failure(error.message)
        }
    }

    /// ToDoの更新をする
    /// - Parameters:
    ///   - addValue: 更新するToDoの値
    ///   - success: 更新成功時のクロージャ
    ///   - failure: 更新失敗時のクロージャ
    func updateTodo(updateTodo: ToDoModel, success: () -> Void, failure: (String) -> Void) {
        switch ToDoModel.update(updateValue: updateTodo) {
        case .success:
            success()
        case .failure(let error):
            failure(error.message)
        }
    }
}
