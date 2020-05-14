#import <CoreFoundation/CFNumber.h>
#import <Foundation/NSNumber.h>

@interface NSNumber_CF : NSNumber {
  @public
    CFNumberType _type;
}

@end
