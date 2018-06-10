//
//  BusTools.swift
//  BusAlarm
//
//  Created by 祖父江亮 on 2018/04/09.
//  Copyright © 2018年 Ryo Sobue. All rights reserved.
//

import UIKit
import SwiftyJSON

class BusTools{
    
    var filename:String = ""
    let TTF = TimeToolsFunctions.init()
    
    // MARK: - 次に乗れるバスの配列番号を返す
    func rowofRidableBusTableNumber(_ table:[String]) -> Int{
        //フォーマットの指定
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier:"en_US") as Locale!
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = NSTimeZone(name:"GMT")! as TimeZone
        
        let now:NSDate = TTF.getnow("HH:mm:ss", isString: false) as! NSDate
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
    
    //    MARK: - exceptionDate.jsonを使って普段とは違う曜日のダイヤに切り替える
    final func exceptionDateChecker(_ today:NSDate) -> String{
        let now = TTF.getnow("HH:mm:ss", isString: false) as! NSDate
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        formatter.locale = NSLocale(localeIdentifier:"ja_JP") as Locale!
        
        let path = Bundle.main.path(forResource: "exceptionDate", ofType: "json")
        do{
            let jsonStr = try String(contentsOfFile: path!)
            let json = JSON.init(parseJSON: jsonStr)
            
            for date in json["holiday"] {
                let jsonDate = date.1.rawString()!
                var exceptionDate = formatter.date(from: jsonDate)! as NSDate//jsonからの日付
                exceptionDate = (NSDate(timeInterval: 60*60*9, since: exceptionDate as Date))
                
                if exceptionDate == now{
                    return "holiday"
                }
            }
            for date in json["satuaday"] {
                let jsonDate = date.1.rawString()!
                var exceptionDate = formatter.date(from: jsonDate)! as NSDate//jsonからの日付
                exceptionDate = (NSDate(timeInterval: 60*60*9, since: exceptionDate as Date))
                
                if exceptionDate == now{
                    return "satuaday"
                }
            }
            for date in json["rinzi"] {
                let jsonDate = date.1.rawString()!
                var exceptionDate = formatter.date(from: jsonDate)! as NSDate//jsonからの日付
                exceptionDate = (NSDate(timeInterval: 60*60*9, since: exceptionDate as Date))
                
                if exceptionDate == now{
                    // 臨時を知らせるポップアップが欲しいかも
                    return filename
                }
            }
            for date in json["closed"] {
                let jsonDate = date.1.rawString()!
                var exceptionDate = formatter.date(from: jsonDate)! as NSDate//jsonからの日付
                exceptionDate = (NSDate(timeInterval: 60*60*9, since: exceptionDate as Date))
                
                if exceptionDate == now{
                    // バスなしを知らせるポップアップが欲しいかも
                    return filename
                }
            }
        } catch{
            return filename
        }
        return filename
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
        
        // さらにカレンダーに準拠した例外の日付でfilenameを変更!
        let what_date:NSDate = TTF.getnow("HH:mm:ss", isString: false) as! NSDate
        formatter.dateFormat = "MM/dd"
        filename = exceptionDateChecker(what_date)
        // ----------------------------------
        
        let path = Bundle.main.path(forResource: filename, ofType: "json")
        do{
            let jsonStr = try String(contentsOfFile: path!)
            let json =  JSON.init(parseJSON: jsonStr)
            
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

}
