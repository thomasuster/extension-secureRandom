#import <Foundation/Foundation.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIKit.h>

namespace secureRandom {
    value _getSecureRandom32()
    {
        FILE *fp = fopen("/dev/random", "r");

        if (!fp) {
            perror("randgetter");
            exit(-1);
        }

        uint_t value = 0;
        int i;
        for (i=0; i<sizeof(value); i++) {
            value <<= 8;
            value |= fgetc(fp);
        }

        fclose(fp);

        char * str = "";
        str += boost::lexical_cast<std::string>(val);
    }
}





