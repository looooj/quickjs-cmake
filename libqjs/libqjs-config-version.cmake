message("===PACKAGE_FIND_VERSION ${PACKAGE_FIND_VERSION}")
set(PACKAGE_VERSION "1")
set(PACKAGE_VERSION_COMPATIBLE TRUE)

set(libqjs_source_version 2025-09-13 PARENT_SCOPE)

#message("==libqjs_source_version ${libqjs_source_version}")

if("${PACKAGE_FIND_VERSION}" EQUAL "1.6")
  set(libqjs_source_version "2025-09-13" PARENT_SCOPE)
endif()

if("${PACKAGE_FIND_VERSION}" EQUAL "1.5")
  set(libqjs_source_version "2025-04-26" PARENT_SCOPE)
endif()

if("${PACKAGE_FIND_VERSION}" EQUAL "1.4")
  set(libqjs_source_version "2024-01-13" PARENT_SCOPE)
endif()

if("${PACKAGE_FIND_VERSION}" EQUAL "1.3")
  set(libqjs_source_version "2023-12-09" PARENT_SCOPE)
endif()

if("${PACKAGE_FIND_VERSION}" EQUAL "1.2")
  set(libqjs_source_version "2021-03-27" PARENT_SCOPE)
endif()

if("${PACKAGE_FIND_VERSION}" EQUAL "1.1")
  set(libqjs_source_version "2020-11-08" PARENT_SCOPE)
endif()

if("${PACKAGE_FIND_VERSION}" EQUAL "1.0")
  set(libqjs_source_version "2020-11-08" PARENT_SCOPE)
endif()

#message("==libqjs_source_version ${libqjs_source_version}")
