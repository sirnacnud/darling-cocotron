/* Copyright (c) 2006-2007 Christopher J. W. Lloyd <cjwl@objc.net>
                 2009 Markus Hitter <mah@jump-ing.de>

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

#import <AppKit/NSGraphicsContextFunctions.h>
#import <AppKit/NSLayoutManager.h>
#import <AppKit/NSStringDrawer.h>
#import <AppKit/NSStringDrawing.h>
#import <AppKit/NSTextContainer.h>
#import <AppKit/NSTextStorage.h>
#import <AppKit/NSView.h>
#import <ApplicationServices/ApplicationServices.h>

const CGFloat NSStringDrawerLargeDimension = 1000000.;

@interface NSStringDrawer_CacheItem : NSObject {
    @public
    NSString* _string;
    NSDictionary* _attributes;
    NSAttributedString* _attributedString;
    NSSize _maxSize;
}

-(instancetype) initWithString: (NSString *) string
                    attributes: (NSDictionary *) attribs
                       maxSize: (NSSize) size;
-(instancetype) initWithAttributedString: (NSAttributedString *) string
                                 maxSize: (NSSize) size;
@end

@implementation NSStringDrawer

+ (NSStringDrawer *) sharedStringDrawer {
    return NSThreadSharedInstance(@"NSStringDrawer");
}

- (NSStringDrawer *) init {
    self = [super init];
    if (self != nil) {
        _textStorage = [NSTextStorage new];
        _layoutManager = [NSLayoutManager new];
        _textContainer = [[NSTextContainer alloc] init];

        _cache = [NSCache new];
        _cache.countLimit = 250;

        [_textStorage addLayoutManager: _layoutManager];
        [_layoutManager addTextContainer: _textContainer];
    }
    return self;
}

- (NSSize) sizeOfString: (NSString *) string
         withAttributes: (NSDictionary *) attributes
                 inSize: (NSSize) maxSize
{
    if (maxSize.width == NSZeroSize.width &&
        maxSize.height == NSZeroSize.height)
        maxSize = NSMakeSize(NSStringDrawerLargeDimension,
                             NSStringDrawerLargeDimension);

    static NSStringDrawer_CacheItem* fastCacheKey;
    if (!fastCacheKey)
        fastCacheKey = [NSStringDrawer_CacheItem alloc];
    fastCacheKey->_string = string;
    fastCacheKey->_attributes = attributes;
    fastCacheKey->_maxSize = maxSize;
    
    NSValue* entry = [_cache objectForKey: fastCacheKey];
    if (entry != nil)
    {
        return [entry sizeValue];
    }

    [_textContainer setContainerSize: maxSize];
    [_textStorage beginEditing];
    [_textStorage
            replaceCharactersInRange: NSMakeRange(0, [_textStorage length])
                          withString: string];
    [_textStorage setAttributes: attributes
                          range: NSMakeRange(0, [_textStorage length])];
    [_textStorage endEditing];
    NSSize result = [_layoutManager usedRectForTextContainer: _textContainer].size;

    NSStringDrawer_CacheItem* cacheKey = [[NSStringDrawer_CacheItem alloc] initWithString: string
                                                                               attributes: attributes
                                                                                  maxSize: maxSize];
    [_cache setObject: [NSValue valueWithSize: result]
              forKey: cacheKey];

    [cacheKey release];
    return result;
}

- (void) drawString: (NSString *) string
        withAttributes: (NSDictionary *) attributes
                inRect: (NSRect) rect
{
    NSRange glyphRange;

    [_textContainer setContainerSize: rect.size];
    [_textStorage beginEditing];
    [_textStorage
            replaceCharactersInRange: NSMakeRange(0, [_textStorage length])
                          withString: string];
    [_textStorage setAttributes: attributes
                          range: NSMakeRange(0, [_textStorage length])];
    [_textStorage endEditing];

    glyphRange = [_layoutManager glyphRangeForTextContainer: _textContainer];

    [_layoutManager drawBackgroundForGlyphRange: glyphRange
                                        atPoint: rect.origin];
    [_layoutManager drawGlyphsForGlyphRange: glyphRange atPoint: rect.origin];
}

- (void) drawString: (NSString *) string
        withAttributes: (NSDictionary *) attributes
               atPoint: (NSPoint) point
                inSize: (NSSize) maxSize
{
    NSRange glyphRange;

    if (maxSize.width == NSZeroSize.width &&
        maxSize.height == NSZeroSize.height)
        maxSize = NSMakeSize(NSStringDrawerLargeDimension,
                             NSStringDrawerLargeDimension);
    [_textContainer setContainerSize: maxSize];
    [_textStorage beginEditing];
    [_textStorage
            replaceCharactersInRange: NSMakeRange(0, [_textStorage length])
                          withString: string];
    [_textStorage setAttributes: attributes
                          range: NSMakeRange(0, [_textStorage length])];
    [_textStorage endEditing];

    glyphRange = [_layoutManager glyphRangeForTextContainer: _textContainer];
    [_layoutManager drawBackgroundForGlyphRange: glyphRange atPoint: point];
    [_layoutManager drawGlyphsForGlyphRange: glyphRange atPoint: point];
}

- (NSSize) sizeOfAttributedString: (NSAttributedString *) astring
                           inSize: (NSSize) maxSize
{
    if (maxSize.width == NSZeroSize.width &&
        maxSize.height == NSZeroSize.height)
        maxSize = NSMakeSize(NSStringDrawerLargeDimension,
                             NSStringDrawerLargeDimension);

    static NSStringDrawer_CacheItem* fastCacheKey;
    if (!fastCacheKey)
        fastCacheKey = [NSStringDrawer_CacheItem alloc];
    fastCacheKey->_maxSize = maxSize;
    fastCacheKey->_attributedString = astring;
    
    NSValue* entry = [_cache objectForKey: fastCacheKey];
    if (entry != nil)
    {
        return [entry sizeValue];
    }

    [_textContainer setContainerSize: maxSize];
    [_textStorage setAttributedString: astring];
    NSSize result = [_layoutManager usedRectForTextContainer: _textContainer].size;

    NSStringDrawer_CacheItem* realCacheKey = [[NSStringDrawer_CacheItem alloc] initWithAttributedString: astring
                                                                                            maxSize: maxSize];
    [_cache setObject: [NSValue valueWithSize: result]
              forKey: realCacheKey];

    [realCacheKey release];
    return result;
}

- (void) drawAttributedString: (NSAttributedString *) astring
                       inRect: (NSRect) rect
{
    NSRange glyphRange;

    [_textContainer setContainerSize: rect.size];
    [_textStorage setAttributedString: astring];

    glyphRange = [_layoutManager glyphRangeForTextContainer: _textContainer];
    [_layoutManager drawBackgroundForGlyphRange: glyphRange
                                        atPoint: rect.origin];
    [_layoutManager drawGlyphsForGlyphRange: glyphRange atPoint: rect.origin];
}

- (void) drawAttributedString: (NSAttributedString *) astring
                      atPoint: (NSPoint) point
                       inSize: (NSSize) maxSize
{
    NSRange glyphRange;

    if (maxSize.width == NSZeroSize.width &&
        maxSize.height == NSZeroSize.height)
        maxSize = NSMakeSize(NSStringDrawerLargeDimension,
                             NSStringDrawerLargeDimension);
    [_textContainer setContainerSize: maxSize];
    [_textStorage setAttributedString: astring];

    glyphRange = [_layoutManager glyphRangeForTextContainer: _textContainer];
    [_layoutManager drawBackgroundForGlyphRange: glyphRange atPoint: point];
    [_layoutManager drawGlyphsForGlyphRange: glyphRange atPoint: point];
}

@end

@implementation NSString (NSStringDrawer)

- (void) _clipAndDrawInRect: (NSRect) rect
             withAttributes: (NSDictionary *) attributes
             truncatingTail: (BOOL) truncateTail
{
    NSAttributedString *string = [[[NSAttributedString alloc]
            initWithString: self
                attributes: attributes] autorelease];
    [string _clipAndDrawInRect: rect truncatingTail: truncateTail];
}

// Draw self in the rect, clipped - add ellipsis if needed
- (void) _clipAndDrawInRect: (NSRect) rect
             withAttributes: (NSDictionary *) attributes
{
    [self _clipAndDrawInRect: rect
              withAttributes: attributes
              truncatingTail: YES];
}

@end

@implementation NSAttributedString (NSStringDrawer)

// Draw self in the rect, clipped - add ellipsis if needed
- (void) _clipAndDrawInRect: (NSRect) rect truncatingTail: (BOOL) truncateTail {
    CGContextRef graphicsPort = NSCurrentGraphicsPort();
    CGContextSaveGState(graphicsPort);
    CGContextClipToRect(graphicsPort, rect);

    // In a perfect world, we could use the NSLineBreakByTruncatingTail
    // attribute, but that's not supported for now by Cocotron
    NSAttributedString *string = self;
    NSSize size = [string size];
    if (truncateTail && size.width > rect.size.width && [string length]) {
        // Create a "..." attributed string with the attributes of the last char
        // of this string
        NSDictionary *attributes =
                [string attributesAtIndex: [string length] - 1
                           effectiveRange: NULL];
        NSAttributedString *ellipsis = [[[NSAttributedString alloc]
                initWithString: @"..."
                    attributes: attributes] autorelease];
        NSAttributedString *clippedTitle = string;
        do {
            clippedTitle = [clippedTitle
                    attributedSubstringFromRange: NSMakeRange(0,
                                                              [clippedTitle
                                                                      length] -
                                                                      1)];
            NSMutableAttributedString *tmpString =
                    [[clippedTitle mutableCopy] autorelease];
            [tmpString appendAttributedString: ellipsis];
            string = tmpString;
            size = [string size];
        } while ([clippedTitle length] && size.width > rect.size.width);
    }
    [[NSStringDrawer sharedStringDrawer] drawAttributedString: string
                                                       inRect: rect];
    CGContextRestoreGState(graphicsPort);
}

- (void) _clipAndDrawInRect: (NSRect) rect {
    [self _clipAndDrawInRect: rect truncatingTail: YES];
}

@end

@implementation NSStringDrawer_CacheItem
-(instancetype) initWithString: (NSString *) string
     attributes: (NSDictionary *) attribs
        maxSize: (NSSize) size
{
    _string = [string retain];
    _attributes = [attribs retain];
    _maxSize = size;

    return self;
}

-(instancetype) initWithAttributedString: (NSAttributedString *) string
                                 maxSize: (NSSize) size;
{
    _attributedString = [string retain];
    _maxSize = size;

    return self;
}

- (NSUInteger) hash {
    NSUInteger h;

    if (_attributedString != nil)
        h = [_attributedString hash];
    else
        h = [_string hash] ^ [_attributes hash];

    return h ^ ((unsigned long)(_maxSize.width * _maxSize.height));
}

- (BOOL) isEqual: (id) object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass: [NSStringDrawer_CacheItem class]]) {
        return NO;
    }
    NSStringDrawer_CacheItem *oo = (NSStringDrawer_CacheItem *) object;

    if (!CGSizeEqualToSize(_maxSize, oo->_maxSize))
        return NO;

    if (_attributedString != nil) {
        if (![_attributedString isEqual: oo->_attributedString])
            return NO;
    } else {
        if (![_string isEqual: oo->_string])
            return NO;

        if (_attributes != nil && oo->_attributes != nil) {
            if (![_attributes isEqual: oo->_attributes])
                return NO;
        }
    }

    return YES;
}

- (void) dealloc {
    [_string release];
    [_attributes release];
    [_attributedString release];
    [super dealloc];
}
@end
