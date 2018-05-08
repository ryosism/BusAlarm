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
    
    let okAction = UIAlertAction(title: "OK", style: .default) { action in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yen240.layer.borderWidth = 2.0 // 枠線の幅
        yen240.layer.borderColor = UIColor.init(colorLiteralRed: 0.1, green: 0.6, blue: 1.0, alpha: 1).cgColor // 枠線の色
        yen240.layer.cornerRadius = 10.0 // 角丸のサイズ
        
        restoreButton.layer.borderWidth = 2.0 // 枠線の幅
        restoreButton.layer.borderColor = UIColor.init(colorLiteralRed: 0.1, green: 0.6, blue: 1.0, alpha: 1).cgColor // 枠線の色
        restoreButton.layer.cornerRadius = 10.0 // 角丸のサイズ

    }
    
    override func didReceiveMemoryWarning() {
        
    }

    @IBAction func yen240Pushed(_ sender: Any) {
        print("240yen")
        let purchaseAlert: UIAlertController = UIAlertController(title: "購入処理が完了しました", message: "ありがとうございます！", preferredStyle: .alert)
        purchaseAlert.addAction(okAction)
        present(purchaseAlert, animated: true, completion: nil)
    }
    @IBAction func restoreButtonPushed(_ sender: Any) {
        print("restore")
        let restoreAlert: UIAlertController = UIAlertController(title: "購入情報を復元しました", message: "ありがとうございます！", preferredStyle: .alert)
        restoreAlert.addAction(okAction)
        present(restoreAlert, animated: true, completion: nil)
    }
}
