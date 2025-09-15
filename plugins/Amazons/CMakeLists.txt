set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
set(PLUGIN "Amazons")

set(
    SRC
    plugin.cpp
    amazons.cpp
)

set(CMAKE_AUTOMOC ON)

include_directories(${CMAKE_SOURCE_DIR}/plugins/Amazons/lib/Amazons)
link_directories(${CMAKE_SOURCE_DIR}/plugins/Amazons/lib/Amazons)

add_custom_target(BuildBackend ALL
    COMMAND make -C ${CMAKE_SOURCE_DIR}/plugins/Amazons/lib/Amazons CC=${CMAKE_C_COMPILER} clean lib
)

add_library(${PLUGIN} MODULE ${SRC})
add_dependencies(${PLUGIN} BuildBackend)
target_link_libraries(${PLUGIN} ${CMAKE_SOURCE_DIR}/plugins/Amazons/lib/Amazons/libamazons.a)
set_target_properties(${PLUGIN} PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${PLUGIN})
qt5_use_modules(${PLUGIN} Qml Quick DBus)

execute_process(
    COMMAND dpkg-architecture -qDEB_HOST_MULTIARCH
    OUTPUT_VARIABLE ARCH_TRIPLET
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

set(QT_IMPORTS_DIR "/lib/${ARCH_TRIPLET}")

install(TARGETS ${PLUGIN} DESTINATION ${QT_IMPORTS_DIR}/${PLUGIN}/)
install(FILES qmldir DESTINATION ${QT_IMPORTS_DIR}/${PLUGIN}/)
