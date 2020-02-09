#import <CoreGraphics/CGDirectDisplay.h>
#import <CoreGraphics/CGError.h>
#import <AppKit/NSDisplay.h>
#import <IOKit/graphics/IOGraphicsTypes.h>

CGError CGReleaseAllDisplays(void) {
   return 0;
}

CGDirectDisplayID CGMainDisplayID(void)
{
   return 0;
}

CGError CGGetOnlineDisplayList(uint32_t maxDisplays, CGDirectDisplayID *onlineDisplays, uint32_t *displayCount)
{
   NSDisplay* display = [NSClassFromString(@"NSDisplay") currentDisplay];
   if (!display)
      return kCGErrorInvalidConnection;

   NSArray<NSScreen*>* screens = [display screens];

   if (displayCount)
      *displayCount = [screens count];
   
   for (int i = 0; i < [screens count] && i < maxDisplays; i++)
   {
      onlineDisplays[i] = i+1;
   }

   return kCGErrorSuccess;
}

size_t CGDisplayPixelsHigh(CGDirectDisplayID displayIndex)
{
   NSDisplay* display = [NSClassFromString(@"NSDisplay") currentDisplay];
   if (!display)
      return kCGErrorInvalidConnection;

   NSArray<NSScreen*>* screens = [display screens];
   if (displayIndex > [screens count] || displayIndex <= 0)
      return 0;
   
   return NSHeight([[screens objectAtIndex: displayIndex-1] frame]);
}

size_t CGDisplayPixelsWide(CGDirectDisplayID displayIndex)
{
   NSDisplay* display = [NSClassFromString(@"NSDisplay") currentDisplay];
   if (!display)
      return kCGErrorInvalidConnection;

   NSArray<NSScreen*>* screens = [display screens];
   if (displayIndex > [screens count] || displayIndex <= 0)
      return 0;
   
   return NSWidth([[screens objectAtIndex: displayIndex-1] frame]);
}

CGError CGGetActiveDisplayList(uint32_t maxDisplays, CGDirectDisplayID *activeDisplays, uint32_t *displayCount)
{
   return CGGetOnlineDisplayList(maxDisplays, activeDisplays, displayCount);
}

CGError CGGetDisplaysWithOpenGLDisplayMask(CGOpenGLDisplayMask mask, uint32_t maxDisplays, CGDirectDisplayID *displays, uint32_t *matchingDisplayCount)
{
   return CGGetOnlineDisplayList(maxDisplays, displays, matchingDisplayCount);
}

CGDirectDisplayID CGOpenGLDisplayMaskToDisplayID(CGOpenGLDisplayMask mask)
{
   return CGMainDisplayID();
}

CGError CGGetDisplaysWithPoint(CGPoint point, uint32_t maxDisplays, CGDirectDisplayID *displays, uint32_t *matchingDisplayCount)
{
   NSDisplay* display = [NSClassFromString(@"NSDisplay") currentDisplay];
   if (!display)
      return kCGErrorInvalidConnection;

   NSArray<NSScreen*>* screens = [display screens];
   *matchingDisplayCount = 0;

   for (int i = 0; i < [screens count] && *matchingDisplayCount < maxDisplays; i++)
   {
      NSRect rect = [[screens objectAtIndex: i] frame];
      if (NSPointInRect(point, rect))
      {
         displays[*matchingDisplayCount] = i+1;
         (*matchingDisplayCount)++;
      }
   }

   return kCGErrorSuccess;
}

CGError CGGetDisplaysWithRect(CGRect rect, uint32_t maxDisplays, CGDirectDisplayID *displays, uint32_t *matchingDisplayCount)
{
   NSDisplay* display = [NSClassFromString(@"NSDisplay") currentDisplay];
   if (!display)
      return kCGErrorInvalidConnection;

   NSArray<NSScreen*>* screens = [display screens];
   *matchingDisplayCount = 0;

   for (int i = 0; i < [screens count] && *matchingDisplayCount < maxDisplays; i++)
   {
      NSRect screenRect = [[screens objectAtIndex: i] frame];
      if (NSIntersectsRect(rect, screenRect))
      {
         displays[*matchingDisplayCount] = i+1;
         (*matchingDisplayCount)++;
      }
   }

   return kCGErrorSuccess;
}

CGError CGDisplayCapture(CGDirectDisplayID display)
{
   return kCGErrorSuccess;
}

