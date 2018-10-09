//
//  Settings.swift
//  BusAlarm
//
//  Created by 祖父江亮 on 2017/06/02.
//  Copyright © 2017年 Ryo Sobue. All rights reserved.
//

import UIKit

class settings: UITableViewController {
    
    @IBOutlet weak var changeTimeLabel: UILabel!
    let busStatus = BusStatus.shared
    
    override func viewWillAppear(_ animated: Bool) {
        changeTimeLabel.text = busStatus.changeTime
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

    }
    
    override func didReceiveMemoryWarning() {
        
    }

}
