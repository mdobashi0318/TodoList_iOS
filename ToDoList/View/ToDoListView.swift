//
//  ToDoListView.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/11/14.
//  Copyright © 2018 m.dobashi. All rights reserved.
//

import UIKit
import RealmSwift

protocol ToDoListViewDelegate {
    func cellTapAction(indexPath:String)
}


class ToDoListView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var toDoModel:ToDoModel = ToDoModel()
    var todoCount: Int?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, toDoModel:ToDoModel) {
        self.init(frame: frame)
        self.toDoModel = toDoModel
        
        viewLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

    func viewLoad(){
        var tableView:UITableView?
        tableView = UITableView(frame: .zero, style: .plain)
        tableView?.separatorInset = .zero
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.addSubview(tableView!)
        
        
        tableView!.backgroundColor = UIColor.white
        tableView!.translatesAutoresizingMaskIntoConstraints = false
        tableView!.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView!.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        tableView!.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tableView!.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        find()
        if todoCount == 0 || todoCount == nil {
            return 1
        }
        return todoCount!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        let realm:Realm = try! Realm()
        
        
        if todoCount == 0 || todoCount == nil {
            cell.textLabel?.text = "何もない"
            return cell
        }
        
        
        let toDoNameLabel: UILabel = UILabel()
        toDoNameLabel.text = realm.objects(ToDoModel.self)[indexPath.section].toDoName
        
        let toDoLabel: UILabel = UILabel()
        toDoLabel.text = realm.objects(ToDoModel.self)[indexPath.section].toDo
        toDoLabel.numberOfLines = 0
        toDoLabel.sizeToFit()
        
        let toDoDateLabel: UILabel = UILabel()
        toDoDateLabel.text = realm.objects(ToDoModel.self)[indexPath.section].todoDate
        
        
        
        let stakc:UIStackView = UIStackView()
        stakc.axis = .vertical
        stakc.alignment = .leading
        stakc.spacing = 5
        stakc.distribution = .fillEqually
        
        stakc.addArrangedSubview(toDoNameLabel)
        stakc.addArrangedSubview(toDoLabel)
        stakc.addArrangedSubview(toDoDateLabel)
        cell.addSubview(stakc)
        
        stakc.translatesAutoresizingMaskIntoConstraints = false
        stakc.topAnchor.constraint(equalTo: cell.topAnchor, constant: 10).isActive = true
        stakc.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 10).isActive = true
        stakc.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -10).isActive = true
        stakc.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -10).isActive = true
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        self.navigationController?.pushViewController(ToDoDetailViewController(), animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    var viewTodo: Any?
   
    
    
    
    func find() {
        let realm:Realm = try! Realm()
        todoCount = realm.objects(ToDoModel.self).count
        print(realm.objects(ToDoModel.self))
    }
    
}
