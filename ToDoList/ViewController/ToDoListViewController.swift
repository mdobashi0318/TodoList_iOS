//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/09/13.
//  Copyright © 2018年 m.dobashi. All rights reserved.
//

import UIKit


class ToDoListViewController: UIViewController {

    var todoListView:ToDoListView?
    var toDoModel:ToDoModel = ToDoModel()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "ToDoリスト"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.leftBarAction))
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let flame:CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        todoListView = ToDoListView(frame: flame, toDoModel: toDoModel)
        self.view.addSubview(todoListView!)
        
        todoListView?.translatesAutoresizingMaskIntoConstraints = false
        todoListView?.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        todoListView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        todoListView?.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func leftBarAction(){
        let controller:InputViewController = InputViewController()
        let navi:UINavigationController = UINavigationController(rootViewController: controller)
        self.present(navi,animated: true, completion: nil)
    }
    
    

}
