//
//  depertureChanger.swift
//  BusAlarm
//
//  Created by 祖父江亮 on 2017/05/24.
//  Copyright © 2017年 Ryo Sobue. All rights reserved.
//

import UIKit

class depertureChanger: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    let busStatus = BusStatus.shared
    
    let time:[String] = ["07:00","08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00"]
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return time.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return time[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        busStatus.changeTime = time[row]
        print(busStatus.changeTime)
        let ud:UserDefaults = UserDefaults.init(suiteName: "group.ryosism.busalarm")!
        ud.set(busStatus.changeTime, forKey: "changeTime")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
