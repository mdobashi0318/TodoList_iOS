//
//  RealmManager.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/09/26.
//  Copyright © 2018 m.dobashi. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoModel:Object {
    @objc dynamic var id:String = ""
    @objc dynamic var todoDate:String?
    @objc dynamic var toDoName:String = ""
    @objc dynamic var toDo:String = ""
    @objc dynamic var createTime:String?
    
    
    // idをプライマリキーに設定
    override static func primaryKey() -> String? {
        return "createTime"
    }
    
    
    
    
    /// Realmのインスタンス化
    class func initRealm(_ vc: UIViewController) -> Realm? {
        
        let realm: Realm
        do {
            realm = try Realm()
            
            return realm
        }
        catch {
            AlertManager().alertAction(vc, message: "エラーが発生しました") { _ in
                                        return
            }
        }
        
        return nil
    }
    
    /// ToDoを追加する
    class func addRealm(_ vc: UIViewController, addValue:TableValue) {
        
        guard let realm = initRealm(vc) else { return }
        let toDoModel: ToDoModel = ToDoModel()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ja_JP")
        let s_Date:String = formatter.string(from: Date())
        
        toDoModel.id = addValue.id
        toDoModel.toDoName = addValue.title
        toDoModel.todoDate = addValue.date
        toDoModel.toDo = addValue.detail
        toDoModel.createTime = s_Date
        
        do {
            try realm.write() {
                realm.add(toDoModel)
            }
        }
        catch {
            AlertManager().alertAction(vc, message: "ToDoの登録に失敗しました") { _ in
                                        return
            }
        }
    
    }
    
    
    
    /// ToDoの更新
    class func updateRealm(_ vc: UIViewController, todoId: Int, updateValue: TableValue) {
        guard let realm = initRealm(vc) else { return }
        let toDoModel: ToDoModel = (realm.objects(ToDoModel.self).filter("id == '\(String(describing: todoId))'").first!)
        
        do {
            try realm.write() {
                toDoModel.toDoName = updateValue.title
                toDoModel.todoDate = updateValue.date
                toDoModel.toDo = updateValue.detail
            }
        }
        catch {
            AlertManager().alertAction(vc,
                                       message: "ToDoの更新に失敗しました") { _ in
                                        return
            }
        }
        
    }
    
    
    /// １件取得
    class func findRealm(_ vc: UIViewController, todoId: Int, createTime: String?) -> ToDoModel? {
        guard let realm = initRealm(vc) else { return nil }
        
        if let _createTime = createTime {
            return (realm.objects(ToDoModel.self).filter("createTime == '\(String(describing: _createTime))'").first)
        } else {
            return(realm.objects(ToDoModel.self).filter("id == '\(String(describing: todoId))'").first!)
        }
        
        
    }
    
    
    
    /// 全件取得
    class func allFindRealm(_ vc: UIViewController) -> Results<ToDoModel>? {
        guard let realm = initRealm(vc) else { return nil }
        
        return realm.objects(ToDoModel.self)
    }
    
    
    /// ToDoの削除
    class func deleteRealm(_ vc: UIViewController, todoId: Int, createTime: String?, completion: () ->Void) {
        guard let realm = initRealm(vc) else { return }
        let toDoModel: ToDoModel = (realm.objects(ToDoModel.self).filter("id == '\(String(describing: todoId))'").first!)
        
        UNUserNotificationCenter
            .current()
            .removePendingNotificationRequests(withIdentifiers: [toDoModel.toDoName])
        
        do {
            try realm.write() {
                realm.delete(toDoModel)
            }
        }
            
        catch {
            AlertManager().alertAction(vc,
                                       message: "ToDoの削除に失敗しました") { _ in
                                        return
            }
        }
        
        
        completion()
    }
    
    
    /// 全件削除
    class func allDeleteRealm(_ vc: UIViewController, completion:@escaping () ->Void) {
        guard let realm = initRealm(vc) else { return }
        
        AlertManager().alertAction(vc, title: "データベースの削除", message: "作成した問題や履歴を全件削除します", handler1: { (action) in
            try! realm.write {
                realm.deleteAll()
            }
            completion()

        }) { (action) in return }
        
    }
    
    
}
