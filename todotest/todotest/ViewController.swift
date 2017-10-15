//
//  ViewController.swift
//  test
//
//  Created by midori on 2017/08/28.
//  Copyright © 2017年 midori. All rights reserved.
//

import UIKit
import RealmSwift


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource  {
    
    //入力する
    @IBOutlet weak var inputtext: UITextField!
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var HistoryButton: UIBarButtonItem!
    @IBOutlet weak var SettingButton: UIBarButtonItem!
    //入力の隣のチェックボックス
     var myButton: UIButton!
    
    //カウント回数の記憶
    let userDefaults = UserDefaults.standard
    
    //var todoKoumoku: Results<Todo>!
    var Todolist: Results<Todo>!
       // var array:[String] = []
   // var count:Int = 0
    
    //画面をまたいでの使用
    var delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //realmの取得
   let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        let myButton = UIButton()
        myButton.backgroundColor = UIColor.blue // 背景色
        myButton.addTarget(self, action: #selector(ViewController.onClickMyButton(sender:)), for: .touchUpInside)
        // タイトルを設定する(通常時).
        myButton.setTitle("ボタン(通常)", for: .normal)
        myButton.setTitleColor(UIColor.white, for: .normal)
        
        // タイトルを設定する(ボタンがハイライトされた時).
        myButton.setTitle("ボタン(押された時)", for: .highlighted)
        myButton.setTitleColor(UIColor.black, for: .highlighted)
        


        
        tableview.dataSource = self    //追加
        tableview.delegate = self // 追加
        // Do any additional setup after loading the view, typically from a nib.
       //メイン画面のtableviewを左端まで引く
        //self.tableview.separatorInset = UIEdgeInsets.zero
        
            Todolist = realm.objects(Todo.self)
            tableview.reloadData()
        
        //もしcountデータが存在しなかったら作成する
        if((userDefaults.object(forKey: "count")) == nil){
            userDefaults.set(0, forKey: "count")
            //データの同期
            userDefaults.synchronize()
        }
        
        if((userDefaults.object(forKey: "term")) == nil){
            userDefaults.set(false, forKey: "term")
            //データの同期
            userDefaults.synchronize()
        }    
        
        print(userDefaults.integer(forKey: "count"))
    //    count = readData()
        //UITextFieldの右端に常に削除ボタン
        inputtext.clearButtonMode = .always
        inputtext.delegate=self as? UITextFieldDelegate
        
          }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //チェックボタンを押すと登録される
    @IBAction func input(_ sender: Any) {
        //hyouzi.text = inputtext.text
        if(inputtext.text != ""){
            let todo = Todo()
            let history=History()
          //  let todo_count = realm.objects(Todo.self).last
          //  let count:Int = todo_count.id+1
          //  let last = realm.objects(Todo.self).sorted(byKeyPath: "id").last
            
            
            todo.koumoku = inputtext.text!
            todo.id=userDefaults.integer(forKey: "count")
            //データの保存。今回訪れた回数に+1している。
            userDefaults.set(userDefaults.integer(forKey: "count") + 1, forKey: "count")
             print(todo.created)
            //データの同期
            userDefaults.synchronize()
            
            print("tylku",userDefaults.integer(forKey: "count"))

            history.KoumokuHistory=inputtext.text!
            
            try! realm.write {
                realm.add(todo)
                realm.add(history)
            }
            print(todo.koumoku)
            print(todo.id)
            self.dismiss(animated: true, completion: nil)
            
            // array.append(inputtext.text!)
            
            tableview.reloadData()
            inputtext.text=""
            inputtext.endEditing(true);
        }else{
            let alert=UIAlertController(title: "項目を入力してください", message: nil, preferredStyle: .alert)
            
            alert.addAction(
                UIAlertAction(
                    title: "OK",
                    style: .default,
                    handler: nil
                )
            )
            
            self.present(alert,
                         animated: true,
                         completion:{
            })
            
            
        }
    }
    
    
    @IBAction func type(_ sender: UITextField) {
        if(sender.text != ""){
            let todo = Todo()
            let history=History()
            //  let todo_count = realm.objects(Todo.self).last
            //  count = readData()+1
            //            print(count)
            //            userDefaults.set(count+1, forKey: "DataStore")
            //            userDefaults.synchronize()
            //            print(count)
            todo.koumoku = sender.text!
            todo.id=userDefaults.integer(forKey: "count")
            //データの保存。今回訪れた回数に+1している。
            userDefaults.set(userDefaults.integer(forKey: "count") + 1, forKey: "count")
            print(todo.created)
            //データの同期
            userDefaults.synchronize()
            
            
            history.KoumokuHistory=sender.text!
            try! realm.write {
                realm.add(todo)
                realm.add(history)
            }
            print(todo.koumoku)
            print(todo.id)
            //  array.append(sender.text!)
            tableview.reloadData()
            sender.text=""
        }else{
            let alert=UIAlertController(title: "項目を入力してください", message: nil, preferredStyle: .alert)
            
            alert.addAction(
                UIAlertAction(
                    title: "OK",
                    style: .default,
                    handler: nil
                )
            )
            
            self.present(alert,
                         animated: true,
                         completion:{
            })
            
        }

    }
 
    
    
    //cellの削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if(editingStyle == UITableViewCellEditingStyle.delete) {
            do{
                let realm = try Realm()
                let todo = realm.objects(Todo.self)
                
                try realm.write {
                   // realm.delete(self.Todolist[indexPath.row])
                    self.realm.delete(todo[indexPath.row])
                }
                
                tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.fade)
            }catch{
            }
            tableView.reloadData()
            
            
        }
        //        if editingStyle == .delete {
        //
        //            //    let todo = Todo()
        //            // 削除
        //            try! realm.write {
        //
        //                realm.delete(self.TodoKoumoku[indexPath.row])
        //
        //            }
        //            tableView.reloadData()
        //            tableView.deleteRows(at: [indexPath], with: .fade)
        //
        //            // array.remove(at: indexPath.row)
        //        }
    }
    
    @IBAction func TapSetting(_ sender: Any) {
        performSegue(withIdentifier: "tosetting",sender: nil)

    }
    
    @IBAction func TappHistory(_ sender: Any) {
        performSegue(withIdentifier: "Tohistory",sender: nil)
    }
    
    @IBAction func goback(segue: UIStoryboardSegue) {
        tableview.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  let realm = try! Realm()
        //let todo = Todo()
        print(indexPath.row)
        //   let realm = try! Realm()
        let todoCollection = realm.objects(Todo.self)
        // Realmに保存されているTodo型のobjectsを取得。
        let todo = todoCollection[indexPath.row]

        print(todo.id)
        self.delegate.id = todo.id
     //    appDelegate.id = todo.id
       // self.delegate.id = todoCollection[indexPath.row]

      //  let todo=realm.objects(Todo.self).select
             // print(todo.id)
         //let Current:Results<Todo> = self.realm.objects(Todo.self).filter("Tag == " + (String)(sender.tag))
       // AppDelegate.id=todo.id
        performSegue(withIdentifier: "hu",sender: nil)
    }
    
    // 一つのsectionの中に入れるCellの数を決める。
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //  let realm = try! Realm()
        let todoCollection = realm.objects(Todo.self)
        // Realmに保存されているTodo型のobjectsを取得。
        
        return todoCollection.count // 総todo数を返している
        //   return array.count // 上に定義した配列arrayの要素数
    }
    
    
    
    // sectionの数を決める
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    @IBAction func tapcheck(_ sender: Any) {
        // タップされたボタンのtableviewの選択行を取得
        let btn = sender as! UIButton
        let cell = btn.superview?.superview as! UITableViewCell
        let row = tableview.indexPath(for: cell)?.row
       // cell.imageView?.image=UIImage(named: "check.jpg")
        // 行数を表示
        print("\(String(describing: row))");
    }
    
    // Cellの高さを決める
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 50
    }
   
    // Cellの内容を決める
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //   let realm = try! Realm()
        let todoCollection = realm.objects(Todo.self)
        // Realmに保存されているTodo型のobjectsを取得。
        let todo = todoCollection[indexPath.row]
       cell.textLabel?.text = todo.koumoku
    // tableView.setEditing(true, animated: true)
    cell.imageView?.image = UIImage(named: "check.jpg")
//        let label = UILabel()
//        label.textColor         = UIColor.black
//        label.text              = todo.koumoku
//        label.textAlignment     = .center
//        label.sizeToFit()     // ADD THIS LINE
        
    //    cell.accessoryView      = label
        // （いろいろ省略していますが、ポイントだけ記載）
//       let addToAboveButton: UIButton = UIButton(frame: CGRect(x:0, y:0,width: 50,height: 50))
//       addToAboveButton.addTarget(self, action: Selector(("checkButtonTapped:event:")), for: .touchUpInside)
//       addToAboveButton.backgroundColor = UIColor.red
//        cell.accessoryView?.addSubview(addToAboveButton)
        
        if(todo.date != ""){
            //print("aaa")
            cell.detailTextLabel?.text=todo.date
        }else{
            cell.detailTextLabel?.text=""
        }
        
        return cell
        
    }
       internal func onClickMyButton(sender: UIButton) {
        print("onClickMyButton:");
     //   print("sender.currentTitle: \(sender.currentTitle)")
      //  print("sender.tag: \(sender.tag)")
    }
}
