find_package(Qt5LinguistTools REQUIRED)
find_program(Qt5_LCONVERT_EXECUTABLE lconvert)

set(DOMAIN ${FULL_PROJECT_NAME})
set(POT_FILE ${PROJECT_SOURCE_DIR}/po/${DOMAIN}.pot)
file(GLOB PO_FILES ${PROJECT_SOURCE_DIR}/po/*.po)
#file(GLOB SOURCE_FILES ../qml/*.qml)

set(TS_MASTER harbour-${PROJECT_NAME}.ts)

add_custom_target(${TS_MASTER} ALL
        COMMENT "Generating Qt Liguist translation template"
        COMMAND cat ${POT_FILE} | tr "CHARSET" "UTF-8" | ${Qt5_LCONVERT_EXECUTABLE}
                -if pot -i -
                -of ts -o ${CMAKE_CURRENT_SOURCE_DIR}/${TS_MASTER}
    )

# convert po files to .ts
foreach(PO_FILE ${PO_FILES})
    get_filename_component(LANG ${PO_FILE} NAME_WE)
    set(TS_FILE harbour-${PROJECT_NAME}-${LANG}.ts)
    set(QM_FILE harbour-${PROJECT_NAME}-${LANG}.qm)
    add_custom_target(conv_${LANG} ALL
        COMMENT "Generating TS file from ${PO_FILE}"
        COMMAND ${Qt5_LCONVERT_EXECUTABLE}
                -verbose
                -source-language en
                -target-language ${LANG}
                -if po -i ${PO_FILE}
                -if ts -i ${TS_FILE}
                -of qm
                -o ${CMAKE_CURRENT_BINARY_DIR}/${QM_FILE}
    )
    install(FILES  ${CMAKE_CURRENT_BINARY_DIR}/${QM_FILE} DESTINATION ${DATA_DIR}/translations/)
endforeach(PO_FILE)
