/*
 This file is part of Darling.

 Copyright (C) 2019-2020 Lubos Dolezel

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

#ifndef CGREMOTEOPERATION_H
#define CGREMOTEOPERATION_H
#include <CoreGraphics/CGError.h>
#include <stdint.h>

typedef CGError CGEventErr;
typedef uint32_t CGButtonCount;
typedef uint32_t CGWheelCount;
typedef uint16_t CGCharCode;
typedef uint16_t CGKeyCode;
typedef uint32_t CGRectCount;

typedef CF_OPTIONS(uint32_t, CGEventFilterMask) {
    kCGEventFilterMaskPermitLocalMouseEvents = 0x00000001,
    kCGEventFilterMaskPermitLocalKeyboardEvents = 0x00000002,
    kCGEventFilterMaskPermitSystemDefinedEvents = 0x00000004
};

typedef CF_ENUM(uint32_t, CGEventSuppressionState) {
    kCGEventSuppressionStateSuppressionInterval = 0,
    kCGEventSuppressionStateRemoteMouseDrag,
    kCGNumberOfEventSuppressionStates
};

typedef CF_OPTIONS(uint32_t, CGScreenUpdateOperation) {
    kCGScreenUpdateOperationRefresh                    =        0,
    kCGScreenUpdateOperationMove                       = 1u <<  0,
    kCGScreenUpdateOperationReducedDirtyRectangleCount = 1u << 31,
};

typedef struct CGScreenUpdateMoveDelta {
    int32_t dX, dY;
} CGScreenUpdateMoveDelta;

#define kCGEventFilterMaskPermitAllEvents (kCGEventFilterMaskPermitLocalMouseEvents | kCGEventFilterMaskPermitLocalKeyboardEvents | kCGEventFilterMaskPermitSystemDefinedEvents)

// TODO: All those deprecated functions

#endif
