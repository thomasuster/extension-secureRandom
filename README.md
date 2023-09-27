## NME extension for Android & iOS secure random Ints

[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE.md)

```bash
git clone https://github.com/jiveui/extensionkit
haxelib dev extensionkit extensionkit
git clone https://github.com/thomasuster/extension-secureRandom
haxelib dev extension-secureRandom extension-secureRandom
```

```xml
<project>
    ...
    <haxelib name="extensionkit" />
    <haxelib name="extension-secureRandom" />
    ...
<project/>
```
```haxe
var sr:SecureRandom;
#if android
sr = new AndroidSecureRandom();
#else
sr = new IOSSecureRandom();
#end

var value:Int = sr.getSecureRandom32();
```
