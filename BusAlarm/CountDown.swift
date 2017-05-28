//
//  CountDown.swift
//  BusAlarm
//
//  Created by 祖父江亮 on 2017/05/27.
//  Copyright © 2017年 Ryo Sobue. All rights reserved.
//

import UIKit

class CountDown: UIViewController{
    
//    ボタン定義------------------------
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contDownLabel: UILabel!
    
    @IBOutlet weak var nextTrain: UIButton!
    @IBAction func nextPushed(_ sender: Any) {
    }
    @IBOutlet weak var prevTrain: UIButton!
    @IBAction func prevPushed(_ sender: Any) {
    }
    @IBOutlet weak var changeDeperture: UIButton!
    @IBAction func changeDeperturePushed(_ sender: Any) {
    }
//    ボタン定義------------------------
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        
        let table:[String] = delegate.loadJson(delegate.destination)
        switch delegate.filename {
        case "weekday":
            dateLabel.text = delegate.getday("M月dd日(E) 平日ダイヤ")
        case "satuaday":
            dateLabel.text = delegate.getday("M月dd日(E) 土曜・休業中ダイヤ")
        case "holiday":
            dateLabel.text = delegate.getday("M月dd日(E) 休日ダイヤ")
        default:
            dateLabel.text = delegate.getday("M月dd日(E)")
        }
        
        let depertureTime:String = table[delegate.rowofRidableBusTableNumber(table)]
        if delegate.destination == "from_jinryo"{
            timeLabel.text = "神領発 ,\(depertureTime)発車"
        }else{
            timeLabel.text = "中部大学発 ,\(depertureTime)発車"
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
