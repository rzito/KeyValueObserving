# Introduction

Responding to changes in a property using key value observing involves the following:

1. Registering for notifications of changes to a kvo-compliant property by calling 
`func addObserver(observer: NSObject, forKeyPath keyPath: String, options: NSKeyValueObservingOptions, context: UnsafeMutablePointer<Void>)`
2. Overriding `func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>)` on an observer, so it can be called when the observed property changes.
3. Unregistering for notifications before the observer is deallocated.

# Summary

KeyValueObserving is an extension on NSObject which aims to make this process easier. 

A proxy object is used to handle the kvo callbacks, and allowing behaviour to 
be defined in a closure provided at registration time.

# Example

```Swift
init { 
  self.addKVO(someObject, keyPath: "someKVOCompliantProperty") { someResponse() } 
}

deinit { 
  self.removeAllKVO() 
}
```

Please see the Examples folder for more examples.

