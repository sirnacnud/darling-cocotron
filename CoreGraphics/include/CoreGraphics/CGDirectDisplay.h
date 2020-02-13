
#import <CoreGraphics/CoreGraphicsExport.h>
#import <CoreGraphics/CGError.h>
#import <CoreGraphics/CGGeometry.h>

typedef uint32_t CGDirectDisplayID;
typedef uint32_t CGOpenGLDisplayMask;
typedef double CGRefreshRate;

#define kCGNullDirectDisplay 0

typedef CFTypeRef CGDisplayModeRef;

COREGRAPHICS_EXPORT CGError CGReleaseAllDisplays(void);


COREGRAPHICS_EXPORT CGDirectDisplayID CGMainDisplayID(void);

COREGRAPHICS_EXPORT CGError CGGetOnlineDisplayList(uint32_t maxDisplays, CGDirectDisplayID *onlineDisplays, uint32_t *displayCount);

COREGRAPHICS_EXPORT CGError CGGetActiveDisplayList(uint32_t maxDisplays, CGDirectDisplayID *activeDisplays, uint32_t *displayCount);

COREGRAPHICS_EXPORT CGError CGGetDisplaysWithOpenGLDisplayMask(CGOpenGLDisplayMask mask, uint32_t maxDisplays, CGDirectDisplayID *displays, uint32_t *matchingDisplayCount);

COREGRAPHICS_EXPORT CGDirectDisplayID CGOpenGLDisplayMaskToDisplayID(CGOpenGLDisplayMask mask);

COREGRAPHICS_EXPORT CGError CGGetDisplaysWithPoint(CGPoint point, uint32_t maxDisplays, CGDirectDisplayID *displays, uint32_t *matchingDisplayCount);

COREGRAPHICS_EXPORT CGError CGGetDisplaysWithRect(CGRect rect, uint32_t maxDisplays, CGDirectDisplayID *displays, uint32_t *matchingDisplayCount);

COREGRAPHICS_EXPORT size_t CGDisplayPixelsHigh(CGDirectDisplayID display);
COREGRAPHICS_EXPORT size_t CGDisplayPixelsWide(CGDirectDisplayID display);

COREGRAPHICS_EXPORT Boolean CGDisplayIsMain(CGDirectDisplayID display);
COREGRAPHICS_EXPORT CGDirectDisplayID CGDisplayMirrorsDisplay(CGDirectDisplayID display);

COREGRAPHICS_EXPORT CGDisplayModeRef CGDisplayCopyDisplayMode(CGDirectDisplayID displayId);
COREGRAPHICS_EXPORT void CGDisplayModeRelease(CGDisplayModeRef mode);
COREGRAPHICS_EXPORT CGDisplayModeRef CGDisplayModeRetain(CGDisplayModeRef mode);
COREGRAPHICS_EXPORT CGDisplayModeRef CGDisplayCopyDisplayMode(CGDirectDisplayID displayId);
COREGRAPHICS_EXPORT double CGDisplayModeGetRefreshRate(CGDisplayModeRef mode);
