#ifndef CGWINDOWLEVEL_H
#define CGWINDOWLEVEL_H

typedef int32_t CGWindowLevel;

enum {
    kCGNormalWindowLevel,
    kCGFloatingWindowLevel,
    kCGTornOffMenuWindowLevel,
    kCGMainMenuWindowLevel,
    kCGStatusWindowLevel,
    kCGModalPanelWindowLevel,
    kCGPopUpMenuWindowLevel,
    kCGScreenSaverWindowLevel,
};

typedef int32_t CGWindowLevelKey;

enum {
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
