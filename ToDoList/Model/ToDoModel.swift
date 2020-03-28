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
    
    
    
    /// ToDoを追加する
    class func addRealm(_ vc: UIViewController, addValue:TableValue) {
        
        let realm: Realm = try! Realm()
        let toDoModel: ToDoModel = ToDoModel()
        
        toDoModel.id = addValue.id
        toDoModel.toDoName = addValue.title
        toDoModel.todoDate = addValue.date
        toDoModel.toDo = addValue.detail
        
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
        let realm: Realm = try! Realm()
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
    
    
    
    /// ToDoの削除
    class func deleteRealm(_ vc: UIViewController, todoId: Int ,completion: () ->Void) {
        let realm:Realm = try! Realm()
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
        let realm: Realm = try! Realm()
        
        AlertManager().alertAction(vc, title: "データベースの削除", message: "作成した問題や履歴を全件削除します", handler1: { (action) in
            try! realm.write {
                realm.deleteAll()
            }
            completion()

        }) { (action) in return }
        
    }
    
    
}
