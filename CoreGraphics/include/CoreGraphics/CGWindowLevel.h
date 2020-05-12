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

#endif
