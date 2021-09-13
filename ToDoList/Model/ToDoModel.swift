//
//  RealmManager.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/09/26.
//  Copyright © 2018 m.dobashi. All rights reserved.
//

import Foundation
import RealmSwift

enum CompletionFlag: String, CaseIterable {
    /// 未完
    case unfinished = "0"
    /// 完了
    case completion = "1"
    /// 期限切れ
    case expired = "2"
}

// MARK: - TodoListError

struct TodoListError: Error {

    var type: ErrorType

    private(set) var message: String = ""

    enum ErrorType: CaseIterable {
        case add, update, delete, allDelete
    }

    init(type: ErrorType) {
        self.type = type
        switch type {
        case .add:
            message = R.string.message.addError()
        case .update:
            message = R.string.message.updateError()
        case.delete:
            message = R.string.message.deleteError()
        case .allDelete:
            message = R.string.message.allDeleteError()
        }
    }

}

// MARK: - ToDoModel
final class ToDoModel: Object {

    // MARK: Properties

    /// todoのid(非推奨)
    @objc dynamic var id: String = ""

    /// Todoの期限
    @objc dynamic var todoDate: String?

    /// Todoのタイトル
    @objc dynamic var toDoName: String = ""

    /// Todoの詳細
    @objc dynamic var toDo: String = ""

    /// Todoの完了フラグ
    /// - 0: 未完
    /// - 1: 完了
    @objc dynamic var completionFlag: String = ""

    /// Todoの作成日時(プライマリキー)
    @objc dynamic var createTime: String?

    // createTimeをプライマリキーに設定
    override static func primaryKey() -> String? {
        "createTime"
    }

    // MARK: init

    convenience init(id: String = "", toDoName: String, todoDate: String?, toDo: String, completionFlag: String, createTime: String?) {
        self.init()

        self.id = id
        self.toDoName = toDoName
        self.todoDate = todoDate
        self.toDo = toDo
        self.completionFlag = completionFlag
        self.createTime = createTime
    }

    /// Realmのインスタンス化
    private static var initRealm: Result<Realm, Error> {
        let realm: Realm
        var configuration: Realm.Configuration = Realm.Configuration()
        configuration.schemaVersion = UInt64(1)

        do {
            realm = try Realm(configuration: configuration)
            return .success(realm)
        } catch {
            return .failure(error)
        }
    }

    /// ToDoを追加する
    /// - Parameters:
    ///   - addValue: 追加するToDo
    ///   - addError: エラー発生時のクロージャー
    class func add(addValue: ToDoModel) -> Result<Void, TodoListError> {
        switch ToDoModel.initRealm {
        case .success(let realm):
            let toDoModel = ToDoModel(id: String(allFind()!.count),
                                      toDoName: addValue.toDoName,
                                      todoDate: addValue.todoDate,
                                      toDo: addValue.toDo,
                                      completionFlag: CompletionFlag.unfinished.rawValue,
                                      createTime: Format().stringFromDate(date: Date(), addSec: true)
            )

            do {

                try realm.write {
                    realm.add(toDoModel)
                }

                Log.devprint("Todoを作成しました: \(toDoModel)")
                NotificationManager().addNotification(toDoModel: toDoModel) { result in
                    NotificationCenter.default.post(name: Notification.Name(R.string.notification.tableReload()), object: nil)
                    NotificationCenter.default.post(name: Notification.Name(R.string.notification.toast()), object: result)
                }
                return .success(Void())
            } catch {
                Log.devprint(error.localizedDescription)
                return .failure(TodoListError(type: .add))
            }
        case .failure(let error):
            Log.devprint(error.localizedDescription)
            return .failure(TodoListError(type: .add))
        }
    }

    /// ToDoの更新
    /// - Parameters:
    ///   - updateValue: 更新するToDo
    ///   - updateError: エラー発生時のクロージャー
    class func update(updateValue: ToDoModel) -> Result<Void, TodoListError> {
        switch ToDoModel.initRealm {
        case .success(let realm):

            let toDoModel = ToDoModel.find(todoId: updateValue.id, createTime: updateValue.createTime)!

            do {
                try realm.write {
                    toDoModel.toDoName = updateValue.toDoName
                    toDoModel.todoDate = updateValue.todoDate
                    toDoModel.toDo = updateValue.toDo
                    toDoModel.completionFlag = CompletionFlag.unfinished.rawValue
                }
                Log.devprint("Todoを更新しました: \(toDoModel)")
                NotificationManager().addNotification(toDoModel: toDoModel) { result in
                    NotificationCenter.default.post(name: Notification.Name(R.string.notification.tableReload()), object: nil)
                    NotificationCenter.default.post(name: Notification.Name(R.string.notification.toast()), object: result)
                }
                return .success(Void())
            } catch {
                Log.devprint(error.localizedDescription)
                return .failure(TodoListError(type: .update))
            }
        case .failure(let error):
            Log.devprint(error.localizedDescription)
            return .failure(TodoListError(type: .update))
        }
    }

