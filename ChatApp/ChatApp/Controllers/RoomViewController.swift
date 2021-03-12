//
//  RoomViewController.swift
//  ChatApp
//
//  Created by 徳永勇希 on 2021/03/10.
//

import UIKit
import ViewAnimator

class RoomViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var roomNameArray = ["誰でも話そうよ","20代のたまり場","一人ぼっち集合","地球住み集合","好きな","大学生","高校生","中学生","暇な人","A型の人"]
    var roomImageStringArray = ["0","1","2","3","4","5","6","7","8","9"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellSetUp()
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.isHidden = false
        let animation = [AnimationType.vector(CGVector(dx: 0, dy: 30))]
        UIView.animate(views: tableView.visibleCells, animations: animation,completion: nil)
        
    }
    func cellSetUp() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
    }
}
extension RoomViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomCell", for: indexPath)
        
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        imageView.image = UIImage(named: roomImageStringArray[indexPath.row])
        
        let label = cell.contentView.viewWithTag(2) as! UILabel
        label.text = roomNameArray[indexPath.row]

       /* cell.imageView?.image = UIImage(named: roomImageStringArray[indexPath.row])
        cell.imageView?.contentMode = .scaleAspectFill
        cell.textLabel?.text = roomNameArray[indexPath.row]*/
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "roomChat", sender: indexPath.row)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let roomChatVC = segue.destination as! ChatViewController
        roomChatVC.roomName = roomNameArray[sender as! Int]
        
    }
    
}
