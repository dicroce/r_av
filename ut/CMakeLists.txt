
add_executable(
    r_av_ut
    include/framework.h
    source/framework.cpp
    include/test_r_mux.h
    source/test_r_mux.cpp
    include/test_r_codec.h
    source/test_r_codec.cpp
)

if(MSVC)
    target_link_options(r_av_ut PUBLIC "/STACK:10000000")
endif()

target_include_directories(
    r_av_ut PUBLIC 
    include
    ../include
    ${SWSCALE_INCLUDE_DIRS}
    ${AVDEVICE_INCLUDE_DIRS}
    ${AVFORMAT_INCLUDE_DIRS}
    ${AVCODEC_INCLUDE_DIRS}
    ${AVUTIL_INCLUDE_DIRS}
)

target_link_directories(
    r_av_ut PUBLIC
    ${SWSCALE_LIB_DIRS}
    ${AVDEVICE_LIB_DIRS}
    ${AVFORMAT_LIB_DIRS}
    ${AVCODEC_LIB_DIRS}
    ${AVUTIL_LIB_DIRS}
)

target_link_libraries(
    r_av_ut LINK_PUBLIC 
    r_utils
    r_av
    ${SWSCALE_LIBRARIES}
    ${AVDEVICE_LIBRARIES}
    ${AVFORMAT_LIBRARIES}
    ${AVCODEC_LIBRARIES}
    ${AVUTIL_LIBRARIES}
)
