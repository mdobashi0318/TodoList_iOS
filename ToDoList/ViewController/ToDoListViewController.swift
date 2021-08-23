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
    func todoAllDelete()
    func deleteTodo(row: Int)
}

enum SegmentIndex: Int, CaseIterable {
    case all = 0
    case active = 1
    case expired = 2
}

final class ToDoListViewController: UITableViewController {

    // MARK: Properties

    private var naviController: UINavigationController!

    private var presenter: ToDoListPresenter?

    private var segmentedControl: UISegmentedControl!

    private var segmenteIndex: SegmentIndex!

    private let refreshCtr = UIRefreshControl()

    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = ToDoListPresenter()

        setNavigationItem()
        setupTableView()
        setupSegmentedControl()
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

    private func setupSegmentedControl() {
        segmenteIndex = .all
        segmentedControl = UISegmentedControl(items: ["全て", "アクティブ", "期限切れ"])
        segmentedControl.selectedSegmentIndex = segmenteIndex.rawValue
        segmentedControl.addTarget(self, action: #selector(segmentedSelect), for: .valueChanged)
    }

    @objc private func segmentedSelect(_ segment: UISegmentedControl) {
        segmenteIndex = SegmentIndex(rawValue: segment.selectedSegmentIndex)

        reloadTableView()
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

// MARK: - NavigationItem

extension ToDoListViewController {

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
    @objc func rightButtonAction() {
        let inputViewController = TodoRegisterViewController()
        naviController = UINavigationController(rootViewController: inputViewController)
        naviController.presentationController?.delegate = self
        present(naviController, animated: true, completion: nil)
    }

    /// データベース内の全件削除(Debug)
    @objc override func leftButtonAction() {
        AlertManager().showAlert(self, type: .delete, message: "ToDoを全件削除しますか?", didTapPositiveButton: { _ in
            self.todoAllDelete()
        })
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

    // MARK: Swipe cell

    /// 編集と削除のスワイプをセット
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let edit = UITableViewRowAction(style: .default, title: R.string.message.edit()) {
            _, indexPath in

            self.editAction(indexPath: indexPath)
        }
        edit.backgroundColor = .orange

        let del = UITableViewRowAction(style: .destructive, title: R.string.message.delete()) {
            _, indexPath in

            self.deleteAction(indexPath: indexPath)
        }

        return [del, edit]
    }

    /// 選択したToDoの編集画面を開く
    ///
    /// - Parameter indexPath: 選択したcellの行
    private func editAction(indexPath: IndexPath) {
        let inputViewController = TodoRegisterViewController(todoId: (presenter?.model?[indexPath.row].id)!, createTime: presenter?.model?[indexPath.row].createTime)
        self.navigationController?.pushViewController(inputViewController, animated: true)
    }

    /// 選択したToDoの削除
    ///
    /// - Parameter indexPath: 選択したcellの行
    private func deleteAction(indexPath: IndexPath) {
        AlertManager().showAlert(self, type: .delete, message: "削除しますか?", didTapPositiveButton: {[weak self] _ in
            self?.deleteTodo(row: indexPath.row)
        })
    }

    /// ToDoの個数が0の時はスワイプさせない
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if presenter?.model?.count == 0 {
            return false
        }
        return true
    }

    // MARK: Header

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .headerColor
        headerView.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        segmentedControl.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true

        return headerView
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }

}

// MARK: - UIAdaptivePresentationControllerDelegate

extension ToDoListViewController: UIAdaptivePresentationControllerDelegate {

    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        AlertManager().showAlert(presentationController.presentedViewController, type: .delete, message: "編集途中の内容がありますが削除しますか?", didTapPositiveButton: { [weak self] _ in
            self?.naviController.dismiss(animated: true) {
                NotificationCenter.default.post(name: Notification.Name(R.string.notification.tableReload()), object: nil)
            }
        })
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
        presenter?.fetchToDoList(segmentIndex: segmenteIndex, success: {
            self.tableView.reloadData()
        }, failure: { error in
            AlertManager().showAlert(self, type: .close, message: error)
        })
    }

    func deleteTodo(row: Int) {
        presenter?.deleteTodo(presenter?.model?[row], success: {
            NotificationCenter.default.post(name: Notification.Name(R.string.notification.tableReload()), object: nil)
        }, failure: { error in
            AlertManager().showAlert(self, type: .close, message: error)
        })
    }

    func todoAllDelete() {
        presenter?.allDelete(success: {
            NotificationCenter.default.post(name: Notification.Name(R.string.notification.tableReload()), object: nil)
        }, failure: { error in
            AlertManager().showAlert(self, type: .close, message: error)
        })
    }

}
