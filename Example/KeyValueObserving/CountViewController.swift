//
//  CountViewController.swift
//  KeyValueObserving
//
//  Created by Richard Zito on 25/04/2015.
//  Copyright (c) 2015 Richard Zito. All rights reserved.
//

import UIKit

class CountViewController: UIViewController
{
    
    let counter: Counter
    var counterLabel: UILabel?
    var observer: NSObject?
    
    init(counter: Counter)
    {
        self.counter = counter
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let counterLabel = UILabel()
        counterLabel.font = UIFont.systemFontOfSize(40)
        counterLabel.frame = self.view.bounds
        self.view.addSubview(counterLabel)
        
        let button = UIButton()
        button.setTitle("Close", forState: .Normal)
        button.sizeToFit()
        button.frame.size.height = 44
        button.addTarget(self, action: "didPressButton:", forControlEvents: .TouchUpInside)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.view.addSubview(button)
        
        self.counterLabel = counterLabel
        
        self.updateForCount()
        
        self.observer = self.addKVO(self.counter, keyPath: "count") { [unowned self] counter in
            self.updateForCount()
        }
    }
    
    private func updateForCount()
    {
        self.counterLabel?.text = "\(counter.count)"
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.updateForCount()
    }
    
    deinit
    {
        self.removeAllKVO()
        self.removeKVO(self.observer)
    }

    @objc private func didPressButton(button: UIButton)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
