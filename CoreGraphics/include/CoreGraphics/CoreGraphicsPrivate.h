#ifndef COREGRAPHICSPRIVATE_H
#define COREGRAPHICSPRIVATE_H
#include <CoreFoundation/CoreFoundation.h>
#include <CoreGraphics/CoreGraphics.h>

__BEGIN_DECLS

// References:
// https://github.com/koekeishiya/cglwindow/blob/master/src/cgl_window.c
// https://sourceforge.net/p/xnntp/SVN_Xnntp/1/tree/CGSPrivate.h

typedef int CGSConnectionID;
typedef int CGSWindowID;
typedef int CGSSurfaceID;
typedef CFMutableDictionaryRef CGSDictionaryObj;
typedef CFTypeRef CGSRegionRef;

#define CGSDefaultConnection _CGSDefaultConnection()

enum {
    kCGSErrorSuccess = 0,
};

typedef enum {
    kCGSOrderBelow = -1,
    kCGSOrderOut, /* hides the window */
    kCGSOrderAbove,
    kCGSOrderIn /* shows the window */
} CGSWindowOrderingMode;

typedef enum {
    kCGSBackingNonRetianed,
    kCGSBackingRetained,
    kCGSBackingBuffered,
} CGSBackingType;

extern void CGSInitialize(void);
extern CGError CGSNewConnection(_Nullable CGSDictionaryObj attribs,
                                CGSConnectionID *connId);
extern CGError CGSReleaseConnection(CGSConnectionID connId);
extern CGSConnectionID _CGSDefaultConnection(void);
extern CGSConnectionID CGSMainConnectionID(void);
extern CGError CGSSetDenyWindowServerConnections(Boolean deny);
extern void CGSShutdownServerConnections(void);

// CGSRegion
extern CGError CGSNewRegionWithRect(const CGRect *rect,
                                    CGSRegionRef *newRegion);
extern void CGSRegionRelease(CGSRegionRef reg);
extern void CGSRegionRetain(CGSRegionRef reg);
extern void
CGSRegionToRect(CGSRegionRef reg,
                CGRect *rect); // This is non-standard. We should support
                               // non-rectangular regions instead
extern bool CGSRegionIsRectangular(CGSRegionRef reg);

extern CGError CGSNewWindow(CGSConnectionID conn, CFIndex flags, float, float,
                            const CGSRegionRef region, CGSWindowID *windowID);
extern CGError CGSReleaseWindow(CGSConnectionID cid, CGSWindowID wid);

extern CGError CGSSetWindowShape(CGSConnectionID cid, CGSWindowID wid,
                                 float x_offset, float y_offset,
                                 const CGSRegionRef shape);
extern OSStatus CGSOrderWindow(CGSConnectionID cid, CGSWindowID wid,
                               CGSWindowOrderingMode place,
                               CGSWindowID relativeToWindow);
extern CGError CGSMoveWindow(CGSConnectionID cid, CGSWindowID wid,
                             const CGPoint *window_pos);
extern CGError CGSSetWindowOpacity(CGSConnectionID cid, CGSWindowID wid,
                                   bool isOpaque);
extern CGError CGSSetWindowAlpha(CGSConnectionID cid, CGSWindowID wid,
                                 float alpha);
extern CGError CGSSetWindowLevel(CGSConnectionID cid, CGSWindowID wid,
                                 CGWindowLevel level);

// Subwindows (for CGL)
extern CGError CGSAddSurface(CGSConnectionID cid, CGSWindowID wid,
                             CGSSurfaceID *sid);
extern CGError CGSRemoveSurface(CGSConnectionID cid, CGSWindowID wid,
                                CGSSurfaceID sid);
extern CGError CGSSetSurfaceBounds(CGSConnectionID cid, CGSWindowID wid,
                                   CGSSurfaceID sid, CGRect rect);
extern CGError CGSOrderSurface(CGSConnectionID cid, CGSWindowID wid,
                               CGSSurfaceID sid, int a, int b);
// extern CGLError CGLSetSurface(CGLContextObj gl, CGSConnectionID cid,
// CGSWindowID wid, CGSSurfaceID sid); // in CGL

// extern CGContextRef CGWindowContextCreate(CGSConnectionID cid, CGSWindowID
// wid, CFDictionaryRef options); // in CGL

extern CGError CGSSetWindowTags(CGSConnectionID cid, CGSWindowID wid,
                                const int tags[2], size_t tag_size);
extern CGError CGSClearWindowTags(CGSConnectionID cid, CGSWindowID wid,
                                  const int tags[2], size_t tag_size);
extern CGError CGSAddActivationRegion(CGSConnectionID cid, CGSWindowID wid,
                                      CGSRegionRef region);
extern CGError CGSClearActivationRegion(CGSConnectionID cid, CGSWindowID wid);
extern CGError CGSAddDragRegion(CGSConnectionID cid, CGSWindowID wid,
                                CGSRegionRef region);
extern CGError CGSClearDragRegion(CGSConnectionID cid, CGSWindowID wid);
extern CGError CGSAddTrackingRect(CGSConnectionID cid, CGSWindowID wid,
                                  CGRect rect);
extern CGError CGSRemoveAllTrackingAreas(CGSConnectionID cid, CGSWindowID wid);
extern CFStringRef CGSCopyManagedDisplayForWindow(const CGSConnectionID cid,
                                                  CGSWindowID wid);
extern CGError CGSGetScreenRectForWindow(CGSConnectionID cid, CGSWindowID wid,
                                         CGRect *outRect);

extern const CFStringRef kCGSWindowTitle;
extern CGError CGSSetWindowTitle(CGSConnectionID cid, CGSWindowID wid,
                                 CFStringRef title);
extern CGError CGSGetWindowProperty(CGSConnectionID cid, CGSWindowID wid,
                                    CFStringRef key, CFTypeRef *outValue);
extern CGError CGSSetWindowProperty(CGSConnectionID cid, CGSWindowID wid,
                                    CFStringRef key, CFTypeRef value);

// Darling extras, e.g. for CGL
void *_CGSNativeDisplay(CGSConnectionID connId);
void *_CGSNativeWindowForID(CGSConnectionID connId, CGSWindowID winId);
void *_CGSNativeWindowForSurfaceID(CGSConnectionID connId, CGSWindowID winId,
                                   CGSSurfaceID surfaceId);

__END_DECLS

#endif
