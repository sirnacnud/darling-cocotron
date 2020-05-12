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
#include "CGEventObjC.h"
#include "CGEventTapInternal.h"
#include <time.h>
#include <CoreGraphics/CGEventSource.h>
#import <Foundation/NSKeyedArchiver.h>
#import <Foundation/NSString.h>

@implementation CGEvent

@synthesize source = _source;
@synthesize type = _type;
@synthesize timestamp = _timestamp;
@synthesize flags = _flags;
@synthesize fields = _fields;
@synthesize virtualKey = _virtualKey;
@synthesize mouseButton = _mouseButton;
@synthesize location = _location;
@synthesize scrollEventUnit = _scrollEventUnit;
@synthesize wheelCount = _wheelCount;

-(instancetype) initWithSource:(CGEventSource*) source
{
	return [self initWithSource: source
							type: kCGEventNull];
}

-(instancetype) initWithSource:(CGEventSource*) source
						type:(CGEventType) type;
{
	_source = [source retain];
	_type = type;
	_fields = [[NSMutableDictionary alloc] initWithCapacity: 0];
	_timestamp = clock_gettime_nsec_np(CLOCK_UPTIME_RAW);
	return self;
}

-(instancetype) initWithCoder:(NSCoder*) coder
{
	NSKeyedUnarchiver* unarchiver = (NSKeyedUnarchiver*) coder;
	
	// TODO

	return self;
}

-(void) dealloc
{
	[_source release];
	[_fields release];
	[super dealloc];
}

-(id)copy
{
	CGEvent* rv = [[CGEvent alloc] initWithSource: _source type: _type];
	rv->_timestamp = self->_timestamp;
	rv->_flags = self->_flags;
	rv->_fields = [_fields copy];

	rv->_virtualKey = _virtualKey;
	memcpy(rv->_unicodeString, _unicodeString, sizeof(_unicodeString));

	rv->_location = _location;
	rv->_mouseButton = _mouseButton;

	rv->_scrollEventUnit = _scrollEventUnit;
	rv->_wheelCount = _wheelCount;
	memcpy(rv->_wheels, _wheels, sizeof(_wheels));

	return rv;
}

- (id)copyWithZone:(NSZone *)zone
{
	return [self copy];
}

-(CFTypeID) _cfTypeID
{
	return CGEventGetTypeID();
}

-(int32_t*) wheels
{
	return _wheels;
}

-(UniChar*) unicodeString
{
	return _unicodeString;
}

-(void) encodeWithCoder:(NSCoder*) coder
{
	NSKeyedArchiver* archiver = (NSKeyedArchiver*) coder;

	CGEventSourceStateID stateId = _source.stateID;
	[archiver encodeInt: stateId forKey:@"stateId"];

	[archiver encodeInt: _type forKey: @"type"];
	[archiver encodeInt64: _timestamp forKey: @"timestamp"];
	[archiver encodeObject: _fields forKey: @"fields"];
	[archiver encodeInt: _virtualKey forKey: @"virtualKey"];
	[archiver encodeBytes: (uint8_t*) _unicodeString length: sizeof(_unicodeString) forKey: @"unicodeString"];
	[archiver encodeDouble: _location.x forKey: @"location.x"];
	[archiver encodeDouble: _location.y forKey: @"location.y"];
	[archiver encodeInt: _mouseButton forKey: @"mouseButton"];
	[archiver encodeInt: _scrollEventUnit forKey: @"scrollEventUnit"];
	[archiver encodeInt: _wheelCount forKey:@"wheelCount"];

	for (uint32_t i = 0; i < _wheelCount; i++)
	{
		[archiver encodeInt: _wheels[i] forKey:[NSString stringWithFormat:@"wheel-%d", i]];
	}
}
@end

////////////////////////////////////////////////////////////////

@implementation CGEventSource
@synthesize keyboardType = _keyboardType;
@synthesize stateID = _stateId;
@synthesize userData = _userData;
@synthesize pixelsPerLine = _pixelsPerLine;

-(instancetype) initWithState: (CGEventSourceStateID) stateId
{
	_stateId = stateId;
	return self;
}

-(CFTypeID) _cfTypeID
{
	return CGEventSourceGetTypeID();
}
@end

////////////////////////////////////////////////////////////////

static void cgEventTapCallout(CFMachPortRef mp, void* msg, CFIndex size, void* info)
{
	CGEventTap* tap = (CGEventTap*) info;

	struct TapMachMessage* tapMessage = (struct TapMachMessage*) msg;
	CGEventRef event = tapMessage->event;

	CGEventType type = CGEventGetType(tapMessage->event);
	if (tap.enabled && (CGEventMaskBit(type) & tap.mask) != 0)
	{
		// Invoke callback
		CGEventRef returned = tap.callback(tapMessage->proxy, type, event, tap.userInfo);

		if (!(tap.options & kCGEventTapOptionListenOnly))
			event = returned;
	}

	// Pass the message on
	if (event != NULL)
	{
		CGEventTapPostEvent(tapMessage->proxy, event);

		if (event != tapMessage->event)
			CFRelease(event);
	}

	CFRelease(tapMessage->event);
}

@implementation CGEventTap

@synthesize machPort = _machPort;
@synthesize options = _options;
@synthesize mask = _mask;
@synthesize callback = _callback;
@synthesize userInfo = _userInfo;
@synthesize enabled = _enabled;

-(instancetype) initWithLocation: (CGEventTapLocation) location
						options: (CGEventTapOptions) options
							mask: (CGEventMask) mask
						callback: (CGEventTapCallBack) callback
						userInfo: (void*) userInfo
{
	_location = location;
	_options = options;
	_mask = mask;
	_callback = callback;
	_userInfo = userInfo;
	_enabled = TRUE;

	kern_return_t ret = mach_port_allocate(mach_task_self(), MACH_PORT_RIGHT_RECEIVE, &_machPort);
    if (KERN_SUCCESS == ret) {
        ret = mach_port_insert_right(mach_task_self(), _machPort, _machPort, MACH_MSG_TYPE_MAKE_SEND);
    }
    if (KERN_SUCCESS != ret) {
        if (MACH_PORT_NULL != _machPort) mach_port_destroy(mach_task_self(), _machPort);
		[self release];
        return nil;
    }

	return self;
}

-(void) dealloc
{
	_CGEventTapDestroyed(_location, _machPort);
	mach_port_destroy(mach_task_self(), _machPort);
	[super dealloc];
}

-(CFMachPortRef) createCFMachPort
{
	CFMachPortRef mp;
	CFMachPortContext ctxt = {
		.copyDescription = NULL,
		.info = self,
		.release = CFRelease,
		.retain = CFRetain,
		.version = 0,
	};

	mp = CFMachPortCreateWithPort(NULL, _machPort, cgEventTapCallout, &ctxt, NULL);

	return mp;
}

@end
