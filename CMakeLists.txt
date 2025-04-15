cmake_minimum_required(VERSION 3.28.3)
set(PROJECT_VERSION_MAJOR 0)
set(PROJECT_VERSION_MINOR 0)
set(PROJECT_VERSION_PATCH 1)
project(r_av VERSION ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH})

include(r_build.txt)
include(FFMPEGConfig.cmake)
include(FetchContent)

FetchContent_Declare(
    r_utils
    GIT_REPOSITORY https://github.com/dicroce/r_utils.git
    GIT_TAG        main
    FIND_PACKAGE_ARGS NAMES r_utils
)
FetchContent_MakeAvailable(r_utils)

add_library(
    r_av
    include/r_av/r_video_decoder.h
    source/r_video_decoder.cpp
    include/r_av/r_video_encoder.h
    source/r_video_encoder.cpp
    include/r_av/r_codec_state.h
    include/r_av/r_demuxer.h
    source/r_demuxer.cpp
    include/r_av/r_format_utils.h
    source/r_format_utils.cpp
    include/r_av/r_muxer.h
    source/r_muxer.cpp
)

target_include_directories(
    r_av PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>
    ${FFMPEG_INCLUDE_DIRS}
)

target_link_directories(
    r_av PUBLIC
    ${FFMPEG_LIB_DIRS}
)

target_link_libraries(
    r_av
    r_utils
    ${FFMPEG_LIBS}
)

add_subdirectory(ut)

if(PROJECT_IS_TOP_LEVEL)
configure_dev_package("r_av" "A C++ wrapper for ffmpeg.")
endif()
