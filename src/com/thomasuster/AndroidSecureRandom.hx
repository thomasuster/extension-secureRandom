package com.thomasuster;

#if android
import openfl.utils.JNI;
#end

class AndroidSecureRandom implements SecureRandom {

    static var _getSecureRandom32:Dynamic;

    public function new():Void {}

    public function getSecureRandom32():Int {
        init();
        return _getSecureRandom32();
    }

    function init():Void {
        if(_getSecureRandom32 == null) {
            #if android
            _getSecureRandom32 = JNI.createStaticMethod("com/thomasuster/SecureRandom", "getSecureRandom32", "()I");
            #end
        }
    }
}