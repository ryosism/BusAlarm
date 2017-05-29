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
// ----------------------------------------------------
        let now = delegate.getnow()
        //フォーマットの指定
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier:"en_US") as Locale!
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = NSTimeZone(name:"GMT")! as TimeZone
        let gettime:NSDate = formatter.date(from: depertureTime)! as NSDate
        
        let span:Int = Int(gettime.timeIntervalSince(now as Date))
        let hour:Int = Int(floor(Double(span/3600)))
        let minute:Int = (span-hour*3600)/60
        let second:Int = span-(hour*3600)-(minute*60)
        
        print(span)
        
        if span >= 3600{
            contDownLabel.text = "\(hour)時間 \(minute)分 \(second)秒"
            contDownLabel.font = UIFont.boldSystemFont(ofSize: 22)
        }else{
            contDownLabel.text = "\(minute)分 \(second)秒"
            contDownLabel.font = UIFont.boldSystemFont(ofSize: 37)
        }
        
        
        
// ----------------------------------------------------
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
    }
    
    func update(){
        viewWillAppear(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
