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
    private lazy var todoRegisterTableView: TodoRegisterTableView = {
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
        
        todoRegisterTableView.toDoregisterDelegate = self
        view.addSubview(todoRegisterTableView)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
    
    // MARK: NavigationButton Action
    
    /// ナビゲーションボタンをセットする
    private func setNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(didTapLeftButton)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(didTapRightButton)
        )
    }
    
    
    /// ナビゲーションボタンの左のボタンタップ時
    /// Todoの新規作成時はモーダルを閉じる
    ///
    /// 編集時は一つ前の画面に戻る
    @objc func didTapLeftButton() {
        if todoId == nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    /// ナビゲーションボタンの右のボタンタップ時
    ///
    /// バリデーションチェックを通った場合は、Todoの保存または更新をする
    @objc func didTapRightButton() {
        validateCheck { result in
            if result == true {
                realmAction()
            }
        }
    }
    
    
    
    // MARK: Realm func
    
    /// Todoの追加または更新をする
    private func realmAction() {
        if todoId != nil {
            updateRealm() { [weak self] in
                AlertManager().alertAction(self!, message: "ToDoを更新しました") { action in
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            
        } else {
            addRealm { [weak self] in
                AlertManager().alertAction(self!, message: "ToDoを登録しました") { action in
                    self?.dismiss(animated: true)
                }
            }
            
        }
    }
    
    
    
    /// ToDoを追加する
    private func addRealm(completeHandler: () -> Void) {
        let id: String = String(ToDoModel.allFindRealm(self)!.count + 1)
        
        ToDoModel.addRealm(self, addValue: ToDoModel(id: id,
                                                     toDoName: (todoRegisterTableView.titletextField.text)!,
                                                     todoDate: todoRegisterTableView.dateTextField.text!,
                                                     toDo: (todoRegisterTableView.detailTextViwe.text)!,
                                                     createTime: nil)
        )
        
        completeHandler()
    }
    
    
    /// ToDoの更新
    private func updateRealm(completeHandler: () -> Void) {
        ToDoModel.updateRealm(self, todoId: todoId!,
                              updateValue: ToDoModel(id: String(todoId!),
                                                     toDoName: (todoRegisterTableView.titletextField.text)!,
                                                     todoDate: todoRegisterTableView.dateTextField.text!,
                                                     toDo: (todoRegisterTableView.detailTextViwe.text)!,
                                                     createTime: self.toDoModel.createTime)
        )
        
        completeHandler()
    }
    
    
    
    
    /// バリデーションチェックをする
    /// - Parameter result: テキストが入力されているか判定結果
    /// - Returns: 入力項目が全て入力されていればtrue、一つでも入力されていなければfalse
    private func validateCheck(result: (Bool) -> ()) {
        
        if todoRegisterTableView.titletextField.text!.isEmpty {
            AlertManager().alertAction(self,
                                       message: "ToDoのタイトルが入力されていません") { _ in return }
            
            result(false)
        } else if todoRegisterTableView.dateTextField.text!.isEmpty {
            AlertManager().alertAction(self,
                                       message: "ToDoの期限が入力されていません") { _ in return }
            
            result(false)
        } else if todoRegisterTableView.detailTextViwe.text.isEmpty {
            AlertManager().alertAction(self,
                                       message: "ToDoの詳細が入力されていません") { _ in return }
            
            result(false)
        } else {
            result(true)
        }

    }
    
    
    /// Todoの追加時にテキスト入力中だったらモーダルを本当に閉じるかの確認フラグをtrueにする
    func textChenge() {
        if #available(iOS 13.0, *) {
            if todoRegisterTableView.titletextField.text!.isEmpty &&
                todoRegisterTableView.dateTextField.text!.isEmpty &&
                todoRegisterTableView.detailTextViwe.text.isEmpty {
                isModalInPresentation = false
            } else {
                isModalInPresentation = true
            }
        }
    }
    
}








