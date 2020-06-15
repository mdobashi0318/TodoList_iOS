//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/09/13.
//  Copyright © 2018年 m.dobashi. All rights reserved.
//

import UIKit
import RealmSwift


final class ToDoListViewController: UITableViewController {
    
    // MARK: Properties
        
    private var naviController: UINavigationController!
    
    /// ToDoを格納する配列
    private var toDoModel: Results<ToDoModel>? {
        didSet {
            tableView.reloadData()
        }
    }

    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toDoModel = ToDoModel.allFindRealm(self)
        setNavigationItem()
        setupTableView()
        setNotificationCenter()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadTableView()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: TableView
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = .zero
        tableView.separatorStyle = toDoModel?.count != 0 ? .none : .singleLine
        tableView.register(TodoListCell.self, forCellReuseIdentifier: "listCell")
    }
    
    
    /// テーブルとセパレート線を更新する
    func reloadTableView() {
        guard let _toDoModel = toDoModel else {
            ToDoModel.devprint("toDoModelがnilのためテーブルの更新失敗")
            return
        }
        
        ToDoModel.devprint("ToDoModel: \(_toDoModel)")
        tableView.separatorStyle = _toDoModel.count != 0 ? .none : .singleLine
        tableView.reloadData()
    }
    
    
    // MARK: NavigationItem
    
    /// setNavigationItemをセットする
    private func setNavigationItem() {
        self.title = "ToDoリスト"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.rightButtonAction))
        
        #if DEBUG
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(leftButtonAction))
        navigationItem.leftBarButtonItem?.accessibilityIdentifier = "allDelete"
        #endif
    }
    
    
    /// Todoの入力画面を開く
    @objc func rightButtonAction(){
        let inputViewController:TodoRegisterViewController = TodoRegisterViewController()
        naviController = UINavigationController(rootViewController: inputViewController)
        naviController.presentationController?.delegate = self
        present(naviController,animated: true, completion: nil)
    }
    
    
    
    /// データベース内の全件削除(Debug)
    @objc override func leftButtonAction() {
        ToDoModel.allDeleteRealm(self) {
            NotificationCenter.default.post(name: Notification.Name(TableReload), object: nil)
        }
    }
    

    
    // MARK: Todo Func
    
    /// Todoの詳細を開く
    ///
    /// - Parameter indexPath: 選択したcellの行
    private func cellTapAction(indexPath: IndexPath) {
        let toDoDetailViewController:ToDoDetailTableViewController = ToDoDetailTableViewController(todoId: (toDoModel?[indexPath.row].id)!, createTime: toDoModel?[indexPath.row].createTime)
        self.navigationController?.pushViewController(toDoDetailViewController, animated: true)
    }
    
    
    /// 選択したToDoの編集画面を開く
    ///
    /// - Parameter indexPath: 選択したcellの行
    private func editAction(indexPath: IndexPath) {
        let inputViewController:TodoRegisterViewController = TodoRegisterViewController(todoId: (toDoModel?[indexPath.row].id)!, createTime: toDoModel?[indexPath.row].createTime)
        self.navigationController?.pushViewController(inputViewController, animated: true)
    }
    
    
    
    /// 選択したToDoの削除
    ///
    /// - Parameter indexPath: 選択したcellの行
    private func deleteAction(indexPath: IndexPath) {
        AlertManager().alertAction(self, message: "削除しますか?", didTapDeleteButton: {[weak self] action in
            
            let todoid = self?.toDoModel![indexPath.row].id
            let createTime = self?.toDoModel?[indexPath.row].createTime
            
            ToDoModel.deleteRealm(self!, todoId: todoid!, createTime: createTime) {
                NotificationCenter.default.post(name: Notification.Name(TableReload), object: nil)
            }
            
            })
    }
    
    
    
    // MARK: Notification
    
    /// NotificationCenterを追加する
    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable(notification:)), name: NSNotification.Name(rawValue: TableReload), object: nil)
    }
    
    /// テーブルの更新とセパレート線の設定
    @objc func reloadTable(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.reloadTableView()
        }
    }
    
    
}







// MARK: - UITableViewDataSource, UITableViewDelegate

extension ToDoListViewController {
         
    /// セクションの数を設定
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    /// セクションの行数を設定
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if toDoModel?.count == 0 {
            return 1
        }
        
        return toDoModel!.count
    }

    
    // MARK: Cell
    
    /// セル内の設定
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if toDoModel?.count == 0 {
            let cell:UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.backgroundColor = cellWhite
            cell.selectionStyle = .none
            cell.textLabel?.text = "Todoがまだ登録されていません"
            return cell
        }
        
        /// ToDoを表示するセル
        let listCell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! TodoListCell
        listCell.setText(title: (toDoModel?[indexPath.row].toDoName)!,
                         date: (toDoModel?[indexPath.row].todoDate!)!,
                         detail: (toDoModel?[indexPath.row].toDo)!
        )
        
        return listCell
    }
    

    /// セルの高さ
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    // MARK: Select cell
    
    /// ToDoの個数が0個の時に選択させない
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if toDoModel?.count == 0 {
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        cellTapAction(indexPath: indexPath)
    }
    
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if toDoModel?.count == 0 {
            return nil
        }
        
        return indexPath
    }
    
    
    /// 編集と削除のスワイプをセット
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let edit = UITableViewRowAction(style: .default, title: "編集") {
            (action, indexPath) in
            
            self.editAction(indexPath: indexPath)
        }
        edit.backgroundColor = .orange
        
        let del = UITableViewRowAction(style: .destructive, title: "削除") {
            (action, indexPath) in
            
            self.deleteAction(indexPath: indexPath)
        }
        
        return [del, edit]
    }
    
    
    /// ToDoの個数が0の時はスワイプさせない
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if toDoModel?.count == 0 {
            return false
        }
        return true
    }
  
}




// MARK: - UIAdaptivePresentationControllerDelegate

extension ToDoListViewController: UIAdaptivePresentationControllerDelegate {

    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        AlertManager().alertAction(naviController, message: "編集途中の内容がありますが削除しますか?", didTapDeleteButton: { [weak self] action in
            self?.naviController.dismiss(animated: true) {
                NotificationCenter.default.post(name: Notification.Name(TableReload), object: nil)
            }
        })
        
    }
    
}


