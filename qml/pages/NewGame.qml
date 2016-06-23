import QtQuick 2.1
import Sailfish.Silica 1.0
import "Database.js" as DB
Page {
    id: newgamePage
    property bool selected
    property bool navigation: false
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
    forwardNavigation: navigation
    Component.onCompleted: {
        DB.initialize()

        DB.sortBySelected()
        if (DB.playerselected() > 0) {
            navigation = true
        }
        mainPage.globalindex = 0
    }
    Rectangle {
        id: root //it's a good idea to name it always root so I'm able to remember it everytime ;)
        width: parent.width
        height: parent.height
        color: "#394264"
        opacity:settings.setting("transparency");
    }
    SilicaFlickable {
        anchors.fill: parent
        PullDownMenu {
            MenuItem {
                text: qsTr("ADD PLAYER")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("NewPlayer.qml"))
                }
            }
        }
        ListModel {
            id: player
        }
        Column {
            id: column
            width: root.width
            spacing: 3

            Item{
                id: topnewgame
                width: root.width
                height: pageheader.height


                Rectangle {
                    anchors.fill:parent
                    color: "#50597b"
                    opacity:settings.setting("transparency");
                }

                Image {
                    id:newgameicon
                    x: Theme.paddingLarge*2
                    anchors.verticalCenter: topnewgame.verticalCenter
                    width: pageheader.height-paddinglarge12; height:pageheader.height-paddinglarge12
                    fillMode: Image.PreserveAspectFit
                    opacity: 1;
                    source: "newgameIcon.png"
                }
                Label {
                    id: pageheader
                    anchors{top:topnewgame.top;topMargin:Theme.paddingMedium;left:newgameicon.right;leftMargin:Theme.paddingMedium}
                    font.family: bebasNeue.name
                    opacity:1;
                    color: "white"
                    font.pixelSize: Theme.fontSizeExtraLarge+Theme.fontSizeMedium
                    text: qsTr("New game")
                    font.bold: true
                }
            }

            Item {
                id: selectplayers
                width: label.width+ Theme.paddingLarge*2
                height: label.height

                Rectangle {
                    anchors.fill: parent
                    color: "#50597b"
                    opacity: settings.setting("transparency");
                }

                Label {
                    id: label
                    x: Theme.paddingLarge
                    font.family: bebasNeue.name
                    anchors{top:selectplayers.top;topMargin: Theme.paddingSmall}
                    color: "white"
                    opacity:1;
                    font.pixelSize: Theme.fontSizeExtraLarge
                    text: qsTr("select players")
                }
            }
        }
        SilicaListView {
            id: listView
            VerticalScrollDecorator {
                flickable: listView
            }
            HorizontalScrollDecorator {
                flickable: listView
            }
            clip:true
            boundsBehavior: Flickable.DragAndOvershootBounds
            snapMode: ListView.SnapToItem
            anchors{fill: parent;topMargin: column.height +Theme.paddingLarge;leftMargin: Theme.paddingMedium}
            spacing: Theme.paddingSmall
            model: player
            delegate: ListItem {
                id: delegate
                contentHeight: nameLabel.height + fullNameLabel.height+Theme.paddingMedium*2
                width: names.width
                visible: true
                onClicked: {
                    var checker = DB.checkSelect(nickname)
                    checkedIcon.text = checker === 0 ? "\uf14a" : "\uf096"

                    if (checker === 1) {
                        DB.playerUnSelect(nickname)
                        navigation = true
                    }
                    if (checker === 0) {
                        DB.playerSelect(nickname)
                    }
                    if (DB.playerselected() > 0) {
                        navigation = true
                    } else
                        navigation = false
                }

                Item{
                    id: names
                    width: screen.width - 50
                    height: parent.height
                    Rectangle {
                        anchors.fill: parent
                        opacity:settings.setting("transparency");
                        color: "#50597b"
                    }
                    Label {
                        id: nameLabel
                        anchors{top: names.top;topMargin: Theme.paddingMedium;left: names.left;leftMargin: Theme.paddingMedium;}
                        font.family: bebasNeue.name
                        font.pixelSize: Theme.fontSizeExtraLarge
                        opacity: 1
                        text: nickname
                    }
                    Label {
                        id: fullNameLabel
                        anchors{left: names.left;leftMargin: Theme.paddingMedium;top: nameLabel.bottom}
                        font.family: bebasNeue.name
                        width: (names.width-checkedIcon.width*2)
                        font.pixelSize: Theme.fontSizeSmall
                        opacity:1
                        truncationMode: TruncationMode.Fade

                        text: firstname + " " + lastname
                    }
                    Text {
                        id: checkedIcon
                        font.family: fontawesome.name
                        anchors{verticalCenter: names.verticalCenter;right: names.right;rightMargin: Theme.paddingMedium}
                        text: gewaehlt == 1 ? "\uf14a" : "\uf096"
                        opacity:1
                        color: "white"
                        font.pixelSize: Theme.fontSizeLarge+38
                    }
                }
            }
        }
    }
    //displayed when no players in database
    Label {
        id: noplayer
        visible: listView.count == 0
        font.family: bebasNeue.name
        text:qsTr("No players")
        color: "white"
        x: Theme.paddingLarge
        anchors{horizontalCenter: newgamePage.horizontalCenter;verticalCenter: newgamePage.verticalCenter}
        font.pixelSize: Theme.fontSizeExtraLarge + 38
        Label {
            visible: listView.count == 0
            font.family: bebasNeue.name
            text: qsTr("pull down to add a new player")
            color: "white"
            x: Theme.paddingLarge
            font.pixelSize: Theme.fontSizeMedium
            anchors{horizontalCenter: parent.horizontalCenter;top: parent.bottom}
        }
    }
}
