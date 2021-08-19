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
        let _ = ToDoModel.allDelete()
    }
    
    
    
    
    /// ToDoModelのInitTest
    func test_initTodoModel() {
        let todoDate = Format().stringFromDate(date: Date())
        let todoModel1 = ToDoModel(id: "0", toDoName: "UnitTest", todoDate: todoDate, toDo: "詳細", createTime: nil)
        
        XCTAssert(todoModel1.id == "0", "idが代入されていない")
        XCTAssert(todoModel1.toDoName == "UnitTest", "Todoのタイトルが代入されていない")
        XCTAssert(todoModel1.todoDate == todoDate, "　Todoの期限が代入されていない")
        XCTAssert(todoModel1.toDo == "詳細", "　Todoの詳細が代入されていない")
        XCTAssertNil(todoModel1.createTime, "Todo作成時間が作成されている")
        
        
        let todoModel2 = ToDoModel(id: "0", toDoName: "UnitTest", todoDate: todoDate, toDo: "詳細", createTime: "createTime")
        
        XCTAssert(todoModel2.id == "0", "idが代入されていない")
        XCTAssert(todoModel2.toDoName == "UnitTest", "Todoのタイトルが代入されていない")
        XCTAssert(todoModel2.todoDate == todoDate, "　Todoの期限が代入されていない")
        XCTAssert(todoModel2.toDo == "詳細", "　Todoの詳細が代入されていない")
        XCTAssert(todoModel2.createTime == "createTime", "Todo作成時間が代入されていない")
    }
    
    
    
    
    func test_AddModel() {
        
        let addTodoDate = Format().stringFromDate(date: Date())
        let _ = ToDoModel.add(addValue: ToDoModel(id: "0", toDoName: "UnitTest", todoDate: addTodoDate, toDo: "詳細", createTime: nil))
        let todoModel = ToDoModel.find(todoId: "0", createTime: nil)
        
        XCTAssert(todoModel?.id == "0", "idが登録されていない")
        XCTAssert(todoModel?.toDoName == "UnitTest", "Todoのタイトルが登録されていない")
        XCTAssert(todoModel?.todoDate == addTodoDate, "　Todoの期限が登録されていない")
        XCTAssert(todoModel?.toDo == "詳細", "　Todoの詳細が登録されていない")
        XCTAssert(!(todoModel?.createTime!.isEmpty)!, "Todo作成時間が登録されていない")
    }
    
    
    
    func test_EditModel() {
        let addTodoDate = Format().stringFromDate(date: Date())
        let _ = ToDoModel.add(addValue: ToDoModel(id: "0", toDoName: "UnitTest", todoDate: addTodoDate, toDo: "詳細", createTime: nil))
    
        let updateTodoDate = Format().stringFromDate(date: Date())
        let _ = ToDoModel.update(updateValue: ToDoModel(id: "0", toDoName: "EditUnitTest", todoDate: updateTodoDate, toDo: "詳細編集", createTime: nil))
        
        
        let todoModel = ToDoModel.find(todoId: "0", createTime: nil)
        XCTAssert(todoModel?.id == "0", "idが登録されていない")
        XCTAssert(todoModel?.toDoName == "EditUnitTest", "Todoのタイトルが登録されていない")
        XCTAssert(todoModel?.todoDate == updateTodoDate, "　Todoの期限が登録されていない")
        XCTAssert(todoModel?.toDo == "詳細編集", "　Todoの詳細が登録されていない")
        XCTAssert(!(todoModel?.createTime!.isEmpty)!, "Todo作成時間が登録されていない")
    }
    
    
    
    
    func test_DeleteModel() {
        let addTodoDate = Format().stringFromDate(date: Date())
        let _ = ToDoModel.add(addValue: ToDoModel(id: "0", toDoName: "UnitTest", todoDate: addTodoDate, toDo: "詳細", createTime: nil))
        
        let todoModel = ToDoModel.find(todoId: "0", createTime: nil)
        
        XCTAssertTrue(ToDoModel.allFind()!.count > 0, "Todoが作成されていない")
        XCTAssert(todoModel?.id == "0", "idが登録されていない")
        XCTAssert(todoModel?.toDoName == "UnitTest", "Todoのタイトルが登録されていない")
        XCTAssert(todoModel?.todoDate == addTodoDate, "　Todoの期限が登録されていない")
        XCTAssert(todoModel?.toDo == "詳細", "　Todoの詳細が登録されていない")
        XCTAssert(!(todoModel?.createTime!.isEmpty)!, "Todo作成時間が登録されていない")
        
        let _ = ToDoModel.delete(todoModel!)
        
    }
    
    
    
    func test_allDeleteModel() {
        let addTodoDate = Format().stringFromDate(date: Date())
        let _ = ToDoModel.add(addValue: ToDoModel(id: "0", toDoName: "UnitTest1", todoDate: addTodoDate, toDo: "詳細1", createTime: nil))
        let _ = ToDoModel.add(addValue: ToDoModel(id: "1", toDoName: "UnitTest2", todoDate: addTodoDate, toDo: "詳細2", createTime: nil))
        
        let todoModel1 = ToDoModel.find(todoId: "0", createTime: nil)
        
        XCTAssertTrue(ToDoModel.allFind()!.count == 2, "Todoが作成されていない")
        XCTAssert(todoModel1?.id == "0", "idが登録されていない")
        XCTAssert(todoModel1?.toDoName == "UnitTest1", "Todoのタイトルが登録されていない")
        XCTAssert(todoModel1?.todoDate == addTodoDate, "　Todoの期限が登録されていない")
        XCTAssert(todoModel1?.toDo == "詳細1", "　Todoの詳細が登録されていない")
        XCTAssert(!(todoModel1?.createTime!.isEmpty)!, "Todo作成時間が登録されていない")
        
        let todoModel2 = ToDoModel.find(todoId: "1", createTime: nil)
        XCTAssert(todoModel2?.id == "1", "idが登録されていない")
        XCTAssert(todoModel2?.toDoName == "UnitTest2", "Todoのタイトルが登録されていない")
        XCTAssert(todoModel2?.todoDate == addTodoDate, "　Todoの期限が登録されていない")
        XCTAssert(todoModel2?.toDo == "詳細2", "　Todoの詳細が登録されていない")
        XCTAssert(!(todoModel2?.createTime!.isEmpty)!, "Todo作成時間が登録されていない")
        
        let _ = ToDoModel.allDelete()
        XCTAssertFalse(ToDoModel.allFind()!.count > 0, "Todoが削除されていない")
        
    }
    

}
