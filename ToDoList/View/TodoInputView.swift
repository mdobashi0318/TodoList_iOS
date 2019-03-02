//
//  InputView.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/11/14.
//  Copyright © 2018 m.dobashi. All rights reserved.
//

import UIKit
import RealmSwift


class TodoInputView: UIView, UITextFieldDelegate, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let titletextField:UITextField = UITextField()
    let dateTextField:UITextField = UITextField()
    let detailTextViwe:UITextView = UITextView()
    let datePicker:UIDatePicker = UIDatePicker()
    var tmpDate:Date?
    
    private var toDoModel:ToDoModel = ToDoModel()
    private var todoId:Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, todoId:Int?) {
        self.init(frame: frame)
        self.todoId = todoId
        
        viewLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func viewLoad(){
        let tableView:UITableView = UITableView(frame: .zero, style: .grouped)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.addSubview(tableView)
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:
            #selector(tapView(_:)))
        tableView.addGestureRecognizer(tapGesture)
        
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
        
        // ToDoの編集時はTextFieldに表示
        if todoId != nil {
            titletextField.text = realm.objects(ToDoModel.self)[todoId!].toDoName
            dateTextField.text = realm.objects(ToDoModel.self)[todoId!].todoDate
            detailTextViwe.text = realm.objects(ToDoModel.self)[todoId!].toDo
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
    
    // MARK: - Realm func
    
    func addRealm(){
        let realm:Realm = try! Realm()
        
        toDoModel.id = String(realm.objects(ToDoModel.self).count + 1)
        toDoModel.toDoName = titletextField.text!
        toDoModel.todoDate = dateTextField.text
        toDoModel.toDo = detailTextViwe.text
        
        try! realm.write() {
            realm.add(toDoModel)
        }
    }
    
    func updateRealm(){
        let realm:Realm = try! Realm()
 
        try! realm.write() {
            realm.objects(ToDoModel.self)[todoId!].toDoName = titletextField.text!
            realm.objects(ToDoModel.self)[todoId!].todoDate = dateTextField.text
            realm.objects(ToDoModel.self)[todoId!].toDo = detailTextViwe.text
        }
    }
    
    //MARK: - TapGesture func
    @objc private func tapView(_:UITapGestureRecognizer){
        titletextField.resignFirstResponder()
        dateTextField.resignFirstResponder()
        detailTextViwe.resignFirstResponder()
    }
    
}
