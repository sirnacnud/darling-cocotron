#ifndef CGWINDOWLEVEL_H
#define CGWINDOWLEVEL_H

#import <CoreFoundation/CoreFoundation.h>

typedef CF_ENUM(int32_t, CGWindowLevel)
{
    kCGNormalWindowLevel,
    kCGFloatingWindowLevel,
    kCGTornOffMenuWindowLevel,
    kCGMainMenuWindowLevel,
    kCGStatusWindowLevel,
    kCGModalPanelWindowLevel,
    kCGPopUpMenuWindowLevel,
    kCGScreenSaverWindowLevel,
};

typedef CF_ENUM(int32_t, CGWindowLevelKey)
{
    kCGBaseWindowLevelKey,
    kCGMinimumWindowLevelKey,
    kCGDesktopWindowLevelKey,
    kCGBackstopMenuLevelKey,
    kCGNormalWindowLevelKey,
    kCGFloatingWindowLevelKey,
    kCGTornOffMenuWindowLevelKey,
    kCGDockWindowLevelKey,
    kCGMainMenuWindowLevelKey,
    kCGStatusWindowLevelKey,
    kCGModalPanelWindowLevelKey,
    kCGPopUpMenuWindowLevelKey,
    kCGDraggingWindowLevelKey,
    kCGScreenSaverWindowLevelKey,
    kCGMaximumWindowLevelKey,
    kCGOverlayWindowLevelKey,
    kCGHelpWindowLevelKey,
    kCGUtilityWindowLevelKey,
    kCGDesktopIconWindowLevelKey,
    kCGCursorWindowLevelKey,
    kCGAssistiveTechHighWindowLevelKey,
    kCGNumberOfWindowLevelKeys
};

CF_IMPLICIT_BRIDGING_ENABLED

COREGRAPHICS_EXPORT CGWindowLevel CGWindowLevelForKey(CGWindowLevelKey key);

CF_IMPLICIT_BRIDGING_DISABLED

#endif
