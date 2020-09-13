//
//  InputView.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/11/14.
//  Copyright © 2018 m.dobashi. All rights reserved.
//

import UIKit


protocol TodoRegisterDelegate: AnyObject {
    func textChenge()
}



final class TodoRegisterTableView: UITableView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate {
    
    private var toDoModel: ToDoModel?
    
    private let leading:CGFloat = 15
    
    weak var toDoregisterDelegate: TodoRegisterDelegate?
    
    /// ToDoのタイトル入力テキストフィールド
    let titletextField:UITextField = {
        let textField: UITextField = UITextField()
        textField.placeholder = "タイトルを入力してください"
        textField.accessibilityLabel = "titleTextField"
        
        return textField
    }()
    
    /// ToDoの期限入力テキストフィールド
    let dateTextField:UITextField = {
        let textField: UITextField = UITextField()
        textField.placeholder = "期限を入力してください"
        textField.accessibilityLabel = "dateTextField"
        
        return textField
    }()
    
    /// ToDoの詳細入力テキストフィールド
    let detailTextViwe:UITextView = {
        let textView: UITextView = UITextView()
        textView.accessibilityLabel = "detailTextViwe"
        
        return textView
    }()
    
    /// ToDoの日付選択デートピッカー
    let datePicker:UIDatePicker = {
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.accessibilityLabel = "detailPicker"
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(onDidChangeDate(sender:)), for: .valueChanged)
        
        return datePicker
    }()
    
    
    
    /// 編集するToDoのID
    private var todoId: String?
    
    
    // MARK: Init
    
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        delegate = self
        dataSource = self
        separatorInset = .zero
        separatorStyle = .singleLine
        estimatedSectionHeaderHeight = 0
        estimatedSectionFooterHeight = 0
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:
            #selector(tapView(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    
    convenience init(frame: CGRect, style: UITableView.Style = .grouped, toDoModel:ToDoModel?) {
        self.init(frame: frame, style: style)
        
        if let _toDoModel = toDoModel {
            self.todoId = _toDoModel.id
            self.toDoModel = _toDoModel
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UITableViewDataSource, UITableViewDelegate
    
    
    /// セクションの数を設定
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    /// セクションの行数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    /// セル内の設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "inputCell")
        cell.accessoryType = .none
        cell.selectionStyle = .none
        cell.backgroundColor = cellColor
        // ToDoの編集時はTextFieldに表示
        if todoId != nil {
            titletextField.text = toDoModel?.toDoName
            dateTextField.text = toDoModel?.todoDate
            detailTextViwe.text = toDoModel?.toDo
        }
        
        
        switch indexPath.section {
        case 0: /* Todoのタイトル */
            textFieldConstraint(cell, textField: titletextField)
            titletextField.delegate = self
            titletextField.backgroundColor = cellColor
        case 1: /* Todoの期限 */
            dateTextField.inputView = datePicker
            dateTextField.delegate = self
            dateTextField.backgroundColor = cellColor
            cell.addSubview(dateTextField)
            
            textFieldConstraint(cell, textField: dateTextField)
        case 2: /* Todoの詳細 */
            detailTextViwe.backgroundColor = cellColor
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
    
    
    /// セルの選択はさせない
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    /// セルの高さを設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section != 2 {
            return 50
        }
        return 100
    }
    
    /// ヘッダー内のビューを設定
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return todoHeadrView(viewForHeaderInSection: section, isEditMode: true)
    }
    
    
    /// ヘッダーの高さを設定
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    /// フッターの高さを設定
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    
    // MARK: UIDatePicker func
    
    @objc private func onDidChangeDate(sender:UIDatePicker){
        datePicker.minimumDate = Date()
        dateTextField.text = Format().stringFromDate(date: sender.date)
    }

    
    //MARK: TapGesture func
    
    /// Viweをタップした時に
    @objc private func tapView(_:UITapGestureRecognizer){
        titletextField.resignFirstResponder()
        dateTextField.resignFirstResponder()
        detailTextViwe.resignFirstResponder()
    }
    
    
    
    /// セルにテキストフィールドの制約を付ける
    /// - Parameter cell: セル
    /// - Parameter textField: 制約を付けるテキストフィールド
    private func textFieldConstraint(_ cell: UITableViewCell, textField: UITextField) {
        cell.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: leading).isActive = true
        textField.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
    }
    
    
    // MARK: TextField Delegate
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        toDoregisterDelegate?.textChenge()
    }
    
    
    
    
    // MARK: TextView Delegate
    
    func textViewDidChange(_ textView: UITextView) {
        toDoregisterDelegate?.textChenge()
    }
    
}
