//
//  purcherAction.swift
//  BusAlarm
//
//  Created by Sobue on 2017/07/08.
//  Copyright © 2017年 Ryo Sobue. All rights reserved.
//

import UIKit

class PurcherAction: UITableViewController {

    @IBOutlet weak var yen240: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        
    }

    @IBAction func yen240Pushed(_ sender: Any) {
        print("240yen")
    }
    @IBAction func restoreButtonPushed(_ sender: Any) {
        print("restore")
    }

}
