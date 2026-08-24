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

Page {
	id: aboutPage

	ScrollView {
		id: scroll
        /*
		anchors {
			top: header.bottom
			top: header.bottom
			topMargin: margin
			left: parent.left
			leftMargin: margin
			right: parent.right
			rightMargin: margin
			bottom: parent.bottom
		}
        */
        anchors.fill: parent
        anchors.margins: Theme.paddingSmall
        contentHeight: content.height


	    PageHeader { id: header; title: i18n.tr("Amazons") }

        PullDownMenu {
            MenuItem {
                text: i18n.tr("Gameplay Rules")
                onClicked: pageStack.push(rulesView)
            }
            MenuItem {
                text: i18n.tr("Game Settings")
                onClicked: pageStack.push(setupView)
            }
        }

		Column { id: content
            anchors.top: header.bottom
			width: scroll.width
			spacing: Theme.paddingLarge

			WrappingLabel {
				text: "Game of the Amazons - " + i18n.tr("written by Arc676/Alessandro Vinciguerra. Project available under") + " GPLv3. Copyright 2019-20 Arc676/Alessandro Vinciguerra <alesvinciguerra@gmail.com>"
			}

			WrappingLabel {
				text: i18n.tr("This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation (version 3).")
			}

			WrappingLabel {
				text: i18n.tr("This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.")
			}

			WrappingLabel {
				text: i18n.tr("For the full license text, visit the <a href='https://github.com/Arc676/Amazons-Linux'>repository</a> or the <a href='http://www.gnu.org/licenses/'>GNU licenses page</a>")
			}

			WrappingLabel {
				text: i18n.tr("%1 assets").arg("<a href='https://creativecommons.org/licenses/by-nc-sa/4.0/'>CC BY-NC-SA 4.0</a>")
				font.pixelSize: Theme.fontSizeLarge
				//textSize: Label.Large
			}

			WrappingLabel {
				text: i18n.tr("All assets by Arc676/Alessandro Vinciguerra adapted from CC0 assets by %1").arg("<a href='https://opengameart.org/content/rpg-itemterraincharacter-sprites-ice-insignia'>rcorre</a>")
			}

			WrappingLabel {
				text: i18n.tr("ported to Sailfish OS by nephros")
			}


		}
	}
}
