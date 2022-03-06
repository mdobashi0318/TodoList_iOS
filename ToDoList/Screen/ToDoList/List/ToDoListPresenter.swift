//
//  ToDoListPresenter.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2020/08/17.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation

final class ToDoListPresenter {

    private(set) var model: [ToDoModel] = []

    func fetchToDoList(segmentIndex index: CompletionFlag, success: () -> Void, failure: (String) -> Void) {
        model = ToDoModel.activeFindToDo(index: index)
        Log.devprint("\(index)のToDoを表示します: \(model)")
        success()
    }

    /// 期限切れかどうかの判定を返す
    func isExpired(row: Int) -> CompletionFlag {
        if  model[row].completionFlag == CompletionFlag.completion.rawValue {
            return CompletionFlag.completion
        } else {
            let flag = Format().stringFromDate(date: Date()) > model[row].todoDate ?? ""
            return flag ? CompletionFlag.expired : CompletionFlag.unfinished
        }
    }

}
