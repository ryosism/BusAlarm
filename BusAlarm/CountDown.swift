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
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var 発車まで残り: UILabel!
    
    @IBOutlet weak var nextTrain: UIButton!

    @IBOutlet weak var prevTrain: UIButton!

    @IBOutlet weak var changeDeperture: UIButton!

//    ボタン定義------------------------
    
    let busStatus = BusStatus.shared
    let busTools = BusTools.init()
    let TTF = TimeToolsFunctions.init()
    var nextPrevCount:Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        
        let table:[String] = busTools.loadJson(busStatus.destination)
        
        switch busStatus.filename {
        case "weekday":
            dateLabel.text = TTF.getnow("M月dd日(E) 平日ダイヤ", isString: true) as? String
        case "satuaday":
            dateLabel.text = TTF.getnow("M月dd日(E) 土曜・休業中ダイヤ", isString: true) as? String
        case "holiday":
            dateLabel.text = TTF.getnow("M月dd日(E) 休日ダイヤ", isString: true) as? String
        default:
            dateLabel.text = TTF.getnow("M月dd日(E)", isString: true) as? String
        }
        if busStatus.trueBusSchedule == "rinzi"{
            dateLabel.text = TTF.getnow("M月dd日(E) 臨時バスダイヤ", isString: true) as? String
        }
        if busStatus.trueBusSchedule == "closed"{
            dateLabel.text = TTF.getnow("M月dd日(E) バス休業中", isString: true) as? String
        }
        
        let index:Int = busTools.rowofRidableBusTableNumber(table) + nextPrevCount
        print("index",index)
        print("table.cont",table.count)
        if index == 0{
            prevTrain.isEnabled = false
            nextTrain.isEnabled = true
        }else if index == table.count-1{
            nextTrain.isEnabled = false
            prevTrain.isEnabled = true
        }else{
            prevTrain.isEnabled = true
            nextTrain.isEnabled = true
        }

        let depertureTime:String = table[index]
        print("depertureTime",depertureTime)
        
        if depertureTime.contains(":") {
            if busStatus.destination == "from_jinryo"{
                timeLabel.text = "神領発 ,\(depertureTime)発車"
            }else{
                timeLabel.text = "中部大学発 ,\(depertureTime)発車"
            }
            // ----------------------------------------------------
            let TTF = TimeToolsFunctions.init()
            let now = TTF.getnow("HH:mm:ss", isString: false)
            //フォーマットの指定
            let formatter = DateFormatter()
            formatter.locale = NSLocale(localeIdentifier:"en_US") as Locale!
            formatter.dateFormat = "HH:mm"
            formatter.timeZone = NSTimeZone(name:"GMT")! as TimeZone
            let gettime:NSDate = formatter.date(from: depertureTime)! as NSDate
            
            let span:Int = Int(gettime.timeIntervalSince(now as! Date))
            let hour:Int = Int(floor(Double(span/3600)))
            let minute:Int = (span-hour*3600)/60
            let second:Int = span-(hour*3600)-(minute*60)
            
            print("span",span)
            発車まで残り.font = UIFont.boldSystemFont(ofSize: 25)

            countDownLabel.isHidden = false
            
            switch span {
            case 3600...2560000:
                発車まで残り.text = "発車まで残り"
                countDownLabel.text = "\(hour)時間 \(minute)分 \(second)秒後"
                countDownLabel.font = UIFont.boldSystemFont(ofSize: 32)
                countDownLabel.textColor = UIColor.black
            case 0...3599:
                発車まで残り.text = "発車まで残り"
                countDownLabel.text = "\(minute)分 \(second)秒後"
                countDownLabel.font = UIFont.boldSystemFont(ofSize: 40)
                countDownLabel.textColor = UIColor.black
            case -3599 ... -1:
                発車まで残り.text = "発車済み"
                countDownLabel.text = "\(-1*minute)分 \(-1*second)秒前"
                countDownLabel.font = UIFont.boldSystemFont(ofSize: 40)
                countDownLabel.textColor = UIColor.gray
            case -2560000 ... -3600:
                発車まで残り.text = "発車済み"
                countDownLabel.text = "\(-1*hour)時間 \(-1*minute)分 \(-1*second)秒前"
                countDownLabel.font = UIFont.boldSystemFont(ofSize: 32)
                countDownLabel.textColor = UIColor.gray
            default:
                break
            }
        }else{ //約3~5分間隔で運行の表示なら
            if busStatus.destination == "from_jinryo"{
                timeLabel.text = "神領発"
            }else{
                timeLabel.text = "中部大学発"
            }
            発車まで残り.text = depertureTime
            発車まで残り.font = UIFont.boldSystemFont(ofSize: 30)
            countDownLabel.isHidden = true
        }
        
        if busStatus.trueBusSchedule == "rinzi" || busStatus.trueBusSchedule == "closed"{
            発車まで残り.isHidden = true
            countDownLabel.isHidden = true
            timeLabel.isHidden = true
            nextTrain.isEnabled = false
            prevTrain.isEnabled = false
            changeDeperture.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
    }
    
    func update(){
        viewWillAppear(true)
    }
    
    @IBAction func nextPushed(_ sender: Any) {
        nextPrevCount += 1
        viewWillAppear(true)
        
    }
    @IBAction func prevPushed(_ sender: Any) {
        nextPrevCount -= 1
        viewWillAppear(true)
    }
    
    @IBAction func changeDeperturePushed(_ sender: Any) {
        nextPrevCount = 0
        if busStatus.destination == "from_jinryo"{
            busStatus.destination = "from_school"
        }else{
            busStatus.destination = "from_jinryo"
        }
        viewWillAppear(true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
