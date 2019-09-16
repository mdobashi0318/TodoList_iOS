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
    
    var tableValues:[TableValue] = [TableValue]()
    weak var toDoListViewDelegate: ToDoListViewDelegate?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.separatorStyle = .none
        self.dataSource = self
        self.delegate = self
        self.separatorInset = .zero
        self.register(TodoListCell.self, forCellReuseIdentifier: "listCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableValues.count > 0 ? tableValues.count : 1
    }

    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableValues.count == 0 {
            let cell:UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.selectionStyle = .none
            cell.textLabel?.text = "Todoがまだ登録されていません"
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! TodoListCell
        cell.setText(title: tableValues[indexPath.row].title,
                     date: tableValues[indexPath.row].date,
                     detail: tableValues[indexPath.row].detail
        )
        
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
        return 80
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
    
}








fileprivate final class TodoListCell:UITableViewCell {
    let titleLabel: UILabel = UILabel()
    let detailLabel: UILabel = UILabel()
    let dateLabel: UILabel = UILabel()
    
    let layerView:UIView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.accessoryType = .disclosureIndicator
        
        layerView.layer.borderColor = UIColor.orange.cgColor
        layerView.layer.borderWidth = 1
        layerView.layer.cornerRadius = 50 / 5
        layerView.layer.shadowColor = UIColor.orange.cgColor
        layerView.layer.shadowOffset = CGSize(width: 0.1, height: 0.2)
        layerView.backgroundColor = GENET
        
        
        
        detailLabel.numberOfLines = 0
        detailLabel.sizeToFit()
        
        let stakc:UIStackView = UIStackView()
        stakc.axis = .vertical
        stakc.alignment = .leading
        stakc.spacing = 5
        stakc.distribution = .fillEqually
        
        stakc.addSubview(layerView)
        stakc.addArrangedSubview(titleLabel)
        stakc.addArrangedSubview(detailLabel)
        stakc.addArrangedSubview(dateLabel)
        
        self.addSubview(stakc)
        
        
        
        stakc.translatesAutoresizingMaskIntoConstraints = false
        stakc.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        stakc.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        stakc.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        stakc.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
        
        
        layerView.translatesAutoresizingMaskIntoConstraints = false
        layerView.topAnchor.constraint(equalTo: stakc.topAnchor, constant: -7).isActive = true
        layerView.leadingAnchor.constraint(equalTo: stakc.leadingAnchor, constant: -5).isActive = true
        layerView.trailingAnchor.constraint(equalTo: stakc.trailingAnchor, constant: 5).isActive = true
        layerView.bottomAnchor.constraint(equalTo: stakc.bottomAnchor, constant: 7).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(title:String, date:String, detail:String){
        titleLabel.text = title
        detailLabel.text = detail
        dateLabel.text = date
        
        
        changeCellBackGroundCollor(date: dateLabel.text!)
    }
    
    
    private func changeCellBackGroundCollor(date: String){
        let format = DateFormatter()
        format.dateFormat = "yyyy/MM/dd hh:mm"
        let now = Date()
        
        layerView.backgroundColor = format.string(from: now) < date ? GENET : .lightGray
    }
}
