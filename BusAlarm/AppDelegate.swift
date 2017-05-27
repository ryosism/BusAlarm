//
//  AppDelegate.swift
//  BusAlarm
//
//  Created by 祖父江亮 on 2017/05/20.
//  Copyright © 2017年 Ryo Sobue. All rights reserved.
//

import UIKit
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var table:[String] = [""]
    var destination:String = "from_jinryo"
    var changeTime:String = "12:00"
    
    func loadJson(_ which_destination:String) -> [String] {
        
        let date = NSDate()
        let formatter = DateFormatter()
        
        //ロケールを設定する。
        formatter.locale = NSLocale(localeIdentifier:"ja_JP") as Locale!
        //フォーマットを設定する。
        formatter.dateFormat = "E" //指定フォーマットだけど曜日だけしか指定しない
        let what_day:String = formatter.string(from: date as Date) //曜日が漢字１文字で入る
        
        var filename:String = ""
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
    
    func getday(_ format:String) -> String!{
        let date = NSDate()
        let formatter = DateFormatter()
        
        //ロケールを設定する。
        formatter.locale = NSLocale(localeIdentifier:"ja_JP") as Locale!
        //フォーマットを設定する。
        formatter.dateFormat = format //指定フォーマット
        return formatter.string(from: date as Date) //指定フォーマットの時刻がStringで帰ってくる
    }
    
    func rowofRidableBusTableNumber(_ table:[String]) -> Int{
        //フォーマットの指定
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier:"en_US") as Locale!
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = NSTimeZone(name:"GMT")! as TimeZone
        
        //現在時刻、TYOで取得
        let current:NSDate = (NSDate(timeInterval: 60*60*9, since: NSDate() as Date))
        let currentString:String = formatter.string(from: current as Date)
        let now:NSDate = formatter.date(from: currentString)! as NSDate
        
        for (row, time) in table.enumerated(){ //emunerated()はfor文と同時に通し番号を発行する、今回の配列番号を返す関数にぴったり
            
            if time.contains(":"){
                let gettime:NSDate = formatter.date(from: time)! as NSDate
//                print("gettime = ",gettime)
//                print("now     = ",now)
                
                let compare:ComparisonResult = now.compare(gettime as Date)
                if compare == .orderedAscending{
                    print("now < gettime , row = ",row)
                    return row
                    
                }
            }
        }
        return -1
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        ここにchangeTime以降か以前かで出発先を変えるスクリプト書きたいなぁ･･･
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier:"en_US") as Locale!
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = NSTimeZone(name:"GMT")! as TimeZone
        
        //現在時刻、TYOで取得
        let current:NSDate = (NSDate(timeInterval: 60*60*9, since: NSDate() as Date))
        let currentString:String = formatter.string(from: current as Date)
        let now:NSDate = formatter.date(from: currentString)! as NSDate
        let changeTime:NSDate = formatter.date(from: self.changeTime)! as NSDate
        
        let compare:ComparisonResult = now.compare(changeTime as Date)
        if compare == .orderedAscending{
            destination = "from_jinryo"
        }else{
            destination = "from_school"
        }
    
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
      
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
       
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
       
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
       
    }

    func applicationWillTerminate(_ application: UIApplication) {

    }


}

