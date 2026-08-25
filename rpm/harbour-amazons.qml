/*
 * SPDX-FileCopyrightText: Copyright (c) 2026 Peter G. (nephros)
 */
import QtQuick 2.6
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0
import "compat"
import "manifest.js" as AppManifest

ApplicationWindow {
    id: app

    allowedOrientations: defaultAllowedOrientations
    Component.onCompleted: {
        var m = AppManifest.data()
        console.info("%1 (%2.%3) v%4: %5 by %6"
            .arg(m.title)
            .arg(Qt.application.organization)
            .arg(Qt.application.name)
            .arg(m.version)
            .arg(m.description)
            .arg(m.maintainer)
        )
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

    property bool areSFXEnabled: false

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
}

// vim: filetype=javascript syntax=qml expandtab tabstop=4 shiftwidth=4
