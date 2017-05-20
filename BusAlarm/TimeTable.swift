//
//  TimeTable.swift
//  BusAlarm
//
//  Created by 祖父江亮 on 2017/05/21.
//  Copyright © 2017年 Ryo Sobue. All rights reserved.
//
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var timetable: UITableView!
    
    let table:[String] = ["","10:00","11:00"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        この１文でテーブルビューセルのIDがなくてクラッシュする問題を解消できる
        timetable.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
    }
    
    func update(){
        timetable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.table.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let now:NSDate = NSDate()
            let formatter = DateFormatter()
            
            formatter.dateFormat = "h:mm:ss"
            
            formatter.locale = NSLocale.system
//            formatter.timeStyle = .medium
            
            let cell = timetable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = "現在の時間 : "+formatter.string(from: now as Date)
            return cell
            
        }
        else{
            let cell = timetable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = table[indexPath.row]
            return cell
        }
        

        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}

