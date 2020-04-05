//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/09/13.
//  Copyright © 2018年 m.dobashi. All rights reserved.
//

import UIKit
import UserNotifications
import RealmSwift
import NotificationBannerSwift

final class ToDoListViewController: UIViewController, ToDoListViewDelegate, UNUserNotificationCenterDelegate, UIAdaptivePresentationControllerDelegate {
    
    // MARK: Properties
    
    private let realm:Realm = try! Realm(configuration: Realm.Configuration(schemaVersion: realmConfig))
    
    
    var naviController:UINavigationController!
    
    let center = UNUserNotificationCenter.current()
    
    /// ToDoListを表示するテーブルビュー
    private lazy var todoListTableView:TodoListTableView = {
        let tableView: TodoListTableView = TodoListTableView(frame: frame_Size(self), style: .plain)
        tableView.toDoListDelegate = self
        
        return tableView
    }()
    
    /// ToDoを格納する配列
    private var tableValues:[TableValue]?

    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setNavigationItem()
        
        tableValues = [TableValue]()
        view.addSubview(todoListTableView)
        
  
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(callViewWillAppear(notification:)), name: NSNotification.Name(rawValue: ViewUpdate), object: nil)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        center.delegate = self
        tableValuesAppend()
        
        #if DEBUG
        print("Model\(String(describing: tableValues!))")
        #endif
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: NavigationItemAction
    
    /// Todoの入力画面を開く
    @objc func rightBarAction(){
        let inputViewController:InputViewController = InputViewController()
        naviController = UINavigationController(rootViewController: inputViewController)
        naviController.presentationController?.delegate = self
        present(naviController,animated: true, completion: nil)
    }
    
    
    
    /// データベース内の全件削除(Debug)
    @objc override func leftButtonAction() {
        ToDoModel.allDeleteRealm(self) { [weak self] in
            self?.tableValues?.removeAll()
            self?.viewWillAppear(true)
        }
        
    }

    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        AlertManager().alertAction(naviController, message: "編集途中の内容がありますが削除しますか?", handler1: { [weak self] action in
            self?.naviController.dismiss(animated: true) {
                self?.tableValuesAppend()
            }
        }) { _ in return }

    }
    
    
    
    /// Todoの詳細を開く
    ///
    /// - Parameter indexPath: 選択したcellの行
    func cellTapAction(indexPath: IndexPath) {
        let toDoDetailViewController:ToDoDetailViewController = ToDoDetailViewController(todoId: Int((tableValues?[indexPath.row].id)!)!, createTime: tableValues?[indexPath.row].createTime)
        self.navigationController?.pushViewController(toDoDetailViewController, animated: true)
    }
    
    
    /// 選択したToDoの編集画面を開く
    ///
    /// - Parameter indexPath: 選択したcellの行
    func editAction(indexPath: IndexPath) {
        let inputViewController:InputViewController = InputViewController(todoId: Int((tableValues?[indexPath.row].id)!)!, createTime: tableValues?[indexPath.row].createTime)
        self.navigationController?.pushViewController(inputViewController, animated: true)
    }
    
    
    // MARK: Realm Func
    
    /// 選択したToDoの削除
    ///
    /// - Parameter indexPath: 選択したcellの行
    func deleteAction(indexPath: IndexPath) {
        AlertManager().alertAction(self, message: "削除しますか?", handler1: {[weak self] action in
            
            let todoid = Int((self?.realm.objects(ToDoModel.self)[indexPath.row].id)!)
            let createTime = self?.realm.objects(ToDoModel.self)[indexPath.row].createTime
            
            ToDoModel.deleteRealm(self!, todoId: todoid!, createTime: createTime) {
                self?.tableValues?.removeAll()
            }
            self?.viewWillAppear(true)
            }){ _ in }
    }
    
    
    
    
    // MARK: Other Func
    
    /// setNavigationItemをセットする
    func setNavigationItem() {
        self.title = "ToDoリスト"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.rightBarAction))
        
        #if DEBUG
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(leftButtonAction))
        navigationItem.leftBarButtonItem?.accessibilityIdentifier = "allDelete"
        #endif
    }
    
    
    /// 配列に追加とViewのTableに反映
    func tableValuesAppend() {
        tableValues?.removeAll()
        
        guard let todoModel = ToDoModel.allFindRealm(self) else { return }
        
        for i in 0..<todoModel.count{
            
            tableValues?.append(TableValue(id: todoModel[i].id,
                                           title: todoModel[i].toDoName,
                                           todoDate: todoModel[i].todoDate!,
                                           detail: todoModel[i].toDo,
                                           createTime: todoModel[i].createTime)
            )
            
            tableValues?.sort{ $0.date < $1.date }
        }
        
        
        todoListTableView.tableValues = tableValues!
        todoListTableView.separatorStyle = todoListTableView.tableValues.count != 0 ? .none : .singleLine
        todoListTableView.reloadData()
    }
    
    
    
    /// viewWillAppearを呼ぶ
    @objc @available(iOS 13.0, *)
    func callViewWillAppear(notification: Notification) {
        self.viewWillAppear(true)
    }
    
    
    /// フォアグラウンドの時の通知
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.sound])
        let banner = FloatingNotificationBanner(title: notification.request.identifier,
                                                subtitle: notification.request.content.body,
                                                style: .success
        )
        banner.autoDismiss = false
        banner.onSwipeUp = {
            banner.dismiss()
            self.viewWillAppear(false)
        }
        
        banner.show(queuePosition: .front,
                    bannerPosition: .top,
                    cornerRadius: 10)
    }
    
}


struct TableValue {
    let id: String
    let title:String
    let date:String
    let detail:String
    let createTime:String?
    
    init(id:String, title:String, todoDate:String, detail: String, createTime: String? = nil) {
        self.id = id
        self.title = title
        self.date = todoDate
        self.detail = detail
        self.createTime = createTime
    }
}

