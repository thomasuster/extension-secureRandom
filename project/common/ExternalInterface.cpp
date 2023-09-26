#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif
#include <hx/CFFI.h>
#include "Utils.h"

using namespace secureRandom;

value getSecureRandom32() {
    int returnValue = _getSecureRandom32();
    return alloc_int(returnValue);
}
DEFINE_PRIM (getSecureRandom32,0);

value makeUUID() {
    const char * returnValue = _makeUUID();
    return alloc_string(returnValue);
}
DEFINE_PRIM (makeUUID,0);

value setKeychain(value key, value v) {
    bool returnValue = _setKeychain(val_string(key), val_string(v));
    return alloc_bool(returnValue);
}
DEFINE_PRIM (setKeychain,2);

value getKeychain(value key) {
    const char * returnValue = _getKeychain(val_string(key));
    return alloc_string(returnValue);
}
DEFINE_PRIM (getKeychain,1);

value removeKeychain(value key) {
    bool returnValue = _removeKeychain(val_string(key));
    return alloc_bool(returnValue);
}
DEFINE_PRIM (removeKeychain,1);

extern "C" void SecureRandom_main () {

}
DEFINE_ENTRY_POINT (SecureRandom);

extern "C" int secureRandom_register_prims () { return 0; }