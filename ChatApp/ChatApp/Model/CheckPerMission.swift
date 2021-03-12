//
//  CheckPerMission.swift
//  ChatApp
//
//  Created by 徳永勇希 on 2021/03/06.
//

import Foundation
import Photos
class CheckPerMission {
    func showCheckPerMission() {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            
            case .notDetermined:
                print("notDetermined")
            case .restricted:
                print("restricted")
            case .denied:
                print("拒否")
            case .authorized:
                print("許可されています")
            case .limited:
                print("limited")
            @unknown default: break
                
            }
        }
    }
}
