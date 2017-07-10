import QtQuick 2.1
import Sailfish.Silica 1.0
import "Database.js" as DB

Page {

    id: playersPage
    property int paddinglarge12:Theme.paddingLarge*1.2
    property var transparency

    FontLoader {
        id: bebasNeue
        source: "bebasNeue Regular.otf"
    }
    FontLoader {
        id: fontawesome
        source: "fontawesome-webfont.ttf"
    }

    //Emitted after component "startup" has completed. This can be used to execute script code at startup, once the full QML environment has been established.
    Component.onCompleted: {
        DB.initialize()
        DB.getNameAdded()
    }

    function reset() {
        remorse.execute("DELETE ALL PLAYERS", function () {
            DB.dropTables()
            pageStack.replace(Qt.resolvedUrl("Players.qml"))
        })
    }
    //reset counter animation
    RemorsePopup {
        id: remorse
    }

    Rectangle {
        id: root //it's a good idea to name it always root so I'm able to remember it everytime ;)
        width: parent.width
        height: parent.height
        opacity: settings.setting("transparency");
        color: "#394264"
    }
    SilicaFlickable {
        anchors.fill: parent
        PullDownMenu {
            MenuItem {
                text: qsTr("DELETE ALL PLAYERS")
                onClicked: {
                    reset()
                }
            }

            MenuItem {
                text: qsTr("ADD PLAYER")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("NewPlayer.qml"))
                }
            }
        }

        //model: player
        ListModel {
            id: player

        }

        Column {
            id: column
            width: root.width
            spacing: 3

            Item{

                id: topPlayers
                width: root.width
                height: pageheader.height


                Rectangle {
                    anchors.fill: parent
                    opacity: settings.setting("transparency");
                    color: "#50597b"
                }

                Image {
                    id:newgameicon
                    x: Theme.paddingLarge*2
                    anchors.verticalCenter: topPlayers.verticalCenter
                    width: pageheader.height-paddinglarge12; height:pageheader.height-paddinglarge12
                    fillMode: Image.PreserveAspectFit
                    source: "playersicon.png"
                }
                Label {
                    id: pageheader
                    anchors{top:topPlayers.top;topMargin:Theme.paddingMedium;left:newgameicon.right;leftMargin:Theme.paddingMedium}
                    font.family: bebasNeue.name
                    color: "white"
                    opacity: 1
                    text: qsTr("Players")
                    font.pixelSize: Theme.fontSizeExtraLarge+Theme.fontSizeMedium
                    font.bold: true
                }
            }
        }

        SilicaListView {
            id: listView
            clip: true
            boundsBehavior: Flickable.DragAndOvershootBounds
            snapMode: ListView.SnapToItem
            VerticalScrollDecorator {
                flickable: listView
            }
            HorizontalScrollDecorator {
                flickable: listView
            }
            anchors{fill: parent;topMargin: column.height +Theme.paddingLarge;leftMargin: Theme.paddingMedium}

            spacing: Theme.paddingSmall
            model: player
            delegate: ListItem {
                id: delegate
                // contentHeight: nameLabel.height+fullNameLabel.height+emailLabel.height+shotstatistics.height+Theme.paddingLarge*2
                contentHeight: names.height
                width: names.width
                visible: true
                menu:ContextMenu {
                    id: contextMenu
                    width: delegate.width+Theme.paddingMedium

                    MenuItem {
                        text: qsTr("Delete")
                        onClicked: remove()
                    }
                    MenuItem {
                        text: qsTr("Edit")
                        onClicked: editplayer()
                    }
                }
                //DELETE FUNKTION (löscht gewählten namen aus der datenbank)
                function remove() {
                    delegate.remorseAction(qsTr("Deleting"), function () {
                        DB.deletePlayer(nickname)
                        player.remove(index)
                    })
                }

                onClicked: {
                    //animate Opacity when button is pressed
                    // animateOpacity.start()
                    //debugging
                    //console.log("debug nickname:" + nickname)
                }

                Item{
                    id: names
                    width: screen.width - 50
                    height: nameLabel.height+fullNameLabel.height+emailLabel.height+shotstatistics.height+Theme.paddingLarge+Theme.paddingSmall


                    //Background rectangele for players info
                    Rectangle {
                        anchors.fill: parent
                        color: "#3c7ea7"
                        opacity: settings.setting("transparency");
                        // opacity: index % 2 == 0 ? 0.7 : 1
                    }

                    ListView.onRemove: animateRemoval(delegate)


                    Label {
                        id: nameLabel
                        anchors.top: names.top
                        anchors.topMargin: Theme.paddingMedium
                        anchors.left: names.left
                        anchors.leftMargin: Theme.paddingMedium
                        font.family: bebasNeue.name
                        font.pixelSize: Theme.fontSizeMedium
                        font.bold: true
                        text: nickname

                    }
                    Label {
                        width: (screen.width - 50) / 2.5
                        id: fullNameLabel
                        anchors.left: names.left
                        anchors.leftMargin: Theme.paddingMedium
                        anchors.top: nameLabel.bottom
                        font.family: bebasNeue.name
                        font.pixelSize: Theme.fontSizeExtraSmall
                        wrapMode: Text.WordWrap
                        text: firstname + " " + lastname
                    }
                    Label {
                        id: emailLabel
                        anchors.left: names.left
                        anchors.leftMargin: Theme.paddingMedium
                        anchors.top: fullNameLabel.bottom
                        font.family: bebasNeue.name
                        font.pixelSize: Theme.fontSizeExtraSmall
                        text: email
                    }

                    Label {
                        id: infoLabel
                        anchors.right: names.right
                        anchors.rightMargin: Theme.paddingLarge
                        anchors.top:nameLabel.verticalCenter
                        //anchors.top: names.top
                        //anchors.topMargin: Theme.paddingLarge
                        font.family: bebasNeue.name
                        font.pixelSize: Theme.fontSizeTiny
                        text: qsTr("Played rounds: %1").arg(roundplayed) + "\n" + qsTr("Time played: %1").arg(timeplayed)
                               + "\n" + qsTr("Average par: %1").arg(DB.getAveragePlayer(nickname))
                    }

                    Label {
                        id: shotstatistics
                        anchors.horizontalCenter: names.horizontalCenter
                        anchors.bottom:names.bottom
                        anchors.bottomMargin:  Theme.paddingMedium
                        font.family: bebasNeue.name
                        font.pixelSize: Theme.fontSizeTiny-3
                        text: "| "+qsTr("Ace: %1").arg(aces) + " | " + qsTr("Eagle: %1").arg(eagle) + " | "+ qsTr("Birdie: %1").arg(birdies) + " | " + qsTr("Par: %1").arg(pars)
                              +" | "+ qsTr("Bogey: %1").arg(bogeys) + " | " + qsTr("Rest : %1").arg(rest) + " | " + qsTr("Total : %1").arg(total) + " |"

                    }
                }
                function editplayer() {
                    pageStack.replace(Qt.resolvedUrl("EditPlayers.qml"), {
                                          nickNameEdit: nickname,
                                          firstNameEdit: firstname,
                                          lastNameEdit: lastname,
                                          emailEdit: email,
                                          notesEdit: notes
                                      })
                }

            }
        }
    }

    //displayed when no players in database
    Label {
        id: noplayer
        visible: listView.count == 0
        font.family: bebasNeue.name
        text: qsTr("No players")
        color: "white"
        x: Theme.paddingLarge
        anchors.horizontalCenter: playersPage.horizontalCenter
        anchors.verticalCenter: playersPage.verticalCenter
        font.pixelSize: Theme.fontSizeLarge + 35

        Label {
            visible: listView.count == 0
            font.family: bebasNeue.name
            text: qsTr("pull down to add a new player")
            color: "white"
            x: Theme.paddingLarge
            font.pixelSize: Theme.fontSizeMedium
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.bottom
        }
    }
}
