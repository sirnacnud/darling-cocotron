/* Copyright (c) 2006-2007 Christopher J. W. Lloyd

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */

#import "NSClassSwapper.h"
#import <Foundation/NSException.h>
#import <Foundation/NSKeyedArchiver.h>
#import <Foundation/NSString.h>
#import <Foundation/NSRaise.h>

@implementation NSClassSwapper

@synthesize className = _className;
@synthesize template = _object;

// TODO: replace the cell for the object too

- (instancetype) init {
    _className = @"NSObject";
    return self;
}

- (id) initWithCoder: (NSCoder *) coder {
    _className = [[coder decodeObjectForKey: @"NSClassName"] retain];
    _originalClassName =
            [[coder decodeObjectForKey: @"NSOriginalClassName"] retain];

    Class class = NSClassFromString(_className);

    if (class == Nil) {
        [NSException raise: NSInvalidArgumentException
                    format: @"NSClassSwapper is unable to find class %@",
                            _className];
    }

    _object = [class alloc];
    if ([coder respondsToSelector: @selector(replaceObject:withObject:)]) {
        [coder replaceObject: self withObject: _object];
    }
    if ([_object respondsToSelector: @selector(initWithCoder:)]) {
        _object = [_object initWithCoder: coder];
    } else {
        _object = [_object init];
    }

    // Retain the object before releasing self and save it to a variable,
    // because self is likely getting deallocated here, and we have to return an
    // owned reference.
    id res = [_object retain];

    [self release];
    return res;
}

- (void) dealloc {
    [_className release];
    [_originalClassName release];
    [_object release];
    [super dealloc];
}

- (void) setTemplate: (id) template {
    [template retain];
    [_object release];
    _object = template;

    // also update the original class name
    [_originalClassName release];
    _originalClassName = [[_object className] copy];
}

- (void) encodeWithCoder: (NSCoder *) coder {
    if (coder.allowsKeyedCoding) {
        [coder encodeObject: _className forKey: @"NSClassName"];
        [coder encodeObject: _originalClassName forKey: @"NSOriginalClassName"];

        [_object encodeWithCoder: coder];
    } else {
        [NSException raise: NSInvalidArchiveOperationException
                    format: @"TODO: support unkeyed encoding in NSClassSwapper"];
    }
}

@end
