//
//  ToDoDetailView.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/11/14.
//  Copyright © 2018 m.dobashi. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoDetailView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var toDoModel:ToDoModel = ToDoModel()
    var todoId:Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, toDoModel:ToDoModel, todoId:Int) {
        self.init(frame: frame)
        self.toDoModel = toDoModel
        self.todoId = todoId
        
        viewLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func viewLoad(){
        let tableView:UITableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.addSubview(tableView)
        
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        cell.accessoryType = .none
        cell.selectionStyle = .none
        
        let realm:Realm = try! Realm()
        
        switch indexPath.section {
        case 0:
            cell.textLabel!.text = realm.objects(ToDoModel.self)[todoId!].toDoName
        case 1:
            cell.textLabel!.text = realm.objects(ToDoModel.self)[todoId!].todoDate
        default:
            cell.textLabel!.text = realm.objects(ToDoModel.self)[todoId!].toDo
            cell.textLabel?.numberOfLines = 0
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView:UIView = UIView()
        let headerLabel:UILabel = UILabel()
        
        switch section {
        case 0:
            headerLabel.text = "タイトル"
        case 1:
            headerLabel.text = "期限"
        case 2:
            headerLabel.text = "詳細"
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
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    // MARK: - Realm func
    
    func deleteRealm(){
        let realm = try! Realm()
        let toDoModel = realm.objects(ToDoModel.self)[todoId!]
        
        try! realm.write() {
            realm.delete(toDoModel)
        }
        
    }
}
