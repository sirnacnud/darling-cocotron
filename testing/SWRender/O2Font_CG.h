//
//  O2Font_CG.h
//  SWRender
//
//  Created by Christopher Lloyd on 10/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <ApplicationServices/ApplicationServices.h>
#import <Onyx2D/O2Font_ttf.h>

@interface O2Font_CG : O2Font_ttf {
    CGFontRef _cgFont;
}

@end
