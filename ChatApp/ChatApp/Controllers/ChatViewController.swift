//
//  ChatViewController.swift
//  ChatApp
//
//  Created by 徳永勇希 on 2021/03/09.
//

import UIKit
import Firebase
import SDWebImage

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    let db = Firestore.firestore()
    var roomName = String()
    var imageString = String()
    
    var messages:[Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cell()
        guard let image = UserDefaults.standard.object(forKey: "userImage") else { return }
        
        imageString = image as! String
        
        if roomName == "" {
            roomName = "All"
        }
        self.navigationItem.title = roomName
        loadMessages(roomName: roomName)
        
    }
    func cell() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
    func loadMessages(roomName:String) {
        db.collection(roomName).order(by: "date").addSnapshotListener { (snapshot, error) in
            self.messages = []
            if error != nil{
                print("error")
            }
            if let snapShot = snapshot?.documents{
                for dog in snapShot {
                    let data = dog.data()
                    guard let sender = data["sender"] as? String,let body = data["body"] as? String,let imageString = data["imageString"] as? String  else { return }
                    let newMessage = Message(sender: sender, body: body, imageString: imageString)
                    self.messages.append(newMessage)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                        
                    }
                }
            }
        }
    }
    
    @IBAction func sendButton(_ sender: Any) {
        
        guard let messageBody = messageTextField.text,let sender = Auth.auth().currentUser?.email else { return }
        db.collection(roomName).addDocument(data: ["sender":sender,"body":messageBody,"imageString":imageString,"date":Date().timeIntervalSince1970]) { (error) in
            if error != nil{
                print("error")
                return
            }
            
            DispatchQueue.main.async {
                self.messageTextField.text = ""
                self.messageTextField.resignFirstResponder()
            }
        }
        
    }
}
extension ChatViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MessageCell
        let message = messages[indexPath.row]
        cell.label.text = message.body
        cell.leftImageView.layer.setNeedsLayout()
        cell.rightImageView.layer.setNeedsLayout()
        cell.backView.layer.setNeedsLayout()
        cell.leftImageView.layer.layoutIfNeeded()
        cell.rightImageView.layer.layoutIfNeeded()
        cell.backView.layer.layoutIfNeeded()
        if message.sender == Auth.auth().currentUser?.email{
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.rightImageView.sd_setImage(with: URL(string: imageString), completed: nil)
            cell.leftImageView.sd_setImage(with: URL(string:messages[indexPath.row].imageString), completed: nil)
            cell.backgroundView?.backgroundColor = .systemTeal
            cell.label.textColor = .white
        }else{
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.rightImageView.sd_setImage(with: URL(string: imageString), completed: nil)
            cell.leftImageView.sd_setImage(with: URL(string:messages[indexPath.row].imageString), completed: nil)
            cell.backgroundView?.backgroundColor = .orange
            cell.label.textColor = .white
            
            
        }
        
        return cell
        
    }
}
