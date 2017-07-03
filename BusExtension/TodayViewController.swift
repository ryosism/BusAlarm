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
    
    override func viewWillAppear(_ animated: Bool) {
        
        let table:[String] = ud.object(forKey: "loadJson") as! [String]
        let index:Int = ud.integer(forKey: "rowof")
        print("index",index)
        
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
                depertureLabel.text = "神領発"
            }else{
                depertureLabel.text = "中部大学発"
            }

            let now = getnow()
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
            
            countDownLabel.isHidden = false
            
            switch span {
            case 3600...2560000:
                countDownLabel.text = "\(hour)時間 \(minute)分 \(second)秒後"
                countDownLabel.font = UIFont.boldSystemFont(ofSize: 32)
                countDownLabel.adjustsFontSizeToFitWidth = true
            case 0...3599:
                countDownLabel.text = "\(minute)分 \(second)秒後"
                countDownLabel.font = UIFont.boldSystemFont(ofSize: 40)
                countDownLabel.adjustsFontSizeToFitWidth = true
            case -3599 ... -1:
                countDownLabel.text = "\(-1*minute)分 \(-1*second)秒前"
                countDownLabel.font = UIFont.boldSystemFont(ofSize: 40)
                countDownLabel.textColor = UIColor.gray
                countDownLabel.adjustsFontSizeToFitWidth = true
            case -2560000 ... -3600:
                countDownLabel.text = "\(-1*hour)時間 \(-1*minute)分 \(-1*second)秒前"
                countDownLabel.font = UIFont.boldSystemFont(ofSize: 32)
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
    
    //    MARK: - 曜日判定をしてjsonを読み込む、１次元配列にしてTimeTable.swiftで活用
    func loadJson(_ which_destination:String) -> [String] {
        
        var filename:String = ""
        let date = NSDate()
        let formatter = DateFormatter()
        
        //ロケールを設定する。
        formatter.locale = NSLocale(localeIdentifier:"ja_JP") as Locale!
        //フォーマットを設定する。
        formatter.dateFormat = "E" //指定フォーマットだけど曜日だけしか指定しない
        let what_day:String = formatter.string(from: date as Date) //曜日が漢字１文字で入る
        switch what_day {
        case "月","火","水","木","金":
            filename = "weekday"
        case "土","休業中":
            filename = "satuaday"
        default:
            filename = "holiday"
        }
        
        let path = Bundle.main.path(forResource: filename, ofType: "json")
        do{
            let jsonStr = try String(contentsOfFile: path!)
            let json =  JSON.parse(jsonStr)
            
            switch which_destination {
            case "from_jinryo":
                print("loadJson",json["from_jinryo"].arrayValue.map({$0.stringValue}))
                return json["from_jinryo"].arrayValue.map({$0.stringValue})
            default:
                print("loadJson",json["from_school"].arrayValue.map({$0.stringValue}))
                return json["from_school"].arrayValue.map({$0.stringValue})
            }
            
        } catch{
            return ["nil"]
        }
    }
    
    //    MARK: - 今の時間を指定フォーマットにしてString型で返す
    func getday(_ format:String) -> String!{
        let date = NSDate()
        let formatter = DateFormatter()
        
        //ロケールを設定する。
        formatter.locale = NSLocale(localeIdentifier:"ja_JP") as Locale!
        //フォーマットを設定する。
        formatter.dateFormat = format //指定フォーマット
        return formatter.string(from: date as Date)
    }
    //    MARK: - 今の時間をNSDate形式で返す
    func getnow() -> NSDate{
        //フォーマットの指定
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier:"en_US") as Locale!
        formatter.dateFormat = "HH:mm:ss"
        formatter.timeZone = NSTimeZone(name:"GMT")! as TimeZone
        
        //現在時刻、TYOで取得
        let current:NSDate = (NSDate(timeInterval: 60*60*9, since: NSDate() as Date))
        let currentString:String = formatter.string(from: current as Date)
        let now:NSDate = formatter.date(from: currentString)! as NSDate
        
        return now as NSDate
    }
    
    // MARK: - 次に乗れるバスの配列番号を返す
    func rowofRidableBusTableNumber(_ table:[String]) -> Int{
        
        //フォーマットの指定
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier:"en_US") as Locale!
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = NSTimeZone(name:"GMT")! as TimeZone
        
        let now:NSDate = getnow()
        for (row, time) in table.enumerated(){ //emunerated()はfor文と同時に通し番号を発行する、今回の配列番号を返す関数にぴったり
            
            if time.contains(":"){
                let gettime:NSDate = formatter.date(from: time)! as NSDate
                print("row",row,"now",now,"gettime",gettime)
                let compare:ComparisonResult = now.compare(gettime as Date)
                if compare == .orderedAscending{
                    
                    if row != 0 && table[row-1].contains("約"){
                        return row-1
                    }
                    return row
                }
            }
        }
        return table.count-1
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
        ud.set(loadJson(destination), forKey: "loadJson")
        ud.set(rowofRidableBusTableNumber(ud.object(forKey: "loadJson") as! [String]), forKey: "rowof")
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
