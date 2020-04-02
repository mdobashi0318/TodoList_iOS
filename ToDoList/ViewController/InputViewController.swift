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
    
    /// Realmのインタンス
    private var realm: Realm?
    
    /// ToDoを入力するためのView
    private lazy var todoInputTableView: TodoInputTableView = {
        
        if todoId == nil {
            let view = TodoInputTableView(frame: frame_Size(self), todoId: nil, tableValue: nil)
            
            return view
            
        } else {
            tableValue = TableValue(id: toDoModel.id,
                                    title: toDoModel.toDoName,
                                    todoDate: toDoModel.todoDate!,
                                    detail: toDoModel.toDo,
                                    createTime: toDoModel.createTime
            )
            let view = TodoInputTableView(frame: frame_Size(self),todoId: todoId, tableValue: tableValue)
            
            return view
        }
    }()
        
    /// ToDoのIDを格納
    private var todoId: Int?
    
    /// ToDoModelのインスタンス
    private var toDoModel: ToDoModel!
    
    /// ToDoのValueの格納するインスタンス
    private var tableValue: TableValue?
    
    
    
    // MARK: Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setRealm()
        
    }
    
    
    /// 編集時のinit
    ///
    /// - Parameter todoId: 編集するTodoのid
    convenience init(todoId:Int, createTime: String?) {
        self.init(nibName: nil, bundle: nil)
        self.todoId = todoId
        toDoModel = ToDoModel.findRealm(self, todoId: todoId, createTime: createTime)
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
        
        view.addSubview(todoInputTableView)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
    // MARK: NavigationButton Action
    
    /// Todoの新規作成時はモーダルを閉じる,編集時はも一つ前の画面に戻る
    @objc func leftButton() {
        if todoId == nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    /// Todoの保存、更新
    @objc func rightButton() {
        
        // バリデーションする
        if todoInputTableView.titletextField.text!.isEmpty {
            AlertManager().alertAction(self,
                              message: "ToDoのタイトルが入力されていません",
                              handler: { _ in return })
            
            return
        }
        
        if todoInputTableView.dateTextField.text!.isEmpty {
            AlertManager().alertAction(self,
                              message: "ToDoの期限が入力されていません",
                              handler: { _ in return })
            
            return
        }
        
        if todoInputTableView.detailTextViwe.text.isEmpty {
            AlertManager().alertAction(self,
                              message: "ToDoの詳細が入力されていません",
                              handler: { _ in return })
            
            return
        }
        
        
        
        if todoId != nil {
            updateRealm() { [weak self] in
                self?.addNotification()
                
                AlertManager().alertAction(self!,
                                           message: "ToDoを更新しました") { [weak self] action in
                                            
                                            self?.navigationController?.popViewController(animated: true)
                }
            }

        } else {
            
            addRealm { [weak self] in
                self?.addNotification()
                if #available(iOS 13.0, *) {
                    NotificationCenter.default.post(name: Notification.Name(ViewUpdate), object: nil)
                }
                AlertManager().alertAction(self!, message: "ToDoを登録しました") { [weak self] action in
                    self?.dismiss(animated: true)
                }
            }
        }
        
    }
    
    
    
    // MARK: Set Notification
    
    /// 通知を設定する
    private func addNotification() {
        
        let content:UNMutableNotificationContent = UNMutableNotificationContent()
        
        content.title = (todoInputTableView.titletextField.text)!
        
        content.body = (todoInputTableView.detailTextViwe.text)!
        
        content.sound = UNNotificationSound.default
        
        
        //通知する日付を設定
        guard let date:Date = (todoInputTableView.tmpDate) else {
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
    
    /// Realmのインスタンスを生成
    func setRealm() {
        do {
            realm = try Realm()
            
        } catch {
            AlertManager().alertAction(self,
                                       message: "エラーが発生しました") { _ in
                                        return
            }
            return
        }
    }
    
    /// ToDoを追加する
    private func addRealm(completeHandler: () -> Void) {
        let id: String = String((realm?.objects(ToDoModel.self).count)! + 1)
        
        ToDoModel.addRealm(self, addValue: TableValue(id: id,
                                                title: (todoInputTableView.titletextField.text)!,
                                                todoDate: todoInputTableView.dateTextField.text!,
                                                detail: (todoInputTableView.detailTextViwe.text)!)
        )
        
        completeHandler()
    }
    
    
    /// ToDoの更新
    private func updateRealm(completeHandler: () -> Void) {
        ToDoModel.updateRealm(self, todoId: todoId!,
                              updateValue: TableValue(id: String(todoId!),
                                                      title: (todoInputTableView.titletextField.text)!,
                                                      todoDate: todoInputTableView.dateTextField.text!,
                                                      detail: (todoInputTableView.detailTextViwe.text)!))
        
        completeHandler()
        
    }
    
}








