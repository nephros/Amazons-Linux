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

PullDownMenu {
		MenuItem {
			//iconName: "undo"
			visible: pageStack.depth === 1
			text: i18n.tr("Undo Choice")
			onClicked: gameViewPage.undoPlacement()
		},
		MenuItem {
			//iconName: "reload"
			visible: pageStack.depth === 1
			text: i18n.tr("New Standard Game")
			onClicked: gameViewPage.restartGame(false)
		},
		MenuItem {
			//iconName: "settings"
			visible: pageStack.depth === 1
			text: i18n.tr("Game Settings")
			onClicked: pageStack.push(setupView)
		},
		MenuItem {
			//iconName: "reset"
			visible: pageStack.depth === 1
			text: i18n.tr("New Custom Game")
			onClicked: gameViewPage.restartGame(true)
		},
		MenuItem {
			//iconName: "info"
			visible: pageStack.depth === 1
			text: i18n.tr("About Amazons")
			onClicked: pageStack.push(aboutView)
		},
		MenuItem {
			//iconName: "help"
			visible: pageStack.depth === 1
			text: i18n.tr("Gameplay Rules")
			onClicked: pageStack.push(rulesView)
		}
	]
}
