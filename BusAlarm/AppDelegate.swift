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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let what_day:String = getday("E")
        print(what_day)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

