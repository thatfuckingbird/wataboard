cmake_minimum_required(VERSION 3.16)

project(Wataboard VERSION 1.0 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.3 COMPONENTS Quick Multimedia REQUIRED)

qt_add_executable(Wataboard
        main.cpp
)

qt_add_qml_module(Wataboard
    URI watasounds
    VERSION 1.0
    SOURCES resources.qrc
    QML_FILES main.qml WataBoard.qml WataButton.qml WataButtonGroup.qml
)

set_property(TARGET Wataboard APPEND PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/android)

set_target_properties(Wataboard PROPERTIES
    WIN32_EXECUTABLE TRUE
)

target_compile_definitions(Wataboard PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(Wataboard PRIVATE Qt6::Quick Qt6::Multimedia)
