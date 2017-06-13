//
//  TodayViewController.swift
//  BusExtension
//
//  Created by 祖父江亮 on 2017/06/08.
//  Copyright © 2017年 Ryo Sobue. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var busIcon: UIImageView!
    @IBOutlet weak var depretureLabel: UILabel!
    @IBOutlet weak var countDownLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        
        let index:Int = rowofRidableBusTableNumber(table)
        
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
                return json["from_jinryo"].arrayValue.map({$0.stringValue})
            default:
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
                let compare:ComparisonResult = now.compare(gettime as Date)
                if compare == .orderedAscending{
                    
                    if row != 0 && table[row-1].contains("約"){
                        return row-1
                    }
                    return row
                }
            }
        }
        return 0
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
