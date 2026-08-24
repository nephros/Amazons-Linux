/*
 * SPDX-FileCopyrightText: Copyright (c) 2026 Peter G. (nephros)
 */
import QtQuick 2.6
import Sailfish.Silica 1.0
import "compat"

ApplicationWindow {
    id: app

    allowedOrientations: defaultAllowedOrientations
    Component.onCompleted: {
        console.info("Game Of The Amazons (%1.%2) v%3 is starting.".arg(Qt.application.organization).arg(Qt.application.name).arg(Qt.application.version))
    }

    cover: coverPage
    initialPage: Component { GameView {} }

    // UT compat helpers:
    property alias units: units
    property alias i18n: i18n
    UbuUnits { id: units }
    QtObject { id: i18n; function tr(s) { return qsTr(s) } }

    Component { id: coverPage
        CoverBackground {
            Image {
                source: "./cover-background.png"
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
                }
                //height: parent.height
                width: parent.width
                sourceSize.width: width
                fillMode: Image.PreserveAspectFit
                opacity: 0.2
            }
            CoverPlaceholder {
                text: "Game of the Amazons"
                textColor: Theme.highlightColor
            }
        }
    }

    Component { id: defaultPulley
        PullDownMenu {
            MenuItem {
                text: i18n.tr("About Amazons")
                onClicked: pageStack.push(aboutView)
            }
//            MenuItem {
//                text: i18n.tr("Gameplay Rules")
//                onClicked: pageStack.push(rulesView)
//            }
//            MenuItem {
//                text: i18n.tr("Game Settings")
//                onClicked: pageStack.push(setupView)
//            }
            MenuItem {
                text: i18n.tr("New Standard Game")
                onClicked: gameViewPage.restartGame(false)
            }
            MenuItem {
                text: i18n.tr("New Custom Game")
                onClicked: gameViewPage.restartGame(true)
            }
            MenuItem {
                text: i18n.tr("Undo Choice")
                onClicked: gameViewPage.undoPlacement()
            }
        }
    }

    property SetupView setupView: SetupView { }

    /*
    property GameView gameView: GameView {
        setup: pageViewer.setupView
        visible: false
    }
    */

    property AboutView aboutView: AboutView { }

    property RulesView rulesView: RulesView { }
}

// vim: filetype=javascript syntax=qml expandtab tabstop=4 shiftwidth=4
