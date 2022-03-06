//
//  ToDoDetailViewController.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/11/12.
//  Copyright © 2018 m.dobashi. All rights reserved.
//

import UIKit

protocol ToDoDetailTableViewControllerProtocol {
    func findTodo()
    func deleteTodo()
    func updateFlag(_ flag: Bool)
}

class ToDoDetailTableViewController: UITableViewController {

    // MARK: Properties

    private var todoId: String?

    private var createTime: String?

    private var presenter: ToDoDetailTableViewControllerPresenter!

    private var completSwitch: UISwitch?

    // MARK: Init

    override init(style: UITableView.Style) {
        super.init(style: style)

        presenter = ToDoDetailTableViewControllerPresenter()
        completSwitch = UISwitch()
    }

    convenience init(todoId: String, createTime: String?) {
        self.init(style: .grouped)
        self.todoId = todoId
        self.createTime = createTime
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(self.didTapLeftButton))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.didTapRightButton))
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        findTodo()
    }

    // MARK: Private Func

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
    }

    /// アクションシートを開く
    @objc private func didTapRightButton() {
        AlertManager().alertSheetAction(self, message: "Todoをどうしますか?",
                                        didTapEditButton: { [weak self] _ in
                                            let inputViewController = TodoRegisterViewController(todoId: self?.todoId ?? "", createTime: self?.createTime)
                                            self?.navigationController?.pushViewController(inputViewController, animated: true)
                                        },
                                        didTapDeleteButton: { [weak self] _ in
                                            self?.deleteTodo()
                                        })
    }

    @objc private func didTapLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ToDoDetailTableViewController {

    /// セクションの数を設定
    override func numberOfSections(in tableView: UITableView) -> Int {
        3
    }

    /// セクションの行数を設定
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    // MARK: UITableViewDelegate

    /// セル内の設定
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "detailCell")
        cell.accessoryType = .none
        cell.selectionStyle = .none
        cell.backgroundColor = .cellColor

        switch indexPath.section {
        case 0:
            cell.textLabel?.text = presenter.model?.todoDate
        case 1:
            cell.textLabel?.text = presenter.model?.toDo
            cell.textLabel?.numberOfLines = 0
        default:
            cell.textLabel?.text = "完了"
            guard let completSwitch = completSwitch else {
                break
            }
            completSwitch.addTarget(self, action: #selector(changeCompleteValue), for: .touchUpInside)
            cell.contentView.addSubview(completSwitch)
            completSwitch.translatesAutoresizingMaskIntoConstraints = false
            completSwitch.topAnchor.constraint(equalTo: cell.topAnchor, constant: 10).isActive = true
            completSwitch.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -20).isActive = true
            completSwitch.widthAnchor.constraint(equalToConstant: 50).isActive = true
        //            completSwitch.heightAnchor.constraint(equalToConstant: 30).isActive = true

        }

        return cell
    }

    @objc func changeCompleteValue(_ sender: UISwitch) {
        updateFlag(sender.isOn)
    }
    /// セルの選択はさせない
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        nil
    }

    /// ヘッダー内のビューを設定
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerLabel = UILabel()

        switch section {
        case 0:
            if presenter.isExpired {
                headerLabel.text = "期限 \(R.string.message.expiredText())"
                headerLabel.setExpiredAttributes()
            } else {
                headerLabel.text = "期限"
                headerLabel.accessibilityLabel = "dateLabel"
            }
        case 1:
            headerLabel.text = "詳細"
            headerLabel.accessibilityLabel = "detailLabel"
        default:
            break
        }

        headerView.addSubview(headerLabel)

        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15).isActive = true
        headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true

        return headerView
    }

    /// ヘッダーの高さを設定
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }

    /// セルの高さを設定
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    /// フッターの高さを設定
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        CGFloat.leastNormalMagnitude
    }

}

extension ToDoDetailTableViewController: ToDoDetailTableViewControllerProtocol {
    func findTodo() {
        presenter.findTodo(todoId: todoId, createTime: createTime, success: {
            if let completSwitch = completSwitch {
                completSwitch.isOn = presenter.model?.completionFlag == CompletionFlag.completion.rawValue ? true : false
            }
            /// テーブルビューの更新
            self.tableView.reloadData()

            // タイトルをセット
            self.navigationItem.title = presenter.model?.toDoName
        }, failure: { error in
            AlertManager().showAlert(self, type: .close, message: error)
        })
    }

    func deleteTodo() {
        presenter.deleteTodo(success: {
            self.navigationController?.popViewController(animated: true)
        }, failure: { error in
            AlertManager().showAlert(self, type: .close, message: error)
        })
    }

    func updateFlag(_ flag: Bool) {
        presenter.changeCompleteFlag(flag: flag, success: {
            /// 何もしない
        }, failure: { error in
            AlertManager().showAlert(self, type: .close, message: error)
        })
    }

}
