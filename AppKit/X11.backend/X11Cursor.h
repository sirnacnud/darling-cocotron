#import <Foundation/NSObject.h>
#import <AppKit/NSImage.h>
#import <X11/cursorfont.h>
#import <X11/Xcursor/Xcursor.h>

@interface X11Cursor : NSObject
{
	Cursor _cursor;
}

-(id)initWithShape:(unsigned int)shape;
-(id)initWithName:(const char*)name;
-(id)initWithImage:(NSImage*)image hotPoint:(NSPoint)hotPoint;
-(id)initBlank;
-(id)init;
-(void)dealloc;

@property (readonly) Cursor cursor;

@end
