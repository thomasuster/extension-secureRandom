## NME extension for Android & iOS secure random Ints

[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE.md)

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