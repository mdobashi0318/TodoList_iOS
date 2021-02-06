//
//  ToDoListPresenter.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2020/08/17.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation


final class ToDoListPresenter {
    
    var model: [ToDoModel]?
    
    func fetchToDoList(segmentIndex index: SegmentIndex, success: ()->(), failure: (String?)->()) {
        
        switch index {
        case .all:
            model = ToDoModel.allFindToDo()
        case .active:
            model = ToDoModel.activeFindToDo(index: index)
        case .expired:
            model = ToDoModel.activeFindToDo(index: index)
        }
        
        if model == nil {
            failure("エラーが発生しました")
            return
            
        }
        success()
    }
    
    
    func allDelete(success: ()->(), failure: @escaping (String?)->()) {
        switch ToDoModel.allDeleteToDo() {
        case .success:
            success()
        case .failure:
            failure("削除に失敗しました")
        }
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
