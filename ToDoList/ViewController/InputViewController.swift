//
//  InputViewController.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/09/13.
//  Copyright © 2018年 m.dobashi. All rights reserved.
//

import UIKit
import UserNotifications
import RealmSwift

class InputViewController: UIViewController {
    
    // MARK: Properties
    let realm:Realm = try! Realm()
    
    private var todoInputTableView:TodoInputTableView?
    private var todoId:Int?
    private var toDoModel:ToDoModel = ToDoModel()
    
    private var tableValue:TableValue?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    // MARK: Init
    
    /// 編集時のinit
    ///
    /// - Parameter todoId: 編集するTodoのid
    convenience init(todoId:Int) {
        self.init(nibName: nil, bundle: nil)
        self.todoId = todoId
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(leftButton))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(rightButton))
        
        if todoId == nil {
            todoInputTableView = TodoInputTableView(frame: frame_Size(self))
        } else {
            tableValue = TableValue(id: realm.objects(ToDoModel.self)[todoId!].id,
                                    title: realm.objects(ToDoModel.self)[todoId!].toDoName,
                                    todoDate: realm.objects(ToDoModel.self)[todoId!].todoDate!,
                                    detail: realm.objects(ToDoModel.self)[todoId!].toDo
            )
            todoInputTableView = TodoInputTableView(frame: frame_Size(self), style: .plain, todoId: todoId, tableValue: tableValue!)
        }
        self.view.addSubview(todoInputTableView!)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /// Todoの新規作成時はモーダルを閉じる,編集時はも一つ前の画面に戻る
    @objc func leftButton(){
        if todoId == nil {
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    /// Todoの保存、更新
    @objc func rightButton(){
        
        // バリデーションする
        
        let alert = AlertManager()
        if todoInputTableView?.titletextField.text?.count == 0 {
            alert.alertAction(viewController: self,
                              title: "",
                              message: "ToDoのタイトルが入力されていません",
                              handler: { _ in return })
        }
        
        if todoInputTableView?.dateTextField.text?.count == 0 {
            alert.alertAction(viewController: self,
                              title: "",
                              message: "ToDoの期限が入力されていません",
                              handler: { _ in return })
        }
        
        if todoInputTableView?.detailTextViwe.text?.count == 0 {
            alert.alertAction(viewController: self,
                              title: "",
                              message: "ToDoの詳細が入力されていません",
                              handler: { _ in return })
        }
        
        addNotification()
        
        if todoId != nil {
            alert.alertAction(viewController: self,
                              title: "",
                              message: "ToDoを更新しました",
                              handler: {[weak self] action in
                                self?.updateRealm()
                                self?.navigationController?.popViewController(animated: true)
                                return
            })
        }
        
        
        alert.alertAction(viewController: self,
                          title: "",
                          message: "ToDoを登録しました",
                          handler: {[weak self] action in
                            self?.addRealm()
                            self?.dismiss(animated: true, completion: nil)
        })
    }
    
    
    
    /// 通知を設定する
    private func addNotification() {
        
        let content:UNMutableNotificationContent = UNMutableNotificationContent()
        
        content.title = (todoInputTableView?.titletextField.text)!
        
        content.body = (todoInputTableView?.detailTextViwe.text)!
        
        content.sound = UNNotificationSound.default
        
        
        //通知する日付を設定
        guard let date:Date = (todoInputTableView?.tmpDate) else {
            return
        }
        let calendar = Calendar.current
        let dateComponent = calendar.dateComponents([.year, .month, .day, .hour, .minute] , from: date)
        
        
        let trigger:UNCalendarNotificationTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        
        let request:UNNotificationRequest = UNNotificationRequest.init(identifier: content.title, content: content, trigger: trigger)
        
        let center:UNUserNotificationCenter = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            
        }
        
    }
    
    
    
    // MARK: Realm func
    
    
    /// ToDoを追加する
    func addRealm(){
        
        toDoModel.id = String(realm.objects(ToDoModel.self).count + 1)
        toDoModel.toDoName = (todoInputTableView?.titletextField.text)!
        toDoModel.todoDate = todoInputTableView?.dateTextField.text
        toDoModel.toDo = (todoInputTableView?.detailTextViwe.text)!
        
        try! realm.write() {
            realm.add(toDoModel)
        }
    }
    
    
    /// ToDoの更新
    func updateRealm(){
        let realm:Realm = try! Realm()
        
        try! realm.write() {
            realm.objects(ToDoModel.self)[todoId!].toDoName = (todoInputTableView?.titletextField.text!)!
            realm.objects(ToDoModel.self)[todoId!].todoDate = todoInputTableView?.dateTextField.text
            realm.objects(ToDoModel.self)[todoId!].toDo = (todoInputTableView?.detailTextViwe.text)!
        }
    }

}








