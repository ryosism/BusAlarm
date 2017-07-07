//
//  PurcherViewController.swift
//  BusAlarm
//
//  Created by 祖父江亮 on 2017/07/07.
//  Copyright © 2017年 Ryo Sobue. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class PurcherViewController: UIViewController {
    
    @IBOutlet weak var previewGifView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
       
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        let gifurl = URL(string: Bundle.main.path(forResource: "previewgif", ofType: "gif")!)
//        let req = URLRequest(url:gifurl!)

        let gifImage = UIImage.gif(name: "previewgif")
        previewGifView.image = gifImage
    }
    
    override func didReceiveMemoryWarning() {
        
    }
}
