//
//  InputView.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/11/14.
//  Copyright © 2018 m.dobashi. All rights reserved.
//

import UIKit
import RealmSwift


class InputView: UIView, UITextFieldDelegate, UIPickerViewDelegate {
    let textField:UITextField = UITextField()
    let DateTextField:UITextField = UITextField()
    let textViwe:UITextView = UITextView()
    let datePicker:UIDatePicker = UIDatePicker()
    
    var toDoModel:ToDoModel = ToDoModel()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
 
    convenience init(frame: CGRect, toDoModel:ToDoModel) {
        self.init(frame: frame)
        self.toDoModel = toDoModel
        
        viewLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func viewLoad(){
        
        textField.layer.borderWidth = 1
        self.addSubview(textField)
        
        setAL(textField: textField, areatopFlag: true)
        
        DateTextField.layer.borderWidth = 1
        self.addSubview(DateTextField)
        
        setAL(textField: DateTextField, areatopFlag: false)
        
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(onDidChangeDate(sender:)), for: .valueChanged)
        DateTextField.inputView = datePicker
        DateTextField.delegate = self
        
        
        DateTextField.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 50).isActive = true
        
        
        textViwe.layer.borderWidth = 1
        self.addSubview(textViwe)
        textViwe.translatesAutoresizingMaskIntoConstraints = false
        
        textViwe.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        textViwe.heightAnchor.constraint(equalToConstant: 100).isActive = true
        textViwe.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        textViwe.topAnchor.constraint(equalTo: DateTextField.bottomAnchor, constant: 50).isActive = true
        
    }
    
    
    @objc func onDidChangeDate(sender:UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.locale = Locale(identifier: "ja_JP")
        
        
        let s_Date:String = formatter.string(from: sender.date)
        DateTextField.text = s_Date
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.endEditing(true)
    }
    
    
    func addRealm(){
        let realm:Realm = try! Realm()
        
        toDoModel.id = String(realm.objects(ToDoModel.self).count + 1)
        toDoModel.toDoName = textField.text!
        toDoModel.todoDate = DateTextField.text//formatter.string(from: now)
        toDoModel.toDo = textViwe.text
        
        try! realm.write() {
            realm.add(toDoModel)
        }
    }
    
    func setAL(textField:UITextField, areatopFlag:Bool){
        textField.translatesAutoresizingMaskIntoConstraints = false
        areatopFlag ? textField.topAnchor.constraint(equalTo: self.topAnchor, constant: 50).isActive = true : nil
        textField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
}
