//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/09/13.
//  Copyright © 2018年 m.dobashi. All rights reserved.
//

import UIKit


class ToDoListViewController: UIViewController, ToDoListViewDelegate {
    private var todoListView:ToDoListView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "ToDoリスト"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.leftBarAction))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        todoListView = ToDoListView(frame: frame_Size(viewController: self))
        todoListView?.toDoListViewDelegate = self
        self.view.addSubview(todoListView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    func cellTapAction(indexPath: Int) {
        let toDoDetailViewController:ToDoDetailViewController = ToDoDetailViewController(todoId: indexPath)
        self.navigationController?.pushViewController(toDoDetailViewController, animated: true)
    }
    
    func editAction(indexPath: IndexPath) {
        let inputViewController:InputViewController = InputViewController(todoId: indexPath.section)
        self.navigationController?.pushViewController(inputViewController, animated: true)
    }
    
    
    func deleteAction(indexPath: IndexPath) {
        AlertManager().alertAction(viewController: self, title: nil, message: "削除しますか?", handler1: {[weak self] action in
            self?.todoListView?.deleteRealm(indexPath: indexPath)
            
            self?.viewWillAppear(true)
            }, handler2: {_ -> Void in})
        
    }

}
