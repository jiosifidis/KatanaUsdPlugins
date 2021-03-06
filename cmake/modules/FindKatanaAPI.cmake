# These files began life as part of the main USD distribution
# https://github.com/PixarAnimationStudios/USD.
# In 2019, Foundry and Pixar agreed Foundry should maintain and curate
# these plug-ins, and they moved to
# https://github.com/TheFoundryVisionmongers/KatanaUsdPlugins
# under the same Modified Apache 2.0 license, as shown below.
#
# Copyright 2016 Pixar
#
# Licensed under the Apache License, Version 2.0 (the "Apache License")
# with the following modification; you may not use this file except in
# compliance with the Apache License and the following modification to it:
# Section 6. Trademarks. is deleted and replaced with:
#
# 6. Trademarks. This License does not grant permission to use the trade
#    names, trademarks, service marks, or product names of the Licensor
#    and its affiliates, except as required to comply with Section 4(c) of
#    the License and to reproduce the content of the NOTICE file.
#
# You may obtain a copy of the Apache License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the Apache License with the above modification is
# distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied. See the Apache License for the specific
# language governing permissions and limitations under the Apache License.
#
# - Find Katana API
#
# Finds an installed Katana plugin API
#
# Variables that will be defined:
# KATANA_API_FOUND         Defined if a Katana installation has been detected
# KATANA_API_INCLUDE_DIR   Path to the Katana API include directories
# KATANA_API_SOURCE_DIR    Path to the Katana API source directories
# KATANA_API_VERSION       Katana API version
# KATANA_BIN               Path to the Katana executable file

find_path(KATANA_API_BASE_DIR
    NAMES
        bin/katanaBin
        bin/katanaBin.exe
    HINTS
        "${KATANA_API_LOCATION}"
        "$ENV{KATANA_API_LOCATION}"
)

set(KATANA_API_HEADER FnAPI/FnAPI.h)

find_path(KATANA_API_INCLUDE_DIR 
    ${KATANA_API_HEADER}
    HINTS
        "${KATANA_API_LOCATION}"
        "$ENV{KATANA_API_LOCATION}"
        "${KATANA_API_BASE_DIR}"
    PATH_SUFFIXES
        plugin_apis/include/
    DOC
        "Katana plugin API headers path"
)

if(KATANA_API_INCLUDE_DIR AND EXISTS "${KATANA_API_INCLUDE_DIR}/${KATANA_API_HEADER}")
    foreach(comp MAJOR MINOR RELEASE)
        file(STRINGS
            ${KATANA_API_INCLUDE_DIR}/${KATANA_API_HEADER}
            TMP
            REGEX "#define KATANA_VERSION_${comp} .*$")
        string(REGEX MATCHALL "[0-9]+" KATANA_API_${comp}_VERSION ${TMP})
    endforeach()
    set(KATANA_API_VERSION ${KATANA_API_MAJOR_VERSION}.${KATANA_API_MINOR_VERSION}.${KATANA_API_RELEASE_VERSION})
endif()

find_path(KATANA_API_SOURCE_DIR 
    FnConfig/FnConfig.cpp
    HINTS
        "${KATANA_API_LOCATION}"
        "$ENV{KATANA_API_LOCATION}"
        "${KATANA_API_BASE_DIR}"
    PATH_SUFFIXES
        plugin_apis/src/
    DOC
        "Katana plugin API source path"
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Katana
    REQUIRED_VARS
        KATANA_API_BASE_DIR
        KATANA_API_INCLUDE_DIR
        KATANA_API_SOURCE_DIR
    VERSION_VAR
        KATANA_API_VERSION
)

set(KATANA_API_INCLUDE_DIRS ${KATANA_API_INCLUDE_DIR})

set(KATANA_BIN "${KATANA_API_BASE_DIR}/bin/katanaBin")
if(CMAKE_SYSTEM_NAME MATCHES Windows)
    set(KATANA_BIN "${KATANA_BIN}.exe")
endif()
