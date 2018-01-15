

import QuartzCore

//installHelper()

let CONFIG_PATH = "/usr/local/etc/butterfly_fixer.plist";

struct Config {
    
    let black_listed: [Int64]
    let timeout: Int
    
    static func CreateConfig() -> Config {
        
    
        
        let myDict = NSDictionary(contentsOfFile: CONFIG_PATH)!
    
        let blacklisted = myDict["blacklisted_keys"]! as! [Int64]
        
        let timeout = (myDict["timeout"]! as! Int)   * 1_000_000
        
        return Config(black_listed: blacklisted, timeout: timeout)
    }
}


struct State {
    var lastTimestamp: CGEventTimestamp? = nil
    var lastEvType: CGEventType? = nil
    
    
}

var state = State()

let config = Config.CreateConfig()

NSLog("started")

NSLog("\(config)")

func callback(proxy: CGEventTapProxy, evType: CGEventType, ev: CGEvent, ref: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {

    
    let keycode = ev.getIntegerValueField(.keyboardEventKeycode)
    #if LOG
        NSLog("ev_type: \(evType == .keyDown ? "keydown" : "keyup"), code: \(keycode)")
    #endif
    let origEv = Unmanaged.passUnretained(ev)
    
    if !config.black_listed.contains(keycode) {
        return origEv
    }
    
    guard let lastEvT = state.lastEvType else {
        state.lastEvType = evType
        return origEv
    }
    state.lastEvType = evType
    
    guard lastEvT == .keyUp && evType == .keyDown else {
        return origEv
    }
    
    guard let lastT = state.lastTimestamp else {
        state.lastTimestamp = ev.timestamp
        return origEv
    }
    state.lastTimestamp = ev.timestamp

    let diff = (ev.timestamp - lastT)
    
    if (diff < config.timeout) {
        NSLog("blocked")        
        return nil
    }
    
    return origEv
}

let EVENTS = CGEventMask(1<<CGEventType.keyDown.rawValue | 1<<CGEventType.keyUp.rawValue)


let tap = CGEvent.tapCreate(tap: .cgSessionEventTap, place: .tailAppendEventTap, options: .defaultTap, eventsOfInterest: EVENTS, callback: callback, userInfo: nil
    )!

let source = CFMachPortCreateRunLoopSource(nil, tap, 0)!


CFRunLoopAddSource(CFRunLoopGetCurrent()!, source, CFRunLoopMode.commonModes)
CFRunLoopRun()

