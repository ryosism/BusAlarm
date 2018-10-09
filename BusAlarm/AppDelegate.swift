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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let ud:UserDefaults = UserDefaults.init(suiteName: "group.ryosism.busalarm")!
        ud.set(destination, forKey: "destination")
        
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier:"en_US") as Locale!
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = NSTimeZone(name:"GMT")! as TimeZone
        
        //MARK:- 現在時刻、TYOで取得
        let current:NSDate = (NSDate(timeInterval: 60*60*9, since: NSDate() as Date))
        let currentString:String = formatter.string(from: current as Date)
        let now:NSDate = formatter.date(from: currentString)! as NSDate
        //ここのchangeTimeはuserDefaultに入ってるデータを使う
        if ud.string(forKey: "changeTime") != nil{
            let changeTime:NSDate = formatter.date(from: ud.string(forKey: "changeTime")!)! as NSDate
            
            let compare:ComparisonResult = now.compare(changeTime as Date)
            if compare == .orderedAscending{
                destination = "from_jinryo"
                print("from_jinryo")
            }else{
                destination = "from_school"
                print("from_school")
            }
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

// singleton
class BusStatus {
    private init() {}
    static let shared = BusStatus()
    
    var filename:String = ""
    var table:[String] = [""]
    var destination:String = "from_jinryo"
    var changeTime:String = "12:00"
}

