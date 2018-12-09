//
//  InputViewController.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/09/13.
//  Copyright © 2018年 m.dobashi. All rights reserved.
//

import UIKit


class InputViewController: UIViewController {
    var todoInputView:TodoInputView?
    var toDoModel:ToDoModel = ToDoModel()
    var todoId:Int?
    
    
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    /// 編集時のinit
    ///
    /// - Parameter todoId: 編集するTodoのid
    convenience init(todoId:Int) {
        self.init(nibName: nil, bundle: nil)
        self.todoId = todoId
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(leftButton))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(rightButton))
        
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        let flame:CGRect = CGRect(x: 0, y: statusBarHeight + navBarHeight! , width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        todoInputView = TodoInputView(frame: flame, toDoModel: toDoModel, todoId: todoId)
        self.view.addSubview(todoInputView!)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /// Todoの新規作成時はモーダルを閉じる,編集時はも一つ前の画面に戻る
    @objc func leftButton(){
        if todoId == nil {
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    /// Todoの保存、更新
    @objc func rightButton(){
        let alert = AlertManager()
        if todoInputView?.textField.text?.count == 0 {
            alert.alertAction(viewController: self,
                              title: "",
                              message: "ToDoのタイトルが入力されていません",
                              handler: { _ in return })
        }
        
        if todoInputView?.dateTextField.text?.count == 0 {
            alert.alertAction(viewController: self,
                              title: "",
                              message: "ToDoの期限が入力されていません",
                              handler: { _ in return })
        }
        
        if todoInputView?.textViwe.text?.count == 0 {
            alert.alertAction(viewController: self,
                              title: "",
                              message: "ToDoの詳細が入力されていません",
                              handler: { _ in return })
        }
        
        
        if todoId != nil {
            alert.alertAction(viewController: self,
                              title: "",
                              message: "ToDoを更新しました",
                              handler: {(action) -> Void in
                                self.todoInputView!.updateRealm()
                                self.navigationController?.popViewController(animated: true)
                                return
            })
        }
        
        
        alert.alertAction(viewController: self,
                          title: "",
                          message: "ToDoを登録しました",
                          handler: {(action) -> Void in
                            self.todoInputView!.addRealm()
                            self.dismiss(animated: true, completion: nil)
        })
    }

}








