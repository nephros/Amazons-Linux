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

    //property bool areSFXEnabled: false

    property int margin: Theme.paddingSmall

    onAccepted: {
        gameConfig.setValue("p1amazons", p1amazons.sliderValue)
        gameConfig.setValue("p2amazons", p2amazons.sliderValue)
        gameConfig.setValue("boardwidth", boardWidth.sliderValue)
        gameConfig.setValue("boardheight", boardHeight.sliderValue)
        appConfig.setValue("sfx", enableSFX.checked)
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
                checked: app.areSFXEnabled
                onCheckedChanged: app.areSFXEnabled = checked
            }
        }
    }
}
