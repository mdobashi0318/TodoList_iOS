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
    
}
