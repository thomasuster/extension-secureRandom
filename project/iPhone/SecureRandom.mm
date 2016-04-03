#import <Foundation/Foundation.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIKit.h>
#include <hx/CFFI.h>
namespace secureRandom {
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


}





