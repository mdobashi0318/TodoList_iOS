//
//  ToDoListView.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/11/14.
//  Copyright © 2018 m.dobashi. All rights reserved.
//

import UIKit
import RealmSwift

protocol ToDoListViewDelegate: class {
    func cellTapAction(indexPath:Int)
}


class ToDoListView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    private let realm:Realm = try! Realm()
    private var todoCount: Int = 0
    weak var toDoListViewDelegate: ToDoListViewDelegate?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        todoCount = realm.objects(ToDoModel.self).count
        viewLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

    private func viewLoad(){
        let tableView:UITableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorInset = .zero
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.addSubview(tableView)
        
        tableView.backgroundColor = UIColor.white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if todoCount == 0 {
            return 1
        }
        return todoCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        
        
        
        if todoCount == 0 {
            cell.selectionStyle = .none
            cell.textLabel?.text = "Todoがまだ登録されていません"
            return cell
        }
        
        
        let format = DateFormatter()
        format.dateFormat = "yyyy/MM/dd hh:mm"
        let now = Date()
        
        cell.backgroundColor = format.string(from: now) < realm.objects(ToDoModel.self)[indexPath.section].todoDate! ? .white : .lightGray
        
        cell.accessoryType = .disclosureIndicator
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
        stakc.addArrangedSubview(toDoDateLabel)
        stakc.addArrangedSubview(toDoLabel)
        cell.addSubview(stakc)
        
        stakc.translatesAutoresizingMaskIntoConstraints = false
        stakc.topAnchor.constraint(equalTo: cell.topAnchor, constant: 10).isActive = true
        stakc.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 10).isActive = true
        stakc.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -10).isActive = true
        stakc.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -10).isActive = true
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if todoCount == 0 {
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        toDoListViewDelegate?.cellTapAction(indexPath: indexPath.section)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
