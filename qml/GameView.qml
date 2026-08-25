// Copyright (C) 2019-21 Arc676/Alessandro Vinciguerra <alesvinciguerra@gmail.com>

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
import QtMultimedia 5.6
//import "compat"

import Amazons 1.0

Page {
	id: gameViewPage

	property bool isSettingUp: false
	property bool isGameOver: false

	property int pickedPositions: 0
	property var initialPositions: []
	property int p1count: 0
	property int p2count: 0
	property int clickedSquare: 0

    property SetupView setupView: SetupView { }

    QtObject{ id: stateLabel
        property string text: i18n.tr("Bows to move")
    }

	function undoPlacement() {
		if (isSettingUp) {
			if (pickedPositions > 0) {
				pickedPositions--
				initialPositions.pop()
				initialPositions.pop()
				if (pickedPositions < p1count) {
					stateLabel.text = i18n.tr("Tap initial starting positions for first player")
				}
			}
		} else {
			clickedSquare = 0
		}
		gameCanvas.requestPaint()
	}

    SoundEffect { id: clickfx
        source: "sfx/click.wav"
    }
    SoundEffect { id: arrowfx
        source: "sfx/arrow.wav"
    }
    SoundEffect { id: spearfx
        source: "sfx/spear.wav"
    }
    SoundEffect { id: gameoverfx
        //source: "sfx/spear.wav"
    }
	function playSound(sfx) {
		if (setupView.areSFXEnabled) {
			if (sfx == "click")
				clickfx.play()
			else if (sfx == "white")
				arrowfx.play()
			else if (sfx == "black")
				spearfx.play()
			else if (sfx == "gameover")
				gameoverfx.play()
		}
	}

	function restartGame(custom) {
		if (custom) {
			var wp = setupView.getAmazons(1)
			var bp = setupView.getAmazons(2)
			var bh = setupView.getBoardSize(1)
			var bw = setupView.getBoardSize(2)
			gameViewPage.isSettingUp = true
			gameViewPage.pickedPositions = 0
			gameViewPage.initialPositions = []
			gameViewPage.clickedSquare = 0
			Amazons.setGameProperties(wp, bp, bw, bh)
			gameViewPage.p1count = wp
			gameViewPage.p2count = bp
			stateLabel.text = i18n.tr("Tap initial starting positions for first player")
		} else {
			newStandardGame()
		}
	}

	function newStandardGame() {
		var wstart = [3, 0, 0, 3, 0, 6, 3, 9]
		var bstart = [6, 0, 9, 3, 9, 6, 6, 9]
		Amazons.setGameProperties(4, 4, 10, 10)
		gameViewPage.p1count = 4
		gameViewPage.p2count = 4
		Amazons.startGame(wstart, bstart)
		gameViewPage.isSettingUp = false
		gameViewPage.isGameOver = false
		gameViewPage.clickedSquare = 0
		stateLabel.text = i18n.tr("Bows to move")
	}

	onStatusChanged: if(status === PageStatus.Active) gameCanvas.requestPaint()
	Connections {
		target: app
        onApplicationActiveChanged: if (applicationActive) gameCanvas.requestPaint()
    }
	Connections {
		target: Amazons

		onRedraw: gameCanvas.requestPaint()
		onBoardSizeChanged: {
			gameCanvas.width = Amazons.getBoardWidth() * gameCanvas.squareSize
			gameCanvas.height = Amazons.getBoardHeight() * gameCanvas.squareSize
//			flick.contentWidth = gameCanvas.width
//			flick.contentHeight = gameCanvas.height
			gameCanvas.requestPaint()
		}
	}

    /*
	Component {
		id: confirmRestartNotif

		ConfirmDialog {
			onRestart: {
				if (custom) {
					var wp = setup.getAmazons(1)
					var bp = setup.getAmazons(2)
					var bh = setup.getBoardSize(1)
					var bw = setup.getBoardSize(2)
					gameViewPage.isSettingUp = true
					gameViewPage.pickedPositions = 0
					gameViewPage.initialPositions = []
					gameViewPage.clickedSquare = 0
					Amazons.setGameProperties(wp, bp, bw, bh)
					gameViewPage.p1count = wp
					gameViewPage.p2count = bp
					stateLabel.text = i18n.tr("Tap initial starting positions for first player")
				} else {
					newStandardGame()
				}
			}
		}
	}
    */

	SilicaFlickable {
		id: flick
        anchors.fill: parent
		contentHeight: gameCanvas.height
		contentWidth: gameCanvas.width
		clip: true
        PageHeader { id: header; title: i18n.tr("Amazons")
                     description: stateLabel.text
        }

        PullDownMenu {
            MenuItem {
                text: i18n.tr("About Amazons")
                onClicked: pageStack.push("AboutView.qml")
            }
            MenuItem {
                text: i18n.tr("Game Settings")
                onClicked: pageStack.push(setupView)
            }
            MenuItem {
                text: i18n.tr("New Standard Game")
                onClicked: Remorse.popupAction(gameViewPage, i18n.tr("Restarting game"), function() {gameViewPage.restartGame(false) }, 4000 )
            }
            MenuItem {
                text: i18n.tr("New Custom Game")
                onClicked: Remorse.popupAction(gameViewPage, i18n.tr("Restarting custom game"), function() {gameViewPage.restartGame(true) }, 4000 )
            }
            MenuItem {
                text: i18n.tr("Undo Choice")
                onClicked: gameViewPage.undoPlacement()
            }
        }

		Canvas {
			id: gameCanvas
            anchors.top: header.bottom
            anchors.topMargin: Theme.itemSizeLagth
            anchors.horizontalCenter: parent.horizontalCenter
            //width: parent.width - Theme.horizontalPageMargin
            //height: width

			property real squareSize: units.gu(4)

			onPaint: {
				var ctx = gameCanvas.getContext('2d')
				// Draw grid of squares
				ctx.fillStyle = setupView.colorScheme.whiteSquare
				ctx.fillRect(0, 0, gameCanvas.width, gameCanvas.height)
				ctx.fillStyle = setupView.colorScheme.blackSquare
				for (var x = 0; x < Amazons.getBoardWidth(); x++) {
					for (var y = 0; y < Amazons.getBoardHeight(); y++) {
						if ((x + y) % 2 == 0) {
							ctx.fillRect(x * squareSize, y * squareSize, squareSize, squareSize)
						}
					}
				}
				if (gameViewPage.isSettingUp) {
					// If setting up, show stored player positions
					for (var i = 0; i < gameViewPage.pickedPositions * 2; i += 2) {
						var x = gameViewPage.initialPositions[i]
						var y = gameViewPage.initialPositions[i + 1]
						if (i < gameViewPage.p1count * 2) {
							ctx.fillStyle = "#AAAAAA"
						} else {
							ctx.fillStyle = "#000000"
						}
						ctx.fillRect(x * squareSize, y * squareSize, squareSize, squareSize)
					}
				} else {
					// If playing, draw player positions and arrows
					for (var x = 0; x < Amazons.getBoardWidth(); x++) {
						for (var y = 0; y < Amazons.getBoardHeight(); y++) {
							switch (Amazons.getSquareState(x, y)) {
								case Amazons.QWHITE:
									ctx.drawImage("sprites/P1.png", x * squareSize, y * squareSize, squareSize, squareSize)
									break
								case Amazons.QBLACK:
									ctx.drawImage("sprites/P2.png", x * squareSize, y * squareSize, squareSize, squareSize)
									break
								case Amazons.QARROW:
									ctx.drawImage("sprites/Occupied.png", x * squareSize, y * squareSize, squareSize, squareSize)
									break
								default:
									break
							}
						}
					}
					// If in the middle of a move, highlight chosen squares
					switch (gameViewPage.clickedSquare) {
						case 2:
							ctx.fillStyle = setupView.colorScheme.redSquare
							var xd = Amazons.getSquare(Amazons.DESTINATION, 1)
							var yd = Amazons.getSquare(Amazons.DESTINATION, 2)
							ctx.fillRect(xd * squareSize, yd * squareSize, squareSize, squareSize)
						case 1:
							ctx.fillStyle = setupView.colorScheme.greenSquare
							var xs = Amazons.getSquare(Amazons.SOURCE, 1)
							var ys = Amazons.getSquare(Amazons.SOURCE, 2)
							ctx.fillRect(xs * squareSize, ys * squareSize, squareSize, squareSize)
						default:
							break
					}
					// If the game is over, highlight the regions controlled by each player
					if (gameViewPage.isGameOver && Amazons.highlightRegions) {
						for (var x = 0; x < Amazons.getBoardWidth(); x++) {
							for (var y = 0; y < Amazons.getBoardHeight(); y++) {
								switch (Amazons.getMapState(x, y)) {
									case Amazons.QWHITE:
										ctx.fillStyle = Qt.rgba(255, 0, 0, 0.5)
										break
									case Amazons.QBLACK:
										ctx.fillStyle = Qt.rgba(0, 0, 255, 0.5)
										break
									default:
										continue
								}
								ctx.fillRect(x * squareSize, y * squareSize, squareSize, squareSize)
							}
						}
					}
				}
			}

			MouseArea {
				id: gameTapArea
				anchors.fill: parent

				onReleased: {
					var squareSize = gameCanvas.squareSize
					var x = Math.floor(mouse.x / squareSize)
					var y = Math.floor(mouse.y / squareSize)
					if (gameViewPage.isSettingUp) {
						for (var i = 0; i < gameViewPage.pickedPositions * 2; i += 2) {
							if (gameViewPage.initialPositions[i] == x &&
								gameViewPage.initialPositions[i + 1] == y) {
								return
							}
						}
						gameViewPage.initialPositions.push(x)
						gameViewPage.initialPositions.push(y)
						gameViewPage.pickedPositions++
						if (gameViewPage.pickedPositions >= gameViewPage.p1count + gameViewPage.p2count) {
							var wstart = gameViewPage.initialPositions.slice(0, gameViewPage.p1count * 2)
							var bstart = gameViewPage.initialPositions.slice(gameViewPage.p1count * 2)
							Amazons.startGame(wstart, bstart)
							gameViewPage.isSettingUp = false
							gameViewPage.isGameOver = false
							stateLabel.text = i18n.tr("Bows to move")
						} else {
							if (gameViewPage.pickedPositions < gameViewPage.p1count) {
								stateLabel.text = i18n.tr("Tap initial starting positions for first player")
							} else {
								stateLabel.text = i18n.tr("Tap initial starting positions for second player")
							}
							gameCanvas.requestPaint()
						}
					} else {
						if (gameViewPage.isGameOver) {
							return
						}
						switch (gameViewPage.clickedSquare) {
							case 0:
								if (!Amazons.setSrc(x, y)) {
									return
								}
								gameViewPage.playSound("click")
								break
							case 1:
								if (!Amazons.setDst(x, y)) {
									return
								}
								gameViewPage.playSound("click")
								break
							case 2:
							default:
								if (!Amazons.moveAmazon(x, y)) {
									return
								}
								var winner = Amazons.gameIsOver()
								if (winner === Amazons.QWHITE) {
									gameViewPage.isGameOver = true;
									gameCanvas.requestPaint()

									if (Amazons.highlightRegions) {
										stateLabel.text = i18n.tr("Bows win! Controlled squares: %1 - %2.")
															.arg(Amazons.whiteSquares)
															.arg(Amazons.blackSquares)
									} else {
										stateLabel.text = i18n.tr("Bows win!")
									}
								} else if (winner === Amazons.QBLACK) {
									gameViewPage.isGameOver = true;
									gameCanvas.requestPaint()

									if (Amazons.highlightRegions) {
										stateLabel.text = i18n.tr("Spears win! Controlled squares: %1 - %2.")
															.arg(Amazons.blackSquares)
															.arg(Amazons.whiteSquares)
									} else {
										stateLabel.text = i18n.tr("Spears win!")
									}
								} else {
									if (Amazons.whiteToPlay()) {
										stateLabel.text = i18n.tr("Bows to move")
										gameViewPage.playSound("black")
									} else {
										stateLabel.text = i18n.tr("Spears to move")
										gameViewPage.playSound("white")
									}
								}
								break
						}
						gameViewPage.clickedSquare = (gameViewPage.clickedSquare + 1) % 3
					}
				}
			}
		}
	}

    /*
	Label {
		id: stateLabel
		anchors {
			left: parent.left
			right: parent.right
			bottom: parent.bottom
			margins: Theme.paddingMedium
		}

		text: i18n.tr("Bows to move")
        color: Theme.highlightColor
	}
    */

	Component.onCompleted: {
		gameCanvas.loadImage("sprites/P1.png")
		gameCanvas.loadImage("sprites/P2.png")
		gameCanvas.loadImage("sprites/Occupied.png")
		newStandardGame()
	}
}
