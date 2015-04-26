//
//  ViewController.swift
//  KeyValueObserving
//
//  Created by Richard Zito on 25/04/2015.
//  Copyright (c) 2015 Richard Zito. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let counter = Counter()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let button = UIButton()
        button.setTitle("Open", forState: .Normal)
        button.sizeToFit()
        button.frame.size.height = 44
        button.addTarget(self, action: "didPressButton:", forControlEvents: .TouchUpInside)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.view.addSubview(button)
        
    }
    
    @objc private func didPressButton(button: UIButton)
    {
        let vc = CountViewController(counter: self.counter)
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
}

