set(pyqt_command "")
if(BUILD_OS_WINDOWS)
    add_custom_target(PyQt
        COMMAND ${PYTHON_EXECUTABLE} -m pip install PyQt5==5.12.1
        COMMENT "Installing PyQt5"
    )

    SetProjectDependencies(TARGET PyQt DEPENDS Python)
else()
    if(BUILD_OS_OSX)
        set(pyqt_command
            "DYLD_LIBRARY_PATH=${CMAKE_INSTALL_PREFIX}/lib"
            ${PYTHON_EXECUTABLE} configure.py
            --sysroot ${CMAKE_INSTALL_PREFIX}
            --qmake ${CMAKE_INSTALL_PREFIX}/bin/qmake
            --sip ${CMAKE_INSTALL_PREFIX}/bin/sip
            --confirm-license
        )
    else()
        set(pyqt_command
            # On Linux, PyQt configure fails because it creates an executable that does not respect RPATH
            "LD_LIBRARY_PATH=${CMAKE_INSTALL_PREFIX}/lib"
            ${PYTHON_EXECUTABLE} configure.py
            --sysroot ${CMAKE_INSTALL_PREFIX}
            --qmake ${CMAKE_INSTALL_PREFIX}/bin/qmake
            --sip ${CMAKE_INSTALL_PREFIX}/bin/sip
            --confirm-license
        )
    endif()

    # Since PyQt5 5.11, PyQt5 requires its standalone sip module which needs to be built with the option
    # --sip-module PyQt5.sip. See https://www.riverbankcomputing.com/static/Docs/PyQt5/installation.html
    ExternalProject_Add(PyQtSip
        URL https://www.riverbankcomputing.com/static/Downloads/sip/4.19.15/sip-4.19.15.tar.gz
        URL_MD5 236578d2199da630ae1251671b9a7bfe
        CONFIGURE_COMMAND ${PYTHON_EXECUTABLE} configure.py --sip-module PyQt5.sip
        BUILD_IN_SOURCE 1
    )
    SetProjectDependencies(TARGET PyQtSip DEPENDS Python)

    ExternalProject_Add(PyQt
        URL https://www.riverbankcomputing.com/static/Downloads/PyQt5/5.12.1/PyQt5_gpl-5.12.1.tar.gz
        URL_MD5 67508b652098d2e05c4c2b5baeb170cc
        CONFIGURE_COMMAND ${pyqt_command}
        BUILD_IN_SOURCE 1
    )

    SetProjectDependencies(TARGET PyQt DEPENDS Qt PyQtSip)
endif()
