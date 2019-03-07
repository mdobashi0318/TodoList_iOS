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
    private var todoListTableView:TodoListTableView?
    private let realm:Realm = try! Realm()
    private var tableValues:[TableValue] = [TableValue]()
    private var todoModel = [ToDoModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "ToDoリスト"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.leftBarAction))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for i in 0..<realm.objects(ToDoModel.self).count{
            tableValues.append(TableValue(id: realm.objects(ToDoModel.self)[i].id,
                                          title: realm.objects(ToDoModel.self)[i].toDoName,
                                          todoDate: realm.objects(ToDoModel.self)[i].todoDate!,
                                          detail: realm.objects(ToDoModel.self)[i].toDo))
        }
  
        todoListTableView = TodoListTableView(frame: frame_Size(self), style: .plain, tableValue: tableValues)
        todoListTableView?.toDoListViewDelegate = self
        self.view.addSubview(todoListTableView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        tableValues.removeAll()
    }
    
    /// Todoの入力画面を開く
    @objc func leftBarAction(){
        let inputViewController:InputViewController = InputViewController()
        let navigationController:UINavigationController = UINavigationController(rootViewController: inputViewController)
        self.present(navigationController,animated: true, completion: nil)
    }
    
    
    /// Todoの詳細を開く
    ///
    /// - Parameter indexPath: 選択したcellの行
    func cellTapAction(indexPath: IndexPath) {
        let toDoDetailViewController:ToDoDetailViewController = ToDoDetailViewController(todoId: indexPath.row)
        self.navigationController?.pushViewController(toDoDetailViewController, animated: true)
    }
    
    func editAction(indexPath: IndexPath) {
        let inputViewController:InputViewController = InputViewController(todoId: indexPath.row)
        self.navigationController?.pushViewController(inputViewController, animated: true)
    }
    
    
    // MARK: - Realm Func
    
    func deleteAction(indexPath: IndexPath) {
        AlertManager().alertAction(viewController: self, title: nil, message: "削除しますか?", handler1: {[weak self] action in
            
            let toDoModel = self?.realm.objects(ToDoModel.self)[indexPath.row]
            
            try! self?.realm.write() {
                self?.realm.delete(toDoModel!)
                self?.tableValues.removeAll()
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

