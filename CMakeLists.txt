cmake_minimum_required(VERSION 3.16)

project(wataboard VERSION 1.0 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.3 COMPONENTS Quick Multimedia REQUIRED)

qt_add_executable(wataboard
    main.cpp
)

qt_add_qml_module(wataboard
    URI watasounds
    VERSION 1.0
    SOURCES resources.qrc
    QML_FILES main.qml WataBoard.qml WataButton.qml
)

set_target_properties(wataboard PROPERTIES
    WIN32_EXECUTABLE TRUE
)

target_compile_definitions(wataboard PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(wataboard PRIVATE Qt6::Quick Qt6::Multimedia)
