//
//  NotificationManager.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2020/06/12.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation
import UserNotifications

struct NotificationManager {

    /// 通知を全件削除する
    let allRemoveNotification = {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        Log.devprint("ToDoの通知を全件削除しました")
    }

    /// 指定した通知を削除する
    let removeNotification = { (identifiers: [String]) -> Void in
        UNUserNotificationCenter
            .current()
            .removePendingNotificationRequests(withIdentifiers: identifiers)
        Log.devprint("ToDoの通知を\(identifiers.count)件削除しました")
    }

    /// 通知を設定する
    /// - Parameters:
    ///   - toDoModel: ToDoModels
    ///   - isRequestResponse: 通知の登録に成功したかを返す
    func addNotification(toDoModel: ToDoModel, isRequestResponse: @escaping(Bool) -> Void) {

        let content = UNMutableNotificationContent()
        content.title = toDoModel.toDoName
        content.body = toDoModel.toDo
        content.sound = UNNotificationSound.default

        // 通知する日付を設定
        guard let date: Date = Format().dateFromString(string: toDoModel.todoDate!) else {
            Log.devprint("期限の登録に失敗しました")
            isRequestResponse(false)
            return
        }

        let calendar = Calendar.current
        let dateComponent = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        let request = UNNotificationRequest(identifier: toDoModel.createTime!, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()

        center.add(request) { error in
            Log.devprint("request: \(request)")
            guard let _error = error else {
                Log.devprint("通知の登録をしました")
                isRequestResponse(true)
                return
            }
            Log.devprint("通知の登録に失敗しました: \(_error)")
            isRequestResponse(false)
        }
    }

}
