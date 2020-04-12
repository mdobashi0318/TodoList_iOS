//
//  ToDoDetailView.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/11/14.
//  Copyright © 2018 m.dobashi. All rights reserved.
//

import UIKit

class ToDoDetailTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var tableValue:TableValue!
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        delegate = self
        dataSource = self
        separatorInset = .zero
        estimatedSectionHeaderHeight = 0
        estimatedSectionFooterHeight = 0
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UITableViewDataSource
    
    /// セクションの数を設定
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    /// セクションの行数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // MARK: UITableViewDelegate
    
    /// セル内の設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "detailCell")
        cell.accessoryType = .none
        cell.selectionStyle = .none
        cell.backgroundColor = cellWhite
        
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
    
    /// セルの選択はさせない
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    /// ヘッダー内のビューを設定
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return todoHeadrView(viewForHeaderInSection: section)
    }
    
    /// ヘッダーの高さを設定
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    /// セルの高さを設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    /// フッターの高さを設定
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}
