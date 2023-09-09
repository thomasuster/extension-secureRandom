package com.thomasuster;

#if android
import openfl.utils.JNI;
#end

class AndroidSecureRandom implements SecureRandom {

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

    function init():Void {
        if(_getSecureRandom32 == null) {
            #if android
            _getSecureRandom32 = JNI.createStaticMethod("com/thomasuster/secureRandom/SecureRandom", "getSecureRandom32", "()I");
            #end
        }
        if(_makeUUID == null) {
            #if android
            _makeUUID = JNI.createStaticMethod("com/thomasuster/secureRandom/SecureRandom", "makeUUID", "()Ljava/lang/String;");
            #end
        }
    }
}