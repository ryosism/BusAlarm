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
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let busTools = BusTools.init()
    let tTF = timeToolsFunctions.init()
    
    override func viewWillAppear(_ animated: Bool) {
//        この１文でテーブルビューセルのIDがなくてクラッシュする問題を解消できる
        timetable.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        if delegate.destination == "from_jinryo"{
            selector.selectedSegmentIndex = 0
        }else{
            selector.selectedSegmentIndex = 1
        }
        
        SetnavigationBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate.table = busTools.loadJson(delegate.destination)

        let scrollIndexpath:IndexPath = IndexPath.init(row: busTools.rowofRidableBusTableNumber(delegate.table), section: 0) as IndexPath
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // 0.5秒後に実行したい処理
            self.timetable.scrollToRow(at: scrollIndexpath as IndexPath, at: .top, animated: true)
        }
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
    }
    
    func update(){
        timetable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return delegate.table.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = timetable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let delegate = UIApplication.shared.delegate as! AppDelegate
        cell.textLabel?.text = delegate.table[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Arial", size: 24)
    
        return cell
    }
    
    func selectorValueChanged(_ sender: UISegmentedControl) {
        switch selector.selectedSegmentIndex {
        case 0:
            delegate.destination = "from_jinryo"
            delegate.table = busTools.loadJson("from_jinryo")
            timetable.reloadData()
        default:
            delegate.destination = "from_school"
            delegate.table = busTools.loadJson("from_school")
            timetable.reloadData()
        }
// -----一番近い時間にスクロールする-------------------------
        let scrollIndexpath:IndexPath = IndexPath.init(row: busTools.rowofRidableBusTableNumber(delegate.table), section: 0) as IndexPath
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // 0.5秒後に実行したい処理
            self.timetable.scrollToRow(at: scrollIndexpath as IndexPath, at: .top, animated: true)
        }
        SetnavigationBar()
    }
    
    final func SetnavigationBar(){
        var text = ""
        if delegate.destination == "from_jinryo"{
            text = "神領発"
        }else{
            text = "中部大学発"
        }
        
        switch tTF.getnow("E", isString: true) as! String {
        case "月","火","水","木","金":
            text = text + "(平日ダイヤ)"
        case "土","休業中":
            text = text + "(土曜・休業中ダイヤ)"
        default:
            text = text + "(休日ダイヤ)"
        }
        navigationBar.title = text
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

