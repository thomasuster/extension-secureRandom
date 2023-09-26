#import <Foundation/Foundation.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIKit.h>
#include <hx/CFFI.h>
#import <Security/Security.h>
namespace secureRandom {

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
    bool _setKeychain(const char *inKey, const char *value) {
          NSLog(@"My value char: %s", value);
          NSString *identifier = [NSString stringWithUTF8String:inKey];
          NSMutableDictionary *dictionary = newSearchDictionary(identifier);

          NSString *stringValue = [NSString stringWithUTF8String:value];
          NSData *valueData = [stringValue dataUsingEncoding:NSUTF8StringEncoding];
          [dictionary setObject:valueData forKey:(id)kSecValueData];
          OSStatus status = SecItemAdd((CFDictionaryRef)dictionary, NULL);
          if(status == errSecSuccess) {
            return true;
          }

          NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
          [updateDictionary setObject:valueData forKey:(id)kSecValueData];
          status = SecItemUpdate((CFDictionaryRef)dictionary,
                                            (CFDictionaryRef)updateDictionary);
          return status == errSecSuccess;
    }

    const char * _getKeychain(const char *inKey) {
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
            return resultString;
        } else {
            const char *resultString = "";
            return resultString;
        }
    }

    bool _removeKeychain(const char *inKey) {
        NSString *identifier = [NSString stringWithUTF8String:inKey];
        NSMutableDictionary *dictionary = newSearchDictionary(identifier);
        OSStatus status = SecItemDelete((CFDictionaryRef)dictionary);
        return status == errSecSuccess;
    }




}





