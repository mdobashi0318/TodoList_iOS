//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/09/13.
//  Copyright © 2018年 m.dobashi. All rights reserved.
//

import UIKit

protocol ToDoListViewControllerProtocol {
    func fetchTodoModel()
}

final class ToDoListViewController: UITableViewController {

    // MARK: Properties

    private var presenter: ToDoListPresenter?

    private let refreshCtr = UIRefreshControl()

    private(set) var completionFlag: CompletionFlag!

    convenience init(page: CompletionFlag) {
        self.init(style: .plain)
        self.completionFlag = page
        fetchTodoModel()
    }

    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = ToDoListPresenter()
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
        tableView.separatorStyle = presenter?.model?.count != 0 ? .none : .singleLine
        tableView.register(TodoListCell.self, forCellReuseIdentifier: "listCell")
        tableView.refreshControl = refreshCtr
        refreshCtr.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
    }

    /// テーブルとセパレート線を更新する
    func reloadTableView() {
        fetchTodoModel()
        tableView.separatorStyle = presenter?.model?.count != 0 ? .none : .singleLine
        tableView.reloadData()
    }

    @objc func refresh(sender: UIRefreshControl) {
        reloadTableView()
        sender.endRefreshing()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ToDoListViewController {

    /// セクションの数を設定
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    /// セクションの行数を設定
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if presenter?.model?.count == 0 || presenter?.model == nil {
            return 1
        }

        return (presenter?.model!.count)!
    }

    // MARK: Cell

    /// セル内の設定
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if presenter?.model?.count == 0 || presenter?.model == nil {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.backgroundColor = .cellColor
            cell.selectionStyle = .none
            cell.textLabel?.text = R.string.message.noToDo()
            return cell
        }

        /// ToDoを表示するセル
        let listCell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! TodoListCell
        listCell.setText(title: (presenter?.model?[indexPath.row].toDoName)!,
                         date: (presenter?.model?[indexPath.row].todoDate!)!,
                         detail: (presenter?.model?[indexPath.row].toDo)!,
                         isExpired: (presenter?.isExpired(row: indexPath.row))!
        )

        return listCell
    }

    /// セルの高さ
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    // MARK: Select cell

    /// ToDoの個数が0個の時に選択させない
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if presenter?.model?.count == 0 {
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        cellTapAction(indexPath: indexPath)
    }

    /// Todoの詳細を開く
    ///
    /// - Parameter indexPath: 選択したcellの行
    private func cellTapAction(indexPath: IndexPath) {
        let toDoDetailViewController = ToDoDetailTableViewController(todoId: (presenter?.model?[indexPath.row].id)!, createTime: presenter?.model?[indexPath.row].createTime)
        self.navigationController?.pushViewController(toDoDetailViewController, animated: true)
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if presenter?.model?.count == 0 {
            return nil
        }

        return indexPath
    }

}

// MARK: - Notification

extension ToDoListViewController {

    /// NotificationCenterを追加する
    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable(notification:)), name: NSNotification.Name(rawValue: R.string.notification.tableReload()), object: nil)
    }

    /// テーブルの更新とセパレート線の設定
    @objc func reloadTable(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.reloadTableView()
        }
    }

}

// MARK: - ToDoListViewControllerProtocol

extension ToDoListViewController: ToDoListViewControllerProtocol {

    func fetchTodoModel() {
        presenter?.fetchToDoList(segmentIndex: completionFlag, success: {
            self.tableView.reloadData()
        }, failure: { error in
            AlertManager().showAlert(self, type: .close, message: error)
        })
    }

}
