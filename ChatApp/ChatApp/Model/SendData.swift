//
//  SendData.swift
//  ChatApp
//
//  Created by 徳永勇希 on 2021/03/06.
//

import Foundation
import FirebaseStorage

protocol SendUserImageOkDelegate {
    func sendUserImage(url:String)
    
}
class SendData {
    
    var delegate:SendUserImageOkDelegate?
    
    func sendUserImageData(data:Data) {
        let image = UIImage(data: data)
        guard let userImage = image?.jpegData(compressionQuality: 0.1) else { return }
        let imageRef = Storage.storage().reference().child("userImage").child(UUID().uuidString)
        imageRef.putData(userImage, metadata: nil) { (metadata, error) in
            if error != nil{
                print("error")
                return
            }
            imageRef.downloadURL { (url, error) in
                if error != nil{
                    print("error")
                }
                UserDefaults.standard.setValue(url?.absoluteString, forKey: "userImage")
                self.delegate?.sendUserImage(url:url!.absoluteString)
            }
        }
    }
}
