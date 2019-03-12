//
//  TodoListCell.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2019/03/12.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit



class TodoListCell:UITableViewCell {
    let titleLabel: UILabel = UILabel()
    let detailLabel: UILabel = UILabel()
    let dateLabel: UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        detailLabel.numberOfLines = 0
        detailLabel.sizeToFit()
        
        let stakc:UIStackView = UIStackView()
        stakc.axis = .vertical
        stakc.alignment = .leading
        stakc.spacing = 5
        stakc.distribution = .fillEqually
        
        stakc.addArrangedSubview(titleLabel)
        stakc.addArrangedSubview(detailLabel)
        stakc.addArrangedSubview(dateLabel)
        self.addSubview(stakc)
        
        stakc.translatesAutoresizingMaskIntoConstraints = false
        stakc.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        stakc.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        stakc.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        stakc.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(title:String, date:String, detail:String){
        titleLabel.text = title
        detailLabel.text = detail
        dateLabel.text = date
    }
}

