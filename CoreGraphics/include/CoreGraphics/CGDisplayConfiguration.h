#import <CoreFoundation/CoreFoundation.h>

typedef CF_OPTIONS(uint32_t, CGDisplayChangeSummaryFlags) {
	kCGDisplayBeginConfigurationFlag  = (1 << 0),
	kCGDisplayMovedFlag               = (1 << 1),
	kCGDisplaySetMainFlag             = (1 << 2),
	kCGDisplaySetModeFlag             = (1 << 3),
	kCGDisplayAddFlag                 = (1 << 4),
	kCGDisplayRemoveFlag              = (1 << 5),
	kCGDisplayEnabledFlag             = (1 << 8),
	kCGDisplayDisabledFlag            = (1 << 9),
	kCGDisplayMirrorFlag              = (1 << 10),
	kCGDisplayUnMirrorFlag            = (1 << 11),
	kCGDisplayDesktopShapeChangedFlag = (1 << 12),
};
