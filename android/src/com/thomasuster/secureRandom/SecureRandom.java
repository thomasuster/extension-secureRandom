package com.thomasuster.secureRandom;

import org.haxe.extension.Extension;
public class SecureRandom extends Extension {

    public SecureRandom() {}

    public static int getSecureRandom32() {
        java.security.SecureRandom sr = new java.security.SecureRandom();
        byte[] output = new byte[4];
        sr.nextBytes(output);
        return output[0];
    }
}