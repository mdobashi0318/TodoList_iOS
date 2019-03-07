//
//  ToDoListView.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/11/14.
//  Copyright © 2018 m.dobashi. All rights reserved.
//

import UIKit

protocol ToDoListViewDelegate: class {
    func cellTapAction(indexPath:IndexPath)
    func deleteAction(indexPath:IndexPath)
    func editAction(indexPath:IndexPath)
}

class TodoListTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    private var tableValues:[TableValue] = [TableValue]()
    weak var toDoListViewDelegate: ToDoListViewDelegate?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
    
    convenience init(frame: CGRect, style: UITableView.Style, tableValue:[TableValue]) {
        self.init(frame: frame, style: style)
        self.tableValues = tableValue
        
        self.dataSource = self
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableValues.count
    }

    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "todoListCell")
        
        
        if tableValues.count == 0 {
            cell.selectionStyle = .none
            cell.textLabel?.text = "Todoがまだ登録されていません"
            return cell
        }
        
        let titleLabel: UILabel = UILabel()
        titleLabel.text = tableValues[indexPath.row].title
        
        let detailLabel: UILabel = UILabel()
        detailLabel.text = tableValues[indexPath.row].detail
        detailLabel.numberOfLines = 0
        detailLabel.sizeToFit()
        
        let dateLabel: UILabel = UILabel()
        dateLabel.text = tableValues[indexPath.row].date
        changeCellBackGroundCollor(cell: cell, indexPath: indexPath)
        
        
        let stakc:UIStackView = UIStackView()
        stakc.axis = .vertical
        stakc.alignment = .leading
        stakc.spacing = 5
        stakc.distribution = .fillEqually
        
        stakc.addArrangedSubview(titleLabel)
        stakc.addArrangedSubview(detailLabel)
        stakc.addArrangedSubview(dateLabel)
        cell.addSubview(stakc)
        
        stakc.translatesAutoresizingMaskIntoConstraints = false
        stakc.topAnchor.constraint(equalTo: cell.topAnchor, constant: 10).isActive = true
        stakc.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 10).isActive = true
        stakc.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -10).isActive = true
        stakc.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -10).isActive = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableValues.count == 0 {
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        toDoListViewDelegate?.cellTapAction(indexPath: indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let edit = UITableViewRowAction(style: .default, title: "編集") {
            (action, indexPath) in
            
            self.toDoListViewDelegate?.editAction(indexPath: indexPath)
        }
        edit.backgroundColor = .orange
        
        let del = UITableViewRowAction(style: .destructive, title: "削除") {
            (action, indexPath) in
            
            self.toDoListViewDelegate?.deleteAction(indexPath: indexPath)
        }
        
        return [del, edit]
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableValues.count == 0 {
            return false
        }
        return true
    }
    
    
    private func changeCellBackGroundCollor(cell:UITableViewCell, indexPath:IndexPath){
        let format = DateFormatter()
        format.dateFormat = "yyyy/MM/dd hh:mm"
        let now = Date()
        
        cell.backgroundColor = format.string(from: now) < tableValues[indexPath.row].date ? .white : .lightGray
    }
}
