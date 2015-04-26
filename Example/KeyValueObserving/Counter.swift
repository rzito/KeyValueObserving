//
//  MyClass.swift
//  KeyValueObserving
//
//  Created by Richard Zito on 25/04/2015.
//  Copyright (c) 2015 Richard Zito. All rights reserved.
//

import Foundation


class Counter : NSObject
{
    dynamic var count: Int
    
    override init()
    {
        self.count = 0
        
        super.init()
        
        self.tick()
        
    }
    
    private func tick()
    {
        self.count++

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Float(NSEC_PER_SEC) * 0.5)), dispatch_get_main_queue(), { [weak self] in
            self?.tick()
        })
    }
    
}