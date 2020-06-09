//
//  InputViewController.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/09/13.
//  Copyright © 2018年 m.dobashi. All rights reserved.
//

import UIKit
import UserNotifications

class TodoRegisterViewController: UIViewController, TodoRegisterDelegate {
    
    
    
    // MARK: Properties
    
    /// ToDoを入力するためのView
    private lazy var todoInputTableView: TodoRegisterTableView = {
        
        
        
        if todoId == nil {
            let view = TodoRegisterTableView(frame: frame_Size(self), toDoModel: nil)
            
            return view
            
        } else {
            let view = TodoRegisterTableView(frame: frame_Size(self), toDoModel: self.toDoModel)
            
            return view
        }
    }()
        
    /// ToDoのIDを格納
    private var todoId: String?
    
    /// ToDoModelのインスタンス
    private var toDoModel: ToDoModel!
    
    
    // MARK: Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    /// 編集時のinit
    ///
    /// - Parameter todoId: 編集するTodoのid
    convenience init(todoId: String, createTime: String?) {
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
        
        view.backgroundColor = UIColor.white
        setNavigationItem()
        
        todoInputTableView.toDoregisterDelegate = self
        view.addSubview(todoInputTableView)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
    // MARK: NavigationButton Action
    
    
    private func setNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(leftButton)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(rightButton)
        )
    }
    
    
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
                AlertManager().alertAction(self!,
                                           message: "ToDoを更新しました") { [weak self] action in
                                            
                                            self?.navigationController?.popViewController(animated: true)
                }
            }

        } else {
            
            addRealm { [weak self] in
                AlertManager().alertAction(self!, message: "ToDoを登録しました") { [weak self] action in
                    self?.dismiss(animated: true)
                }
            }
        }
        
    }
    
    
    
    
    
    
    // MARK: Realm func
    
    /// ToDoを追加する
    private func addRealm(completeHandler: () -> Void) {
        let id: String = String(ToDoModel.allFindRealm(self)!.count + 1)
        
        ToDoModel.addRealm(self, addValue: ToDoModel(id: id,
                                                     toDoName: (todoInputTableView.titletextField.text)!,
                                                     todoDate: todoInputTableView.dateTextField.text!,
                                                     toDo: (todoInputTableView.detailTextViwe.text)!,
                                                     createTime: nil)
        )
        
        completeHandler()
    }
    
    
    /// ToDoの更新
    private func updateRealm(completeHandler: () -> Void) {
        ToDoModel.updateRealm(self, todoId: todoId!,
                              updateValue: ToDoModel(id: String(todoId!),
                                                     toDoName: (todoInputTableView.titletextField.text)!,
                                                     todoDate: todoInputTableView.dateTextField.text!,
                                                     toDo: (todoInputTableView.detailTextViwe.text)!,
                                                     createTime: self.toDoModel.createTime)
        )
        
        completeHandler()
        
    }
    
    
    /// Todoの追加時にテキスト入力中だったらモーダルを本当に閉じるかの確認フラグをtrueにする
    func textChenge() {
        if #available(iOS 13.0, *) {
            if todoInputTableView.titletextField.text!.isEmpty &&
                todoInputTableView.dateTextField.text!.isEmpty &&
                todoInputTableView.detailTextViwe.text.isEmpty {
                isModalInPresentation = false
            } else {
                isModalInPresentation = true
            }
        }
    }
    
}








