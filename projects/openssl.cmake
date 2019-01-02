if(BUILD_OS_OSX)
    set(_openssl_os darwin64-x86_64-cc enable-ec_nistp_64_gcc_128)
    set(_openssl_args no-ssl2 no-ssl3 no-zlib shared enable-cms)

    ExternalProject_Add(OpenSSL
        URL https://www.openssl.org/source/openssl-1.0.2q.tar.gz
        URL_HASH SHA256=5744cfcbcec2b1b48629f7354203bc1e5e9b5466998bbccc5b5fcde3b18eb684
        CONFIGURE_COMMAND perl Configure --prefix=${CMAKE_INSTALL_PREFIX} ${_openssl_args} ${_openssl_os}
        BUILD_COMMAND make depend && make
        INSTALL_COMMAND make install
        BUILD_IN_SOURCE 1
    )
elseif(BUILD_OS_LINUX)
    set(_openssl_args
        no-ssl2 no-ssl3
        zlib shared enable-cms
        --with-zlib-include=${CMAKE_INSTALL_PREFIX}/include
        --with-zlib-lib=${CMAKE_INSTALL_PREFIX}/lib
        )

    ExternalProject_Add(OpenSSL
        URL https://www.openssl.org/source/openssl-1.0.2q.tar.gz
        URL_HASH SHA256=5744cfcbcec2b1b48629f7354203bc1e5e9b5466998bbccc5b5fcde3b18eb684
        CONFIGURE_COMMAND ./config --prefix=${CMAKE_INSTALL_PREFIX} ${_openssl_args} LDFLAGS='-Wl,--enable-new-dtags,-rpath,$(LIBRPATH)'
        BUILD_COMMAND make
        INSTALL_COMMAND make install
        BUILD_IN_SOURCE 1
    )
    SetProjectDependencies(TARGET OpenSSL DEPENDS zlib)
endif()

return()

if(BUILD_OS_WINDOWS)
    if(BUILD_OS_WIN32)
        set(_openssl_os "VC-WIN32")
        set(_openssl_build ms\\do_nasm.bat && nmake -f ms\\nt.mak)
    else()
        set(_openssl_os "VC-WIN64A")
        set(_openssl_build ms\\do_win64a.bat && nmake -f ms\\nt.mak)
    endif()

    ExternalProject_Add(OpenSSL
        URL https://www.openssl.org/source/openssl-1.0.2q.tar.gz
        URL_HASH SHA256=5744cfcbcec2b1b48629f7354203bc1e5e9b5466998bbccc5b5fcde3b18eb684
        CONFIGURE_COMMAND perl Configure ${_openssl_os} --prefix=${CMAKE_INSTALL_PREFIX}
        BUILD_COMMAND ${_openssl_build}
        INSTALL_COMMAND nmake -f ms\\nt.mak install
        BUILD_IN_SOURCE 1
    )
endif()
