cmake_minimum_required(VERSION 2.8)
project(machinekit-libnml)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} 
	"${CMAKE_SOURCE_DIR}/cmake/Modules/")

set(NML_SRC rcs/rcs_print.cc
	rcs/rcs_exit.cc
	os_intf/_sem.c
	os_intf/_shm.c
	os_intf/_timer.c
	os_intf/sem.cc
	os_intf/shm.cc
	os_intf/timer.cc
	buffer/locmem.cc
	buffer/memsem.cc
	buffer/phantom.cc
	buffer/physmem.cc
	buffer/recvn.c
	buffer/sendn.c
	buffer/shmem.cc
	buffer/tcpmem.cc
	cms/cms.cc
	cms/cms_aup.cc
	cms/cms_cfg.cc
	cms/cms_in.cc
	cms/cms_dup.cc
	cms/cms_pm.cc
	cms/cms_srv.cc
	cms/cms_up.cc
	cms/cms_xup.cc
	cms/cmsdiag.cc
	cms/tcp_opts.cc
	cms/tcp_srv.cc
	nml/cmd_msg.cc
	nml/nml_mod.cc
	nml/nml_oi.cc
	nml/nml_srv.cc
	nml/nml.cc
	nml/nmldiag.cc
	nml/nmlmsg.cc
	nml/stat_msg.cc
	linklist/linklist.cc)

set(NML_INC buffer/locmem.hh
	buffer/memsem.hh
	buffer/phantom.hh
	buffer/physmem.hh
	buffer/recvn.h
	buffer/rem_msg.hh
	buffer/sendn.h
	buffer/shmem.hh
	buffer/tcpmem.hh
	cms/cms_aup.hh
	cms/cms_cfg.hh
	cms/cmsdiag.hh
	cms/cms_dup.hh
	cms/cms.hh
	cms/cms_srv.hh
	cms/cms_up.hh
	cms/cms_user.hh
	cms/cms_xup.hh
	cms/tcp_opts.hh
	cms/tcp_srv.hh
	linklist/linklist.hh
	nml/cmd_msg.hh
	nml/nmldiag.hh
	nml/nml.hh
	nml/nml_mod.hh
	nml/nmlmsg.hh
	nml/nml_oi.hh
	nml/nml_srv.hh
	nml/nml_type.hh
	nml/stat_msg.hh
	os_intf/inetfile.hh
	os_intf/_sem.h
	os_intf/sem.hh
	os_intf/_shm.h
	os_intf/shm.hh
	os_intf/_timer.h
	os_intf/timer.hh
	posemath/gomath.h
	posemath/gotypes.h
	posemath/posemath.h
	posemath/sincos.h
	rcs/rcs_exit.hh
	rcs/rcs.hh
	rcs/rcs_print.hh
	rcs/rcsversion.h)

find_package(LinuxCNC REQUIRED)

include_directories(${LINUXCNC_INCLUDE_DIR})

add_library(inifile STATIC inifile/inifile.cc inifile/inifile.hh)
add_executable(inivar inifile/inivar.cc inifile/inifile.cc inifile/inifile.hh inifile/inifile.h)
add_library(nml MODULE ${NML_SRC} ${NML_INC})

add_library(posemath MODULE posemath/_posemath.c posemath/posemath.cc
			posemath/gomath.c posemath/sincos.c)
set_target_properties(posemath PROPERTIES COMPILE_DEFINITIONS "ULAPI")

add_library(posemath-posix STATIC posemath/_posemath.c posemath/posemath.cc
			posemath/gomath.c posemath/sincos.c)
set_target_properties(posemath-posix PROPERTIES 
			COMPILE_DEFINITIONS "RTAPI; \\
				THREAD_FLAVOR_ID=RTAPI_POSIX_ID")

add_library(posemath-rtpreempt STATIC posemath/_posemath.c posemath/posemath.cc
			posemath/gomath.c posemath/sincos.c)
set_target_properties(posemath-rtpreempt PROPERTIES 
			COMPILE_DEFINITIONS "RTAPI; \\
				THREAD_FLAVOR_ID=RTAPI_RT_PREEMPT_ID")

add_library(posemath-xenomai STATIC posemath/_posemath.c posemath/posemath.cc
			posemath/gomath.c posemath/sincos.c)
set_target_properties(posemath-xenomai PROPERTIES 
			COMPILE_DEFINITIONS "RTAPI; \\
				THREAD_FLAVOR_ID=RTAPI_XENOMAI_ID")

set(targets inivar nml posemath)

set(targets-dev inifile posemath-posix posemath-rtpreempt posemath-xenomai)

# install targets
install(TARGETS ${targets} 
	DESTINATION bin
	LIBRARY DESTINATION lib
	ARCHIVE DESTINATION lib)

install(TARGETS ${targets-dev} 
	DESTINATION bin
	LIBRARY DESTINATION lib
	ARCHIVE DESTINATION lib)

install(FILES ${NML_INC} DESTINATION include/linuxcnc)

set(CPACK_GENERATOR "DEB")
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "GP Orcullo")
 
include(CPack)