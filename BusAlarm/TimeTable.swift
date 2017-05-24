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
    
    @IBOutlet weak var selector: UISegmentedControl!
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        delegate.table = delegate.loadJson(delegate.destination)
        print(delegate.table)
    }

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
            return delegate.table.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let now:NSDate = NSDate()
            let formatter = DateFormatter()
            
            formatter.dateFormat = "HH:mm:ss" //独自フォーマット
            formatter.locale = NSLocale.system //タイムゾーン
            
            let cell = timetable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = "現在の時間 : "+formatter.string(from: now as Date)
            cell.textLabel?.font = UIFont(name: "Arial", size: 22)
            
            switch delegate.getday("E") {
            case "月","火","水","木","金":
                cell.textLabel?.textColor = UIColor.black
            case "土","休業中":
                cell.textLabel?.textColor = UIColor.cyan
            default:
                cell.textLabel?.textColor = UIColor.red
            }
            
            return cell
        }
        else{
            let cell = timetable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            let delegate = UIApplication.shared.delegate as! AppDelegate
            cell.textLabel?.text = delegate.table[indexPath.row]
            cell.textLabel?.font = UIFont(name: "Arial", size: 22)

            return cell
        }
    }
    
    @IBAction func selectorValueChanged(_ sender: UISegmentedControl) {
        switch selector.selectedSegmentIndex {
        case 0:
            delegate.destination = "from_jinryo"
            delegate.table = delegate.loadJson("from_jinryo")
            timetable.reloadData()
        default:
            delegate.destination = "from_school"
            delegate.table = delegate.loadJson("from_school")
            timetable.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

