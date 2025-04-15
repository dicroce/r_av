if(NOT TARGET FFmpeg::ffmpeg)

    if(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
        add_library(FFmpeg::ffmpeg INTERFACE IMPORTED GLOBAL)

        target_include_directories(FFmpeg::ffmpeg INTERFACE
            "$ENV{FFMPEG_TOP_DIR}/include"
        )

        target_link_directories(FFmpeg::ffmpeg INTERFACE
            "$ENV{FFMPEG_TOP_DIR}/lib"
        )

        target_link_libraries(FFmpeg::ffmpeg INTERFACE
            swscale.lib
            avdevice.lib
            avformat.lib
            avcodec.lib
            avutil.lib
        )

        set(FFMPEG_LIBS FFmpeg::ffmpeg)
    endif()

    if(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
        find_package(PkgConfig REQUIRED)

        pkg_search_module(SWSCALE REQUIRED libswscale)
        pkg_search_module(AVDEVICE REQUIRED libavdevice)
        pkg_search_module(AVFORMAT REQUIRED libavformat)
        pkg_search_module(AVCODEC REQUIRED libavcodec)
        pkg_search_module(AVUTIL REQUIRED libavutil)

        add_library(FFmpeg::ffmpeg INTERFACE IMPORTED GLOBAL)

        target_include_directories(FFmpeg::ffmpeg INTERFACE
            ${SWSCALE_INCLUDE_DIRS}
            ${AVDEVICE_INCLUDE_DIRS}
            ${AVFORMAT_INCLUDE_DIRS}
            ${AVCODEC_INCLUDE_DIRS}
            ${AVUTIL_INCLUDE_DIRS}
        )

        target_link_directories(FFmpeg::ffmpeg INTERFACE
            ${SWSCALE_LIBRARY_DIRS}
            ${AVDEVICE_LIBRARY_DIRS}
            ${AVFORMAT_LIBRARY_DIRS}
            ${AVCODEC_LIBRARY_DIRS}
            ${AVUTIL_LIBRARY_DIRS}
        )

        target_link_libraries(FFmpeg::ffmpeg INTERFACE
            ${SWSCALE_LIBRARIES}
            ${AVDEVICE_LIBRARIES}
            ${AVFORMAT_LIBRARIES}
            ${AVCODEC_LIBRARIES}
            ${AVUTIL_LIBRARIES}
        )

        set(FFMPEG_LIBS FFmpeg::ffmpeg)
    endif()
endif()