    /// 完了フラグの更新
    /// - Parameters:
    ///   - updateTodo: 更新するTodo
    ///   - flag: 変更する値
    static func updateCompletionFlag(updateTodo: ToDoModel, flag: CompletionFlag) {
        switch initRealm {
        case .success(let realm):
            guard let toDoModel = ToDoModel.find(todoId: updateTodo.id, createTime: updateTodo.createTime) else { return }
            try? realm.write {
                toDoModel.completionFlag = flag.rawValue
            }
            if updateTodo.completionFlag == CompletionFlag.completion.rawValue {
                NotificationManager().removeNotification([toDoModel.createTime ?? ""])
            } else {
                NotificationManager().addNotification(toDoModel: toDoModel) { result in
                    NotificationCenter.default.post(name: Notification.Name(R.string.notification.tableReload()), object: nil)
                    NotificationCenter.default.post(name: Notification.Name(R.string.notification.toast()), object: result)
                }
            }

        case .failure(let error):
            Log.devprint("完了フラグ更新エラー: \(error)")
        }
    }

    /// １件取得
    /// - Parameters:
    ///   - todoId: todoId
    ///   - createTime: 作成時間
    class func find(todoId: String, createTime: String?) -> ToDoModel? {
        switch ToDoModel.initRealm {
        case .success(let realm):
            if let _createTime = createTime {
                let todo = (realm.objects(ToDoModel.self).filter("createTime == '\(String(describing: _createTime))'").first)
                Log.devprint("Todoを１件表示します: \(String(describing: todo))")
                return todo
            } else {
                let todo = (realm.objects(ToDoModel.self).filter("id == '\(todoId)'").first!)
                Log.devprint("Todoを１件表示します: \(todo)")
                return todo
            }
        case .failure(let error):
            Log.devprint(error.localizedDescription)
            return nil
        }
    }

    /// 全件取得
    /// - Parameter vc: 呼び出し元のViewController
    /// - Returns: 取得したTodoを全件返す
    class func allFind() -> [ToDoModel]? {
        switch ToDoModel.initRealm {
        case .success(let realm):
            var todomodel = [ToDoModel]()
            let todo = realm.objects(ToDoModel.self)
            todo.forEach { value in
                todomodel.append(value)
            }
            return todomodel
        case .failure(let error):
            Log.devprint(error.localizedDescription)
            return nil
        }
    }

    /// 全件取得
    class func activeFindToDo(index: CompletionFlag) -> [ToDoModel]? {
        guard let todomodel = ToDoModel.allFind() else {
            return nil
        }

        switch index {
        case .completion:
            let filterToDo = todomodel.filter {
                $0.completionFlag == CompletionFlag.completion.rawValue
            }
            Log.devprint("完了したToDoを表示します: \(filterToDo)")
            return filterToDo
        case .unfinished:
            let filterToDo = todomodel.filter {
                $0.todoDate! >= Format().stringFromDate(date: Date()) && $0.completionFlag != CompletionFlag.completion.rawValue
            }
            Log.devprint("未完了のToDoを表示します: \(filterToDo)")
            return filterToDo
        case .expired:
            let filterToDo = todomodel.filter {
                $0.todoDate! < Format().stringFromDate(date: Date()) && $0.completionFlag != CompletionFlag.completion.rawValue
            }
            Log.devprint("期限の過ぎたToDoを表示します: \(filterToDo)")
            return filterToDo
        }

        return nil
    }

    /// ToDoの削除
    /// - Parameters:
    ///   - vc: 呼び出し元のViewController
    ///   - todoId: TodoId
    ///   - createTime: Todoの作成時間
    ///   - completion: 削除完了後の動作
    class func delete(_ model: ToDoModel) -> Result<Void, TodoListError> {
        switch ToDoModel.initRealm {
        case .success(let realm):
            guard let toDoModel = ToDoModel.find(todoId: model.id, createTime: model.createTime) else {
                return .failure(TodoListError(type: .delete))
            }
            NotificationManager().removeNotification([toDoModel.createTime!])
            do {
                Log.devprint("Todoを削除します: \(toDoModel)")
                try realm.write {
                    realm.delete(toDoModel)
                }
                Log.devprint("Todoを削除しました")
                return .success(Void())
            } catch {
                Log.devprint(error.localizedDescription)
                return .failure(TodoListError(type: .delete))
            }
        case .failure(let error):
            Log.devprint(error.localizedDescription)
            return .failure(TodoListError(type: .delete))
        }
    }

    /// 全件削除
    /// - Parameters:
    ///   - vc: 呼び出し元のViewController
    ///   - completion: 削除完了後の動作
    class func allDelete() -> Result<Void, TodoListError> {
        switch ToDoModel.initRealm {
        case .success(let realm):
            do {
                try realm.write {
                    realm.deleteAll()
                    Log.devprint("ToDoを全件削除しました")
                    NotificationManager().allRemoveNotification()
                }
                return .success(Void())
            } catch {
                Log.devprint(error.localizedDescription)
                return .failure(TodoListError(type: .delete))
            }
        case .failure(let error):
            Log.devprint(error.localizedDescription)
            return .failure(TodoListError(type: .delete))
        }
    }

}
