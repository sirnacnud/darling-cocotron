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

#import <Foundation/Foundation.h>
#import <AppKit/NSUserInterfaceItemIdentification.h>

@class NSTableView, NSCell;

enum {
    NSTableColumnNoResizing = 0x00,
    NSTableColumnAutoresizingMask = 0x01,
    NSTableColumnUserResizingMask = 0x02,
};

@interface NSTableColumn : NSObject <NSUserInterfaceItemIdentification> {
    NSUserInterfaceItemIdentifier _identifier;
    NSTableView *_tableView;
    NSCell *_headerCell;
    NSCell *_dataCell;
    NSString *_headerToolTip;
    CGFloat _width;
    CGFloat _minWidth;
    CGFloat _maxWidth;
    BOOL _isResizable;
    BOOL _isEditable;
    NSUInteger _resizingMask;
    NSSortDescriptor *_sortDescriptorPrototype;
}

- (instancetype) initWithIdentifier: (NSUserInterfaceItemIdentifier) identifier;

- (NSTableView *) tableView;
- (id) headerCell;
- (id) dataCell;
- (NSString *) headerToolTip;

- (CGFloat) width;
- (CGFloat) minWidth;
- (CGFloat) maxWidth;
- (BOOL) isResizable;
- (BOOL) isEditable;
- (NSUInteger) resizingMask;

- (void) setTableView: (NSTableView *) tableView;
- (void) setHeaderCell: (NSCell *) cell;
- (void) setDataCell: (NSCell *) cell;
- (void) setHeaderToolTip: (NSString *) value;

- (void) setWidth: (CGFloat) width;
- (void) setMinWidth: (CGFloat) width;
- (void) setMaxWidth: (CGFloat) width;
- (void) setResizable: (BOOL) flag;
- (void) setEditable: (BOOL) flag;
- (void) setResizingMask: (NSUInteger) value;

- (NSCell *) dataCellForRow: (NSInteger) row;

- (NSSortDescriptor *) sortDescriptorPrototype;
- (void) setSortDescriptorPrototype: (NSSortDescriptor *) value;

// internal
- (void) prepareCell: (id) cell inRow: (NSInteger) row;
- (void) _boundValuesChanged;
- (void) _sort;

@end
