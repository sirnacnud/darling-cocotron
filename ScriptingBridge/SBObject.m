#import <Foundation/NSRaise.h>
#import <ScriptingBridge/SBObject.h>

@implementation SBObject

- initWithProperties: (NSDictionary *) properties {
    _properties = [properties copy];
    return self;
}

- (void) dealloc {
    [_properties release];
    [super dealloc];
}

@end
