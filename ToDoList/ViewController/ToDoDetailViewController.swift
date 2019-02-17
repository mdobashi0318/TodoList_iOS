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
    private var toDoDetailView:ToDoDetailView?
    private var toDoModel:ToDoModel = ToDoModel()
    private var todoId:Int?
    
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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.rightBarAction))
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
         toDoDetailView = ToDoDetailView(frame: frame_Size(viewController: self), toDoModel: toDoModel, todoId:todoId!)
        self.view.addSubview(toDoDetailView!)
    }
    
    
    /// アクションシートを開く
    @objc private func rightBarAction(){
        let alertSheet:UIAlertController = UIAlertController(title: nil, message: "Todoをどうしますか?", preferredStyle: .actionSheet)
        alertSheet.addAction(UIAlertAction(title: "編集", style: .default, handler: {(action) -> Void in
            let inputViewController:InputViewController = InputViewController(todoId: self.todoId!)
            self.navigationController?.pushViewController(inputViewController, animated: true)
        })
        )
        alertSheet.addAction(UIAlertAction(title: "削除", style: .destructive, handler: {(action) -> Void in
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [self.realm.objects(ToDoModel.self)[self.todoId!].toDoName])
            self.toDoDetailView?.deleteRealm()
            self.navigationController?.popViewController(animated: true)
        })
        )
        alertSheet.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        
        self.present(alertSheet,animated: true, completion: nil)
    }
    

}
