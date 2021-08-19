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
}


class ToDoDetailTableViewController: UITableViewController {
    
    // MARK: Properties
    
    private var todoId:String?
    
    private var createTime:String?
    
    private var presenter: ToDoDetailTableViewControllerPresenter!
    
    
    // MARK: Init
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        
        presenter = ToDoDetailTableViewControllerPresenter()
    }
    
    convenience init(todoId:String, createTime: String?) {
        self.init(style: .grouped)
        self.todoId = todoId
        self.createTime = createTime
        
        findTodo()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.didTapRightButton))
        setupTableView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // テーブルビューの更新
        tableView.reloadData()
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
                                        didTapEditButton: { [weak self] action in
                                            let inputViewController:TodoRegisterViewController = TodoRegisterViewController(todoId: (self?.todoId!)!, createTime: self?.createTime)
                                            self?.navigationController?.pushViewController(inputViewController, animated: true)
            },
                                        didTapDeleteButton: { [weak self] action in
                                            self?.deleteTodo()
        })
    }
    
}





// MARK: - UITableViewDelegate, UITableViewDataSource


extension ToDoDetailTableViewController {
    
    /// セクションの数を設定
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    /// セクションの行数を設定
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    // MARK: UITableViewDelegate
    
    /// セル内の設定
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "detailCell")
        cell.accessoryType = .none
        cell.selectionStyle = .none
        cell.backgroundColor = .cellColor
        
        switch indexPath.section {
        case 0:
            cell.textLabel!.text = presenter.model?.toDoName
        case 1:
            cell.textLabel!.text = presenter.model?.todoDate
        default:
            cell.textLabel!.text = presenter.model?.toDo
            cell.textLabel?.numberOfLines = 0
        }
        
        return cell
    }
    
    /// セルの選択はさせない
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    /// ヘッダー内のビューを設定
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return todoHeadrView(viewForHeaderInSection: section, isEditMode: false, isExpired: presenter.isExpired)
    }
    
    /// ヘッダーの高さを設定
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    /// セルの高さを設定
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    /// フッターの高さを設定
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
}




extension ToDoDetailTableViewController: ToDoDetailTableViewControllerProtocol {
    func findTodo() {
        presenter.findTodo(todoId: todoId, createTime: createTime, success: {
            
        }) { error in
            AlertManager().alertAction(self, message: error!)
            
        }
    }
    
    func deleteTodo() {
        presenter.deleteTodo(success: {
            self.navigationController?.popViewController(animated: true)
        }, failure: { error in
            AlertManager().alertAction(self, message: error)
        })
    }
    
    
    
    
}

