//
//  ToDoListPresenter.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2020/08/17.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation

final class ToDoListPresenter {

    private(set) var model: [ToDoModel]?

    func fetchToDoList(segmentIndex index: PageType, success: () -> Void, failure: (String) -> Void) {
        switch index {
        case .all:
            model = ToDoModel.allFind()
        case .active:
            model = ToDoModel.activeFindToDo(index: index)
        case .expired:
            model = ToDoModel.activeFindToDo(index: index)
        }

        if model == nil {
            failure(R.string.message.errorMessage())
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
    func deleteTodo(_ model: ToDoModel?, success: () -> Void, failure: (String) -> Void) {
        guard let model = model else { return failure(R.string.message.errorMessage()) }
        switch ToDoModel.delete(model) {
        case .success:
            success()
        case .failure(let error):
            failure(error.message)
        }
    }

    /// 期限切れかどうかの判定を返す
    func isExpired(row: Int) -> Bool {
        Format().stringFromDate(date: Date()) > model?[row].todoDate ?? ""
    }

}
