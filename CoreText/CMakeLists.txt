project(CoreText)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} \
	-Wno-deprecated-objc-isa-usage \
	-mmacosx-version-min=10.10"
)

find_package(Freetype REQUIRED)

include_directories(
	${CMAKE_CURRENT_SOURCE_DIR}
	${FREETYPE_INCLUDE_DIRS}
)

set(CoreText_sources
	CTFont.m
	KTFont.m
	KTFont_FT.m
	constants.c
	stubs.c
)

set_source_files_properties(${CoreText_sources} LANGUAGE C)

set(DYLIB_COMPAT_VERSION "1.0.0")
set(DYLIB_CURRENT_VERSION "1.0.0")

add_framework(CoreText
	FAT
	CURRENT_VERSION
	SOURCES
		${CoreText_sources}
		VERSION "A"
	DEPENDENCIES
		objc
		system
		CoreFoundation
		Foundation
		CoreGraphics
		Onyx2D
		# native
		FreeType
)
