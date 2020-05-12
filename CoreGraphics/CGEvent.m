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

#include <CoreGraphics/CGEvent.h>
#include <stdarg.h>
#import "CGEventObjC.h"

CFTypeID CGEventGetTypeID(void)
{
	return (CFTypeID) [CGEvent self];
}

CGEventRef CGEventCreate(CGEventSourceRef source)
{
	return (CGEventRef) [[CGEvent alloc] initWithSource: (CGEventSource*) source];
}

CGEventRef CGEventCreateCopy(CGEventRef event)
{
	return (CGEventRef) [(CGEvent*)event copy];
}

CFDataRef CGEventCreateData(CFAllocatorRef allocator, CGEventRef event)
{
	CGEvent* e = (CGEvent*) event;
	return (CFDataRef) [e createData];
}

CGEventRef CGEventCreateFromData(CFAllocatorRef allocator, CFDataRef data)
{
	CGEvent* e = [[CGEvent alloc] initWithData: (NSData*) data];
	return (CGEventRef) e;
}

CGEventType CGEventGetType(CGEventRef event)
{
	CGEvent* e = (CGEvent*) event;
	return e.type;
}

void CGEventSetSource(CGEventRef event, CGEventSourceRef source)
{
	CGEvent* e = (CGEvent*) event;
	e.source = (CGEventSource*) source;
}

CGEventSourceRef CGEventCreateSourceFromEvent(CGEventRef event)
{
	CGEvent* e = (CGEvent*) event;
	return (CGEventSourceRef) [(CGEventSource*) e.source retain];
}

void CGEventSetType(CGEventRef event, CGEventType type)
{
	CGEvent* e = (CGEvent*) event;
	e.type = type;
}

CGEventTimestamp CGEventGetTimestamp(CGEventRef event)
{
	CGEvent* e = (CGEvent*) event;
	return e.timestamp;
}

void CGEventSetTimestamp(CGEventRef event, CGEventTimestamp timestamp)
{
	CGEvent* e = (CGEvent*) event;
	e.timestamp = timestamp;
}

int64_t CGEventGetIntegerValueField(CGEventRef event, CGEventField field)
{
	CGEvent* e = (CGEvent*) event;
	NSNumber* value = e.fields[[NSNumber numberWithInt: field]];

	if (!value)
		return 0;
	return value.longLongValue;
}

void CGEventSetIntegerValueField(CGEventRef event, CGEventField field, int64_t value)
{
	CGEvent* e = (CGEvent*) event;
	e.fields[[NSNumber numberWithInt: field]] = [NSNumber numberWithLongLong: value];
}

double CGEventGetDoubleValueField(CGEventRef event, CGEventField field)
{
	CGEvent* e = (CGEvent*) event;
	NSNumber* value = e.fields[[NSNumber numberWithInt: field]];

	if (!value)
		return 0;
	return value.doubleValue;
}

void CGEventSetDoubleValueField(CGEventRef event, CGEventField field, double value)
{
	CGEvent* e = (CGEvent*) event;
	e.fields[[NSNumber numberWithInt: field]] = [NSNumber numberWithDouble: value];
}

CGEventRef CGEventCreateKeyboardEvent(CGEventSourceRef source, CGKeyCode virtualKey, bool keyDown)
{
	CGEventType type = keyDown ? kCGEventKeyDown : kCGEventKeyUp;
	CGEvent* event = [[CGEvent alloc] initWithSource: (CGEventSource*) source type: type];
	event.virtualKey = virtualKey;

	return (CGEventRef) event;
}

CGEventRef CGEventCreateMouseEvent(CGEventSourceRef source, CGEventType mouseType, CGPoint mouseCursorPosition, CGMouseButton mouseButton)
{
	CGEvent* event = [[CGEvent alloc] initWithSource: (CGEventSource*) source type: mouseType];
	event.location = mouseCursorPosition;
	event.mouseButton = mouseButton;
	return (CGEventRef) event;
}

CGEventRef CGEventCreateScrollWheelEvent(CGEventSourceRef source, CGScrollEventUnit units, uint32_t wheelCount, int32_t wheel1, ...)
{
	CGEvent* event = [[CGEvent alloc] initWithSource: (CGEventSource*) source type: kCGEventScrollWheel];
	event.scrollEventUnit = units;
	event.wheelCount = wheelCount;
	event.wheels[0] = wheel1;

	if (wheelCount > 1)
	{
		va_list vl;
		va_start(vl, wheel1);

		event.wheels[1] = va_arg(vl, int32_t);

		if (wheelCount > 2)
			event.wheels[2] = va_arg(vl, int32_t);

		va_end(vl);
	}
	return (CGEventRef) event;
}

CGPoint CGEventGetLocation(CGEventRef event)
{
	CGEvent* e = (CGEvent*) event;
	return e.location;
}

void CGEventSetLocation(CGEventRef event, CGPoint location)
{
	CGEvent* e = (CGEvent*) event;
	e.location = location;
}

void CGEventKeyboardGetUnicodeString(CGEventRef event, UniCharCount maxStringLength, UniCharCount *actualStringLength, UniChar *unicodeString)
{
	CGEvent* e = (CGEvent*) event;
	UniChar* savedString = e.unicodeString;

	UniCharCount length = 0;
	while (length < 5 && savedString[length])
		length++;
	
	if (maxStringLength == 0)
	{
		*actualStringLength = length;
	}
	
	*actualStringLength = length;
	if (maxStringLength < length)
		*actualStringLength = maxStringLength;

	memcpy(unicodeString, savedString, *actualStringLength * sizeof(UniChar));
}

void CGEventKeyboardSetUnicodeString(CGEventRef event, UniCharCount stringLength, const UniChar *unicodeString)
{
	CGEvent* e = (CGEvent*) event;

	// This is the maximum CGEvent can save
	if (stringLength > 5)
		stringLength = 5;
	
	memcpy(e.unicodeString, unicodeString, stringLength * sizeof(UniChar));
}
