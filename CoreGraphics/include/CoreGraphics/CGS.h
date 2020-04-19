#ifndef _CGS_H_
#define _CGS_H_
#include <CoreGraphics/CGError.h>

#ifdef __cplusplus
extern "C" {
#endif

// Private APIs

CGError CGSSetDenyWindowServerConnections(Boolean deny);
void CGSShutdownServerConnections(void);

#ifdef __cplusplus
}
#endif

#endif
