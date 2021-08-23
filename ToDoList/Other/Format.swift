//
//  Format.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2020/06/03.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation

/// Dateにフォーマットを設定する
struct Format {

    /// フォーマットを返す
    /// - Parameter addSec: ミリ秒もフォーマットに設定するかの判定
    private func _dateFormatter(addms: Bool) -> DateFormatter {
        let formatter = DateFormatter()
        if addms {
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss.SSS"
        } else {
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
        }

        formatter.locale = Locale(identifier: "ja_JP")

        return formatter
    }

    /// Stringのフォーマットを設定Dateを返す
    func dateFromString(string: String, addSec: Bool = false) -> Date? {
        let formatter: DateFormatter = _dateFormatter(addms: addSec)
        return formatter.date(from: string)
    }

    /// Dateのフォーマットを設定しStringを返す
    func stringFromDate(date: Date, addSec: Bool = false) -> String {
        let formatter = _dateFormatter(addms: addSec)
        let s_Date: String = formatter.string(from: date)

        return s_Date
    }

    /// Dateのフォーマットを設定して返す
    func dateFormat(addSec: Bool = false) -> Date {
        let formatter = _dateFormatter(addms: addSec)
        let s_Date: String = formatter.string(from: Date())

        return formatter.date(from: s_Date) ?? Date()
    }

}
