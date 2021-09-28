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
        case add, update, delete, allDelete, initError
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
        case .initError:
            message = "システムエラーが発生しました"
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
    private static var initRealm: Realm? {
        let realm: Realm
        var configuration: Realm.Configuration = Realm.Configuration()
        configuration.schemaVersion = UInt64(1)
        do {
            realm = try Realm(configuration: configuration)
            return realm
        } catch {
            return nil
        }
    }

    /// ToDoを追加する
    /// - Parameters:
    ///   - addValue: 追加するToDo
    ///   - addError: エラー発生時のクロージャー
    class func add(addValue: ToDoModel) throws {
        guard let realm = ToDoModel.initRealm else {
            throw TodoListError(type: .initError)
        }
        let toDoModel = ToDoModel(id: String(allFind().count),
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
        } catch {
            Log.devprint(error.localizedDescription)
            throw TodoListError(type: .add)
        }
    }

    /// ToDoの更新
    /// - Parameters:
    ///   - updateValue: 更新するToDo
    ///   - updateError: エラー発生時のクロージャー
    class func update(updateValue: ToDoModel) throws {
        guard let realm = ToDoModel.initRealm,
              let toDoModel = ToDoModel.find(todoId: updateValue.id, createTime: updateValue.createTime) else {
            throw TodoListError(type: .initError)
        }

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
        } catch {
            Log.devprint(error.localizedDescription)
            throw TodoListError(type: .update)
        }
    }

    /// 完了フラグの更新
    /// - Parameters:
    ///   - updateTodo: 更新するTodo
    ///   - flag: 変更する値
    static func updateCompletionFlag(updateTodo: ToDoModel, flag: CompletionFlag) throws {
        guard let realm = ToDoModel.initRealm,
              let toDoModel = ToDoModel.find(todoId: updateTodo.id, createTime: updateTodo.createTime) else {
            throw TodoListError(type: .initError)
        }
        do {
            try realm.write {
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

        } catch {
            Log.devprint("完了フラグ更新エラー: \(error)")
            throw TodoListError(type: .update)
        }
    }

    /// １件取得
    /// - Parameters:
    ///   - todoId: todoId
    ///   - createTime: 作成時間
    class func find(todoId: String, createTime: String?) -> ToDoModel? {
        guard let realm = ToDoModel.initRealm,
              !todoId.isEmpty else {
            print(TodoListError(type: .initError).message)
            return nil
        }
        if let _createTime = createTime {
            let todo = (realm.objects(ToDoModel.self).filter("createTime == '\(String(describing: _createTime))'").first)
            Log.devprint("Todoを１件表示します: \(String(describing: todo))")
            return todo
        } else {
            let todo = (realm.objects(ToDoModel.self).filter("id == '\(todoId)'").first)
            Log.devprint("Todoを１件表示します: \(todo ?? ToDoModel())")
            return todo
        }
    }

    /// 全件取得
    /// - Parameter vc: 呼び出し元のViewController
    /// - Returns: 取得したTodoを全件返す
    class func allFind() -> [ToDoModel] {
        guard let realm = ToDoModel.initRealm else {
            return []
        }
        var todomodel = [ToDoModel]()
        let todo = realm.objects(ToDoModel.self)
        todo.forEach { value in
            todomodel.append(value)
        }
        return todomodel
    }

    /// 全件取得
    class func activeFindToDo(index: CompletionFlag) -> [ToDoModel] {
        let todomodel = ToDoModel.allFind()
        if todomodel.isEmpty {
            return []
        }

        switch index {
        case .completion:
            return todomodel.filter {
                $0.completionFlag == CompletionFlag.completion.rawValue
            }
        case .unfinished:
            return todomodel.filter {
                $0.todoDate ?? "" >= Format().stringFromDate(date: Date()) && $0.completionFlag != CompletionFlag.completion.rawValue
            }
        case .expired:
            return todomodel.filter {
                $0.todoDate ?? "" < Format().stringFromDate(date: Date()) && $0.completionFlag != CompletionFlag.completion.rawValue
            }
        }
    }

    /// ToDoの削除
    /// - Parameters:
    ///   - vc: 呼び出し元のViewController
    ///   - todoId: TodoId
    ///   - createTime: Todoの作成時間
    ///   - completion: 削除完了後の動作
    class func delete(_ model: ToDoModel) throws {
        guard let realm = ToDoModel.initRealm else {
            throw TodoListError(type: .initError)
        }
        guard let toDoModel = ToDoModel.find(todoId: model.id, createTime: model.createTime),
              let createTime = toDoModel.createTime else {
            throw TodoListError(type: .delete)
        }
        do {
            Log.devprint("Todoを削除します: \(toDoModel)")
            try realm.write {
                realm.delete(toDoModel)
            }
            NotificationManager().removeNotification([createTime])
            Log.devprint("Todoを削除しました")
        } catch {
            Log.devprint(error.localizedDescription)
            throw TodoListError(type: .delete)
        }
    }

    /// 全件削除
    /// - Parameters:
    ///   - vc: 呼び出し元のViewController
    ///   - completion: 削除完了後の動作
    class func allDelete() throws {
        guard let realm = ToDoModel.initRealm else {
            throw TodoListError(type: .initError)
        }
        do {
            try realm.write {
                realm.deleteAll()
                Log.devprint("ToDoを全件削除しました")
                NotificationManager().allRemoveNotification()
            }
        } catch {
            Log.devprint(error.localizedDescription)
            throw TodoListError(type: .delete)
        }
    }

}
