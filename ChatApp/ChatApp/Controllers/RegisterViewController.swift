//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by 徳永勇希 on 2021/03/06.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var sendData = SendData()
    var urlString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendData.delegate = self
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        //カメラの許可画面表示
        let checkPerMission = CheckPerMission()
        checkPerMission.showCheckPerMission()
        
    }
    
    @IBAction func newRegisterButton(_ sender: Any) {
        guard let email = emailTextField.text,let password = passwordTextField.text,let image = userImageView.image else { return }
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil{
               print("error")
            }
            guard let data = image.jpegData(compressionQuality: 0.1) else { return }
            self.sendData.sendUserImageData(data:data)
        }
    }
    
    @IBAction func tapImageView(_ sender: Any) {
        showAlert()
    }
    func doCamera(){
        
        let source:UIImagePickerController.SourceType = .photoLibrary
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = source
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    func doAlbum(){
        
        let source:UIImagePickerController.SourceType = .photoLibrary
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = source
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
}
extension RegisterViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if info[.originalImage] as? UIImage != nil{
            let selectedImage = info[.originalImage] as? UIImage
            userImageView.image = selectedImage
            picker.dismiss(animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func showAlert() {
        let alertController = UIAlertController(title: "選択", message: "どちらを使用しますか？", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "カメラ", style: .default, handler: { (alert) in
            self.doCamera()
        }))
        alertController.addAction(UIAlertAction(title: "アルバム", style: .default, handler: { (alert) in
            self.doAlbum()
        }))
        alertController.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: { (alert) in
            
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}
extension RegisterViewController:UITextFieldDelegate{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
    }
    
}
extension RegisterViewController:SendUserImageOkDelegate{
    func sendUserImage(url: String) {
        urlString = url
        if urlString.isEmpty != true{
            
            performSegue(withIdentifier: "chat", sender: nil)
        }
    }
}
