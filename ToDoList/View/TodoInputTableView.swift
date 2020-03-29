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
    private let leading:CGFloat = 15
    
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
    
    /// 日付の一時保存
    private(set) var tmpDate:Date?
    
    /// 編集するToDoのID
    private var todoId:Int?
    
    
    // MARK: Init
    
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
    
    
    convenience init(frame: CGRect, style: UITableView.Style = .grouped, todoId:Int?, tableValue:TableValue?) {
        self.init(frame: frame, style: style)
        
        
        if let _todoId = todoId {
            self.todoId = _todoId
        }
        
        if let _tableValue = tableValue {
            self.tableValue = TableValue(id: _tableValue.id,
                                         title: _tableValue.title,
                                         todoDate: _tableValue.date,
                                         detail: _tableValue.detail,
                                         createTime: _tableValue.createTime
            )
        }
        
        self.delegate = self
        self.dataSource = self
        self.separatorInset = .zero
        self.separatorStyle = .singleLine
        
        self.estimatedSectionHeaderHeight = 0
        self.estimatedSectionFooterHeight = 0
        
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:
            #selector(tapView(_:)))
        self.addGestureRecognizer(tapGesture)
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
        cell.backgroundColor = cellWhite
        // ToDoの編集時はTextFieldに表示
        if todoId != nil {
            titletextField.text = tableValue?.title
            dateTextField.text = tableValue?.date
            detailTextViwe.text = tableValue?.detail
        }
        
        
        switch indexPath.section {
        case 0: /* Todoのタイトル */
            textFieldConstraint(cell, textField: titletextField)
        case 1: /* Todoの期限 */
            dateTextField.inputView = datePicker
            dateTextField.delegate = self
            
            cell.addSubview(dateTextField)
            
            textFieldConstraint(cell, textField: dateTextField)
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
        return todoHeadrView(viewForHeaderInSection: section)
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
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd hh:mm"
        formatter.locale = Locale(identifier: "ja_JP")
        
        tmpDate = sender.date
        let s_Date:String = formatter.string(from: sender.date)
        datePicker.minimumDate = Date()
        dateTextField.text = s_Date
        
    }

    //MARK: TapGesture func
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
}
