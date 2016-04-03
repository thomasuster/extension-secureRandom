#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif
#include <hx/CFFI.h>
#include "Utils.h"

using namespace uuid;

value getSecureRandom32() {
    return _getSecureRandom32();
}
DEFINE_PRIM (make,0);

extern "C" void SecureRandom_main () {

}
DEFINE_ENTRY_POINT (SecureRandom);

extern "C" int uuid_register_prims () { return 0; }