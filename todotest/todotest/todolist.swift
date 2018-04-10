//
//  todolist.swift
//  test
//
//  Created by midori on 2017/08/28.
//  Copyright © 2017年 midori. All rights reserved.
//


import Foundation
import RealmSwift

class Todo: Object{
    
    // 登録日時
    dynamic var created = Date()
    
    // 登録日
    dynamic var term:String=""
    //日付の表示
    dynamic var date:String=""
    
    dynamic var NTime:Date? = nil     //締め切り時刻
    // todoの項目
    dynamic var koumoku: String = ""
    
    //色の付箋
    dynamic var ColorRight:Int=0
    // メモ内容
    dynamic var memo: String=""
    
    //認識
    dynamic var id:Int = -1
    
    //チェック
    dynamic var tyeck:Bool=false
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

class History: Object{
    
    dynamic var KoumokuHistory: String=""
   // dynamic var CompleteDay:Date?
}

