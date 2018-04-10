//
//  HistoryViewController.swift
//  test
//
//  Created by midori on 2017/08/28.
//  Copyright © 2017年 midori. All rights reserved.
//

import UIKit
import RealmSwift

class HistoryViewController: UIViewController,UITableViewDelegate , UITableViewDataSource  {
    
    
    @IBOutlet weak var histableview: UITableView!
    
    
    let realm = try! Realm() //いつもの
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        histableview.dataSource = self    //追加
        histableview.delegate = self // 追加
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func BackMain(_ sender: Any) {
        performSegue(withIdentifier: "toMain2",sender: nil)
        
    }
    @IBAction func HistoryDelete(_ sender: Any) {
        
        let alert=UIAlertController(title: "履歴を削除します", message: nil, preferredStyle: .alert)
        
        alert.addAction(
            UIAlertAction(
                title: "キャンセル",
                style: .cancel,
                handler: nil
            )
        )
        
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: {(action)->Void in
                    self.delete()
            })
        )
        
        self.present(alert,
                     animated: true,
                     completion:{
                        
        })
        
        
    }
    
    func delete(){
        
        // Realmに保存されてるオブジェクトを全て取得
        let history = realm.objects(History.self)
        
        try! realm.write() {
            realm.delete(history)
        }
        histableview.reloadData()
        
    }
    
    // 一つのsectionの中に入れるCellの数を決める。
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //  let realm = try! Realm()
        let todoCollection = realm.objects(History.self)
        // Realmに保存されているTodo型のobjectsを取得。
        
        return todoCollection.count // 総todo数を返している
        //   return array.count // 上に定義した配列arrayの要素数
    }
    
    
    
    // sectionの数を決める
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    // Cellの高さを決める
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 50
    }
    
    
    // Cellの内容を決める
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "historycell", for: indexPath)
        //   let realm = try! Realm()
        let historyCollection = realm.objects(History.self)
        // Realmに保存されているTodo型のobjectsを取得。
        let history = historyCollection[indexPath.row]
        cell.textLabel?.text = history.KoumokuHistory
        
//        let myDateFormatter: DateFormatter = DateFormatter()
//        myDateFormatter.dateFormat = "yyyy/MM/dd hh:mm"
//        cell.detailTextLabel?.text=myDateFormatter.string(from: (history.CompleteDay)) as String
        //  cell.textLabel?.text = array[indexPath.row] // indexPath.rowはセルの番号
         cell.isUserInteractionEnabled = false
        
        return cell
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
