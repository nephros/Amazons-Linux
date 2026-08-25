// Copyright (C) 2019-20 Arc676/Alessandro Vinciguerra <alesvinciguerra@gmail.com>

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation (version 3)

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

import QtQuick 2.4
import Sailfish.Silica 1.0
import "compat"

Dialog {
    id: setupPage

    property bool areSFXEnabled: false

    property int margin: Theme.paddingSmall

    onAccepted: {
        gameConfig.setValue("p1amazons", p1amazons.sliderValue)
        gameConfig.setValue("p2amazons", p2amazons.sliderValue)
        gameConfig.setValue("boardwidth", boardWidth.sliderValue)
        gameConfig.setValue("boardheight", boardHeight.sliderValue)
        appConfig.setValue("sfx", enableSFX.checked)
        colorScheme = new Object(colorSchemes.get(colorSchemeIdx))
        appConfig.setValue("colorScheme", colorSchemeIdx)
    }

    function parseWithDefault(text, def) {
        var parsed = parseInt(text)
        if (isNaN(parsed) || parsed <= 0) {
            return def
        }
        return parsed
    }

    function getAmazons(player) {
        return parseWithDefault(player === 1 ? p1amazons.sliderValue : p2amazons.sliderValue, 4)
    }

    function getBoardSize(axis) {
        return parseWithDefault(axis === 1 ? boardHeight.sliderValue : boardWidth.sliderValue, 10)
    }
    property QtObject colorScheme: {}
    property int colorSchemeIdx: appConfig.calue("colorScheme", 0)
    ListModel { id: colorSchemes
        ListElement {
            displayName: ""
            whiteSquare: "#FFFFFF"
            blackSquare: "#7F7F7F"
            greenSquare: ""
            redSquare:   ""
        }
        ListElement {
            displayName: ""
            whiteSquare: "#edead9"
            blackSquare: "#2f0d02"
            greenSquare: ""
            redSquare:   ""
        }
        ListElement {
            displayName: ""
            blackSquare: "#b96829"
            whiteSquare: "#171717"
            greenSquare: ""
            redSquare:   ""
        }
        ListElement {
            displayName: ""
            whiteSquare: "#d1843a"
            blackSquare: "#191106"
            greenSquare: ""
            redSquare:   ""
        }
        // work around ListElement: cannot use script for property value
        Component.onCompleted: {
            setProperty(0, "displayName", i18n.tr("Default"))
            setProperty(0, "greenSquare", Theme.rgba(Theme.highlightFromColor(Qt.rgba(0, 255, 0, 0.5), Theme.colorScheme), 0.5).toString())
            setProperty(0, "redSquare",   Theme.rgba(Theme.highlightFromColor("#FF0000", Theme.colorScheme), 0.5).toString())
            setProperty(1, "displayName", i18n.tr("White Ground"))
            setProperty(1, "greenSquare", Theme.rgba("#debf6f", 0.5).toString())
            setProperty(1, "redSquare",   Theme.rgba("#ab1e21", 0.5).toString())
            setProperty(2, "displayName", i18n.tr("Black Figure"))
            setProperty(2, "greenSquare", Theme.rgba("#b69560", 0.5).toString())
            setProperty(2, "redSquare",   Theme.rgba("#5b362c", 0.5).toString())
            setProperty(3, "displayName", i18n.tr("Red Figure"))
            setProperty(3, "greenSquare", Theme.rgba("#f6d6ad", 0.5).toString())
            setProperty(3, "redSquare",   Theme.rgba("#d41d3e", 0.5).toString())
            colorScheme = new Object(colorSchemes.get(colorSchemeIdx))
        }
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: content.height
        Column { id: content
            width: parent.width
            spacing: Theme.paddingLarge

            DialogHeader { id: header; }//title: i18n.tr("Game Settings") }

            Slider { id: p1amazons
                width: parent.width
                label: i18n.tr("Player 1 Amazons")
                stepSize: 1
                minimumValue: 3
                maximumValue: 7
                value: gameConfig.value("p1amazons", 4)
                valueText: sliderValue
                handleVisible: true
            }

            Slider { id: p2amazons
                width: parent.width
                label: i18n.tr("Player 2 Amazons")
                stepSize: 1
                minimumValue: 3
                maximumValue: 7
                value: gameConfig.value("p2amazons", 4)
                valueText: sliderValue
                handleVisible: true
            }

            Slider { id: boardWidth
                width: parent.width
                label: i18n.tr("Board width")
                stepSize: 1
                minimumValue: 7
                maximumValue: 19
                value: gameConfig.value("boardwidth", 10)
                valueText: sliderValue
                handleVisible: true
            }

            Slider { id: boardHeight
                width: parent.width
                label: i18n.tr("Board height")
                stepSize: 1
                minimumValue: 7
                maximumValue: 19
                value: gameConfig.value("boardheight", 10)
                valueText: sliderValue
                handleVisible: true
            }

            TextSwitch {
                id: enableSFX
                width: parent.width
                text: i18n.tr("Enable sound effects")
                checked: areSFXEnabled
                onCheckedChanged: areSFXEnabled = checked
            }

            SectionHeader { text: i18n.tr("Color Scheme") }

            Grid { id: colorGrid
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Theme.paddingLarge
                rows: 2; columns: 2
                Repeater { model: colorSchemes
                delegate: GridItem {
                        onClicked: { colorSchemeIdx = index }
                        width: units.gu(8); height:  units.gu(4) + label.height
                        Row { id: row
                            Rectangle { width: units.gu(4); height: width; color: whiteSquare }
                            Rectangle { width: units.gu(4); height: width; color: blackSquare }
                        }
                        Label { id: label
                            anchors.top: row.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: model.displayName
                            font.pixelSize: Theme.fontSizeTiny
                            color: colorSchemeIdx == index ? Theme.primaryColor : Theme.secondaryHighlightColor
                        }
                    }
                }
            }
        }
    }
}
