//
//  ViewController.swift
//  LZGesture-Swift
//
//  Created by Artron_LQQ on 2016/10/26.
//  Copyright © 2016年 Artup. All rights reserved.
//

import UIKit

class ViewController: UIViewController, LZCircleViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let lock = LZCircleView.init()
//        lock.delegate = self
//        lock.backgroundColor = UIColor.blue
//        self.view.addSubview(lock)
    }

    @IBAction func show(_ sender: AnyObject) {
        let gesture = LZGestureViewController()
        
        gesture.showIn(viewController: self, style: .Screen)
    }
    @IBAction func verity(_ sender: AnyObject) {
        let gesture = LZGestureViewController()
        
        gesture.showIn(viewController: self, style: .Verity)
    }
    @IBAction func update(_ sender: AnyObject) {
        let gesture = LZGestureViewController()
        
        gesture.showIn(viewController: self, style: .Update)
    }
    
    @IBAction func setting(_ sender: AnyObject) {
        
        let gesture = LZGestureViewController()
        
        gesture.showIn(viewController: self, style: .Setting)
        
    }
    func circleView(_ view: LZCircleView, firstConnect result: String) {
        
        print(result)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

