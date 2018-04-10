//
//  colorselectViewController.swift
//  todotest
//
//  Created by midori totizawa on 2017/10/15.
//  Copyright © 2017年 midori. All rights reserved.
//

import UIKit
import RealmSwift

class colorselectViewController: UIViewController {

     let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch: UITouch in touches {
            let tag = touch.view!.tag
            print(tag)
            if tag == 1 {
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
   
   
    @IBAction func selectcolor(_ sender: Any) {
        // UINavigationBar.appearance().barTintColor=(sender as AnyObject).backgroundColor
         //self.navigationController?.navigationBar.barTintColor=(sender as AnyObject).backgroundColor
        let button:UIButton = sender as! UIButton
        print(button.tag)
        
        userDefaults.set(button.tag, forKey: "color")
        
        userDefaults.synchronize()
        
      //  print((sender as AnyObject).tag)
       UINavigationBar.appearance().barTintColor = (sender as AnyObject).backgroundColor
        viewWillDisappear(true)
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UINavigationBar.appearance()
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
