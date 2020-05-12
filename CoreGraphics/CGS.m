/*
 This file is part of Darling.

 Copyright (C) 2020 Lubos Dolezel

 Darling is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 Darling is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with Darling.  If not, see <http://www.gnu.org/licenses/>.
*/
#import <CoreGraphics/CGSConnection.h>
#import <CoreGraphics/CGSSurface.h>
#import <CoreGraphics/CGSWindow.h>
#include <CoreGraphics/CoreGraphicsPrivate.h>
#import <Foundation/Foundation.h>
#include <dispatch/dispatch.h>
#include <stdatomic.h>

static NSMutableDictionary<NSNumber *, CGSConnection *> *g_connections = nil;
static Boolean g_denyConnections = FALSE;

static CGSConnectionID g_defaultConnection = -1;
static pthread_mutex_t g_defaultConnectionMutex = PTHREAD_MUTEX_INITIALIZER;

static _Atomic CGSConnectionID g_nextConnectionID = 1;
static Class g_backendClass = nil;

CGError CGSSetDenyWindowServerConnections(Boolean deny) {
    // TODO: Instruct our platform abstraction about this
    // TODO: Return failure if there's an existing connection
    return kCGErrorSuccess;
}

void CGSShutdownServerConnections(void) {
    // TODO
}

CGError CGSNewWindow(CGSConnectionID conn, CFIndex flags, float x_offset,
                     float y_offset, const CGSRegionRef region,
                     CGSWindowID *windowID)
{
    CGSConnection *c = _CGSConnectionForID(conn);
    if (!c)
        return kCGErrorInvalidConnection;

    CGSWindow *window = [c newWindow: region];
    if (!window)
        return kCGErrorIllegalArgument;

    *windowID = window.windowId;
    return kCGSErrorSuccess;
}

CGError CGSReleaseWindow(CGSConnectionID cid, CGSWindowID wid) {
    CGSConnection *c = _CGSConnectionForID(cid);
    if (!c)
        return kCGErrorInvalidConnection;
    return [c destroyWindow: wid];
}

CGError CGSSetWindowShape(CGSConnectionID cid, CGSWindowID wid, float x_offset,
                          float y_offset, const CGSRegionRef shape)
{
    CGSWindow *window;
    CGError err = getWindow(cid, wid, &window);

    if (err != kCGSErrorSuccess)
        return err;

    return [window setRegion: shape];
}

OSStatus CGSOrderWindow(CGSConnectionID cid, CGSWindowID wid,
                        CGSWindowOrderingMode place,
                        CGSWindowID relativeToWindow)
{
    CGSConnection *c = _CGSConnectionForID(cid);
    if (!c)
        return kCGErrorInvalidConnection;

    CGSWindow *window = [c windowForId: wid];
    if (!window)
        return kCGErrorIllegalArgument;

    CGSWindow *relativeTo = [c windowForId: relativeToWindow];
    return [window orderWindow: place relativeTo: relativeTo];
}

CGError CGSMoveWindow(CGSConnectionID cid, CGSWindowID wid,
                      const CGPoint *window_pos)
{
    CGSWindow *window;
    CGError err = getWindow(cid, wid, &window);

    if (err != kCGSErrorSuccess)
        return err;

    return [window moveTo: window_pos];
}

extern CGError CGSSetWindowOpacity(CGSConnectionID cid, CGSWindowID wid,
                                   bool isOpaque);
extern CGError CGSSetWindowAlpha(CGSConnectionID cid, CGSWindowID wid,
                                 float alpha);
extern CGError CGSSetWindowLevel(CGSConnectionID cid, CGSWindowID wid,
                                 CGWindowLevel level);

CGError CGSGetWindowProperty(CGSConnectionID cid, CGSWindowID wid,
                             CFStringRef key, CFTypeRef *outValue)
{
    CGSWindow *window;
    CGError err = getWindow(cid, wid, &window);

    if (err != kCGSErrorSuccess)
        return err;

    return [window getProperty: key value: outValue];
}

CGError CGSSetWindowProperty(CGSConnectionID cid, CGSWindowID wid,
                             CFStringRef key, CFTypeRef value)
{
    CGSWindow *window;
    CGError err = getWindow(cid, wid, &window);

    if (err != kCGSErrorSuccess)
        return err;

    return [window setProperty: key value: value];
}

CGError getSurface(CGSConnectionID cid, CGSWindowID wid, CGSSurfaceID sid,
                   CGSSurface **surface)
{
    CGSWindow *window;

    CGError err = getWindow(cid, wid, &window);
    if (err != kCGSErrorSuccess)
        return err;

    *surface = [window surfaceForId: sid];
    return (*surface) ? kCGSErrorSuccess : kCGErrorIllegalArgument;
}

CGError CGSAddSurface(CGSConnectionID cid, CGSWindowID wid, CGSSurfaceID *sid) {
    CGSWindow *window;

    CGError err = getWindow(cid, wid, &window);
    if (err != kCGSErrorSuccess)
        return err;

    CGSSurface *surface = [window createSurface];
    if (!surface)
        return kCGErrorFailure;

    *sid = surface.surfaceId;
    return kCGSErrorSuccess;
}

CGError CGSRemoveSurface(CGSConnectionID cid, CGSWindowID wid, CGSSurfaceID sid)
{
    CGSSurface *surface;

    CGError err = getSurface(cid, wid, sid, &surface);
    if (err != kCGSErrorSuccess)
        return err;

    [surface invalidate];
    return kCGSErrorSuccess;
}

CGError CGSSetSurfaceBounds(CGSConnectionID cid, CGSWindowID wid,
                            CGSSurfaceID sid, CGRect rect)
{
    CGSSurface *surface;

    CGError err = getSurface(cid, wid, sid, &surface);
    if (err != kCGSErrorSuccess)
        return err;

    return [surface setBounds: rect];
}
