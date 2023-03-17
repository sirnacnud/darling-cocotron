#import <CoreFoundation/CFBase.h>
#import <CoreText/CoreTextExport.h>

CF_IMPLICIT_BRIDGING_ENABLED

typedef struct __CTFontDescriptor* CTFontDescriptorRef;

CORETEXT_EXPORT CFTypeRef CTFontDescriptorCopyAttribute(CTFontDescriptorRef descriptor, CFStringRef attribute);

CF_IMPLICIT_BRIDGING_DISABLED
