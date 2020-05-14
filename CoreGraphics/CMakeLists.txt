project(CoreGraphics)

include(darling_framework)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} \
	-include math.h \
	-include stdlib.h \
	-include CoreFoundation/CoreFoundation.h \
	-Wno-nonportable-include-path \
	-mmacosx-version-min=10.10"
)

find_package(PkgConfig REQUIRED)
pkg_check_modules(PC_CAIRO cairo)

set_property(SOURCE 
	CGAffineTransform.m
	CGBitmapContext.m
	CGColor.m
	CGColorSpace.m
	CGContext.m
	CGDataConsumer.m
	CGDataProvider.m
	CGDirectDisplay.m
	CGFont.m
	CGFunction.m
	CGGeometry.m
	CGGradient.m
	CGImageDestination.m
	CGImage.m
	CGImageProperties.m
	CGImageSource.m
	CGLayer.m
	CGLPixelSurface.m
	CGPath.m
	CGPattern.m
	CGPDFContext.m
	CGPDFDocument.m
	CGPDFPage.m
	CGShading.m
	CGWindow.m
	CGSubWindow.m
	CGS.m
	CGSConnection.m
	CGSWindow.m
	CGSSurface.m
	CGSRegion.m

	APPEND PROPERTY COMPILE_FLAGS "-include Foundation/Foundation.h"
)

include_directories(
	${CMAKE_SOURCE_DIR}/src/external/icu/icuSources/i18n
	${CMAKE_SOURCE_DIR}/src/external/icu/icuSources/common

	${CMAKE_CURRENT_SOURCE_DIR}
	${CMAKE_CURRENT_SOURCE_DIR}/..
	${CMAKE_CURRENT_SOURCE_DIR}/../CoreText

	${PC_CAIRO_INCLUDE_DIRS}
)

set(CoreGraphics_sources
	CGAffineTransform.m
	CGBitmapContext.m
	CGColor.m
	CGColorSpace.m
	CGContext.m
	CGDataConsumer.m
	CGDataProvider.m
	CGDirectDisplay.m
	src/CGEvent.c
	src/stubs.c
	CGFont.m
	CGFunction.m
	CGGeometry.m
	CGGradient.m
	CGImage.m
	CGLayer.m
	CGLPixelSurface.m
	CGPath.m
	CGPattern.m
	CGPDFContext.m
	CGPDFDocument.m
	CGPDFPage.m
	CGShading.m
	CGWindow.m
	CGSubWindow.m
	CGDisplayFade.m
	CGS.m
	CGSConnection.m
	CGSWindow.m
	CGSSurface.m
	CGSRegion.m
	CGEvent.m
	CGEventSource.m
	CGEventTap.m
	CGEventObjC.m
	# KTFont+PDF.m 'KGPDFArray.h' file not found
)

set_source_files_properties(${CoreGraphics_sources} LANGUAGE C)

set(DYLIB_COMPAT_VERSION "64.0.0")
set(DYLIB_CURRENT_VERSION "1070.22.0")

add_framework(CoreGraphics
	FAT
	CURRENT_VERSION
	SOURCES
		${CoreGraphics_sources}
	VERSION "A"
	DEPENDENCIES
		objc
		system
		CoreFoundation
		Foundation
		Onyx2D
		GL
		IOKit
)
