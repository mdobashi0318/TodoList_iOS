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
    private(set) var model: ToDoModel?

    /// 期限切れかどうかの判定を返す
    var isExpired: Bool {
        get {
            Format().stringFromDate(date: Date()) > model?.todoDate ?? ""
        }
    }

    /// ToDoを１件検索
    /// - Parameters:
    ///   - todoId: todoId
    ///   - createTime: 作成時間
    ///   - success: 検索成功時
    ///   - failure: 検索失敗時
    func findTodo(todoId: String?, createTime: String?, success: () -> Void, failure: (String) -> Void) {
        guard let _todoId = todoId else {
            failure("ToDoが見つかりませんでした")
            return
        }
        self.model = ToDoModel.find(todoId: _todoId, createTime: createTime)

        if self.model == nil {
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
    func deleteTodo(success: () -> Void, failure: (String) -> Void) {
        guard let _model = model else {
            failure("削除に失敗しました")
            return
        }

        switch ToDoModel.delete(_model) {
        case .success:
            success()
        case .failure:
            failure("削除に失敗しました")
        }
    }

}
