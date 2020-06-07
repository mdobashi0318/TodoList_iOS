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
    
    
    /// 期限が切れているか、切れていないかでbackgroundColorを変える
    private func changeCellBackGroundCollor(date: String){
        layerView.backgroundColor = Format().stringFromDate(date: Date()) < date ? Rose : .lightGray
    }
    
}
