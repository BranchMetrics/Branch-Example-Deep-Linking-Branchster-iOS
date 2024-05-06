//
//  ViewController.swift
//  BranchMonsterFactoryAppClip
//
//  Created by Ernest Cho on 10/8/20.
//  Copyright © 2020 Branch. All rights reserved.
//

import UIKit
import BranchSDK

class ViewController: UIViewController {
    
    let monster = Monster.shared
    
    @IBOutlet weak var name: UILabel?
    @IBOutlet weak var face: UIImageView?
    @IBOutlet weak var body: UIImageView?
    
    @IBOutlet weak var color0: UIButton?
    @IBOutlet weak var color1: UIButton?
    @IBOutlet weak var color2: UIButton?
    @IBOutlet weak var color3: UIButton?
    @IBOutlet weak var color4: UIButton?
    @IBOutlet weak var color5: UIButton?
    @IBOutlet weak var color6: UIButton?
    @IBOutlet weak var color7: UIButton?
    
    lazy var colors: [(button: UIButton, color: UIColor)] = {
        var tmp = [
            (self.color0!, self.monster.colors[0]),
            (self.color1!, self.monster.colors[1]),
            (self.color2!, self.monster.colors[2]),
            (self.color3!, self.monster.colors[3]),
            (self.color4!, self.monster.colors[4]),
            (self.color5!, self.monster.colors[5]),
            (self.color6!, self.monster.colors[6]),
            (self.color7!, self.monster.colors[7])
        ]
        
        return tmp;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.redrawColors()
        
        self.renderMonster()
        self.monster.callback = {
            self.renderMonster()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func colorFor(button: UIButton)->(UIColor) {
        for (b, c) in self.colors {
            if (b.isEqual(button)) {
                return c
            }
        }
        
        // default to black, should not occur
        return UIColor.black
    }
    
    func buttonFor(color: UIColor)->(UIButton?) {
        for (b, c) in self.colors {
            if (c.isEqual(color)) {
                return b
            }
        }
        // default to the first button, should not occur
        return self.color0
    }
    
    func redrawColors() {
        for (button, color) in self.colors {
            self.updateColorButton(button: button, color: color, selected: false)
        }
    }
    
    func updateColorButton(button: UIButton?, color:UIColor?, selected: Bool) {
        button?.backgroundColor = color
        if (selected) {
            button?.layer.borderWidth = 2.0
        } else {
            button?.layer.borderWidth = 0.0
        }
        button?.layer.borderColor = UIColor.black.cgColor
        button?.layer.cornerRadius = (button?.frame.size.width ?? 0)/2
    }
    
    @IBAction func selectColorButton(sender: UIButton) {
        let color = self.colorFor(button: sender)
        self.monster.color = color
        self.renderMonster()
    }
    
    @IBAction func swipeUp(_ gestureRecogniser: UISwipeGestureRecognizer) {
        if (gestureRecogniser.state == .ended) {
            self.monster.prevFace()
            self.renderMonster()
        }
    }
    
    @IBAction func swipeDown(_ gestureRecogniser: UISwipeGestureRecognizer) {
        if (gestureRecogniser.state == .ended) {
            self.monster.nextFace()
            self.renderMonster()
        }
    }
    
    @IBAction func swipeRight(_ gestureRecogniser: UISwipeGestureRecognizer) {
        if (gestureRecogniser.state == .ended) {
            self.monster.nextBody()
            self.renderMonster()
        }
    }
    
    @IBAction func swipeLeft(_ gestureRecogniser: UISwipeGestureRecognizer) {
        if (gestureRecogniser.state == .ended) {
            self.monster.prevBody()
            self.renderMonster()
        }
    }
    
    func renderMonster() {
        if let name = self.name {
            UIView.transition(with: name, duration: 0.5, options: .transitionCrossDissolve, animations: {
                name.text = self.monster.name
            }, completion: nil)
        }
        
        if let face = self.face {
            UIView.transition(with: face, duration: 0.5, options: .transitionCrossDissolve, animations: {
                face.image = self.monster.face
            }, completion: nil)
        }
        
        if let body = self.body {
            UIView.transition(with: body, duration: 0.5, options: .transitionCrossDissolve, animations: {
                body.image = self.monster.body
                body.backgroundColor = self.monster.color
                self.redrawColors()
                
                // don't highlight the color button before data arrives
                if (!self.monster.waitingForData) {
                    self.updateColorButton(button: self.buttonFor(color: self.monster.color), color: self.monster.color, selected: true)
                }
                
            }, completion: nil)
        }
    }

    
    @IBAction func shareMonster() {
        let lp = BranchLinkProperties()
        lp.feature = "monster_sharing"
        lp.channel = "appclip"
        
        let buo = self.monster.shareWithBranch()
        buo.showShareSheet(withShareText: "Share Your Monster!") { (activityType, success, error) in
            if (success) {
                print("should log an event here")
            }
        }
    }
}




