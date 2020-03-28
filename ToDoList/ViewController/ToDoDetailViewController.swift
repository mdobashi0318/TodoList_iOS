//
//  ToDoDetailViewController.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/11/12.
//  Copyright © 2018 m.dobashi. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications


class ToDoDetailViewController: UIViewController {
    
    // MARK: Properties
    
    let realm: Realm = try! Realm()
    private var todoId:Int?
    private var tableValue:TableValue?
    
    private var toDoModel: ToDoModel!
    
    private lazy var toDoDetailView:ToDoDetailTableView = {
        let tableView: ToDoDetailTableView = ToDoDetailTableView(frame: frame_Size(self), style: .plain)
        
        return tableView
    }()
    
    // MARK: Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(todoId:Int) {
        self.init(nibName: nil, bundle: nil)
        self.todoId = todoId
        
        toDoModel = (realm.objects(ToDoModel.self).filter("id == '\(String(describing: todoId))'").first)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.rightBarAction))
        
        view.addSubview(toDoDetailView)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // テーブルビューの更新
        tableValue = setTableValue()
        
        toDoDetailView.tableValue = tableValue
        toDoDetailView.reloadData()
        
        
    }
    
    
    
    // MARK: Private Func
    
    /// ToDoのValueをセットする
    private func setTableValue() -> TableValue {
        return TableValue(id: toDoModel.id,
                          title: toDoModel.toDoName,
                          todoDate: toDoModel.todoDate!,
                          detail: toDoModel.toDo
        )
    }
    
    
    /// アクションシートを開く
    @objc private func rightBarAction(){
        let alertSheet:UIAlertController = UIAlertController(title: nil, message: "Todoをどうしますか?", preferredStyle: .actionSheet)
        alertSheet.addAction(UIAlertAction(title: "編集", style: .default) {[weak self] action in
            let inputViewController:InputViewController = InputViewController(todoId: (self?.todoId!)!)
            self?.navigationController?.pushViewController(inputViewController, animated: true)
        })
        
        alertSheet.addAction(UIAlertAction(title: "削除", style: .destructive) { [weak self] action in
            
            ToDoModel.deleteRealm(self!, todoId: (self?.todoId!)!) {
                self?.navigationController?.popViewController(animated: true)
            }
            
        })
        alertSheet.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        
        self.present(alertSheet,animated: true, completion: nil)
    }
    
}
