function(add_backend name)
	cmake_parse_arguments(BACKEND "" "INFO_PLIST" "SOURCES;DEPENDENCIES;RESOURCES" ${ARGN})
	set(path "/System/Library/Frameworks/CoreGraphics.framework/Versions/C/Resources/Backends/${name}.backend/Contents")
	set(DYLIB_INSTALL_NAME "${path}/MacOS/${name}")

	add_darling_library(${name}_cgbackend SHARED ${BACKEND_SOURCES})
	set_target_properties(${name}_cgbackend PROPERTIES OUTPUT_NAME "${name}" SUFFIX "" PREFIX "")
	make_fat(${name}_cgbackend)

	if (BACKEND_DEPENDENCIES)
		target_link_libraries(${name}_cgbackend PRIVATE ${BACKEND_DEPENDENCIES})
	endif (BACKEND_DEPENDENCIES)

	install(TARGETS ${name}_cgbackend DESTINATION "libexec/darling${path}/MacOS")
	install(FILES ${BACKEND_INFO_PLIST} DESTINATION "libexec/darling${path}" RENAME Info.plist)

	if (BACKEND_RESOURCES)
		while (BACKEND_RESOURCES)
			list(GET BACKEND_RESOURCES 0 res_install_path)
			list(GET BACKEND_RESOURCES 1 res_source_path)
			get_filename_component(res_install_dir ${res_install_path} DIRECTORY)
			get_filename_component(res_install_name ${res_install_path} NAME)
			install(FILES ${res_source_path}
				DESTINATION libexec/darling${path}/Resources/${res_install_dir}
				RENAME ${res_install_name})
			list(REMOVE_AT BACKEND_RESOURCES 0 1)
		endwhile (BACKEND_RESOURCES)
	endif (BACKEND_RESOURCES)
endfunction(add_backend)

add_backend(X11
	SOURCES
		CGSConnectionX11.m
		CGSWindowX11.m
		CGSSurfaceX11.m
		X11KeySymToUCS.m
	INFO_PLIST
		Info.plist
	DEPENDENCIES
		objc
		system
		CoreFoundation
		Foundation
		AppKit
		Onyx2D
		CoreGraphics
		OpenGL
		QuartzCore
		# native libraries
                X11
		XRandR
		Xcursor
		fontconfig
		xkbfile
)
