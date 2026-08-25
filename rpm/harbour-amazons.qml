/*
 * SPDX-FileCopyrightText: Copyright (c) 2026 Peter G. (nephros)
 */
import QtQuick 2.6
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0
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

    // application settings:
    property alias appConfig: appConfig
    property alias gameConfig: gameConfig
    ConfigurationGroup  {
        id: settings
        path: "/org/nephros/" + Qt.application.name
    }
    ConfigurationGroup  {
        id: appConfig
        scope: settings
        path:  "app"
    }
    ConfigurationGroup  {
        id: gameConfig
        scope: settings
        path:  "game"
    }


    Component { id: coverPage
        CoverBackground {
            CoverPlaceholder {
                text: "Game of the Amazons"
                textColor: Theme.highlightColor
                icon.source: "./cover-background.png"
                icon.height: Theme.iconSizeLarge
                icon.width: Theme.iconSizeLarge
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
