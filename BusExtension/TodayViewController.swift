//
//  TodayViewController.swift
//  BusExtension
//
//  Created by 祖父江亮 on 2017/06/08.
//  Copyright © 2017年 Ryo Sobue. All rights reserved.
//

import UIKit
import NotificationCenter
import SwiftyJSON

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var depertureLabel: UILabel!
    
    @IBOutlet weak var icon1: UIImageView!
    @IBOutlet weak var icon2: UIImageView!
    @IBOutlet weak var icon3: UIImageView!
    @IBOutlet weak var icon4: UIImageView!
    @IBOutlet weak var icon5: UIImageView!
    
    var destination:String = "from_jinryo"
    let ud:UserDefaults = UserDefaults.init(suiteName: "group.ryosism.busalarm")!
    let formatter = DateFormatter()
    var changeTime:NSDate = NSDate(timeIntervalSinceReferenceDate: 43200)
    
    let tTF = timeToolsFunctions.init()
    let busTools = BusTools.init()
    
    override func viewWillAppear(_ animated: Bool) {
        
        let table:[String] = ud.object(forKey: "loadJson") as! [String]
        let index:Int = ud.integer(forKey: "rowof")
        
        formatter.locale = NSLocale(localeIdentifier:"en_US") as Locale!
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = NSTimeZone(name:"GMT")! as TimeZone
        
        //現在時刻、TYOで取得
        let current:NSDate = (NSDate(timeInterval: 60*60*9, since: NSDate() as Date))
        let currentString:String = formatter.string(from: current as Date)
        let now:NSDate = formatter.date(from: currentString)! as NSDate
        
        //      ここのchangeTimeはuserDefaultに入ってるデータを使う
        if ud.string(forKey: "changeTime") != nil{
            let changeTime:NSDate = formatter.date(from: ud.string(forKey: "changeTime")!)! as NSDate
            
            let compare:ComparisonResult = now.compare(changeTime as Date)
            if compare == .orderedAscending{
                destination = "from_jinryo"
                print("destination",destination)
            }else{
                destination = "from_school"
                print("destination",destination)
            }
        }
        
        let depertureTime:String = table[index]
        print("depertureTime",depertureTime)
        
        if depertureTime.contains(":") {
            depertureLabel.adjustsFontSizeToFitWidth = true
            if destination == "from_jinryo"{
                depertureLabel.text = "神領発 発車まで"
            }else{
                depertureLabel.text = "中部大学発 発車まで"
            }

            let now = tTF.getnow("HH:mm:ss", isString: false)
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
            
            countDownLabel.isHidden = false
            
            switch span {
            case 3600...2560000:
                countDownLabel.text = "\(hour)時間 \(minute)分 \(second)秒後"
                countDownLabel.font = UIFont.boldSystemFont(ofSize: 22)
                countDownLabel.adjustsFontSizeToFitWidth = true
            case 0...3599:
                countDownLabel.text = "\(minute)分 \(second)秒後"
                countDownLabel.font = UIFont.boldSystemFont(ofSize: 30)
                countDownLabel.adjustsFontSizeToFitWidth = true
            case -3599 ... -1:
                countDownLabel.text = "\(-1*minute)分 \(-1*second)秒前"
                countDownLabel.font = UIFont.boldSystemFont(ofSize: 30)
                countDownLabel.textColor = UIColor.gray
                countDownLabel.adjustsFontSizeToFitWidth = true
            case -2560000 ... -3600:
                countDownLabel.text = "\(-1*hour)時間 \(-1*minute)分 \(-1*second)秒前"
                countDownLabel.font = UIFont.boldSystemFont(ofSize: 22)
                countDownLabel.textColor = UIColor.gray
                countDownLabel.adjustsFontSizeToFitWidth = true
            default:
                break
            }
            
            print("span",span)
            
            //バスアイコンの設定
            if destination == "from_jinryo"{
                icon5.image = UIImage(named:"bluebus.png")
                icon1.image = UIImage(named:"school.png")
                icon2.image = UIImage(named:"blue.png")
                icon3.image = UIImage(named:"blue.png")
                icon4.image = UIImage(named:"blue.png")
                switch span%4 {
                case 3:
                    icon3.isHidden = true
                    icon2.isHidden = true
                    icon4.isHidden = true
                case 2:
                    icon4.isHidden = false
                    icon3.isHidden = true
                    icon2.isHidden = true
                case 1:
                    icon3.isHidden = false
                    icon2.isHidden = true
                    icon4.isHidden = true
                default:
                    icon2.isHidden = false
                    icon3.isHidden = true
                    icon4.isHidden = true
                }
            }else{
                let trans = CGAffineTransform(scaleX: -1, y: 1)
                icon1.image = UIImage(named:"redbus.png")
                icon1.transform = trans
                icon5.image = UIImage(named:"train.png")
                icon2.image = UIImage(named:"red.png")
                icon3.image = UIImage(named:"red.png")
                icon4.image = UIImage(named:"red.png")
                icon2.transform = trans
                icon3.transform = trans
                icon4.transform = trans
                switch span%4 {
                case 1:
                    icon3.isHidden = true
                    icon2.isHidden = true
                    icon4.isHidden = true
                case 2:
                    icon4.isHidden = false
                    icon3.isHidden = true
                    icon2.isHidden = true
                case 3:
                    icon3.isHidden = false
                    icon2.isHidden = true
                    icon4.isHidden = true
                default:
                    icon2.isHidden = false
                    icon3.isHidden = true
                    icon4.isHidden = true
                }

            }
            
        }else{ //約3~5分間隔で運行の表示なら
            if destination == "from_jinryo"{
                depertureLabel.text = "神領発"
            }else{
                depertureLabel.text = "中部大学発"
            }
            countDownLabel.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TodayViewController.update), userInfo: nil, repeats: true)
    }
    func update(){
        viewWillAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        let ud:UserDefaults = UserDefaults.init(suiteName: "group.ryosism.busalarm")!
        ud.set(busTools.loadJson(destination), forKey: "loadJson")
        ud.set(busTools.rowofRidableBusTableNumber(ud.object(forKey: "loadJson") as! [String]), forKey: "rowof")
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
