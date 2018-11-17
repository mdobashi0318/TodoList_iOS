//
//  InputViewController.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/09/13.
//  Copyright © 2018年 m.dobashi. All rights reserved.
//

import UIKit
import RealmSwift

class InputViewController: UIViewController {
    var inputV:InputView?
    var toDoModel:ToDoModel = ToDoModel()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(leftButton))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(rightButton))
        
        
        let flame:CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        inputV = InputView(frame: flame, toDoModel: toDoModel)
        
        
        self.view.addSubview(inputV!)
        
        inputV?.translatesAutoresizingMaskIntoConstraints = false
        inputV?.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        inputV?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        inputV?.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func leftButton(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func rightButton(){
        let controller:UIAlertController = UIAlertController(title: "", message: "ToDoを登録しました", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
            self.inputV!.addRealm()
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(controller,animated: true,completion: nil)
        
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}








