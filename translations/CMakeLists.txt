find_package(Qt5LinguistTools REQUIRED)
find_program(Qt5_LCONVERT_EXECUTABLE lconvert)

file(GLOB PO_FILES ${PROJECT_SOURCE_DIR}/po/*.po)

# convert po files to qm
foreach(PO_FILE ${PO_FILES})
    get_filename_component(LANG ${PO_FILE} NAME_WE)
    set(QM_FILE harbour-${PROJECT_NAME}-${LANG}.qm)
    add_custom_target(conv_${LANG} ALL
        COMMENT "Generating Qt translation file from ${PO_FILE}"
        INPUT ${PO_FILE} OUTPUT ${QM_FILE}
        COMMAND ${Qt5_LCONVERT_EXECUTABLE}
                -verbose
                -source-language en
                -target-language ${LANG}
                -if po -i ${PO_FILE}
                -of qm
                -o ${QM_FILE}
    )
    install(FILES ${QM_FILE} DESTINATION ${DATA_DIR}/translations/)
endforeach(PO_FILE)
