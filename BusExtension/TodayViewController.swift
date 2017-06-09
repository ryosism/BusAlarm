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
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TodayViewController.update), userInfo: nil, repeats: true)
        
    }
    
    func update(){
        viewWillAppear(true)
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
