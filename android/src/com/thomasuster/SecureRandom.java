package com.thomasuster;
import org.haxe.extension.Extension;
public class SecureRandom extends Extension {

    public SecureRandom() {}

    public static int getSecureRandom32() {
        java.security.SecureRandom sr = new java.security.SecureRandom();
        byte[] output = new byte[32];
        sr.nextBytes(output);
        return toInt(output);
    }

    public static int toInt(byte[] bytes) {
        int ret = 0;
        for (int i=0; i<4 && i<bytes.length; i++) {
            ret <<= 8;
            ret |= (int)bytes[i] & 0xFF;
        }
        return ret;
    }
}