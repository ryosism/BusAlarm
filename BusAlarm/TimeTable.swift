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
    @IBOutlet weak var nowTime: UILabel!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
//        この１文でテーブルビューセルのIDがなくてクラッシュする問題を解消できる
        timetable.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        if delegate.destination == "from_jinryo"{
            navigationBar.title = "神領発"
            selector.selectedSegmentIndex = 0
        }else{
            navigationBar.title = "中部大学発"
            selector.selectedSegmentIndex = 1
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate.table = delegate.loadJson(delegate.destination)

        let scrollIndexpath:IndexPath = IndexPath.init(row: delegate.rowofRidableBusTableNumber(delegate.table), section: 0) as IndexPath
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // 0.5秒後に実行したい処理
            self.timetable.scrollToRow(at: scrollIndexpath as IndexPath, at: .top, animated: true)
        }
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
        
// -----現在の時間を表示するラベル---------------------
        print("return",delegate.rowofRidableBusTableNumber(delegate.table))
        nowTime.text = delegate.getday("現在の時間 : HH:mm:ss")
        nowTime.font = UIFont(name: "Arial", size: 22)

        switch delegate.getday("E") {
        case "月","火","水","木","金":
            nowTime.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        case "土","休業中":
            nowTime.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        default:
            nowTime.backgroundColor = #colorLiteral(red: 1, green: 0.7692273855, blue: 0.8850077987, alpha: 1)
// -----現在の時間を表示するラベル---------------------
        }
    }
    
    func update(){
        timetable.reloadData()
        nowTime.text = delegate.getday("現在の時間 : HH:mm:ss")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return delegate.table.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = timetable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let delegate = UIApplication.shared.delegate as! AppDelegate
        cell.textLabel?.text = delegate.table[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Arial", size: 24)
        
//        if indexPath.row == delegate.rowofRidableBusTableNumber(delegate.table){
//            cell.backgroundColor = #colorLiteral(red: 1, green: 0.9076395035, blue: 0.8201603293, alpha: 1)
//        }
        return cell
    }
    
    func selectorValueChanged(_ sender: UISegmentedControl) {
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
// -----一番近い時間にスクロールする-------------------------
        let scrollIndexpath:IndexPath = IndexPath.init(row: delegate.rowofRidableBusTableNumber(delegate.table), section: 0) as IndexPath
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // 0.5秒後に実行したい処理
            self.timetable.scrollToRow(at: scrollIndexpath as IndexPath, at: .top, animated: true)
        }
// -----一番近い時間にスクロールする-------------------------
        if delegate.destination == "from_jinryo"{
            navigationBar.title = "神領発"
        }else{
            navigationBar.title = "中部大学発"
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

