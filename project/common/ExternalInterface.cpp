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

extern "C" void SecureRandom_main () {

}
DEFINE_ENTRY_POINT (SecureRandom);

extern "C" int secureRandom_register_prims () { return 0; }