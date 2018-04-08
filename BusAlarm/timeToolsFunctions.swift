//
//  timeToolsFunctions.swift
//  BusAlarm
//
//  Created by 祖父江亮 on 2018/04/08.
//  Copyright © 2018年 Ryo Sobue. All rights reserved.
//

import UIKit

class timeToolsFunctions{
    func getnow(_ format:String, isString:Bool) -> Any{
//            typeで返す型を決める
//            0:NSDate
//            1:String
        
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier:"en_US") as Locale!

        formatter.dateFormat = format
        let stringNow = formatter.string(from: date as Date)
        
        if isString {
            return stringNow
        }else{
            formatter.timeZone = NSTimeZone(name:"GMT")! as TimeZone
            let nsdateNow:NSDate = formatter.date(from: stringNow)! as NSDate
            
            return nsdateNow
        }
    }
}
