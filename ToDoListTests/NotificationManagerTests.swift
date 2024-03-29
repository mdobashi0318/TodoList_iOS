//
//  NotificationManagerTests.swift
//  ToDoListTests
//
//  Created by 土橋正晴 on 2020/06/12.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import XCTest
@testable import ToDoList

class NotificationManagerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        NotificationManager().allRemoveNotification()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_addNotification() {

        let createTime1 = Format().stringFromDate(date: Date(), addSec: true)
        NotificationManager().addNotification(toDoModel: ToDoModel(id: "0", toDoName: "TEST", todoDate: Format().stringFromDate(date: Date(timeIntervalSinceNow: 60 * 60 * 48)), toDo: "TESTTodo",  completionFlag: CompletionFlag.unfinished.rawValue, createTime: createTime1)) { result in
            XCTAssertTrue(result, "Todoの登録に失敗している")
        }

        NotificationManager().addNotification(toDoModel: ToDoModel(id: "0", toDoName: "TEST", todoDate: "TESTDate", toDo: "TESTTodo",  completionFlag: CompletionFlag.unfinished.rawValue, createTime: Format().stringFromDate(date: Date(), addSec: true))) { result in
            XCTAssertFalse(result, "Todoの登録に成功している")
        }

        sleep(1)
        UNUserNotificationCenter.current().getPendingNotificationRequests { notification in
            XCTAssertTrue(notification.count == 1, "Todoが作成した以上に登録されている")
            XCTAssertTrue(notification[0].identifier == createTime1, "Todoが登録されていない")

        }

    }

    func test_deleteNotification() {

        let createTime1 = Format().stringFromDate(date: Date(), addSec: true)
        let todoDate1 = Format().stringFromDate(date: Date(timeIntervalSinceNow: 60 * 60 * 48))
        let todoModel1 = ToDoModel(id: "0", toDoName: "TEST", todoDate: todoDate1, toDo: "TESTTodo", completionFlag: CompletionFlag.unfinished.rawValue, createTime: createTime1)
        NotificationManager().addNotification(toDoModel: todoModel1) { _ in
        }
        sleep(1)

        let createTime2 = Format().stringFromDate(date: Date(), addSec: true)
        let todoDate2 = Format().stringFromDate(date: Date(timeIntervalSinceNow: 60 * 60 * 48))
        let todoModel2 = ToDoModel(id: "0", toDoName: "TEST", todoDate: todoDate2, toDo: "TESTTodo", completionFlag: CompletionFlag.unfinished.rawValue, createTime: createTime2)
        NotificationManager().addNotification(toDoModel: todoModel2) { _ in
        }

        UNUserNotificationCenter.current().getPendingNotificationRequests { notification in
            XCTAssertTrue(notification.count == 2, "Todoが作成した以上に登録されている")
            XCTAssertTrue(notification[0].identifier == todoModel1.createTime!, "Todoが登録されていない")
            XCTAssertTrue(notification[1].identifier == todoModel2.createTime!, "Todoが登録されていない")
        }

        /// 削除
        NotificationManager().removeNotification([todoModel1.createTime!])
        sleep(1)
        /// 削除されたことの確認
        UNUserNotificationCenter.current().getPendingNotificationRequests { notification in
            XCTAssertTrue(notification.count == 1, "Todoが作成した以上に登録されている")
            XCTAssertTrue(notification[0].identifier == todoModel2.createTime!, "Todoが登録されていない")
        }

    }

    func test_allDeleteNotification() throws {

        let createTime1 = Format().stringFromDate(date: Date(), addSec: true)
        let todoDate1 = Format().stringFromDate(date: Date(timeIntervalSinceNow: 60 * 60 * 48))
        let todoModel1 = ToDoModel(id: "0", toDoName: "TEST", todoDate: todoDate1, toDo: "TESTTodo", completionFlag: CompletionFlag.unfinished.rawValue, createTime: createTime1)
        NotificationManager().addNotification(toDoModel: todoModel1) { _ in
        }
        sleep(1)

        let createTime2 = Format().stringFromDate(date: Date(), addSec: true)
        let todoDate2 = Format().stringFromDate(date: Date(timeIntervalSinceNow: 60 * 60 * 48))
        let todoModel2 = ToDoModel(id: "0", toDoName: "TEST", todoDate: todoDate2, toDo: "TESTTodo", completionFlag: CompletionFlag.unfinished.rawValue, createTime: createTime2)
        NotificationManager().addNotification(toDoModel: todoModel2) { _ in
        }

        UNUserNotificationCenter.current().getPendingNotificationRequests { notification in
            XCTAssertTrue(notification.count == 2, "Todoが2件が登録されていない")
            XCTAssertTrue(notification[0].identifier == todoModel1.createTime!, "Todoが登録されていない")
            XCTAssertTrue(notification[1].identifier == todoModel2.createTime!, "Todoが登録されていない")
        }

        /// 削除
        NotificationManager().allRemoveNotification()
        sleep(1)
        /// 削除されたことの確認
        UNUserNotificationCenter.current().getPendingNotificationRequests { notification in
            XCTAssertTrue(notification.count == 0, "Todoが削除されていない")
        }

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
