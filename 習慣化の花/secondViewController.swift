//
//  secondViewController.swift
//  習慣化の花
//
//  Created by 吉永秀和 on 2018/07/16.
//  Copyright © 2018年 吉永秀和. All rights reserved.
//

import UIKit
import RealmSwift
class secondViewController: UIViewController {
    var recieve = Habit()
    var timer: Timer?
    var tDate:String = ""
    var yDate:String = ""
    
    @IBOutlet weak var TitleLabel: UILabel!
    
    @IBOutlet weak var flower: UIImageView!
    @IBOutlet weak var water: UIImageView!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var reset: UIButton!
    @IBOutlet weak var giveWater: UIButton!
    @IBOutlet weak var flowerPosi: NSLayoutConstraint!
    @IBOutlet weak var flowerWidth: NSLayoutConstraint!
    @IBOutlet weak var flowerHeight: NSLayoutConstraint!
    @IBOutlet weak var Uekibachi: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // background image
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "background2.png")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
        TitleLabel.text = recieve.name
        DateLabel.text = "\(recieve.date)日目"
        flower.image = #imageLiteral(resourceName: "flower_seichou1.png")
        reset.isHidden = true
        reset.isEnabled = false
        let calendar = Calendar.current
        let date = Date()
        let day_yesterday = calendar.date(
            byAdding: .day, value: -1, to: calendar.startOfDay(for: date))
        let format = DateFormatter()
        format.dateFormat = "yyyy/MM/dd"
        //日付をStringに変換する
        tDate = format.string(from: date)
        yDate = format.string(from: day_yesterday!)
        print(recieve.date)
        if recieve.date > 6 {
            print(recieve.date)
            flower.image = #imageLiteral(resourceName: "flower_seichou8.png")
            flowerPosi.constant = 140
            flowerWidth.constant = 170
            flowerHeight.constant = 170
            giveWater.isEnabled = false
            giveWater.setTitle("習慣化済み", for: .normal)
            giveWater.isEnabled = false
        } else if recieve.day == tDate || recieve.day == yDate {
            if recieve.did == false {
                giveWater.isEnabled = true
                if recieve.date == 6 {
                    flower.image = #imageLiteral(resourceName: "flower_seichou6.png")
                    flowerPosi.constant = 140
                    flowerWidth.constant = 160
                    flowerHeight.constant = 160
                }
                if recieve.date == 5{
                    flower.image = #imageLiteral(resourceName: "flower_seichou5.png")
                    flowerPosi.constant = 140
                    flowerWidth.constant = 150
                    flowerHeight.constant = 150
                }
                if recieve.date == 4 {
                    flower.image = #imageLiteral(resourceName: "flower_seichou4.png")
                    flowerPosi.constant = 140
                    flowerWidth.constant = 140
                    flowerHeight.constant = 140
                }
                if recieve.date == 3 {
                    flower.image = #imageLiteral(resourceName: "flower_seichou3.png")
                    flowerPosi.constant = 140
                    flowerWidth.constant = 130
                    flowerHeight.constant = 130
                }
                if recieve.date == 2 {
                    flower.image = #imageLiteral(resourceName: "flower_seichou2.png")
                    flowerPosi.constant = 140
                    flowerWidth.constant = 110
                    flowerHeight.constant = 110
                }
            } else if recieve.did == true {
                giveWater.isEnabled = false
                if recieve.date == 6 {
                    flower.image = #imageLiteral(resourceName: "flower_seichou7.png")
                    flowerPosi.constant = 140
                    flowerWidth.constant = 170
                    flowerHeight.constant = 170
                }
                if recieve.date == 5 {
                    flower.image = #imageLiteral(resourceName: "flower_seichou6.png")
                    flowerPosi.constant = 140
                    flowerWidth.constant = 160
                    flowerHeight.constant = 160
                }
                if recieve.date == 4{
                    flower.image = #imageLiteral(resourceName: "flower_seichou5.png")
                    flowerPosi.constant = 140
                    flowerWidth.constant = 150
                    flowerHeight.constant = 150
                }
                if recieve.date == 3 {
                    flower.image = #imageLiteral(resourceName: "flower_seichou4.png")
                    flowerPosi.constant = 140
                    flowerWidth.constant = 140
                    flowerHeight.constant = 140
                }
                if recieve.date == 2 {
                    flower.image = #imageLiteral(resourceName: "flower_seichou3.png")
                    flowerPosi.constant = 140
                    flowerWidth.constant = 130
                    flowerHeight.constant = 130
                }
                if recieve.date == 1 {
                    flower.image = #imageLiteral(resourceName: "flower_seichou2.png")
                    flowerPosi.constant = 140
                    flowerWidth.constant = 110
                    flowerHeight.constant = 110
                }
            }
        } else {
            water.image = #imageLiteral(resourceName: "flower_seichou9.png")
            giveWater.setTitle("やり直す", for: .normal)
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func feed(_ sender: Any) {
        if giveWater.titleLabel?.text != "やり直す" {
            water.image = #imageLiteral(resourceName: "gatag-00009009.png")
            water.isHidden = false
            self.vibrate(amount: 10.0 ,view: self.water)
            self.timer = Timer(timeInterval: 1.8, target: self, selector: #selector(self.timerUpdate), userInfo: nil, repeats: false)
            RunLoop.main.add(self.timer!, forMode: .defaultRunLoopMode)
            // Realmのインスタンスを取得
            let realm = try! Realm()
            try! realm.write {
                realm.create(Habit.self, value: ["id": recieve.id, "date": recieve.date, "day": tDate, "did": true], update: true)
            }
            giveWater.isEnabled = false
        } else {
            // Realmのインスタンスを取得
            let realm = try! Realm()
            try! realm.write {
                recieve.date = 1
                recieve.did = false
                recieve.day = yDate
                // タイトルはそのままで値段のプロパティだけを更新することができます。
            }
            loadView()
            viewDidLoad()
        }
    }
    func vibrate(amount: Float ,view: UIView) {
        if amount > 0 {
            var animation: CABasicAnimation
            animation = CABasicAnimation(keyPath: "transform.rotation")
            animation.duration = 0.3
            animation.fromValue = amount * Float(M_PI) / 180.0
            animation.toValue = 0 - (animation.fromValue as! Float)
            animation.repeatCount = 3.0
            animation.autoreverses = true
            view.layer .add(animation, forKey: "VibrateAnimationKey")
        }
        else {
            view.layer.removeAnimation(forKey: "VibrateAnimationKey")
        }
    }
    @objc func timerUpdate() {
        water.isHidden = true
        if flower.image == #imageLiteral(resourceName: "flower_seichou7.png"){
            flower.image = #imageLiteral(resourceName: "flower_seichou8.png")
            flowerWidth.constant = 200
            flowerHeight.constant = 200
        }
        if flower.image == #imageLiteral(resourceName: "flower_seichou6.png"){
            flower.image = #imageLiteral(resourceName: "flower_seichou7.png")
            flowerWidth.constant = 170
            flowerHeight.constant = 170
        }
        if flower.image == #imageLiteral(resourceName: "flower_seichou5.png"){
            flower.image = #imageLiteral(resourceName: "flower_seichou6.png")
            flowerWidth.constant = 160
            flowerHeight.constant = 160
        }
        if flower.image == #imageLiteral(resourceName: "flower_seichou4.png"){
            flower.image = #imageLiteral(resourceName: "flower_seichou5.png")
            flowerWidth.constant = 150
            flowerHeight.constant = 150
        }
        if flower.image == #imageLiteral(resourceName: "flower_seichou3.png"){
            flower.image = #imageLiteral(resourceName: "flower_seichou4.png")
            flowerWidth.constant = 140
            flowerHeight.constant = 140
        }
        if flower.image == #imageLiteral(resourceName: "flower_seichou2.png"){
            flower.image = #imageLiteral(resourceName: "flower_seichou3.png")
            flowerWidth.constant = 130
            flowerHeight.constant = 130
        }
        if flower.image == #imageLiteral(resourceName: "flower_seichou1.png"){
            flower.image = #imageLiteral(resourceName: "flower_seichou2.png")
            flowerPosi.constant = 140
            flowerWidth.constant = 110
            flowerHeight.constant = 110
        }
    }
    @IBAction func resetAll(_ sender: Any) {
        flower.image = #imageLiteral(resourceName: "flower_seichou1.png")
    }
    @IBAction func back(_ sender: UIButton) {
        let controller = self.presentingViewController as? ViewController
        controller?.loadView()
        controller?.viewDidLoad()
        controller?.TableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
