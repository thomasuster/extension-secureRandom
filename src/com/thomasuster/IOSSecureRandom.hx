package com.thomasuster;
import cpp.Lib;
class IOSSecureRandom implements SecureRandom {

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

    public function setKeychain(key:String, value:String):Bool {
        init();
        return _setKeychain(key, value);
    }

    public function getKeychain(key:String):String {
        init();
        return _getKeychain(key);
    }

    public function removeKeychain(key:String):Bool {
        init();
        return _removeKeychain(key);
    }

    public function init():Void {
        if(_getSecureRandom32 == null) {
            #if ios
            _getSecureRandom32 = Lib.load("secureRandom","getSecureRandom32",0);
            #end
        }
        if(_makeUUID == null) {
            #if ios
            _makeUUID = Lib.load("secureRandom","makeUUID",0);
            #end
        }
        if(_setKeychain == null) {
            #if ios
            _setKeychain = Lib.load("secureRandom","setKeychain",2);
            #end
        }
        if(_getKeychain == null) {
            #if ios
            _getKeychain = Lib.load("secureRandom","getKeychain",1);
            #end
        }
        if(_removeKeychain == null) {
            #if ios
            _removeKeychain = Lib.load("secureRandom","removeKeychain",1);
            #end
        }
    }
}