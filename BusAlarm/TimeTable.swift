//
//  TimeTable.swift
//  BusAlarm
//
//  Created by 祖父江亮 on 2017/05/21.
//  Copyright © 2017年 Ryo Sobue. All rights reserved.
//
import UIKit
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var timetable: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.jsondata = delegate.loadJson()!
        
        delegate.table = delegate.jsondata["toschool"].arrayValue.map({$0.stringValue})
        print(delegate.table)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        この１文でテーブルビューセルのIDがなくてクラッシュする問題を解消できる
        timetable.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
        
//        print(loadJson("weekday")!)
    }
    
    func update(){
        timetable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.table.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let now:NSDate = NSDate()
            let formatter = DateFormatter()
            
            formatter.dateFormat = "hh:mm:ss" //独自フォーマット
            formatter.locale = NSLocale.system //タイムゾーン
            
            let cell = timetable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = "現在の時間 : "+formatter.string(from: now as Date)
            return cell
        }
        else{
            let cell = timetable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            let delegate = UIApplication.shared.delegate as! AppDelegate
            cell.textLabel?.text = delegate.table[indexPath.row]
            return cell
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

