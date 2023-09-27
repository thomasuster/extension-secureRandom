package com.thomasuster;
import cpp.Lib;
import nme.events.EventDispatcher;
import nme.events.Event;
import extensionkit.ExtensionKit;
class KeyChainEvent extends Event {
    public static inline var COMPLETE = "keychain_complete";

    public var value(default, null): String;
    public var success(default, null): Bool;

    public function new(type: String, value: String, success: Bool) {
        this.value = value;
        this.success = success;
        super(type, true, true);
    }
}

class KeyChainEventDispatcher extends EventDispatcher {
    public dynamic function onEnd( data : String, success: Bool ):Void {}

    public var eventDispatcherId(default, null):Int = 0;

    public function new() {
        super();
        this.eventDispatcherId = ExtensionKit.RegisterEventDispatcher(this);
        addEventListener(KeyChainEvent.COMPLETE, function(e: Dynamic) {
            onEnd(e.value, e.success);
        });
    }
}

class KeyChainSuccessEvent extends Event {
    public static inline var COMPLETE = "keychain_success_complete";

    public var success(default, null): Bool;

    public function new(type: String, success: Bool) {
        this.success = success;
        super(type, true, true);
    }
}

class KeyChainSuccessEventDispatcher extends EventDispatcher {
    public dynamic function onEnd( success: Bool ):Void {}

    public var eventDispatcherId(default, null):Int = 0;

    public function new() {
        super();
        this.eventDispatcherId = ExtensionKit.RegisterEventDispatcher(this);
        addEventListener(KeyChainSuccessEvent.COMPLETE, function(e: Dynamic) {
            onEnd(e.success);
        });
    }
}

class IOSSecureRandom implements SecureRandom {

    static var initialized:Bool = false;
    static var _getSecureRandom32:Dynamic;
    static var _makeUUID:Dynamic;
    static var _setKeychain:Dynamic;
    static var _getKeychain:Dynamic;
    static var _removeKeychain:Dynamic;

    public function new():Void {}

    public function getSecureRandom32():Int {
        init();
        return _getSecureRandom32();
    }

    public function makeUUID():String {
        init();
        return _makeUUID();  
    }

    public function setKeychain(key:String, value:String, onEnd: Bool -> Void):Void {
        init();
        var d = new KeyChainSuccessEventDispatcher();
        d.onEnd = onEnd;
        _setKeychain(d.eventDispatcherId, key, value);
    }

    public function getKeychain(key:String, onEnd: String -> Bool -> Void):Void {
        init();
        var d = new KeyChainEventDispatcher();
        d.onEnd = onEnd;
        _getKeychain(d.eventDispatcherId, key);
    }

    public function removeKeychain(key:String, onEnd: Bool -> Void):Void {
        init();
        var d = new KeyChainSuccessEventDispatcher();
        d.onEnd = onEnd;
        _removeKeychain(d.eventDispatcherId, key);
    }

    public function init():Void {
        if(initialized)
            return;
        initialized = true;
        #if ios
        _getSecureRandom32 = Lib.load("secureRandom","getSecureRandom32",0);
        _makeUUID = Lib.load("secureRandom","makeUUID",0);
        _setKeychain = Lib.load("secureRandom","setKeychain",3);
        _getKeychain = Lib.load("secureRandom","getKeychain",2);
        _removeKeychain = Lib.load("secureRandom","removeKeychain",2);
        #end
        ExtensionKit.Initialize();
    }
}