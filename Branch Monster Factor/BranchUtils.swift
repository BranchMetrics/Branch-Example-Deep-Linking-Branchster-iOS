//
//  BranchUtils.swift
//  Branch Monster Factory
//
//  Created by Robert Gioia on 11/5/25.
//

import BranchSDK

func createQRCode(completion: @escaping (UIImage?) -> Void, monsterColor: String, monsterLevel: Int) {
    let qrCode = BranchQRCode()
    qrCode.codeColor = UIColor.black
    qrCode.backgroundColor = UIColor.white
    qrCode.width = 1024
    qrCode.margin = 1
    qrCode.imageFormat = .PNG
    
    let buo = BranchUniversalObject(canonicalIdentifier: "\(monsterColor)/\(monsterLevel)")
    let lp = BranchLinkProperties()
    
    qrCode.getAsImage(buo, linkProperties: lp) { qrCodeImage, error in
        if let error = error {
            print("Error creating QR code: \(error.localizedDescription)")
            completion(nil)
            return
        }
        completion(qrCodeImage)
    }
}
