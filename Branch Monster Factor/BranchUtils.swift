//
//  BranchUtils.swift
//  Branch Monster Factory
//
//  Created by Robert Gioia on 11/5/25.
//

import BranchSDK

let baseImageURL = "https://rob-gioia-branch.github.io/"
let imageURLSuffix = ".png"

func createQRCode(
    completion: @escaping (UIImage?) -> Void, monsterColor: String,
    monsterLevel: Int, selectedMonsterName: String
) {
    let qrCode = BranchQRCode()

    switch monsterColor {
    case "green":
        qrCode.codeColor = UIColor.green
        break
    case "red":
        qrCode.codeColor = UIColor.red
        break
    case "blue":
        qrCode.codeColor = UIColor.blue
        break
    case "yellow":
        qrCode.codeColor = UIColor.yellow
        break
    case "purple":
        qrCode.codeColor = UIColor.purple
        break
    case "white":
        qrCode.codeColor = UIColor.white
        break
    case "black":
        break
    case "pink":
        qrCode.codeColor = UIColor.systemPink
        break
    case "orange":
        qrCode.codeColor = UIColor.orange
        break
    default:
        break
    }
    qrCode.backgroundColor = UIColor.white
    qrCode.width = 1024
    qrCode.margin = 1
    qrCode.imageFormat = .PNG
    qrCode.centerLogo = baseImageURL + selectedMonsterName + imageURLSuffix

    let buo = BranchUniversalObject(
        canonicalIdentifier: "\(monsterColor)/\(monsterLevel)")
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
