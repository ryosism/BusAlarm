//
//  PurcherViewController.swift
//  BusAlarm
//
//  Created by 祖父江亮 on 2017/07/07.
//  Copyright © 2017年 Ryo Sobue. All rights reserved.
//

import UIKit

class PurcherViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
       
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let gifurl = URL(string: Bundle.main.path(forResource: "previewgif", ofType: "gif")!)
        let req = URLRequest(url:gifurl!)

    }
    
    override func didReceiveMemoryWarning() {
        
    }
}
