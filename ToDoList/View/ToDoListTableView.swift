//
//  ToDoListView.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/11/14.
//  Copyright © 2018 m.dobashi. All rights reserved.
//

import UIKit

// MARK: - ToDoListViewDelegate

protocol ToDoListViewDelegate: class {
    
    /// ToDoセルの選択時
    func cellTapAction(indexPath:IndexPath)
    
    /// セルのスワイプの削除ボタンタップ
    func deleteAction(indexPath:IndexPath)
    
    /// セルのスワイプの編集ボタンタップ
    func editAction(indexPath:IndexPath)
}








// MARK: - TodoListTableView

final class TodoListTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    
    /// ToDoを格納する配列
    var tableValues:[TableValue]! {
        didSet {
            reloadData()
        }
    }
    
    /// TodoListのデリゲート
    weak var toDoListDelegate: ToDoListViewDelegate?
    
    
    // MARK: Init
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        separatorStyle = .none
        dataSource = self
        delegate = self
        separatorInset = .zero
        register(TodoListCell.self, forCellReuseIdentifier: "listCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    // MARK: UITableViewDataSource, UITableViewDelegate
     
    /// セクションの数を設定
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    /// セクションの行数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableValues.count > 0 ? tableValues.count : 1
    }

    
    // MARK: Cell
    
    /// セル内の設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableValues.count == 0 {
            let cell:UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.backgroundColor = cellWhite
            cell.selectionStyle = .none
            cell.textLabel?.text = "Todoがまだ登録されていません"
            return cell
        }
        
        /// ToDoを表示するセル
        let listCell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! TodoListCell
        listCell.setText(title: tableValues[indexPath.row].title,
                     date: tableValues[indexPath.row].date,
                     detail: tableValues[indexPath.row].detail
        )
        
        return listCell
    }
    
    

    /// セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    // MARK: Select cell
    
    /// ToDoの個数が0個の時に選択させない
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableValues.count == 0 {
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        toDoListDelegate?.cellTapAction(indexPath: indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if tableValues.count == 0 {
            return nil
        }
        
        return indexPath
    }
    
    
    /// 編集と削除のスワイプをセット
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let edit = UITableViewRowAction(style: .default, title: "編集") {
            (action, indexPath) in
            
            self.toDoListDelegate?.editAction(indexPath: indexPath)
        }
        edit.backgroundColor = .orange
        
        let del = UITableViewRowAction(style: .destructive, title: "削除") {
            (action, indexPath) in
            
            self.toDoListDelegate?.deleteAction(indexPath: indexPath)
        }
        
        return [del, edit]
    }
    
    
    /// ToDoの個数が0の時はスワイプさせない
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableValues.count == 0 {
            return false
        }
        return true
    }
    
}











// MARK: - TodoListCell

/// Todoを表示するセル
fileprivate final class TodoListCell:UITableViewCell {
    
    // MARK: Properties
    
    /// タイトルを表示するラベル
    let titleLabel: UILabel = UILabel()
    
    /// ToDoの詳細を表示するラベル
    let detailLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 0
        
        return label
    }()
    
    /// 日付を表示するラベル
    let dateLabel: UILabel = UILabel()
    
    /// セルの背景のバックグラウンド
    let layerView:UIView = UIView()
    
    // MARK: Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        
        layerView.layer.cornerRadius = 50 / 5
        
        let stakc:UIStackView = UIStackView()
        stakc.axis = .vertical
        stakc.alignment = .leading
        stakc.spacing = 5
        stakc.distribution = .fillEqually
        
        stakc.addSubview(layerView)
        stakc.addArrangedSubview(titleLabel)
        stakc.addArrangedSubview(detailLabel)
        stakc.addArrangedSubview(dateLabel)
        
        addSubview(stakc)
        
        
        
        stakc.translatesAutoresizingMaskIntoConstraints = false
        stakc.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        stakc.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        stakc.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        stakc.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        
        
        
        layerView.translatesAutoresizingMaskIntoConstraints = false
        layerView.topAnchor.constraint(equalTo: stakc.topAnchor, constant: -7).isActive = true
        layerView.leadingAnchor.constraint(equalTo: stakc.leadingAnchor, constant: -5).isActive = true
        layerView.trailingAnchor.constraint(equalTo: stakc.trailingAnchor, constant: 5).isActive = true
        layerView.bottomAnchor.constraint(equalTo: stakc.bottomAnchor, constant: 7).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    /// セルにテキストを設定する
    /// - Parameter title: Todoのタイトル
    /// - Parameter date: ToDoの日付
    /// - Parameter detail: ToDoの詳細
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
        
        layerView.backgroundColor = format.string(from: now) < date ? Rose : .lightGray
    }
}
