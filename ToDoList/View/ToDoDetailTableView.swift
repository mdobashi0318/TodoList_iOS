//
//  ToDoDetailView.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/11/14.
//  Copyright © 2018 m.dobashi. All rights reserved.
//

import UIKit

class ToDoDetailTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    private var todoId:Int?
    private var tableValue:TableValue!
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.delegate = self
        self.dataSource = self
        self.separatorInset = .zero
        self.estimatedSectionHeaderHeight = 0
        self.estimatedSectionFooterHeight = 0
        self.backgroundColor = UIColor.rgba(red: 230, green: 230, blue: 230, alpha: 1)
        
    }
    
    convenience init(frame: CGRect, style: UITableView.Style, todoId:Int?, tableValue:TableValue) {
        self.init(frame: frame, style: style)
        self.todoId = todoId
        self.tableValue = TableValue(id: tableValue.id,
                                     title: tableValue.title,
                                     todoDate: tableValue.date,
                                     detail: tableValue.detail
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        let cell:UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "detailCell")
        cell.accessoryType = .none
        cell.selectionStyle = .none
        
        
        switch indexPath.section {
        case 0:
            cell.textLabel!.text = tableValue.title
        case 1:
            cell.textLabel!.text = tableValue.date
        default:
            cell.textLabel!.text = tableValue.detail
            cell.textLabel?.numberOfLines = 0
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.todoHeadrView(viewForHeaderInSection: section)
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
}
