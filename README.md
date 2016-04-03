# secureRandom

NME extension for Android & iOS secure random bytes

```
haxelib dev extension-secureRandom extension-secureRandom
```

```
var sr:SecureRandom;
#if android
sr = new AndroidSecureRandom();
#else
sr = new IOSSecureRandom();
#end

var value:Int = sr.getSecureRandom32();
```