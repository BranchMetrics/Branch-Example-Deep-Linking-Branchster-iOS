//
//  ViewController.swift
//  BranchMonsterFactoryAppClip
//
//  Created by Ernest Cho on 10/8/20.
//  Copyright © 2020 Branch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let monster = Monster.shared
    
    @IBOutlet weak var name: UILabel?
    @IBOutlet weak var face: UIImageView?
    @IBOutlet weak var body: UIImageView?
    @IBOutlet weak var text: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.updateMonster()
        self.monster.callback = {
            self.updateMonster()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func updateMonster() {
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
            }, completion: nil)
        }

        if let text = self.text {
            UIView.transition(with: text, duration: 0.5, options: .transitionCrossDissolve, animations: {
                text.text = self.monster.text
            }, completion: nil)
        }
    }
}

