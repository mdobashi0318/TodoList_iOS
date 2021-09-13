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

    /// 期限切れかどうかの判定を返す
    func isExpired(row: Int) -> Bool {
        Format().stringFromDate(date: Date()) > model?[row].todoDate ?? ""
    }

}
