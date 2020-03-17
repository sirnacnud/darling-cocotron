project(Cocoa)

set(Cocoa_sources
	Cocoa.m
)

set_source_files_properties(${Cocoa_sources} LANGUAGE C)

set(DYLIB_COMPAT_VERSION "1.0.0")
set(DYLIB_CURRENT_VERSION "22.0.0")

add_framework(Cocoa
	FAT
	CURRENT_VERSION
	SOURCES
		${Cocoa_sources}
	VERSION "A"
	DEPENDENCIES
		objc
		system
		Foundation
		AppKit
		CoreData
)
