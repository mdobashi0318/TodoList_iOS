//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/09/13.
//  Copyright © 2018年 m.dobashi. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UIViewController, ToDoListViewDelegate {
    
    // MARK: Properties
    
    private let realm:Realm = try! Realm()
    
    private lazy var todoListTableView:TodoListTableView = {
        let tableView: TodoListTableView = TodoListTableView(frame: frame_Size(self), style: .plain)
        tableView.toDoListViewDelegate = self
        
        return tableView
    }()
    
    /// ToDoを格納する配列
    private var tableValues:[TableValue]?

    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "ToDoリスト"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.rightBarAction))
     
        tableValues = [TableValue]()
        view.addSubview(todoListTableView)
        
        #if DEBUG
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(leftButtonAction))
        navigationItem.leftBarButtonItem?.accessibilityIdentifier = "allDelete"
        #endif
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableValuesAppend()
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 配列の中身を削除
        tableValues?.removeAll()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    /// 配列に追加とViewのTableに反映
    func tableValuesAppend() {
        for i in 0..<realm.objects(ToDoModel.self).count{
            
            tableValues?.append(TableValue(id: realm.objects(ToDoModel.self)[i].id,
                                           title: realm.objects(ToDoModel.self)[i].toDoName,
                                           todoDate: realm.objects(ToDoModel.self)[i].todoDate!,
                                           detail: realm.objects(ToDoModel.self)[i].toDo))
            
            tableValues?.sort{ $0.date < $1.date }
        }
        
        
        todoListTableView.tableValues = tableValues!
        todoListTableView.separatorStyle = todoListTableView.tableValues.count != 0 ? .none : .singleLine
        todoListTableView.reloadData()
    }
    
    
    /// Todoの入力画面を開く
    @objc func rightBarAction(){
        let inputViewController:InputViewController = InputViewController()
        let navigationController:UINavigationController = UINavigationController(rootViewController: inputViewController)
        self.present(navigationController,animated: true, completion: nil)
    }
    
    
    
    /// データベース内の全件削除(Debug)
    @objc override func leftButtonAction(){
        AlertManager().alertAction(viewController: self, title: "データベースの削除", message: "作成した問題や履歴を全件削除します", handler1: { [weak self]  (action) in
            try! self?.realm.write {
                self?.realm.deleteAll()
            }
            self?.tableValues?.removeAll()
            self?.viewWillAppear(true)
            
        }){ (action) in return }
        
    }

    
    
    /// Todoの詳細を開く
    ///
    /// - Parameter indexPath: 選択したcellの行
    func cellTapAction(indexPath: IndexPath) {
        let toDoDetailViewController:ToDoDetailViewController = ToDoDetailViewController(todoId: indexPath.row)
        self.navigationController?.pushViewController(toDoDetailViewController, animated: true)
    }
    
    
    /// 選択したToDoの編集画面を開く
    ///
    /// - Parameter indexPath: 選択したcellの行
    func editAction(indexPath: IndexPath) {
        let inputViewController:InputViewController = InputViewController(todoId: indexPath.row)
        self.navigationController?.pushViewController(inputViewController, animated: true)
    }
    
    
    // MARK: - Realm Func
    
    /// 選択したToDoの削除
    ///
    /// - Parameter indexPath: 選択したcellの行
    func deleteAction(indexPath: IndexPath) {
        AlertManager().alertAction(viewController: self, title: nil, message: "削除しますか?", handler1: {[weak self] action in
            
            let toDoModel = self?.realm.objects(ToDoModel.self)[indexPath.row]
            
            try! self?.realm.write() {
                self?.realm.delete(toDoModel!)
                self?.tableValues?.removeAll()
            }
            
            self?.viewWillAppear(true)
            }, handler2: {_ -> Void in})
    }
}


struct TableValue {
    let id: String
    let title:String
    let date:String
    let detail:String
    
    init(id:String, title:String, todoDate:String, detail: String) {
        self.id = id
        self.title = title
        self.date = todoDate
        self.detail = detail
    }
}

