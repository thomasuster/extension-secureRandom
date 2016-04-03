package com.thomasuster;
import cpp.Lib;
class IOSSecureRandom implements SecureRandom {

    static var _getSecureRandom32:Dynamic;

    public function new():Void {}

    public function getSecureRandom32():Int {
        init();
        return _getSecureRandom32();
    }

    public function init():Void {
        if(_getSecureRandom32 == null) {
            #if ios
            _getSecureRandom32 = Lib.load("secureRandom","getSecureRandom32",0);
            #end
        }
    }
}