CGError CGDisplayRelease(CGDirectDisplayID display)
{
   return kCGErrorSuccess;
}

CGRect CGDisplayBounds(CGDirectDisplayID displayIndex)
{
   NSDisplay* display = [NSClassFromString(@"NSDisplay") currentDisplay];
   if (!display)
      return NSZeroRect;

   NSArray<NSScreen*>* screens = [display screens];
   if (displayIndex > [screens count] || displayIndex <= 0)
      return NSZeroRect;

	return [[screens objectAtIndex: displayIndex-1] frame];
}

CGError CGDisplayHideCursor(CGDirectDisplayID displayIndex)
{
   NSDisplay* display = [NSClassFromString(@"NSDisplay") currentDisplay];
   if (!display)
      return kCGErrorInvalidConnection;
   
   [display hideCursor];
	return kCGErrorSuccess;
}

CGError CGDisplayShowCursor(CGDirectDisplayID displayIndex)
{
   NSDisplay* display = [NSClassFromString(@"NSDisplay") currentDisplay];
   if (!display)
      return kCGErrorInvalidConnection;
   
   [display unhideCursor];
	return kCGErrorSuccess;
}

CFArrayRef CGDisplayAvailableModes(CGDirectDisplayID displayIndex)
{
   NSDisplay* display = [NSClassFromString(@"NSDisplay") currentDisplay];
   if (!display)
      return NULL;
   return (CFArrayRef) [display modesForScreen:displayIndex-1];
}

Boolean CGDisplayIsMain(CGDirectDisplayID display)
{
   return display == 1;
}

CGDirectDisplayID CGDisplayMirrorsDisplay(CGDirectDisplayID display)
{
   // STUB!
   // TODO: Get this from XRandR
   return kCGNullDirectDisplay;
}

CGDisplayModeRef CGDisplayCopyDisplayMode(CGDirectDisplayID displayId)
{
   NSDisplay* display = [NSClassFromString(@"NSDisplay") currentDisplay];
   if (!display)
      return NULL;

   NSDictionary* dict = [[display currentModeForScreen: displayId-1] retain];

   return (CGDisplayModeRef) dict;
}

void CGDisplayModeRelease(CGDisplayModeRef mode)
{
   if (mode != NULL)
      CFRelease(mode);
}

CGDisplayModeRef CGDisplayModeRetain(CGDisplayModeRef mode)
{
   if (mode)
      CFRetain(mode);
   return mode;
}

size_t CGDisplayModeGetHeight(CGDisplayModeRef mode)
{
   NSDictionary* dict = (NSDictionary*) mode;
   return [[dict valueForKey:@"Height"] unsignedIntValue];
}

size_t CGDisplayModeGetWidth(CGDisplayModeRef mode)
{
   NSDictionary* dict = (NSDictionary*) mode;
   return [[dict valueForKey:@"Width"] unsignedIntValue];
}

double CGDisplayModeGetRefreshRate(CGDisplayModeRef mode)
{
   NSDictionary* dict = (NSDictionary*) mode;
   return [[dict valueForKey:@"RefreshRate"] doubleValue];
}

CFStringRef CGDisplayModeCopyPixelEncoding(CGDisplayModeRef mode)
{
   NSDictionary* dict = (NSDictionary*) mode;
   unsigned depth = [[dict valueForKey:@"Depth"] unsignedIntValue];

   switch (depth)
   {
      case 32:
         return CFSTR(IO32BitDirectPixels);
      case 16:
         return CFSTR(IO16BitDirectPixels);
      default:
         return CFSTR("");
   }
}

CFArrayRef CGDisplayCopyAllDisplayModes(CGDirectDisplayID displayIndex, CFDictionaryRef options)
{
   NSDisplay* display = [NSClassFromString(@"NSDisplay") currentDisplay];
   if (!display)
      return NULL;
   return (CFArrayRef) [[display modesForScreen:displayIndex-1] retain];
}

CGError CGDisplaySetDisplayMode(CGDirectDisplayID displayId, CGDisplayModeRef mode, CFDictionaryRef options)
{
   NSDisplay* display = [NSClassFromString(@"NSDisplay") currentDisplay];
   if (!display)
      return kCGErrorInvalidConnection;
   BOOL result = [display setMode:mode forScreen:displayId-1];

   return result ? kCGErrorSuccess : kCGErrorFailure;
}
