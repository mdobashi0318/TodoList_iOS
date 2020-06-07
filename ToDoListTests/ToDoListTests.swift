//
//  ToDoListTests.swift
//  ToDoListTests
//
//  Created by 土橋正晴 on 2018/11/14.
//  Copyright © 2018 m.dobashi. All rights reserved.
//

import XCTest
@testable import ToDoList

class ToDoModelTests: XCTestCase {

    var view:ToDoListViewController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        view = ToDoListViewController()
        
     
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        ToDoModel.allDelete()
    }
    
    
    func test_AddModel() {
        
        let addTodoDate = Format().stringFromDate(date: Date())
        ToDoModel.addRealm(view, addValue: TableValue(id: "0", title: "UnitTest", todoDate: addTodoDate, detail: "詳細"))
        let todoModel = ToDoModel.findRealm(view, todoId: "0", createTime: nil)
        
        XCTAssert(todoModel?.id == "0", "idが登録されていない")
        XCTAssert(todoModel?.toDoName == "UnitTest", "Todoのタイトルが登録されていない")
        XCTAssert(todoModel?.todoDate == addTodoDate, "　Todoの期限が登録されていない")
        XCTAssert(todoModel?.toDo == "詳細", "　Todoの詳細が登録されていない")
        XCTAssert(!(todoModel?.createTime!.isEmpty)!, "Todo作成時間が登録されていない")
    }
    
    
    
    func test_EditModel() {
        let addTodoDate = Format().stringFromDate(date: Date())
        ToDoModel.addRealm(view, addValue: TableValue(id: "0", title: "UnitTest", todoDate: addTodoDate, detail: "詳細"))
    
        let updateTodoDate = Format().stringFromDate(date: Date())
        ToDoModel.updateRealm(view, todoId: "0", updateValue: TableValue(id: "0", title: "EditUnitTest", todoDate: updateTodoDate, detail: "詳細編集"))
        
        
        let todoModel = ToDoModel.findRealm(view, todoId: "0", createTime: nil)
        XCTAssert(todoModel?.id == "0", "idが登録されていない")
        XCTAssert(todoModel?.toDoName == "EditUnitTest", "Todoのタイトルが登録されていない")
        XCTAssert(todoModel?.todoDate == updateTodoDate, "　Todoの期限が登録されていない")
        XCTAssert(todoModel?.toDo == "詳細編集", "　Todoの詳細が登録されていない")
        XCTAssert(!(todoModel?.createTime!.isEmpty)!, "Todo作成時間が登録されていない")
    }
    

}
