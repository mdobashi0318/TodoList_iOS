//
//  InputViewController.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/09/13.
//  Copyright © 2018年 m.dobashi. All rights reserved.
//

import UIKit

protocol TodoRegisterViewControllerProtocol {
    func findTodo()
    func addTodo()
    func updateTodo()
}

final class TodoRegisterViewController: UIViewController {

    // MARK: Properties

    /// ToDoを入力するためのView
    private lazy var todoRegisterTableView: TodoRegisterTableView = {
        if todoId == nil {
            let view = TodoRegisterTableView(frame: UIScreen.main.bounds, toDoModel: nil)

            return view

        } else {
            let view = TodoRegisterTableView(frame: UIScreen.main.bounds, toDoModel: self.presenter?.model)

            return view
        }
    }()

    /// ToDoのIDを格納
    private var todoId: String?

    private var create_time: String?

    private var presenter: TodoRegisterPresenter?

    // MARK: Init

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        presenter = TodoRegisterPresenter()
    }

    /// 編集時のinit
    ///
    /// - Parameter todoId: 編集するTodoのid
    convenience init(todoId: String, createTime: String?) {
        self.init(nibName: nil, bundle: nil)
        self.todoId = todoId
        self.create_time = createTime

        findTodo()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        setNavigationItem()

        todoRegisterTableView.toDoregisterDelegate = self
        view.addSubview(todoRegisterTableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: NavigationButton Action

    /// ナビゲーションボタンをセットする
    private func setNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(didTapLeftButton)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(didTapRightButton)
        )
    }

    /// ナビゲーションボタンの左のボタンタップ時
    /// Todoの新規作成時はモーダルを閉じる
    ///
    /// 編集時は一つ前の画面に戻る
    @objc func didTapLeftButton() {
        if todoId == nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    /// ナビゲーションボタンの右のボタンタップ時
    ///
    /// バリデーションチェックを通った場合は、Todoの保存または更新をする
    @objc func didTapRightButton() {
        validateCheck { [weak self] result in
            if result == true {
                self?.realmAction()
            }
        }
    }

    // MARK: Realm func

    /// Todoの追加または更新をする
    private func realmAction() {
        if todoId != nil {
            updateTodo()
        } else {
            addTodo()
        }
    }

    /// バリデーションチェックをする
    /// - Parameter result: テキストが入力されているか判定結果
    /// - Returns: 入力項目が全て入力されていればtrue、一つでも入力されていなければfalse
    private func validateCheck(result: (Bool) -> Void) {

        if todoRegisterTableView.titletextField.text!.isEmpty {
            AlertManager().showAlert(self, type: .close,
                                     message: R.string.message.titleAlert())

            result(false)
        } else if todoRegisterTableView.todoDate.isEmpty {
            AlertManager().showAlert(self, type: .close,
                                     message: R.string.message.dateAlert())

            result(false)
        } else if todoRegisterTableView.detailTextViwe.text.isEmpty {
            AlertManager().showAlert(self, type: .close,
                                     message: R.string.message.detailAlert())

            result(false)
        } else {
            result(true)
        }

    }

}

// MARK: - TodoRegisterDelegate

extension TodoRegisterViewController: TodoRegisterDelegate {

    /// Todoの追加時にテキスト入力中だったらモーダルを本当に閉じるかの確認フラグをtrueにする
    func textChenge() {
        if #available(iOS 13.0, *) {
            if todoRegisterTableView.titletextField.text!.isEmpty &&
                todoRegisterTableView.todoDate.isEmpty &&
                todoRegisterTableView.detailTextViwe.text.isEmpty {
                isModalInPresentation = false
            } else {
                isModalInPresentation = true
            }
        }
    }

}

// MARK: - TodoRegisterViewControllerProtocol

extension TodoRegisterViewController: TodoRegisterViewControllerProtocol {

    func findTodo() {
        presenter?.findTodo(todoId: todoId, createTime: create_time, success: {
            Log.devprint("Todoを検索: \(String(describing: self.presenter?.model))")
        }) { error in
            AlertManager().showAlert(self, type: .close, message: error)
        }
    }

    func addTodo() {
        presenter?.addTodo(addValue: ToDoModel(toDoName: todoRegisterTableView.titletextField.text!,
                                               todoDate: todoRegisterTableView.todoDate,
                                               toDo: todoRegisterTableView.detailTextViwe.text!,
                                               createTime: nil),
                           success: {
                            AlertManager().showAlert(self, type: .close, message: R.string.message.addMessage(), didTapPositiveButton: { _ in
                                self.dismiss(animated: true)
                            })
                           }) { error in
            AlertManager().showAlert(self, type: .close, message: error)
        }
    }

    func updateTodo() {
        presenter?.updateTodo(updateTodo: ToDoModel(toDoName: todoRegisterTableView.titletextField.text!,
                                                    todoDate: todoRegisterTableView.todoDate,
                                                    toDo: todoRegisterTableView.detailTextViwe.text!,
                                                    createTime: create_time),
                              success: {
                                AlertManager().showAlert(self, type: .close, message: R.string.message.updateMessage(), didTapPositiveButton: { _ in
                                    self.navigationController?.popViewController(animated: true)
                                })
                              }) { error in
            AlertManager().showAlert(self, type: .close, message: error)
        }
    }

}

/// Private関数のテスト
protocol TodoRegisterVCTestProtocol {
    /// テキストをセットする
    func addText(toDoName: String?, todoDate: String?, toDo: String?)
    /// TodoIdを取得する
    func gettodoId() -> String?
    /// ToDoModelを取得する
    func getToDoModel() -> ToDoModel!
    /// バリデーションチェックの結果を取得
    func getValidateCheck() -> Bool
}

extension TodoRegisterViewController: TodoRegisterVCTestProtocol {
    func addText(toDoName: String?, todoDate: String?, toDo: String?) {
        todoRegisterTableView.titletextField.text = toDoName
        todoRegisterTableView.dateTextField.text = todoDate
        todoRegisterTableView.detailTextViwe.text = toDo
    }

    func gettodoId() -> String? {
        todoId
    }

    func getToDoModel() -> ToDoModel! {
        presenter?.model
    }

    func getValidateCheck() -> Bool {
        var isValidate: Bool!
        validateCheck { result in
            isValidate = result
        }
        return isValidate
    }

}
