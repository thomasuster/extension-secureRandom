#import <Foundation/Foundation.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIKit.h>
#include <hx/CFFI.h>
#import <Security/Security.h>
#include "ExtensionKitIPhone.h"
#import <dispatch/dispatch.h>
namespace secureRandom {

    dispatch_queue_t backgroundQueue = dispatch_queue_create("com.thomasuster.secureRandom", DISPATCH_QUEUE_SERIAL);

    NSMutableDictionary * newSearchDictionary(NSString * identifier) {
      NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];

      [searchDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];

      NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
      [searchDictionary setObject:encodedIdentifier forKey:(id)kSecAttrGeneric];
      [searchDictionary setObject:encodedIdentifier forKey:(id)kSecAttrAccount];
      static NSString *bundleName = nil;

      if (!bundleName) {
          bundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
      }
      [searchDictionary setObject:bundleName forKey:(id)kSecAttrService];

      return searchDictionary;
    }

    int _getSecureRandom32()
    {
        FILE *fp = fopen("/dev/random", "r");

        if (!fp) {
            perror("randgetter");
            exit(-1);
        }

        uint32_t value = 0;
        int i;
        for (i=0; i<sizeof(value); i++) {
            value <<= 8;
            value |= fgetc(fp);
        }

        fclose(fp);

        return (int) value;
    }

    const char* _makeUUID()
    {
        NSUUID *uuid = [NSUUID UUID];
        NSString *uuidString = [uuid UUIDString];
        const char *cString = [uuidString UTF8String];
        return cString;
    }


    // References from https://useyourloaf.com/blog/simple-iphone-keychain-access/
    void _setKeychain(int eventDispatcherId, const char *inKey, const char *value) {
        dispatch_async(backgroundQueue, ^{
          NSLog(@"My value char: %s", value);
          NSString *identifier = [NSString stringWithUTF8String:inKey];
          NSMutableDictionary *dictionary = newSearchDictionary(identifier);

          NSString *stringValue = [NSString stringWithUTF8String:value];
          NSData *valueData = [stringValue dataUsingEncoding:NSUTF8StringEncoding];
          [dictionary setObject:valueData forKey:(id)kSecValueData];
          OSStatus status = SecItemAdd((CFDictionaryRef)dictionary, NULL);

          if(status == errSecSuccess) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                    extensionkit::DispatchEventToHaxeInstance(eventDispatcherId, "com.thomasuster.KeyChainSuccessEvent",
                        extensionkit::CSTRING, "keychain_success_complete",
                        extensionkit::CBOOL, true,
                        extensionkit::CEND);

            });
            return;
          }

          NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
          [updateDictionary setObject:valueData forKey:(id)kSecValueData];
          status = SecItemUpdate((CFDictionaryRef)dictionary,
                                            (CFDictionaryRef)updateDictionary);

          dispatch_sync(dispatch_get_main_queue(), ^{
                    extensionkit::DispatchEventToHaxeInstance(eventDispatcherId, "com.thomasuster.KeyChainSuccessEvent",
                        extensionkit::CSTRING, "keychain_success_complete",
                        extensionkit::CBOOL, status == errSecSuccess,
                        extensionkit::CEND);

          });
        });
    }

    void _getKeychain(int eventDispatcherId, const char *inKey) {
        dispatch_async(backgroundQueue, ^{
            NSString *identifier = [NSString stringWithUTF8String:inKey];
            NSMutableDictionary *searchDictionary = newSearchDictionary(identifier);

            // Add search attributes
            [searchDictionary setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];

            // Add search return types
            [searchDictionary setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];

            NSData *result = nil;
            OSStatus status = SecItemCopyMatching((CFDictionaryRef)searchDictionary,
                                                  (CFTypeRef *)&result);
            if(result) {
                const char *resultString = (const char *)[result bytes];
                dispatch_sync(dispatch_get_main_queue(), ^{
                      extensionkit::DispatchEventToHaxeInstance(eventDispatcherId, "com.thomasuster.KeyChainEvent",
                          extensionkit::CSTRING, "keychain_complete",
                          extensionkit::CSTRING, resultString,
                          extensionkit::CBOOL, status == errSecSuccess,
                          extensionkit::CEND);

                });
            } else {
                const char *resultString = "";
                dispatch_sync(dispatch_get_main_queue(), ^{
                      extensionkit::DispatchEventToHaxeInstance(eventDispatcherId, "com.thomasuster.KeyChainEvent",
                          extensionkit::CSTRING, "keychain_complete",
                          extensionkit::CSTRING, resultString,
                          extensionkit::CBOOL, false,
                          extensionkit::CEND);

                });
            }
        });
    }

    void _removeKeychain(int eventDispatcherId, const char *inKey) {
        dispatch_async(backgroundQueue, ^{
            NSString *identifier = [NSString stringWithUTF8String:inKey];
            NSMutableDictionary *dictionary = newSearchDictionary(identifier);
            OSStatus status = SecItemDelete((CFDictionaryRef)dictionary);
            dispatch_sync(dispatch_get_main_queue(), ^{
                      extensionkit::DispatchEventToHaxeInstance(eventDispatcherId, "com.thomasuster.KeyChainSuccessEvent",
                          extensionkit::CSTRING, "keychain_success_complete",
                          extensionkit::CBOOL, status == errSecSuccess,
                          extensionkit::CEND);

            });
        });
    }




}





