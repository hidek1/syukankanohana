//
//  ViewController.swift
//  習慣化の花
//
//  Created by 吉永秀和 on 2018/07/11.
//  Copyright © 2018年 吉永秀和. All rights reserved.
//

import UIKit
import RealmSwift
class Habit: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var date = 1
    @objc dynamic var did = false
    @objc dynamic var day = ""
    // idをプライマリキーに設定
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
 {
    var habits:Results<Habit>?
    var send = Habit()
    var tDate:String = ""
    var yDate:String = ""
    var maxId: Int { return try! Realm().objects(Habit.self).sorted(byKeyPath: "id").last?.id ?? 0 }
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var TextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // background image
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "background.png")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
        // Do any additional setup after loading the view, typically from a nib.
        let calendar = Calendar.current
        let date = Date()
        let day_yesterday = calendar.date(
            byAdding: .day, value: -1, to: calendar.startOfDay(for: date))
        let format = DateFormatter()
        format.dateFormat = "yyyy/MM/dd"
        //日付をStringに変換する
        tDate = format.string(from: date)
        yDate = format.string(from: day_yesterday!)
        // Realmのインスタンスを取得
        let realm = try! Realm()
                // 全てのデータを削除
//                try! realm.write() {
//                    realm.deleteAll()
//                }
        // Realmに保存されてるDog型のオブジェクトを全て取得
        habits = realm.objects(Habit.self)
    }
    
    @IBAction func MakeHabit(_ sender: Any) {
        guard let Text = TextField.text, !Text.isEmpty else { return }
        //Realmのインスタンス取得
        do {
            let realm = try Realm()
            let habit = Habit() //Habitモデルのオブジェクトを取得
            habit.id = maxId + 1
            habit.name = Text
            habit.date = 1
            habit.did = false
            habit.day = yDate
            try! realm.write {
                realm.add(habit)
                print("成功だよ", habit)
                send = habit
            }
        } catch {
            print("エラーだよ")
        }
    self.performSegue(withIdentifier: "toSecond", sender: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "SampleCell")
        cell.backgroundColor = .clear
        // セルに表示する値を設定する
        cell.textLabel!.text = "\(habits![indexPath.row].name)"
        if habits![indexPath.row].day == yDate && habits![indexPath.row].did == true{
            // Realmのインスタンスを取得
            let realm = try! Realm()
            try! realm.write {
                habits![indexPath.row].date += 1
                habits![indexPath.row].did = false
            }
        }
        cell.detailTextLabel?.text = "\(habits![indexPath.row].date)日目"
        cell.detailTextLabel?.textColor = UIColor.black
        if habits![indexPath.row].did == false {
            cell.textLabel!.textColor = UIColor.red
            cell.detailTextLabel!.textColor = UIColor.red
        }
        if habits![indexPath.row].date > 6{
            cell.textLabel!.textColor = UIColor.green
            cell.detailTextLabel!.textColor = UIColor.green
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        send = habits![indexPath.row]
        self.performSegue(withIdentifier: "toSecond", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSecond" {
            
            let secondViewController:secondViewController = segue.destination as! secondViewController
            
            // 変数:遷移先ViewController型 = segue.destinationViewController as 遷移先ViewController型
            // segue.destinationViewController は遷移先のViewController
            
            secondViewController.recieve = self.send
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

