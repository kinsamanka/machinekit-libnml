# - Find LinuxCNC
# Find the LinuxCNC includes and library
#
#  LINUXCNC_INCLUDE_DIR - where to find header files.
#  LINUXCNC_LIBRARIES   - List of libraries.
#  LINUXCNC_FOUND       - True if LinuxCNC is found.


if(LINUXCNC_INCLUDE_DIR)
	# Already in cache, be silent
	set(LINUXCNC_FIND_QUIETLY TRUE)
endif(LINUXCNC_INCLUDE_DIR)

find_path(LINUXCNC_INCLUDE_DIR emc.hh PATHS /usr/include/linuxcnc)

set(LINUXCNC_NAMES nml linuxcncini linuxcnc linuxcnchal)

set(LINUXCNC_LIBRARY)
foreach(NAMES ${LINUXCNC_NAMES})
	find_library(LCNC_${NAMES}_lib NAMES ${NAMES} lib${NAMES})
	if(LCNC_${NAMES}_lib)
		list(APPEND LINUXCNC_LIBRARY ${LCNC_${NAMES}_lib})
	endif(LCNC_${NAMES}_lib)
endforeach(NAMES)


# handle the QUIETLY and REQUIRED arguments and set LIBDL_FOUND to TRUE if 
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LinuxCNC DEFAULT_MSG LINUXCNC_LIBRARY LINUXCNC_INCLUDE_DIR)

if(NOT LINUXCNC_FOUND)
	set(LINUXCNC_INCLUDE_DIR)
	set(LCNC_NML_lib)
	set(LCNC_LINUXCNCINI_lib)
	set(LCNC_LINUXCNC_lib)
	set(LCNC_LINUXCNCHAL_lib)
endif(NOT LINUXCNC_FOUND)

mark_as_advanced(LCNC_NML_lib LCNC_LINUXCNCINI_lib
		 LCNC_LINUXCNC_lib LCNC_LINUXCNCHAL_lib
		 LINUXCNC_INCLUDE_DIR)

