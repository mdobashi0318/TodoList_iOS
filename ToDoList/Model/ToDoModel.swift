//
//  RealmManager.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/09/26.
//  Copyright © 2018 m.dobashi. All rights reserved.
//

import Foundation
import RealmSwift

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
    
    /// Todoの作成日時(プライマリキー)
    @objc dynamic var createTime: String?
    
    
    // createTimeをプライマリキーに設定
    override static func primaryKey() -> String? {
        return "createTime"
    }
    
    
    
    // MARK: init
    
    convenience init(id: String = "", toDoName: String, todoDate: String?, toDo: String, createTime: String?) {
        self.init()
        
        self.id = id
        self.toDoName = toDoName
        self.todoDate = todoDate
        self.toDo = toDo
        self.createTime = createTime
    }
    
    
    
    
    
    /// Realmのインスタンス化
    private class func initRealm() -> Realm? {
        let realm: Realm
        
        do {
            realm = try Realm()
            
            return realm
        }
        catch {
            return nil
        }
    }
    
    
    
    
    
    /// ToDoを追加する
    /// - Parameters:
    ///   - addValue: 追加するToDo
    ///   - addError: エラー発生時のクロージャー
    class func addToDo(addValue: ToDoModel, addError:(String?) -> ()) {
        guard let realm = initRealm() else {
            addError(R.string.localizable.errorMessage())
            return
        }
        
        let toDoModel: ToDoModel = ToDoModel(id: String(allFindToDo()!.count),
                                             toDoName: addValue.toDoName,
                                             todoDate: addValue.todoDate,
                                             toDo: addValue.toDo,
                                             createTime: Format().stringFromDate(date: Date(), addSec: true)
        )
        
        do {
            try realm.write() {
                realm.add(toDoModel)
            }
            devprint("Todoを作成しました: \(toDoModel)")
            NotificationManager().addNotification(toDoModel: toDoModel) { result in
                NotificationCenter.default.post(name: Notification.Name(TableReload), object: nil)
                NotificationCenter.default.post(name: Notification.Name(toast), object: result)
            }
            
        }
        catch {
            addError("Todoの追加に失敗しました")
        }
    
    }
    
    
    
    
    
    /// ToDoの更新
    /// - Parameters:
    ///   - updateValue: 更新するToDo
    ///   - updateError: エラー発生時のクロージャー
    class func updateToDo(updateValue: ToDoModel, updateError:(String?) -> ()) {
        guard let realm = initRealm() else {
            updateError(R.string.localizable.errorMessage())
            return
        }
        
        let toDoModel: ToDoModel = ToDoModel.findToDo(todoId: updateValue.id, createTime: updateValue.createTime)!
        
        do {
            try realm.write() {
                toDoModel.toDoName = updateValue.toDoName
                toDoModel.todoDate = updateValue.todoDate
                toDoModel.toDo = updateValue.toDo
            }
            devprint("Todoを更新しました: \(toDoModel)")
            NotificationManager().addNotification(toDoModel: toDoModel) { result in
                NotificationCenter.default.post(name: Notification.Name(TableReload), object: nil)
                NotificationCenter.default.post(name: Notification.Name(toast), object: result)
            }
              
        }
        catch {
            updateError("ToDoの更新に失敗しました")
            
        }
        
    }
    
    
    
    
    
    /// １件取得
    /// - Parameters:
    ///   - todoId: todoId
    ///   - createTime: 作成時間
    class func findToDo(todoId: String, createTime: String?) -> ToDoModel? {
        guard let realm = initRealm() else { return nil }
        
        if let _createTime = createTime {
            let todo = (realm.objects(ToDoModel.self).filter("createTime == '\(String(describing: _createTime))'").first)
            devprint("Todoを１件表示します: \(String(describing: todo))")
            return todo
        } else {
            let todo = (realm.objects(ToDoModel.self).filter("id == '\(todoId)'").first!)
            devprint("Todoを１件表示します: \(todo)")
            return todo
        }
        
        
    }
    
    
    /// 全件取得
    /// - Parameter vc: 呼び出し元のViewController
    /// - Returns: 取得したTodoを全件返す
    class func allFindToDo() -> [ToDoModel]? {
        guard let realm = initRealm() else { return nil }
        
        var todomodel = [ToDoModel]()
        let todo = realm.objects(ToDoModel.self)
        todo.forEach { value in
            todomodel.append(value)
        }
        devprint("Todoを全件表示します: \(todomodel)")
        return todomodel
    }
    
    
    
    /// 全件取得
    class func activeFindToDo(index: SegmentIndex) -> [ToDoModel]? {
        guard let realm = initRealm() else { return nil }
        
        var todomodel = [ToDoModel]()
        let todo = realm.objects(ToDoModel.self)
        todo.forEach { value in
            todomodel.append(value)
        }
        
        switch index {
        case .active:
            let filterToDo = todomodel.filter {
                $0.todoDate! > Format().stringFromDate(date: Date())
            }
            devprint("期限が過ぎていないToDoを表示します: \(filterToDo)")
            return filterToDo
        case .expired:
            let filterToDo = todomodel.filter {
                $0.todoDate! <= Format().stringFromDate(date: Date())
            }
            devprint("期限の過ぎたToDoを表示します: \(filterToDo)")
            return filterToDo
        default:
            break
        }
        
        return nil
    }
    
    
    
    /// ToDoの削除
    /// - Parameters:
    ///   - vc: 呼び出し元のViewController
    ///   - todoId: TodoId
    ///   - createTime: Todoの作成時間
    ///   - completion: 削除完了後の動作
    class func deleteToDo(todoId: String, createTime: String?, deleteError: (String?) -> Void) {
        guard let realm = initRealm() else { return }
        
        let toDoModel: ToDoModel = ToDoModel.findToDo(todoId: todoId, createTime: createTime)!
        
        NotificationManager().removeNotification([toDoModel.createTime!])
        
        do {
            devprint("Todoを削除します: \(toDoModel)")
            try realm.write() {
                realm.delete(toDoModel)
            }
            devprint("Todoを削除しました")
        }
        catch {
            deleteError("ToDoの削除に失敗しました")
        }
        
        
        
    }
    
    
    /// 全件削除
    /// - Parameters:
    ///   - vc: 呼び出し元のViewController
    ///   - completion: 削除完了後の動作
    class func allDeleteToDo(deleteError:@escaping (String?) ->Void) {
        guard let realm = initRealm() else { return }
        
        do {
            try realm.write {
                realm.deleteAll()
                devprint("ToDoを全件削除しました")
                NotificationManager().allRemoveNotification()
            }
        } catch {
            deleteError("ToDoの削除に失敗しました")
        }
            
        
    }
    
    
    
    /// 全件削除
    class func allDelete() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        devprint("ToDoを全件削除しました")
        NotificationManager().allRemoveNotification()
        
    }
    
    
    
    
    class func devprint(_ message: String) {
        #if DEBUG
        print("\(message)")
        #endif
    }
    

}
