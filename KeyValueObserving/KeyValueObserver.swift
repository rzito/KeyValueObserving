//
//  KeyValueObserver.swift
//  KeyValueObserving
//
//  Created by Richard Zito on 25/04/2015.
//  Copyright (c) 2015 Richard Zito. All rights reserved.
//

import Foundation

// Proxy does the observing, and callback forwarding. Can't be generic itself, as needs to override objc KVO method. Uses generic init instead.
private class KeyValueObserverProxy : NSObject {

    var context = 0
    let callback: (NSObject) -> Void
    let keyPath: String
    weak var source: NSObject!
    
    init<T : NSObject>(source: T, keyPath: String, callback: (T) -> Void)
    {
        self.callback = { source in
            callback(source as! T)
        }
        self.source = source
        self.keyPath = keyPath
        super.init()
        // TODO: allow options to be set.
        source.addObserver(self, forKeyPath: keyPath, options: .allZeros, context: &self.context)
    }
    
    deinit
    {
        self.source.removeObserver(self, forKeyPath: self.keyPath, context: &self.context)
    }
    
    @objc override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>)
    {
        if context == &self.context
        {
            // TODO: pass change dict back too, in some form
            self.callback(object as! NSObject)
        }
    }
    
}

// observer register, keyed first by observer, then by proxy (for fast deletion)
private var proxiesByObserver: [UnsafePointer<Void>:[UnsafePointer<Void>:AnyObject]] = [:]

extension NSObject
{

    private var kvoKey: UnsafePointer<Void>
    {
        return unsafeAddressOf(self)
    }
    
    func addKVO<T:NSObject>(source: T, keyPath: String, callback: (T) -> Void) -> NSObject
    {
        
        let proxy = KeyValueObserverProxy(source: source, keyPath: keyPath, callback: callback)
        if var proxies = proxiesByObserver[self.kvoKey]
        {
            proxies[proxy.kvoKey] = proxy
            proxiesByObserver[self.kvoKey] = proxies
        }
        else
        {
            proxiesByObserver[self.kvoKey] = [proxy.kvoKey : proxy]
        }
        return proxy
    }
    
    func removeKVO(proxy: NSObject?)
    {
        if let proxy = proxy
        {
            if var proxies = proxiesByObserver[self.kvoKey]
            {
                proxies.removeValueForKey(proxy.kvoKey)
                proxiesByObserver[self.kvoKey] = proxies
            }
        }
        
    }
    
    func removeAllKVO()
    {
        proxiesByObserver.removeValueForKey(self.kvoKey)
    }
    
}