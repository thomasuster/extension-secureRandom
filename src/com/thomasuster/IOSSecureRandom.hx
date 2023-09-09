package com.thomasuster;
import cpp.Lib;
class IOSSecureRandom implements SecureRandom {

    static var _getSecureRandom32:Dynamic;
    static var _makeUUID:Dynamic;

    public function new():Void {}

    public function getSecureRandom32():Int {
        init();
        return _getSecureRandom32();
    }

    public function makeUUID():String {
        init();
        return _makeUUID();  
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
    }
}