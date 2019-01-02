if(BUILD_OS_LINUX)
    ExternalProject_Add(zlib
        URL https://github.com/madler/zlib/archive/v1.2.11.tar.gz
        URL_HASH SHA256=629380c90a77b964d896ed37163f5c3a34f6e6d897311f1df2a7016355c45eff
        CONFIGURE_COMMAND ./configure --prefix=${CMAKE_INSTALL_PREFIX} --64
        BUILD_COMMAND make
        INSTALL_COMMAND make install
        BUILD_IN_SOURCE 1
    )
endif()
