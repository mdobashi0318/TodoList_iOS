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
    
    
    func testToDolistViewUITest(){
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
        
        app.cells.textFields["dateTextField"].tap()
        
        let datePicker = app.datePickers["detailPicker"]
        XCTAssert(datePicker.exists)
//        datePicker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "Sep 22")
        datePicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "5")
        datePicker.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "50")

        
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
        XCTAssert(app.cells.textFields["dateTextField"].exists, "期限のテキストフィールドがない")
        XCTAssert(app.cells.textViews["detailTextViwe"].exists, "詳細入力用のテキストビューがない")
        app.cells.textFields["dateTextField"].tap()
        let datePicker = app.datePickers["detailPicker"]
        XCTAssert(datePicker.exists, "期限設定するデートピッカーが表示されない")
        
        createToDo(isOpen: false)
        

        
        app.tables.cells.firstMatch.swipeLeft()
        let edit = app.tables.buttons["編集"]
        edit.tap()
        
        
        
        // タイトル入力
        app.cells.textFields["titleTextField"].tap()
        for _ in 0...3 {
            app.keys["delete"].tap()
        }
        app.typeText("edit")
        
        // 期限入力
        app.cells.textFields["dateTextField"].tap()
        //        datePicker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "Sep 22")
        datePicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "8")
        datePicker.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "00")
        
        // 詳細入力
        app.cells.textViews["detailTextViwe"].tap()
        
        
        app.typeText("detailEdit")
        
        // 保存
        app.navigationBars.buttons["Save"].tap()
        app.alerts.buttons["閉じる"].tap()
    }
    
    
    
    func createToDo(isOpen: Bool = true) {
        let app: XCUIApplication = XCUIApplication()
        
        if isOpen == true {
            let navigationTitle = app.navigationBars["ToDoリスト"]
            navigationTitle.buttons["Add"].tap()
        }
        // タイトル入力
        app.cells.textFields["titleTextField"].tap()
        app.typeText("test")
        
        // 期限入力
        app.cells.textFields["dateTextField"].tap()
        let datePicker = app.datePickers["detailPicker"]
        XCTAssert(datePicker.exists)
        //        datePicker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "Sep 22")
        datePicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "5")
        datePicker.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "50")
        
        // 詳細入力
        app.cells.textViews["detailTextViwe"].tap()
        app.typeText("testDetail")
        
        // 保存
        app.navigationBars.buttons["Save"].tap()
        app.alerts.buttons["閉じる"].tap()
    }
    
    
    
}
