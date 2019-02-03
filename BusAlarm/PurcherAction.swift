//
//  purcherAction.swift
//  BusAlarm
//
//  Created by Sobue on 2017/07/08.
//  Copyright © 2017年 Ryo Sobue. All rights reserved.
//

import UIKit
import StoreKit

class PurcherAction: UITableViewController {

    @IBOutlet weak var yen240: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    
    let okAction = UIAlertAction(title: "OK", style: .default) { action in }
    let cancelAction = UIAlertAction(title: "キャンセル", style: .default) { action in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(donePurchase), name: NSNotification.Name(rawValue: "donePurchase"), object: nil)
    
        yen240.layer.borderWidth = 2.0 // 枠線の幅
        yen240.layer.borderColor = UIColor.init(colorLiteralRed: 0.1, green: 0.6, blue: 1.0, alpha: 1).cgColor // 枠線の色
        yen240.layer.cornerRadius = 10.0 // 角丸のサイズ
        
        restoreButton.layer.borderWidth = 2.0 // 枠線の幅
        restoreButton.layer.borderColor = UIColor.init(colorLiteralRed: 0.1, green: 0.6, blue: 1.0, alpha: 1).cgColor // 枠線の色
        restoreButton.layer.cornerRadius = 10.0 // 角丸のサイズ
        
    }

    @IBAction func yen240Pushed(_ sender: Any) {
        let purchaseConfirmAlert: UIAlertController = UIAlertController(
                title: "購入の確認",
                message: "ウィジェット機能を¥240で購入しますか？\n\nテスト用のため請求はされません",
                preferredStyle: .alert)
        purchaseConfirmAlert.addAction(cancelAction)
        purchaseConfirmAlert.addAction(purchaseAction)
        present(purchaseConfirmAlert, animated: true, completion: nil)
    }

    let purchaseAction = UIAlertAction(title: "購入", style: .default) { action in
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "donePurchase"), object: nil)
    }
    
    @objc final func donePurchase(){
        print("done")
        let purchaseDoneAlert: UIAlertController = UIAlertController(
            title: "購入処理が完了しました",
            message: "ありがとうございます！",
            preferredStyle: .alert)
        purchaseDoneAlert.addAction(okAction)
        present(purchaseDoneAlert, animated: true, completion: nil)
    }
    
    @IBAction func restoreButtonPushed(_ sender: Any) {

    }
    
    final func doneRestore(){
        let restoreAlert: UIAlertController = UIAlertController(
                title: "購入情報を復元しました",
                message: "ありがとうございます！",
                preferredStyle: .alert)
        restoreAlert.addAction(okAction)
        present(restoreAlert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
    }
}
