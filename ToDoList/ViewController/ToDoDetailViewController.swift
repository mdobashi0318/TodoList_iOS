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
    private var toDoDetailView:ToDoDetailTableView?
    private var todoId:Int?
    private var tableValue:TableValue?
    
    
    let realm:Realm = try! Realm()
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(todoId:Int) {
        self.init(nibName: nil, bundle: nil)
        self.todoId = todoId
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableValue = TableValue(id: realm.objects(ToDoModel.self)[todoId!].id, title: realm.objects(ToDoModel.self)[todoId!].toDoName, todoDate: realm.objects(ToDoModel.self)[todoId!].todoDate!, detail: realm.objects(ToDoModel.self)[todoId!].toDo)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.rightBarAction))
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        toDoDetailView = ToDoDetailTableView(frame: frame_Size(self), style: .plain, todoId: todoId, tableValue: tableValue!)
        self.view.addSubview(toDoDetailView!)
    }
    
    
    /// アクションシートを開く
    @objc private func rightBarAction(){
        let alertSheet:UIAlertController = UIAlertController(title: nil, message: "Todoをどうしますか?", preferredStyle: .actionSheet)
        alertSheet.addAction(UIAlertAction(title: "編集", style: .default, handler: {[weak self] action in
            let inputViewController:InputViewController = InputViewController(todoId: (self?.todoId!)!)
            self?.navigationController?.pushViewController(inputViewController, animated: true)
        })
        )
        alertSheet.addAction(UIAlertAction(title: "削除", style: .destructive, handler: {[weak self] action in
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [(self?.realm.objects(ToDoModel.self)[(self?.todoId!)!].toDoName)!])
            self?.deleteRealm()
            self?.navigationController?.popViewController(animated: true)
        })
        )
        alertSheet.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        
        self.present(alertSheet,animated: true, completion: nil)
    }
    

    
    // MARK: - Realm func
    
    func deleteRealm(){
        let realm:Realm = try! Realm()
        let toDoModel = realm.objects(ToDoModel.self)[todoId!]
        
        try! realm.write() {
            realm.delete(toDoModel)
        }
        
    }
}
