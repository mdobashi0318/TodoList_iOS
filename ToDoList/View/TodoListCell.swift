//
//  ToDoListView.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/11/14.
//  Copyright © 2018 m.dobashi. All rights reserved.
//

import UIKit

/// Todoを表示するセル
final class TodoListCell: UITableViewCell {
    
    // MARK: Properties
    
    let expiredLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "期限切れ"
        label.textColor = .red
        return label
    }()
    
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
    
    let vStack: UIStackView = UIStackView()
    
    let hStack: UIStackView = UIStackView()
    
    // MARK: Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        
        vStack.layer.shadowOpacity = 0.5
        vStack.layer.shadowOffset = CGSize(width: 2, height: 2)
        vStack.backgroundColor = .todoListCell
        
        
        hStack.axis = .horizontal
        hStack.alignment = .leading
        hStack.spacing = 5
        hStack.distribution = .equalSpacing
        hStack.addArrangedSubview(dateLabel)
        hStack.addArrangedSubview(expiredLabel)
        
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.spacing = 1
        vStack.distribution = .fill
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(detailLabel)
        vStack.addArrangedSubview(hStack)
        addSubview(vStack)
        
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        vStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        vStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
   
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
        expiredLabel.isHidden = Format().stringFromDate(date: Date()) < date
    }
    
}
