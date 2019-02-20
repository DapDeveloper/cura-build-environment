if(BUILD_OS_OSX)
    ExternalProject_Add(Freetype
        URL https://download.savannah.gnu.org/releases/freetype/freetype-2.9.1.tar.gz
        URL_HASH SHA256=ec391504e55498adceb30baceebd147a6e963f636eb617424bcfc47a169898ce
        CONFIGURE_COMMAND ./configure
            --prefix=${CMAKE_INSTALL_PREFIX}
            --enable-freetype-config
            --without-zlib
            --without-bzip2
            --without-png
            --without-harfbuzz
            --with-sysroot=${CMAKE_OSX_SYSROOT}
        BUILD_COMMAND make
        INSTALL_COMMAND make install
        BUILD_IN_SOURCE 1
    )
endif()
