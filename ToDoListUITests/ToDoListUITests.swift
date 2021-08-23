//
//  ToDoListUITests.swift
//  ToDoListUITests
//
//  Created by 土橋正晴 on 2018/11/15.
//  Copyright © 2018 m.dobashi. All rights reserved.
//

import XCTest

class ToDoListUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.

        let app: XCUIApplication = XCUIApplication()

        if app.alerts.buttons["Allow"].exists {
            app.alerts.buttons["Allow"].tap()
            sleep(1)
        }

        app.navigationBars["ToDoリスト"].buttons["allDelete"].tap()
        app.alerts.buttons["削除"].tap()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.

    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

    }

    func testToDolistViewUITest() {
        let app: XCUIApplication = XCUIApplication()

        let navigationTitle = app.navigationBars["ToDoリスト"]
        XCTAssert(navigationTitle.exists)
        XCTAssert(navigationTitle.buttons["Add"].exists)

        let cellLabel = app.tables.cells.staticTexts["Todoがまだ登録されていません"]
        XCTAssert(cellLabel.exists, "ToDo未登録時のラベルがない")

        XCTAssertEqual(cellLabel.label, "Todoがまだ登録されていません", "文言違い")

        app.navigationBars["ToDoリスト"].buttons["Add"].tap()

        app.cells.textFields["titleTextField"].tap()
        app.typeText("test")

        let datePicker = app.datePickers["datePicker"]
        if #available(iOS 14.0, *) {
            XCTAssertTrue(app.cells.textFields["titleTextField"].exists, "期限入力用DatePickerがない")
        } else {
            XCTAssert(app.cells.textFields["dateTextField"].exists, "期限のテキストフィールドがない")
            app.cells.textFields["dateTextField"].tap()
            XCTAssert(datePicker.exists, "期限設定するデートピッカーが表示されない")
        }

        if #available(iOS 14.0, *) {
            /// 何もしない
        } else if #available(iOS 13.0, *) {
            datePicker.pickerWheels.element(boundBy: 0).swipeUp()
            datePicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "5")
            datePicker.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "50")
        } else {
            datePicker.pickerWheels.element(boundBy: 0).swipeDown()
            datePicker.pickerWheels.element(boundBy: 1).swipeDown()
            datePicker.pickerWheels.element(boundBy: 2).swipeDown()
        }

        app.cells.textViews["detailTextViwe"].tap()
        app.typeText("testDetail")

        app.navigationBars.buttons["Save"].tap()
        app.alerts.buttons["閉じる"].tap()

        XCTAssertEqual(app.tables.staticTexts["test"].label, "test", "登録したタイトルが表示されていない")
        XCTAssertEqual(app.tables.staticTexts["testDetail"].label, "testDetail", "登録した詳細が表示されていない")

        app.tables.cells.firstMatch.swipeLeft()
        let edit = app.tables.buttons["編集"]
        let delete = app.tables.buttons["削除"]
        XCTAssert(edit.exists)
        XCTAssert(delete.exists)

        edit.tap()
        app.navigationBars.buttons["Cancel"].tap()

        app.tables.cells.firstMatch.swipeLeft()
        delete.tap()
        app.alerts.buttons["削除"].tap()

    }

    func testTodoInputTableView() {
        let app: XCUIApplication = XCUIApplication()
        let navigationTitle = app.navigationBars["ToDoリスト"]
        navigationTitle.buttons["Add"].tap()

        XCTAssert(app.navigationBars.buttons["Save"].exists, "保存ボタンがない")
        XCTAssert(app.navigationBars.buttons["Cancel"].exists, "キャンセルボタンがない")
        XCTAssert(app.cells.textFields["titleTextField"].exists, "タイトル入力のテキストフィールドがない")

        let datePicker = app.datePickers["datePicker"]
        if #available(iOS 14.0, *) {
            XCTAssertTrue(app.cells.textFields["titleTextField"].exists, "期限入力用DatePickerがない")
        } else {
            XCTAssert(app.cells.textFields["dateTextField"].exists, "期限のテキストフィールドがない")
            app.cells.textFields["dateTextField"].tap()
            XCTAssert(datePicker.exists, "期限設定するデートピッカーが表示されない")
        }
        XCTAssert(app.cells.textViews["detailTextViwe"].exists, "詳細入力用のテキストビューがない")

        createToDo(num: 1, isOpen: false)

        sleep(1)
        app.tables.cells.firstMatch.swipeLeft()
        sleep(1)
        let edit = app.tables.buttons["編集"]
        if app.waitForExistence(timeout: 1.0) {
            edit.tap()
        }

        // タイトル入力
        app.cells.textFields["titleTextField"].tap()
        for _ in 0...3 {
            app.keys["delete"].tap()
        }
        app.typeText("edit")

        // 期限入力
        if #available(iOS 14.0, *) {
            // 何もしない
        } else {
            app.cells.textFields["dateTextField"].tap()
            XCTAssert(datePicker.exists)
        }

        if #available(iOS 14.0, *) {
            // 何もしない
        } else if #available(iOS 13.0, *) {
            datePicker.pickerWheels.element(boundBy: 0).swipeUp()
            datePicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "5")
            datePicker.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "50")
        } else {
            datePicker.pickerWheels.element(boundBy: 0).swipeDown()
            datePicker.pickerWheels.element(boundBy: 1).swipeDown()
            datePicker.pickerWheels.element(boundBy: 2).swipeDown()
        }

        // 詳細入力
        app.cells.textViews["detailTextViwe"].tap()
        app.typeText("detailEdit")

        // 保存
        app.navigationBars.buttons["Save"].tap()
        app.alerts.buttons["閉じる"].tap()
    }

    func testDetailEdit() {

        let app: XCUIApplication = XCUIApplication()

        createToDo(num: 1, isOpen: true)
        app.tables.cells.element(boundBy: 0).tap()
        app.navigationBars.buttons.element(boundBy: 1).tap()

        app.sheets.buttons["編集"].tap()

        editTodo(title: "編集", detail: "編集詳細")

        sleep(1)

        XCTAssert(app.staticTexts["編集"].exists, "編集したタイトルが表示されていません")
        XCTAssert(app.staticTexts["編集詳細"].exists, "編集したタイトルが表示されていません")

    }

    func createToDo(num: Int, isOpen: Bool = true) {
        let app: XCUIApplication = XCUIApplication()

        if isOpen == true {
            let navigationTitle = app.navigationBars["ToDoリスト"]
            navigationTitle.buttons["Add"].tap()
        }
        // タイトル入力
        app.cells.textFields["titleTextField"].tap()
        app.typeText("test\(String(num))")

        // 期限入力
        let datePicker = app.datePickers["datePicker"]
        if #available(iOS 14.0, *) {
            XCTAssertTrue(app.cells.textFields["titleTextField"].exists, "期限入力用DatePickerがない")
        } else {
            app.cells.textFields["dateTextField"].tap()
            XCTAssert(datePicker.exists)
        }

        if #available(iOS 14.0, *) {
            // 何もしない
        } else if #available(iOS 13.0, *) {
            datePicker.pickerWheels.element(boundBy: 0).swipeUp()
            datePicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "5")
            datePicker.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "50")
        } else {
            datePicker.pickerWheels.element(boundBy: 0).swipeDown()
            datePicker.pickerWheels.element(boundBy: 1).swipeDown()
            datePicker.pickerWheels.element(boundBy: 2).swipeDown()
        }

        // 詳細入力
        app.cells.textViews["detailTextViwe"].tap()
        app.typeText("testDetail")

        sleep(1)

        // 保存
        app.navigationBars.buttons["Save"].tap()
        app.alerts.buttons["閉じる"].tap()
    }

    func editTodo(title: String, detail: String) {
        let app: XCUIApplication = XCUIApplication()
        sleep(1)
        // タイトル入力
        app.cells.textFields["titleTextField"].tap()
        for _ in 0...app.cells.textFields["titleTextField"].label.count - 1 {
            app.keys["delete"].tap()
        }
        app.typeText(title)

        // 期限入力
        let datePicker = app.datePickers["datePicker"]
        if #available(iOS 14.0, *) {
            XCTAssertTrue(app.cells.textFields["titleTextField"].exists, "期限入力用DatePickerがない")
        } else {
            app.cells.textFields["dateTextField"].tap()
            XCTAssert(datePicker.exists)
        }

        if #available(iOS 14.0, *) {
            // 何もしない
        } else if #available(iOS 13.0, *) {
            datePicker.pickerWheels.element(boundBy: 0).swipeUp()
            datePicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "5")
            datePicker.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "50")
        } else {
            datePicker.pickerWheels.element(boundBy: 0).swipeDown()
            datePicker.pickerWheels.element(boundBy: 1).swipeDown()
            datePicker.pickerWheels.element(boundBy: 2).swipeDown()
        }

        // 詳細入力

        if #available(iOS 13.0, *) {
            app.cells.textViews["detailTextViwe"].doubleTap()
        } else {
            app.cells.textViews["detailTextViwe"].doubleTap()
            app.cells.textViews["detailTextViwe"].doubleTap()
        }
        app.typeText(detail)

        // 保存
        app.navigationBars.buttons["Save"].tap()
        app.alerts.buttons["閉じる"].tap()
    }

}
