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

    /// ベースビュー
    private let baseView = UIView()

    private let expiredLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.message.expiredText()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    /// タイトルを表示するラベル
    private let titleLabel = UILabel()

    /// ToDoの詳細を表示するラベル
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2

        return label
    }()

    /// 日付を表示するラベル
    private let dateLabel = UILabel()

    private let vStack = UIStackView()

    private let hStack = UIStackView()

    private let expiredView = UIView()

    // MARK: Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        accessoryType = .disclosureIndicator

        baseView.layer.cornerRadius = 8
        addSubview(baseView)

        baseView.layer.shadowOpacity = 0.5
        baseView.layer.shadowOffset = CGSize(width: 2, height: 2)
        baseView.backgroundColor = .todoListCell

        initHStack()
        initVStack()
        initConstraint()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// セルにテキストを設定する
    /// - Parameter title: Todoのタイトル
    /// - Parameter date: ToDoの日付
    /// - Parameter detail: ToDoの詳細
    /// - Parameter isExpired: 期限切れラベルの表示フラグ
    func setText(title: String, date: String, detail: String, isExpired: Bool) {
        titleLabel.text = title
        detailLabel.text = detail.replacingOccurrences(of: "\n", with: "")
        dateLabel.text = date
        expiredLabel.isHidden = !isExpired
    }

    private func initHStack() {
        hStack.axis = .horizontal
        hStack.alignment = .bottom
        hStack.spacing = 5
        hStack.distribution = .equalSpacing
        hStack.addArrangedSubview(dateLabel)
        hStack.addArrangedSubview(expiredLabel)
        expiredView.addSubview(hStack)
    }

    private func initVStack() {
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.spacing = 1
        vStack.distribution = .fill
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(detailLabel)
        vStack.addArrangedSubview(        expiredView)
        baseView.addSubview(vStack)
    }

    private func initConstraint() {
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.topAnchor.constraint(equalTo: expiredView.topAnchor).isActive = true
        hStack.leadingAnchor.constraint(equalTo: expiredView.leadingAnchor).isActive = true
        hStack.trailingAnchor.constraint(equalTo: expiredView.trailingAnchor).isActive = true
        hStack.bottomAnchor.constraint(equalTo: expiredView.bottomAnchor).isActive = true

        baseView.translatesAutoresizingMaskIntoConstraints = false
        baseView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        baseView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        baseView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        baseView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true

        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 5).isActive = true
        vStack.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 10).isActive = true
        vStack.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -20).isActive = true
        vStack.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -5).isActive = true
    }

}
