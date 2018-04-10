//
//  editViewController.swift
//  test
//
//  Created by midori on 2017/08/28.
//  Copyright © 2017年 midori. All rights reserved.
//
import UIKit
import RealmSwift

class editViewController: UIViewController{
    
    @IBOutlet weak var uibar: UINavigationBar!
    @IBOutlet weak var memo: UITextView!
    @IBOutlet weak var colorlabel: UILabel!
    @IBOutlet weak var day: UILabel!
    
   var delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

   // let id = self.delegate.id
    let pickerView: UIDatePicker = UIDatePicker()
    
    let realm = try! Realm() //いつもの

    @IBOutlet weak var edit: UITextField!
   
   // @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("settingcoor")
        UINavigationBar.appearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("settingcoorviewWillAppear")
        UINavigationBar.appearance()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingColor()
        print("移動した値:",self.delegate.id)
      
         let data = realm.object(ofType: Todo.self, forPrimaryKey: self.delegate.id as AnyObject)
        edit.text=data?.koumoku
         //   print("id: \(data.koumoku)")
        
        memo.text=data?.memo
        
        timeField.text=data?.date
        let myDateFormatter: DateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "yyyy/MM/dd hh:mm"
        day.text=myDateFormatter.string(from: (data?.created)!) as String
        
        picker()
        
        // 角に丸みをつける.
        memo.layer.masksToBounds = true
        
        // 丸みのサイズを設定する.
       memo.layer.cornerRadius = 20.0
        
        // 枠線の太さを設定する.
       memo.layer.borderWidth = 1
        
        // 枠線の色を黒に設定する.
        memo.layer.borderColor = UIColor.green.cgColor
        // Do any additional setup after loading the view.
        
        colorlabel.layer.borderColor = UIColor.black.cgColor
        
        colorlabel.layer.borderWidth = 1.0
        
        
        //文字色の設定
    //    colorlabel.backgroundColor.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSMakeRange(0, 4))
        colorlabel.backgroundColor = UIColor(red:0.0,green:1.5,blue:1.0,alpha:1.0)//UIColor.blue
    }
    
    func picker(){
        
        pickerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: pickerView.bounds.size.height)
        //    pickerView.delegate   = self
        //     pickerView.dataSource = self
        pickerView.timeZone = NSTimeZone.local
        pickerView.addTarget(self, action: #selector(editViewController.onDidChangeDate(sender:)), for: .valueChanged)
        let vi = UIView(frame: pickerView.bounds)
        vi.backgroundColor = UIColor.white
        vi.addSubview(pickerView)
        
        timeField.inputView = vi
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        let doneButton   = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(editViewController.donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(editViewController.cancelPressed))
        let spaceButton  = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
       timeField.inputAccessoryView = toolBar
        
    }
    
    
     //DatePickerが選ばれた際に呼ばれる.
 
    internal func onDidChangeDate(sender: UIDatePicker){
        
        
        // フォーマットを生成.
        let myDateFormatter: DateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "yyyy/MM/dd hh:mm"
        
        // 日付をフォーマットに則って取得.
        let mySelectedDate: NSString = myDateFormatter.string(from: sender.date) as NSString
        timeField.text = mySelectedDate as String
     let data = realm.object(ofType: Todo.self, forPrimaryKey: self.delegate.id as AnyObject)
       try! realm.write {
            data!.date = mySelectedDate as String
        }


    }
    
    // Done
    func donePressed() {
        view.endEditing(true)
    }
    
    // Cancel
    func cancelPressed() {
        timeField.text = ""
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //メイン画面に推移
    @IBAction func ReturnMain(_ sender: Any) {
        performSegue(withIdentifier: "toMain",sender: nil)
    }
    //項目の書き換え
    @IBAction func koumoku(_ sender: UITextField) {
        let data = realm.object(ofType: Todo.self, forPrimaryKey: self.delegate.id as AnyObject)
        let history=History()
        history.KoumokuHistory=sender.text!

        try! realm.write {
            data?.koumoku = sender.text!
            realm.add(history)

        }

    }
    //メモの保存
    @IBAction func memoStorage(_ sender: Any) {
        let data = realm.object(ofType: Todo.self, forPrimaryKey: self.delegate.id as AnyObject)
        try! realm.write {
            data?.memo = memo.text!
        }

    }
    
    func settingColor(){
        let userDefaults = UserDefaults.standard
        if(userDefaults.integer(forKey: "color") == 0){
            uibar.barTintColor = UIColor.black
        }
        if(userDefaults.integer(forKey: "color") == 1){
            uibar.barTintColor = UIColor.red
        }
        if(userDefaults.integer(forKey: "color") == 2){
            uibar.barTintColor = UIColor.orange
        }
        if(userDefaults.integer(forKey: "color") == 3){
            uibar.barTintColor = UIColor.yellow
        }
        if(userDefaults.integer(forKey: "color") == 4){
            uibar.barTintColor = UIColor.green
        }
        if(userDefaults.integer(forKey: "color") == 5){
            uibar.barTintColor = UIColor.blue
        }
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
