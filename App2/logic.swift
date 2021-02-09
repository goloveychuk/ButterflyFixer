import QuartzCore

struct Config {
    
    let timeout: Int
    
    static func CreateConfig() -> Config {
        
//        let myDict = NSDictionary(contentsOfFile: CONFIG_PATH)!
        
        // let blacklisted = Set(myDict["blacklisted_keys"]! as! [Int64])
        
        let timeout = (100)   * 1_000_000
        
        return Config(timeout: timeout)
    }
}



let config = Config.CreateConfig()

//NSLog("started")
//
//NSLog("\(config)")

public func checkAccess(checkPrompt: Bool) -> Bool{
    //get the value for accesibility
    let checkOptPrompt = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString
    //set the options: false means it wont ask
    //true means it will popup and ask
    let options = [checkOptPrompt: checkPrompt]
    //translate into boolean value
    let accessEnabled = AXIsProcessTrustedWithOptions(options as CFDictionary?)
    return accessEnabled
}

class State {
    var lastTimestamp: CGEventTimestamp = 0
    var lastEvType: CGEventType = .keyUp
    let key: String
    init(key: String) {
        self.key = key
    }
}


func shouldBlock(state: State, evType: CGEventType, ev: CGEvent)->Bool {
    let lastEvT = state.lastEvType
    state.lastEvType = evType
    
    guard lastEvT == .keyUp && evType == .keyDown else {
        return false
    }
    
    let lastT = state.lastTimestamp
    
    state.lastTimestamp = ev.timestamp
    
    let diff = (ev.timestamp - lastT)
    
    if (diff < config.timeout) {
        return true
    }
    
    return false
}

var states = Dictionary(uniqueKeysWithValues:
    ALL_KEYS_MAPPING.map { (key, value) -> (Int64, State) in (Int64(key), State(key: value)) })


func callback(proxy: CGEventTapProxy, evType: CGEventType, ev: CGEvent, ref: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    
    
    let keycode = ev.getIntegerValueField(.keyboardEventKeycode)
    
    
    guard let state = states[keycode] else {
        return Unmanaged.passUnretained(ev)
    }

//    #if DEBUG
//        NSLog("ev_type: \(evType == .keyDown ? "keydown" : "keyup"), key: \(state.key)")
//    #endif
    
    if shouldBlock(state: state, evType: evType, ev: ev){
        NSLog("blocked")
        return nil
    } else {
        return Unmanaged.passUnretained(ev)
    }

}


let CONFIG_PATH = "/usr/local/etc/butterfly_fixer.plist";


func writeLog(_ log: String) {
    print(log)
}


func grant() {
    if (!checkAccess(checkPrompt: true)) {
        print("granting access")
        sleep(20)
        if (!checkAccess(checkPrompt: false)) {
            print("access granting failed")
            exit(1)
        } else {
            print("access granted")
        }
    } else {
        print("already have access")
    }
}

func startInterceptor() {
    
    


        let EVENTS = CGEventMask(1<<CGEventType.keyDown.rawValue | 1<<CGEventType.keyUp.rawValue)


        let _tap = CGEvent.tapCreate(tap: .cgSessionEventTap, place: .tailAppendEventTap, options: .defaultTap, eventsOfInterest: EVENTS, callback: callback, userInfo: nil
        )

        guard let tap = _tap else {
            print("dont have access to create tap")
            grant()
            exit(1)
        }
//
        let source = CFMachPortCreateRunLoopSource(nil, tap, 0)!
//
//
        CFRunLoopAddSource(CFRunLoopGetCurrent()!, source, CFRunLoopMode.commonModes)
        CFRunLoopRun()

        writeLog("Started!")
}
