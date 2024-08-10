
cmake_minimum_required(VERSION 3.14)
set(PROJECT_VERSION_MAJOR 0)
set(PROJECT_VERSION_MINOR 0)
set(PROJECT_VERSION_PATCH 1)
project(r_av VERSION ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH})

include(r_build.txt)
include(FetchContent)

FetchContent_Declare(
    r_utils
    GIT_REPOSITORY https://github.com/dicroce/r_utils.git
    GIT_TAG        main
)
FetchContent_MakeAvailable(r_utils)

find_package(PkgConfig)
pkg_search_module(SWSCALE REQUIRED libswscale) 
pkg_search_module(AVDEVICE REQUIRED libavdevice) 
pkg_search_module(AVFORMAT REQUIRED libavformat) 
pkg_search_module(AVCODEC REQUIRED libavcodec) 
pkg_search_module(AVUTIL REQUIRED libavutil) 

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
    include
    ../r_utils/include
    ${SWSCALE_INCLUDE_DIRS}
    ${AVDEVICE_INCLUDE_DIRS}
    ${AVFORMAT_INCLUDE_DIRS}
    ${AVCODEC_INCLUDE_DIRS}
    ${AVUTIL_INCLUDE_DIRS}
)

target_link_directories(
    r_av PUBLIC
    ${SWSCALE_LIB_DIRS}
    ${AVDEVICE_LIB_DIRS}
    ${AVFORMAT_LIB_DIRS}
    ${AVCODEC_LIB_DIRS}
    ${AVUTIL_LIB_DIRS}
)

target_link_libraries(
    r_av
    r_utils
    ${SWSCALE_LIBRARIES}
    ${AVDEVICE_LIBRARIES}
    ${AVFORMAT_LIBRARIES}
    ${AVCODEC_LIBRARIES}
    ${AVUTIL_LIBRARIES}
)

add_subdirectory(ut)
