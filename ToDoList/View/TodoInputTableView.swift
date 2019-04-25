//
//  InputView.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/11/14.
//  Copyright © 2018 m.dobashi. All rights reserved.
//

import UIKit

class TodoInputTableView: UITableView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate {
    
    private var tableValue:TableValue?
    
    let titletextField:UITextField = UITextField()
    let dateTextField:UITextField = UITextField()
    let detailTextViwe:UITextView = UITextView()
    let datePicker:UIDatePicker = UIDatePicker()
    var tmpDate:Date?
    
    private var todoId:Int?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.delegate = self
        self.dataSource = self
        self.separatorInset = .zero
        self.estimatedSectionHeaderHeight = 0
        self.estimatedSectionFooterHeight = 0
        self.backgroundColor = UIColor.rgba(red: 230, green: 230, blue: 230, alpha: 1)
        
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:
            #selector(tapView(_:)))
        self.addGestureRecognizer(tapGesture)
        
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
        let cell:UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "inputCell")
        cell.accessoryType = .none
        cell.selectionStyle = .none
        
        // ToDoの編集時はTextFieldに表示
        if todoId != nil {
            titletextField.text = tableValue?.title
            dateTextField.text = tableValue?.date
            detailTextViwe.text = tableValue?.detail
        }
        
        let leading:CGFloat = 15
        switch indexPath.section {
        case 0: /* Todoのタイトル */
            cell.addSubview(titletextField)
            titletextField.translatesAutoresizingMaskIntoConstraints = false
            titletextField.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            titletextField.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: leading).isActive = true
            titletextField.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
            titletextField.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        case 1: /* Todoの期限 */
            dateTextField.inputView = datePicker
            dateTextField.delegate = self
            datePicker.datePickerMode = .dateAndTime
            datePicker.addTarget(self, action: #selector(onDidChangeDate(sender:)), for: .valueChanged)
            cell.addSubview(dateTextField)
            
            dateTextField.translatesAutoresizingMaskIntoConstraints = false
            dateTextField.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            dateTextField.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: leading).isActive = true
            dateTextField.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
            dateTextField.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        case 2: /* Todoの詳細 */
            cell.addSubview(detailTextViwe)
            detailTextViwe.translatesAutoresizingMaskIntoConstraints = false
            detailTextViwe.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            detailTextViwe.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: leading).isActive = true
            detailTextViwe.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
            detailTextViwe.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section != 2 {
            return 50
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.todoHeadrView(viewForHeaderInSection: section)
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    
    // MARK: - UIDatePicker func
    @objc private func onDidChangeDate(sender:UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd hh:mm"
        formatter.locale = Locale(identifier: "ja_JP")
        
        tmpDate = sender.date
        let s_Date:String = formatter.string(from: sender.date)
        datePicker.minimumDate = Date()
        dateTextField.text = s_Date
        
    }

    //MARK: - TapGesture func
    @objc private func tapView(_:UITapGestureRecognizer){
        titletextField.resignFirstResponder()
        dateTextField.resignFirstResponder()
        detailTextViwe.resignFirstResponder()
    }
}
