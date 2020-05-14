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
#ifndef CGSCONNECTION_H
#define CGSCONNECTION_H
#include <CoreGraphics/CoreGraphicsPrivate.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSObject.h>
#include <stdatomic.h>

@class CGSWindow;

@interface CGSConnection : NSObject {
    CGSConnectionID _connectionId;
    _Atomic CGSWindowID _nextWindowId;
    NSMutableDictionary<NSNumber *, CGSWindow *> *_windows;
}
- (instancetype) initWithConnectionID: (CGSConnectionID) connId;
- (void) dealloc;
- (CGSWindow *) windowForId: (CGSWindowID) winId;
- (CGSWindow *) newWindow: (CGSRegionRef) region;
- (CGError) destroyWindow: (CGSWindowID) winId;

+ (BOOL) isAvailable;

- (void) _windowInvalidated: (CGSWindowID) winId;

// For CGL
- (void *) nativeDisplay;
@end

#endif
