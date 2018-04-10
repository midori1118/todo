//
//  settingViewController.swift
//  todotest
//
//  Created by midori totizawa on 2017/09/06.
//  Copyright © 2017年 midori. All rights reserved.
//

import UIKit
import RealmSwift

let sectionTitle=["カラー","リセット","表示"]
let section0=["テーマカラーの決定"]
let section1=["データの全削除"]
let section2=["リストに通知日を表示"]

class settingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
     let userDefaults = UserDefaults.standard
    let mySwicth: UISwitch = UISwitch()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        navigationController?.navigationBar.barTintColor = UIColor.red
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //セルの個数を指定する
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return section0.count
        case 1:
            return section1.count
        case 2:
            return section2.count
        default:
            return 0
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int { // sectionの数を決める
        return sectionTitle.count
    }
    //セルに表示するデータを指定する
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Cellの高さを決める
        
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Cellの内容を決める（超重要）
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "setcell", for: indexPath)
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = section0[indexPath.row]
            cell.accessoryType = .disclosureIndicator

        case 1:
            cell.textLabel?.text = section1[indexPath.row]
          
        case 2:
            cell.textLabel?.text = section2[indexPath.row]
            
            mySwicth.isOn = userDefaults.bool(forKey: "term")
              mySwicth.addTarget(self, action: #selector(settingViewController.onClickMySwicth(sender:)), for: UIControlEvents.valueChanged)
             cell.accessoryView = mySwicth
        default:
            break
        }
      //   cell.isUserInteractionEnabled = false
        return cell
        
    }
    
    internal func onClickMySwicth(sender: UISwitch){
        
        if sender.isOn {
            print("On")
           // mySwicth.isOn = true
            userDefaults.set(true, forKey: "term")
            //データの同期
            userDefaults.synchronize()
        }
        else {
            print("Off")
            // mySwicth.isOn = false
            userDefaults.set(false, forKey: "term")

        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath)
        //データを全削除する
        if(indexPath == [1,0] ){
            
            let alert2=UIAlertController(title: "データを完全削除します(o_o)b", message: nil, preferredStyle: .alert)
            
            alert2.addAction(
                UIAlertAction(
                    title: "キャンセル",
                    style: .default,
                    handler: nil
                )
            )

            alert2.addAction(
                UIAlertAction(
                    title: "OK",
                    style: .default,
                    handler: {(action) ->Void in self.DataDelete()}
                )
            )
            
            
            self.present(alert2,
                         animated: true,
                         completion:{
            })
           
        }
        //色の選択画面に移動する
        if(indexPath==[0,0]){
        performSegue(withIdentifier: "colorselect", sender: nil)
        }
        //選択し終わったら色を解除
         tableView.deselectRow(at: indexPath, animated: true)
        
    }

    //データの全削除
    func DataDelete(){
           let realm = try! Realm()
                try! realm.write {
                    realm.deleteAll()
                }
                //カウント回数の記憶
                let userDefaults = UserDefaults.standard
                userDefaults.removeObject(forKey: "count")
                print(userDefaults.integer(forKey: "count"))
                userDefaults.removeObject(forKey: "term")
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
