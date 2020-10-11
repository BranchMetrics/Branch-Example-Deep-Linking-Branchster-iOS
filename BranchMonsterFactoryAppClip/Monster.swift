//
//  Monster.swift
//  BranchMonsterFactoryAppClip
//
//  Created by Ernest Cho on 10/9/20.
//  Copyright © 2020 Branch. All rights reserved.
//

import UIKit

// ViewModel
class Monster: NSObject {
    
    static let shared = Monster()
    
    let faces = [
        UIImage(named: "face0.png"),
        UIImage(named: "face1.png"),
        UIImage(named: "face2.png"),
        UIImage(named: "face3.png"),
        UIImage(named: "face4.png")
    ]
    
    let bodies = [
        UIImage(named: "0body.png"),
        UIImage(named: "1body.png"),
        UIImage(named: "2body.png"),
        UIImage(named: "3body.png"),
        UIImage(named: "4body.png")
    ]
    
    let colors = [
        UIColor(red:0.141, green:0.643, blue:0.8666, alpha:1),
        UIColor(red:0.925, green:0.384, blue:0.4745, alpha:1),
        UIColor(red:0.161, green:0.706, blue:0.443,alpha:1),
        UIColor(red:0.965, green:0.6, blue:0.220, alpha:1),
        UIColor(red:0.518, green:0.149, blue:0.545, alpha:1),
        UIColor(red:0.141, green:0.792, blue:0.855, alpha:1),
        UIColor(red:0.996, green:0.835, blue:0.129, alpha:1),
        UIColor(red:0.620, green:0.086, blue:0.137, alpha:1)
    ]
    
    var callback: () -> () = {
        print("default monster callback")
    }
    
    var name : String
    var face : UIImage
    var body : UIImage
    var color : UIColor
    var text : String
    
    override init() {
        name = "Monster Incoming!"
        face = UIImage(named: "defaultface")!
        body = bodies[0]!
        color = UIColor.white
        text = ""
    }
    
    func update(name: String, text: String, face: Int, body: Int, color: Int) {
        self.name = name
        self.text = text
        
        if face < faces.count {
            self.face = faces[face]!
        }
        
        if body < bodies.count {
            self.body = bodies[body]!
        }
        
        if color < colors.count {
            self.color = colors[color]
        }
        
        self.callback()
    }
}
